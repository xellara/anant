import 'dart:async';
import 'dart:math';
import 'package:anant_flutter/common/bottom_nav_bloc.dart';
import 'package:anant_flutter/common/coming_soon_page.dart';
import 'package:anant_flutter/common/settings_bloc.dart';
import 'package:anant_flutter/features/attendance/attendance.dart';
import 'package:anant_flutter/features/profile_screen.dart';
import 'package:anant_flutter/features/teacher_home/student_attendance_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// -------------------------
// BLoC: Event & State
// -------------------------

abstract class TeacherHomePageEvent extends Equatable {
  const TeacherHomePageEvent();
  @override
  List<Object> get props => [];
}

// Existing event for feature selection.
class FeatureSelectedEvent extends TeacherHomePageEvent {
  final int selectedIndex;
  const FeatureSelectedEvent({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

// New event to update greeting based on the current time.
class GreetingTickEvent extends TeacherHomePageEvent {
  final DateTime time;
  const GreetingTickEvent(this.time);

  @override
  List<Object> get props => [time];
}

class TeacherHomePageState extends Equatable {
  final int? selectedFeatureIndex;
  final String greetingMessage;
  final String emoji;

  const TeacherHomePageState({
    this.selectedFeatureIndex,
    this.greetingMessage = '',
    this.emoji = '',
  });

  TeacherHomePageState copyWith({
    int? selectedFeatureIndex,
    String? greetingMessage,
    String? emoji,
  }) {
    return TeacherHomePageState(
      selectedFeatureIndex: selectedFeatureIndex ?? this.selectedFeatureIndex,
      greetingMessage: greetingMessage ?? this.greetingMessage,
      emoji: emoji ?? this.emoji,
    );
  }

  @override
  List<Object?> get props => [selectedFeatureIndex, greetingMessage, emoji];
}

class TeacherHomePageBloc extends Bloc<TeacherHomePageEvent, TeacherHomePageState> {
  // List of emojis used for greetings.
  final List<String> emojis = [
    '👋', '🤝', '🙋‍♂️', '🙋‍♀️', '🤚', '🖐️', '🖖', '🤙',
    '🤗', '😊', '😃', '😎', '🥰', '🌞', '💫', '✨',
    '😀', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂',
    '🙃', '😉', '😇', '😍', '🥰', '😘', '😗', '😚',
    '😋', '😜', '😝', '😛', '🤑', '🤗', '🤓', '😎',
  ];

  late Timer _greetingTimer;

  TeacherHomePageBloc() : super(const TeacherHomePageState()) {
    // Handle feature selection events.
    on<FeatureSelectedEvent>((event, emit) {
      emit(state.copyWith(selectedFeatureIndex: event.selectedIndex));
    });

    // Handle greeting update events.
    on<GreetingTickEvent>((event, emit) {
      final hour = event.time.hour;
      String greeting;
      if (hour < 12) {
        greeting = 'Good Morning,';
      } else if (hour < 17) {
        greeting = 'Good Afternoon,';
      } else {
        greeting = 'Good Evening,';
      }
      // Select emoji based on the current second.
      final emoji = emojis[event.time.second % emojis.length];
      emit(state.copyWith(greetingMessage: greeting, emoji: emoji));
    });

    // Start a timer to dispatch a greeting tick every second.
    _greetingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(GreetingTickEvent(DateTime.now()));
    });
  }

  @override
  Future<void> close() {
    _greetingTimer.cancel();
    return super.close();
  }
}

// -------------------------
// Home Screen Widget
// -------------------------

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Using a percentage of screen height for the banner.
    final double bannerHeight = screenSize.height * 0.3;
    // Dynamic top padding to keep banner visible behind the content.
    final double contentTopPadding = bannerHeight * 0.7;
    // Dynamic heights for stats cards and feature cards.
    final double statsCardHeight = screenSize.height * 0.1;
    final double featureCardHeight = screenSize.height * 0.18;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: null, 
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, navState) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: IndexedStack(
              index: navState.selectedIndex,
              children: [
                _buildTeacherHomePageContent(
                    screenSize, statusBarHeight, contentTopPadding, statsCardHeight, featureCardHeight),
                const AttendanceInputPage(),
                const StudentAttendancePage(),
                const ComingSoonPage(), // Timetable for teacher (using ComingSoon as placeholder if no specific page)
                const ProfileScreen(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, navState) {
          return TeacherCustomFloatingNavBar(
            selectedIndex: navState.selectedIndex,
            onItemSelected: (index) {
              BlocProvider.of<BottomNavBloc>(context)
                  .add(NavItemSelectedEvent(selectedIndex: index));
            },
          );
        },
      ),
    );
  }

  // Extracted home screen content (original Stack) as a separate method.
  Widget _buildTeacherHomePageContent(
    Size screenSize,
    double statusBarHeight,
    double contentTopPadding,
    double statsCardHeight,
    double featureCardHeight,
  ) {
    return Stack(
      children: [
        // 1) Dark background banner with subtle 3D transform.
        Transform(
          alignment: FractionalOffset.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(0.07), // tilt forward
          child: SizedBox(
            height: screenSize.height * 0.3 + statusBarHeight,
            width: screenSize.width,
            child: CustomPaint(
              painter: HomeBannerPainter(),
            ),
          ),
        ),
        // 2) Twinkling stars over the banner.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenSize.height * 0.3 + statusBarHeight,
          child: Transform(
            alignment: FractionalOffset.topCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(0.07),
            child: TwinklingStarsWidget(),
          ),
        ),
        // Greeting widget using TeacherHomePageBloc.
        Positioned(
          top: statusBarHeight + 20,
          left: 16,
          child: BlocBuilder<TeacherHomePageBloc, TeacherHomePageState>(
            builder: (context, state) {
              return Text(
                '${state.emoji} ${state.greetingMessage}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        // Profile image widget.
        Positioned(
          top: statusBarHeight + 10,
          right: 16,
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Container(
                color: Colors.blueGrey[100],
              ),
            ),
          ),
        ),
        Positioned(
          top: statusBarHeight + 90,
          left: 16,
          child: BlocBuilder<TeacherHomePageBloc, TeacherHomePageState>(
            builder: (context, state) {
              return Text(
                'Welcome back,',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        // Main content in a scrollable Column.
        SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: contentTopPadding, bottom: 100),
            child: Container(
              width: screenSize.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 16,
                  right: 16,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    _buildFeatureGrid(context, featureCardHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Grid of feature cards.
  Widget _buildFeatureGrid(BuildContext context, double featureCardHeight) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final allFeatures = [
          {
            'title': 'Mark Attendance',
            'subtitle': 'Record your attendance quickly',
            'icon': Icons.check_circle,
            'key': 'attendance',
          },
          {
            'title': 'View Attendance',
            'subtitle': 'Review your attendance history',
            'icon': Icons.view_agenda,
            'key': 'attendance',
          },
          {
            'title': 'Timetable',
            'subtitle': 'View your schedule',
            'icon': Icons.calendar_today,
            'key': 'timetable',
          },
          {
            'title': 'Exams',
            'subtitle': 'Events & Holidays',
            'icon': Icons.event,
            'key': 'exams',
          },
        ];

        final enabledFeatures = allFeatures.where((feature) {
          if (state is SettingsLoaded) {
            return state.isModuleEnabled(feature['key'] as String);
          }
          return true;
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: enabledFeatures.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: featureCardHeight,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final feature = enabledFeatures[index];
              return Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-0.05),
                child: _buildFeatureCard(
                  context: context,
                  title: feature['title'] as String,
                  subtitle: feature['subtitle'] as String,
                  icon: feature['icon'] as IconData,
                  index: index,
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Individual feature card widget.
  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.7),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Map grid items to nav bar indices
            // Mark Attendance -> 1
            // View Attendance -> 2
            // Timetable -> 3
            
            int? navIndex;
            if (title == 'Mark Attendance') navIndex = 1;
            if (title == 'View Attendance') navIndex = 2;
            if (title == 'Timetable') navIndex = 3;

            if (navIndex != null) {
               BlocProvider.of<BottomNavBloc>(context).add(NavItemSelectedEvent(selectedIndex: navIndex));
            } else if (title == 'Exams') {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComingSoonPage()),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: const Color(0xFF335762),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------
// Custom Floating Nav Bar (Teacher)
// -------------------------

class TeacherCustomFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const TeacherCustomFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final allItems = [
          {'icon': Icons.home_rounded, 'label': 'Home', 'key': 'home'},
          {'icon': Icons.edit_calendar_rounded, 'label': 'Mark', 'key': 'attendance'},
          {'icon': Icons.fact_check_outlined, 'label': 'View', 'key': 'attendance'},
          {'icon': Icons.calendar_month_rounded, 'label': 'Time', 'key': 'timetable'},
          {'icon': Icons.person_rounded, 'label': 'Me', 'key': 'profile'},
        ];

        final enabledItems = allItems.where((item) {
          if (item['key'] == 'home' || item['key'] == 'profile') return true;
          if (state is SettingsLoaded) {
            return state.isModuleEnabled(item['key'] as String);
          }
          return true;
        }).toList();

        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(enabledItems.length, (index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () => onItemSelected(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 20 : 12,
                    vertical: 12,
                  ),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: const Color(0xFF335762),
                          borderRadius: BorderRadius.circular(30),
                        )
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        enabledItems[index]['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.grey,
                        size: 24,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          enabledItems[index]['label'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// -------------------------
// Supporting Widgets (Duplicated for now to be self-contained)
// -------------------------

class HomeBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xFF1E293B);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final Offset center = const Offset(0, 0);
    final List<Color> circleColors = [
      const Color(0xFF335762),
      const Color(0xFF3C6673),
      const Color(0xFF457584),
      const Color(0xFF4E8596),
    ];
    double radius = size.width * 1.2;
    for (int i = 0; i < circleColors.length; i++) {
      paint.color = circleColors[i].withValues(alpha: 0.6);
      final rect = Rect.fromCircle(center: center, radius: radius);
      const double startAngle = -0.5;
      const double sweepAngle = 2.5;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      radius *= 0.709;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TwinklingStarsWidget extends StatefulWidget {
  @override
  _TwinklingStarsWidgetState createState() => _TwinklingStarsWidgetState();
}

class _TwinklingStarsWidgetState extends State<TwinklingStarsWidget>
    with TickerProviderStateMixin {
  static const int starCount = 10;
  final Random _random = Random();
  List<Offset> _starPositions = [];
  List<double> _starSizes = [];
  List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(starCount, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200 + _random.nextInt(1200)),
      )..repeat(reverse: true);
      return controller;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_starPositions.isEmpty) {
          _generateStars(constraints.maxWidth, constraints.maxHeight);
        }

        return Stack(
          children: List.generate(starCount, (i) {
            return Positioned(
              left: _starPositions[i].dx,
              top: _starPositions[i].dy,
              child: AnimatedBuilder(
                animation: _controllers[i],
                builder: (context, child) {
                  final opacity = _controllers[i].value;
                  return Opacity(
                    opacity: opacity,
                    child: SizedBox(
                      width: _starSizes[i],
                      height: _starSizes[i],
                      child: CustomStarWidget(
                        size: _starSizes[i],
                        color: Colors.white.withValues(alpha: opacity),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }

  void _generateStars(double maxWidth, double maxHeight) {
    for (int i = 0; i < starCount; i++) {
      final dx = _random.nextDouble() * maxWidth;
      final dy = _random.nextDouble() * maxHeight;
      _starPositions.add(Offset(dx, dy));
      _starSizes.add(_random.nextDouble() * 12 + 3);
    }
  }
}

class CustomStarWidget extends StatelessWidget {
  final double size;
  final Color color;

  const CustomStarWidget({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarPainter(color),
      size: Size(size, size),
    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    const double angle = pi / 5;

    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      double x = centerX + radius * cos(i * 2 * angle);
      double y = centerY + radius * sin(i * 2 * angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      x = centerX + (radius / 2) * cos((i * 2 + 1) * angle);
      y = centerY + (radius / 2) * sin((i * 2 + 1) * angle);
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => false;
}