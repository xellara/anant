import 'dart:async';
import 'package:anant_flutter/common/bottom_nav_bloc.dart';
import 'package:anant_flutter/common/coming_soon_page.dart';
import 'package:anant_flutter/features/profile_screen.dart';
import 'package:anant_flutter/features/role_dashboards/dashboard_shared.dart';
import 'package:anant_flutter/features/student_attendance/presentation/pages/student_attendance_page.dart';
import 'package:anant_flutter/features/timetable/presentation/pages/timetable_page.dart';
import 'package:anant_flutter/features/transaction/organization/monthly_fee_transaction_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anant_flutter/features/attendance/attendance.dart';

// -------------------------
// Models
// -------------------------

class DashboardFeature {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardFeature({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color = const Color(0xFF335762),
    this.onTap,
  });
}

// -------------------------
// BLoC: Event & State
// -------------------------

abstract class RoleDashboardEvent extends Equatable {
  const RoleDashboardEvent();
  @override
  List<Object> get props => [];
}

class GreetingTickEvent extends RoleDashboardEvent {
  final DateTime time;
  const GreetingTickEvent(this.time);

  @override
  List<Object> get props => [time];
}

class RoleDashboardState extends Equatable {
  final String greetingMessage;
  final String emoji;

  const RoleDashboardState({
    this.greetingMessage = '',
    this.emoji = '',
  });

  RoleDashboardState copyWith({
    String? greetingMessage,
    String? emoji,
  }) {
    return RoleDashboardState(
      greetingMessage: greetingMessage ?? this.greetingMessage,
      emoji: emoji ?? this.emoji,
    );
  }

  @override
  List<Object?> get props => [greetingMessage, emoji];
}

class RoleDashboardBloc extends Bloc<RoleDashboardEvent, RoleDashboardState> {
  final List<String> emojis = [
    '👋', '🤝', '🙋‍♂️', '🙋‍♀️', '🤚', '🖐️', '🖖', '🤙',
    '🤗', '😊', '😃', '😎', '🥰', '🌞', '💫', '✨',
  ];

  late Timer _greetingTimer;

  RoleDashboardBloc() : super(const RoleDashboardState()) {
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
      final emoji = emojis[event.time.second % emojis.length];
      emit(state.copyWith(greetingMessage: greeting, emoji: emoji));
    });

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
// Generic Dashboard Widget
// -------------------------

class GenericRoleDashboard extends StatelessWidget {
  final String roleName;
  final List<DashboardFeature> features;
  final List<Map<String, dynamic>>? navItems;
  final List<Widget>? pages;

  const GenericRoleDashboard({
    super.key,
    required this.roleName,
    required this.features,
    this.navItems,
    this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoleDashboardBloc(),
      child: _DashboardView(
        roleName: roleName,
        features: features,
        navItems: navItems,
        pages: pages,
      ),
    );
  }
}

class _DashboardView extends StatefulWidget {
  final String roleName;
  final List<DashboardFeature> features;
  final List<Map<String, dynamic>>? navItems;
  final List<Widget>? pages;

  const _DashboardView({
    required this.roleName,
    required this.features,
    this.navItems,
    this.pages,
  });

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Reset navigation to home (index 0) when entering this dashboard
    context.read<BottomNavBloc>().add(const NavItemSelectedEvent(selectedIndex: 0));
    
    // Trigger profile load to get user details
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final double bannerHeight = screenSize.height * 0.3;
    final double contentTopPadding = bannerHeight * 0.7;
    
    // Use ResponsiveLayout helper to determine if we should show desktop layout
    // We treat tablet and desktop as "large screen" for the purpose of the grid count in home content
    final bool isLargeScreen = !ResponsiveLayout.isMobile(context);

    // Default pages: Home + Profile
    final homeContent = _buildHomeContent(screenSize, statusBarHeight, contentTopPadding, isLargeScreen);
    final profileContent = const ProfileScreen();

    List<Widget> activePages;
    if (widget.pages != null) {
      activePages = List.from(widget.pages!);
      if (activePages.isNotEmpty && activePages[0] is SizedBox && (activePages[0] as SizedBox).height == 0) {
         activePages[0] = homeContent;
      }
    } else {
      activePages = [homeContent, profileContent];
    }

    return ResponsiveLayout(
      mobileBody: _buildMobileLayout(activePages),
      tabletBody: _buildDesktopLayout(context, activePages),
      desktopBody: _buildDesktopLayout(context, activePages),
    );
  }

  Widget _buildMobileLayout(List<Widget> activePages) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: false, // Changed to false to prevent content hiding
      backgroundColor: Colors.white,
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, navState) {
          final int safeIndex = navState.selectedIndex >= activePages.length 
              ? 0 
              : navState.selectedIndex;
          
          return IndexedStack(
            index: safeIndex,
            children: activePages,
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, navState) {
          return GenericFloatingNavBar(
            selectedIndex: navState.selectedIndex,
            items: widget.navItems,
            onItemSelected: (index) {
              BlocProvider.of<BottomNavBloc>(context)
                  .add(NavItemSelectedEvent(selectedIndex: index));
            },
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<Widget> activePages) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, navState) {
          final int safeIndex = navState.selectedIndex >= activePages.length 
              ? 0 
              : navState.selectedIndex;
          
          return Row(
            children: [
              _buildSideNav(context, safeIndex),
              Expanded(
                child: IndexedStack(
                  index: safeIndex,
                  children: activePages,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSideNav(BuildContext context, int selectedIndex) {
    final displayItems = widget.navItems ?? [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        BlocProvider.of<BottomNavBloc>(context)
            .add(NavItemSelectedEvent(selectedIndex: index));
      },
      labelType: NavigationRailLabelType.all,
      backgroundColor: Colors.white,
      selectedIconTheme: const IconThemeData(color: Color(0xFF335762)),
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      selectedLabelTextStyle: const TextStyle(
        color: Color(0xFF335762),
        fontWeight: FontWeight.bold,
      ),
      destinations: displayItems.map((item) {
        return NavigationRailDestination(
          icon: Icon(item['icon'] as IconData),
          label: Text(item['label'] as String),
        );
      }).toList(),
    );
  }

  Widget _buildHomeContent(
    Size screenSize,
    double statusBarHeight,
    double contentTopPadding,
    bool isDesktop,
  ) {
    return Stack(
      children: [
        // Banner
        Transform(
          alignment: FractionalOffset.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.07),
          child: SizedBox(
            height: screenSize.height * 0.3 + statusBarHeight,
            width: double.infinity,
            child: CustomPaint(
              painter: HomeBannerPainter(),
            ),
          ),
        ),
        // Stars
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
            child: const TwinklingStarsWidget(),
          ),
        ),
        // Greeting
        Positioned(
          top: statusBarHeight + 20,
          left: 16,
          child: BlocBuilder<RoleDashboardBloc, RoleDashboardState>(
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
        // Profile Image
        Positioned(
          top: statusBarHeight + 10,
          right: 16,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String initials = '';
              if (state is ProfileLoaded) {
                final parts = (state.user.fullName ?? '').split(RegExp(r'[\s@.]'));
                for (final part in parts) {
                  if (part.isNotEmpty && RegExp(r'[A-Za-z]').hasMatch(part[0])) {
                    initials += part[0].toUpperCase();
                  }
                }
                if (initials.length > 2) initials = initials.substring(0, 2);
              }
              
              return CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.blueGrey[100],
                  child: state is ProfileLoaded
                      ? Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF335762),
                          ),
                        )
                      : const Icon(Icons.person, color: Colors.white),
                ),
              );
            },
          ),
        ),
        // Welcome Text
        Positioned(
          top: statusBarHeight + 90,
          left: 16,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String name = widget.roleName;
              if (state is ProfileLoaded) {
                name = state.user.fullName ?? widget.roleName;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        // Main Content
        SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: contentTopPadding, bottom: 20), // Reduced bottom padding
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildFeatureGrid(context, isDesktop),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid(BuildContext context, bool isDesktop) {
    if (widget.features.isEmpty) {
      return _buildPlaceholderCard();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : 2,
        mainAxisExtent: 160,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.features.length,
      itemBuilder: (context, index) {
        final feature = widget.features[index];
        return _buildFeatureCard(context, feature);
      },
    );
  }

  Widget _buildFeatureCard(BuildContext context, DashboardFeature feature) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(2, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: feature.onTap ?? () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComingSoonPage()),
              );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: feature.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    feature.icon,
                    size: 28,
                    color: feature.color,
                  ),
                ),
                const Spacer(),
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.subtitle,
                  style: TextStyle(
                    color: Colors.grey[500],
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

  Widget _buildPlaceholderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.dashboard_customize_rounded, size: 48, color: Colors.blueGrey[300]),
          const SizedBox(height: 16),
          Text(
            '${widget.roleName} Dashboard',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF335762),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Features for ${widget.roleName} are coming soon!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------
// Generic Floating Nav Bar
// -------------------------

class GenericFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final List<Map<String, dynamic>>? items;

  const GenericFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = items ?? [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];

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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(displayItems.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onItemSelected(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 24 : 16,
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
                    displayItems[index]['icon'] as IconData,
                    color: isSelected ? Colors.white : Colors.grey,
                    size: 24,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      displayItems[index]['label'] as String,
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
  }
}

// -------------------------
// Specific Role Dashboards
// -------------------------

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Student',
      features: [
        DashboardFeature(
          title: 'Timetable',
          subtitle: 'View your schedule',
          icon: Icons.calendar_today_rounded,
          color: Colors.blue,
          onTap: () {
            BlocProvider.of<BottomNavBloc>(context).add(const NavItemSelectedEvent(selectedIndex: 1));
          },
        ),
        DashboardFeature(
          title: 'Attendance',
          subtitle: 'Track attendance',
          icon: Icons.check_circle_outline_rounded,
          color: Colors.green,
          onTap: () {
            BlocProvider.of<BottomNavBloc>(context).add(const NavItemSelectedEvent(selectedIndex: 2));
          },
        ),
        DashboardFeature(
          title: 'Fees',
          subtitle: 'Pay your dues',
          icon: Icons.currency_rupee_rounded,
          color: Colors.orange,
          onTap: () {
            BlocProvider.of<BottomNavBloc>(context).add(const NavItemSelectedEvent(selectedIndex: 3));
          },
        ),
        DashboardFeature(
          title: 'Exams',
          subtitle: 'View exam dates',
          icon: Icons.event_rounded,
          color: Colors.purple,
          onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComingSoonPage()),
              );
          },
        ),
      ],
      navItems: const [
        {'icon': Icons.home_rounded, 'label': 'Home'},
        {'icon': Icons.calendar_month_rounded, 'label': 'Time'},
        {'icon': Icons.check_circle_outline_rounded, 'label': 'Attend'},
        {'icon': Icons.currency_rupee_rounded, 'label': 'Fees'},
        {'icon': Icons.person_rounded, 'label': 'Profile'},
      ],
      pages: const [
        SizedBox(height: 0), // Placeholder for Home
        TimetablePage(),
        StudentAttendancePage(),
        MonthlyFeeTransactionPage(),
        ProfileScreen(),
      ],
    );
  }
}

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Teacher',
      features: [
        DashboardFeature(
          title: 'Mark Attendance',
          subtitle: 'Record attendance',
          icon: Icons.edit_calendar_rounded,
          color: Colors.blue,
          onTap: () {
            BlocProvider.of<BottomNavBloc>(context).add(const NavItemSelectedEvent(selectedIndex: 1));
          },
        ),
        DashboardFeature(
          title: 'View Attendance',
          subtitle: 'Review history',
          icon: Icons.fact_check_outlined,
          color: Colors.green,
          onTap: () {
            BlocProvider.of<BottomNavBloc>(context).add(const NavItemSelectedEvent(selectedIndex: 2));
          },
        ),
        DashboardFeature(
          title: 'Timetable',
          subtitle: 'View schedule',
          icon: Icons.calendar_today_rounded,
          color: Colors.orange,
          onTap: () {
            BlocProvider.of<BottomNavBloc>(context).add(const NavItemSelectedEvent(selectedIndex: 3));
          },
        ),
        DashboardFeature(
          title: 'Reports',
          subtitle: 'Student reports',
          icon: Icons.analytics_rounded,
          color: Colors.purple,
          onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComingSoonPage()),
              );
          },
        ),
      ],
      navItems: const [
        {'icon': Icons.home_rounded, 'label': 'Home'},
        {'icon': Icons.edit_calendar_rounded, 'label': 'Mark'},
        {'icon': Icons.fact_check_outlined, 'label': 'View'},
        {'icon': Icons.calendar_month_rounded, 'label': 'Time'},
        {'icon': Icons.person_rounded, 'label': 'Profile'},
      ],
      pages: const [
        SizedBox(height: 0), // Placeholder for Home
        AttendanceInputPage(),
        StudentAttendancePage(),
        ComingSoonPage(), // Placeholder for Teacher Timetable if not yet implemented
        ProfileScreen(),
      ],
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Admin',
      features: [
        DashboardFeature(
          title: 'Manage Users',
          subtitle: 'Add or edit users',
          icon: Icons.people_alt_rounded,
          color: Colors.blue,
        ),
        DashboardFeature(
          title: 'Manage Classes',
          subtitle: 'Configure school structure',
          icon: Icons.school_rounded,
          color: Colors.orange,
        ),
        DashboardFeature(
          title: 'System Settings',
          subtitle: 'Global configurations',
          icon: Icons.settings_rounded,
          color: Colors.grey,
        ),
        DashboardFeature(
          title: 'Reports',
          subtitle: 'View analytics',
          icon: Icons.bar_chart_rounded,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class PrincipalDashboard extends StatelessWidget {
  const PrincipalDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Principal',
      features: [
        DashboardFeature(
          title: 'Teacher Stats',
          subtitle: 'Performance overview',
          icon: Icons.analytics_rounded,
          color: Colors.teal,
        ),
        DashboardFeature(
          title: 'Student Stats',
          subtitle: 'Attendance & grades',
          icon: Icons.groups_rounded,
          color: Colors.indigo,
        ),
        DashboardFeature(
          title: 'Announcements',
          subtitle: 'Broadcast messages',
          icon: Icons.campaign_rounded,
          color: Colors.redAccent,
        ),
        DashboardFeature(
          title: 'Timetable',
          subtitle: 'School schedule',
          icon: Icons.calendar_month_rounded,
          color: Colors.blueGrey,
        ),
      ],
    );
  }
}

class AccountantDashboard extends StatelessWidget {
  const AccountantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Accountant',
      features: [
        DashboardFeature(
          title: 'Collect Fees',
          subtitle: 'Process payments',
          icon: Icons.attach_money_rounded,
          color: Colors.green,
        ),
        DashboardFeature(
          title: 'Pending Dues',
          subtitle: 'Track defaulters',
          icon: Icons.warning_amber_rounded,
          color: Colors.orangeAccent,
        ),
        DashboardFeature(
          title: 'Expenses',
          subtitle: 'Manage outflows',
          icon: Icons.money_off_rounded,
          color: Colors.red,
        ),
        DashboardFeature(
          title: 'Salary',
          subtitle: 'Payroll management',
          icon: Icons.payments_rounded,
          color: Colors.blue,
        ),
      ],
    );
  }
}

class ClerkDashboard extends StatelessWidget {
  const ClerkDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Clerk',
      features: [
        DashboardFeature(
          title: 'New Admission',
          subtitle: 'Register student',
          icon: Icons.person_add_rounded,
          color: Colors.blue,
        ),
        DashboardFeature(
          title: 'Certificates',
          subtitle: 'Issue documents',
          icon: Icons.description_rounded,
          color: Colors.amber,
        ),
        DashboardFeature(
          title: 'Student Records',
          subtitle: 'Maintain files',
          icon: Icons.folder_shared_rounded,
          color: Colors.brown,
        ),
        DashboardFeature(
          title: 'Enquiries',
          subtitle: 'Handle questions',
          icon: Icons.question_answer_rounded,
          color: Colors.cyan,
        ),
      ],
    );
  }
}

class LibrarianDashboard extends StatelessWidget {
  const LibrarianDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Librarian',
      features: [
        DashboardFeature(
          title: 'Issue Book',
          subtitle: 'Lend to student',
          icon: Icons.book_rounded,
          color: Colors.indigo,
        ),
        DashboardFeature(
          title: 'Return Book',
          subtitle: 'Accept return',
          icon: Icons.assignment_return_rounded,
          color: Colors.teal,
        ),
        DashboardFeature(
          title: 'Catalog',
          subtitle: 'Manage inventory',
          icon: Icons.library_books_rounded,
          color: Colors.brown,
        ),
        DashboardFeature(
          title: 'Overdue',
          subtitle: 'Track late returns',
          icon: Icons.timer_off_rounded,
          color: Colors.red,
        ),
      ],
    );
  }
}

class TransportDashboard extends StatelessWidget {
  const TransportDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Transport Manager',
      features: [
        DashboardFeature(
          title: 'Routes',
          subtitle: 'Manage paths',
          icon: Icons.map_rounded,
          color: Colors.blue,
        ),
        DashboardFeature(
          title: 'Vehicles',
          subtitle: 'Bus fleet',
          icon: Icons.directions_bus_rounded,
          color: Colors.orange,
        ),
        DashboardFeature(
          title: 'Drivers',
          subtitle: 'Manage staff',
          icon: Icons.person_pin_circle_rounded,
          color: Colors.green,
        ),
        DashboardFeature(
          title: 'Maintenance',
          subtitle: 'Service logs',
          icon: Icons.build_rounded,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class HostelDashboard extends StatelessWidget {
  const HostelDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Hostel Warden',
      features: [
        DashboardFeature(
          title: 'Allocation',
          subtitle: 'Assign rooms',
          icon: Icons.bed_rounded,
          color: Colors.indigo,
        ),
        DashboardFeature(
          title: 'Mess Menu',
          subtitle: 'Food schedule',
          icon: Icons.restaurant_menu_rounded,
          color: Colors.orange,
        ),
        DashboardFeature(
          title: 'Attendance',
          subtitle: 'Night check',
          icon: Icons.checklist_rtl_rounded,
          color: Colors.green,
        ),
        DashboardFeature(
          title: 'Complaints',
          subtitle: 'Manage issues',
          icon: Icons.report_problem_rounded,
          color: Colors.red,
        ),
      ],
    );
  }
}

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Parent',
      features: [
        DashboardFeature(
          title: 'My Children',
          subtitle: 'View profiles',
          icon: Icons.face_rounded,
          color: Colors.blue,
        ),
        DashboardFeature(
          title: 'Pay Fees',
          subtitle: 'Online payment',
          icon: Icons.payment_rounded,
          color: Colors.green,
        ),
        DashboardFeature(
          title: 'Report Card',
          subtitle: 'Academic progress',
          icon: Icons.grade_rounded,
          color: Colors.purple,
        ),
        DashboardFeature(
          title: 'Attendance',
          subtitle: 'Check presence',
          icon: Icons.calendar_today_rounded,
          color: Colors.teal,
        ),
      ],
    );
  }
}
