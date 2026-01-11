import 'dart:async';
import 'dart:ui';
import 'package:anant_flutter/common/bottom_nav_bloc.dart';
import 'package:anant_flutter/common/coming_soon_page.dart';
import 'package:anant_flutter/main.dart';
import 'package:anant_client/anant_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anant_flutter/features/profile_screen.dart';
import 'package:anant_flutter/features/role_dashboards/dashboard_shared.dart';
import 'package:anant_flutter/features/student_attendance/presentation/pages/student_attendance_page.dart';
import 'package:anant_flutter/features/timetable/presentation/pages/timetable_page.dart';
import 'package:anant_flutter/fee_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/features/role_dashboards/dashboard_animations.dart';
import 'package:anant_flutter/features/attendance/attendance.dart';
import 'package:anant_flutter/features/exams/presentation/pages/exam_schedule_page.dart';
import 'package:anant_flutter/features/teacher_home/student_selection_page.dart';
import 'package:anant_flutter/features/announcements/presentation/pages/announcement_page.dart';
import 'package:anant_flutter/features/announcements/presentation/pages/create_announcement_page.dart';
import 'package:anant_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:anant_flutter/features/admin/pages/manage_users_page.dart';
import 'package:anant_flutter/features/admin/pages/manage_classes_page.dart';
import 'package:anant_flutter/features/admin/pages/system_settings_page.dart';
import 'package:anant_flutter/features/admin/pages/reports_page.dart';

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

class RoleTheme {
  final List<Color> gradientColors;
  final Color accentColor;
  final Color secondaryAccent;

  const RoleTheme({
    required this.gradientColors,
    required this.accentColor,
    required this.secondaryAccent,
  });
}

final Map<String, RoleTheme> dashboardThemes = {
  'Student': const RoleTheme(
    gradientColors: [Color(0xFF1A237E), Color(0xFF3949AB), Color(0xFF8E24AA)],
    accentColor: Color(0xFF3949AB),
    secondaryAccent: Color(0xFF8E24AA),
  ),
  'Teacher': const RoleTheme(
    gradientColors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF00897B)],
    accentColor: Color(0xFF00695C),
    secondaryAccent: Color(0xFF4DB6AC),
  ),
  'Principal': const RoleTheme(
    gradientColors: [Color(0xFF3E2723), Color(0xFF5D4037), Color(0xFF8D6E63)],
    accentColor: Color(0xFF5D4037),
    secondaryAccent: Color(0xFFA1887F),
  ),
  'Admin': const RoleTheme(
    gradientColors: [Color(0xFF212121), Color(0xFF424242), Color(0xFF616161)],
    accentColor: Color(0xFF424242),
    secondaryAccent: Color(0xFF757575),
  ),
  'Accountant': const RoleTheme(
    gradientColors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
    accentColor: Color(0xFF2E7D32),
    secondaryAccent: Color(0xFF66BB6A),
  ),
  'Clerk': const RoleTheme(
    gradientColors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1976D2)],
    accentColor: Color(0xFF1565C0),
    secondaryAccent: Color(0xFF42A5F5),
  ),
  'Hostel Warden': const RoleTheme(
    gradientColors: [Color(0xFFBF360C), Color(0xFFD84315), Color(0xFFF4511E)],
    accentColor: Color(0xFFD84315),
    secondaryAccent: Color(0xFFFF7043),
  ),
  'Librarian': const RoleTheme(
    gradientColors: [Color(0xFF33691E), Color(0xFF558B2F), Color(0xFF689F38)],
    accentColor: Color(0xFF558B2F),
    secondaryAccent: Color(0xFF8BC34A),
  ),
  'Transport Manager': const RoleTheme(
    gradientColors: [Color(0xFFE65100), Color(0xFFEF6C00), Color(0xFFF57C00)],
    accentColor: Color(0xFFEF6C00),
    secondaryAccent: Color(0xFFFF9800),
  ),
};

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
  int _unreadCount = 0;
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _fetchUnreadCount();
    // Reset navigation to home (index 0) when entering this dashboard
    context.read<BottomNavBloc>().add(const NavItemSelectedEvent(selectedIndex: 0));
    
    // Trigger profile load to get user details
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) {
        debugPrint('Dashboard: userId is null in prefs');
        return;
      }
      debugPrint('Dashboard: Fetching unread count for userId: $userId');
      
      final anantId = prefs.getString('userName');

      if (anantId != null && anantId.isNotEmpty) {
        if (_notificationSubscription == null) _setupRealtime(anantId);
        
        debugPrint('Dashboard: Calling getUnreadCount for $anantId');
        final count = await client.notification.getUnreadCount(anantId);
        debugPrint('Dashboard: Unread count fetched: $count');
        if (mounted) {
           setState(() {
             _unreadCount = count;
           });
        }
      } else {
        debugPrint('Dashboard: userName (anantId) is null/empty in prefs');
      }
    } catch (e, stack) {
      debugPrint('Error fetching unread count: $e\nStack: $stack');
    }
  }

  void _setupRealtime(String anantId) async {
    try {
      await client.openStreamingConnection();
      _notificationSubscription = client.notification.receiveNotificationStream(anantId).listen((event) {
        _fetchUnreadCount();
      });
    } catch (e) {
      debugPrint('Realtime setup failed: $e');
    }
  }
  
  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final double bannerHeight = screenSize.height * 0.3;
    final double contentTopPadding = bannerHeight * 0.7;
    
    // Use ResponsiveLayout helper to determine if we should show desktop layout
    final bool isLargeScreen = !ResponsiveLayout.isMobile(context);

    // Default pages: Home + Profile
    final homeContent = isLargeScreen 
        ? _buildDesktopHomeContent(screenSize) 
        : _buildHomeContent(screenSize, statusBarHeight, contentTopPadding, isLargeScreen);
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
      backgroundColor: const Color(0xFFF3F4F6), // Light background for contrast
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, navState) {
          final int safeIndex = navState.selectedIndex >= activePages.length 
              ? 0 
              : navState.selectedIndex;
          
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFloatingSideNav(context, safeIndex),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    bottomLeft: Radius.circular(32),
                  ),
                  child: IndexedStack(
                    index: safeIndex,
                    children: activePages,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFloatingSideNav(BuildContext context, int selectedIndex) {
    final displayItems = widget.navItems ?? [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];

    return Container(
      width: 100, // Fixed width for the nav area
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(4, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Shrink to fit content
            children: [
              // Logo Placeholder or Home Indicator
              Container(
                 margin: const EdgeInsets.only(bottom: 32),
                 padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                   shape: BoxShape.circle,
                 ),
                 child: Icon(
                   Icons.school_rounded,
                   color: Theme.of(context).primaryColor,
                   size: 24,
                 ),
              ),
              
              // Nav Items
              ...displayItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == selectedIndex;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Tooltip(
                    message: item['label'] as String,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<BottomNavBloc>(context)
                            .add(NavItemSelectedEvent(selectedIndex: index));
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Theme.of(context).primaryColor 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  )
                                ]
                              : [],
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected ? Colors.white : Colors.grey[400],
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              
              // Flexible Spacer if we want bottom items
              // const Spacer(), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent(
    Size screenSize,
    double statusBarHeight,
    double contentTopPadding,
    bool isDesktop,
  ) {
    // Adjusted heights for better fit on all screens
    // For Web/Tablet, we reduce the banner height ratio slightly to avoid it taking over the whole screen
    final double bannerHeightRatio = ResponsiveLayout.isMobile(context) ? 0.35 : 0.28;
    final double bannerHeight = screenSize.height * bannerHeightRatio;
    final double overlap = 30.0;
    
    // Ensure minimum banner height
    final double safeBannerHeight = bannerHeight < 250 ? 250 : bannerHeight;

    return Stack(
      children: [
        // Ultra-Premium Gradient Banner
        Container(
          height: safeBannerHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
          child: Stack(
            children: [
              // 0. Base Particles (Magical Knowledge World)
              Positioned.fill(
                child: MagicalKnowledgeWorldWidget(
                  size: Size(screenSize.width, safeBannerHeight),
                ),
              ),

              // 1. Organic Mesh-like BLUR Shapes (Animated)
              Positioned(
                top: -100,
                left: -100,
                child: BreathingWidget(
                  duration: const Duration(seconds: 6),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pink.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                right: -50,
                child: BreathingWidget(
                  duration: const Duration(seconds: 5),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              
              // 2. Glassmorphism Overlay (Subtle)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(color: Colors.transparent),
                ),
              ),

              // 3. Subtle Texture
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: const TwinklingStarsWidget(),
                ),
              ),
            ],
          ),
        ),

        // Main Content Layer (Foreground)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar & Notification Bell (future proofing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EntranceFader(
                      delay: const Duration(milliseconds: 200),
                      child: BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          String initials = 'U';
                          if (state is ProfileLoaded) {
                            final parts = (state.user.fullName ?? '').split(RegExp(r'[\s@.]'));
                            if (parts.isNotEmpty && parts[0].isNotEmpty) {
                               initials = parts[0][0].toUpperCase();
                               if(parts.length > 1 && parts[1].isNotEmpty) initials += parts[1][0].toUpperCase();
                            }
                          }
                          
                          return Container(
                            padding: const EdgeInsets.all(2), // Space for border
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: const Color(0xFFE8EAF6),
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    
                    // Notification Icon with Badge
                    EntranceFader(
                      delay: const Duration(milliseconds: 300),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NotificationsPage()),
                              ).then((_) => _fetchUnreadCount());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                            ),
                          ),
                          // Badge
                          if (_unreadCount > 0)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  _unreadCount > 9 ? '9+' : _unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Greeting & Name - Hero Text
                BlocBuilder<RoleDashboardBloc, RoleDashboardState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EntranceFader(
                          delay: const Duration(milliseconds: 400),
                          child: Row(
                            children: [
                              Text(
                                state.emoji, 
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.greetingMessage.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                         EntranceFader(
                           delay: const Duration(milliseconds: 500),
                           child: BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, profileState) {
                              String name = widget.roleName;
                              if (profileState is ProfileLoaded) {
                                name = profileState.user.fullName ?? widget.roleName;
                                // Just get first name for friendlier UI
                                name = name.split(' ')[0];
                              }
                              return Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36, // Huge text
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -0.5,
                                  height: 1.1,
                                ),
                              );
                            },
                                                   ),
                         ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Context Pill
                 EntranceFader(
                   delay: const Duration(milliseconds: 600),
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                     decoration: BoxDecoration(
                       color: Colors.white.withValues(alpha: 0.1),
                       borderRadius: BorderRadius.circular(30),
                       border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                     ),
                     child: const Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Icon(Icons.school_outlined, size: 14, color: Colors.white70),
                         SizedBox(width: 8),
                         Text('Academic Year 2024-25', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                       ],
                     ),
                   ),
                 ),

                 const SizedBox(height: 16),
                 
                 // Motivational Quotes Carousel (New!)
                 const SplashScreenQuotesWidget(),

              ],
            ),
          ),
        ),

        // Scrollable Content Sheet
        Positioned.fill(
          top: safeBannerHeight - overlap, 
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC), // Slightly off-white for depth
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20), // Top padding pushes content down
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                       return _buildFeatureGrid(context, constraints);
                    },
                  ),
                  // Add more widgets here if needed (e.g. recent announcements)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid(BuildContext context, BoxConstraints constraints) {
    if (widget.features.isEmpty) {
      return _buildPlaceholderCard();
    }
    
    
    // Dynamic Grid Cols based on width
    int crossAxisCount = 2;
    if (constraints.maxWidth > 1200) {
      crossAxisCount = 4;
    } else if (constraints.maxWidth > 800) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
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

  Widget _buildDesktopHomeContent(Size screenSize) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Stack(
                children: [
                   Positioned(
                      right: -50,
                      top: -50,
                       child: Container(
                         width: 200,
                         height: 200,
                         decoration: BoxDecoration(
                           color: Colors.white.withValues(alpha: 0.1),
                           shape: BoxShape.circle,
                         ),
                       ),
                   ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<RoleDashboardBloc, RoleDashboardState>(
                        builder: (context, state) {
                          return Text(
                            state.greetingMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          String name = widget.roleName;
                          if (state is ProfileLoaded) {
                            name = state.user.fullName ?? widget.roleName;
                          }
                          return Text(
                            "Welcome back, $name",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Academic Year 2024-2025",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Content Grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Features
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Quick Access",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 180, // Taller cards
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                        ),
                        itemCount: widget.features.length,
                        itemBuilder: (context, index) {
                          final feature = widget.features[index];
                          return _buildFeatureCard(context, feature);
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 40),
                
                // Sidebar Widgets (e.g. Notifications / Calendar)
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDesktopNotificationWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Removed _buildDesktopFeatureCard to use the standard _buildFeatureCard everywhere

  Widget _buildDesktopNotificationWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (_unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$_unreadCount new",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          // Simple placeholder list
          _buildNotificationPlaceholderItem("School Annual Day announced", "2 hours ago"),
          _buildNotificationPlaceholderItem("Exam schedule for Term 1 released", "Yesterday"),
          _buildNotificationPlaceholderItem("Holiday declared on Monday", "2 days ago"),
          
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => const NotificationsPage()),
                 ).then((_) => _fetchUnreadCount());
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("View All"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPlaceholderItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, DashboardFeature feature) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: Theme.of(context).extension<AppGradients>()?.cardGradient,
        boxShadow: [
          BoxShadow(
            color: feature.color.withValues(alpha: 0.15),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: feature.onTap ?? () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComingSoonPage()),
              );
          },
          child: Stack(
            children: [
              // Decorative Circle
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: feature.color.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            feature.color.withValues(alpha: 0.8),
                            feature.color,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: feature.color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        feature.icon,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF1F2937),
                                  letterSpacing: -0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                feature.subtitle,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[50],
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
        gradient: Theme.of(context).extension<AppGradients>()!.cardGradient,
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TimetablePage()),
            );
          },
        ),
        DashboardFeature(
          title: 'My Attendance',
          subtitle: 'Track your records',
          icon: Icons.fact_check_outlined,
          color: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentAttendancePage()),
            );
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
                MaterialPageRoute(builder: (context) => const ExamSchedulePage()),
              );
          },
        ),
      ],
      navItems: const [
        {'icon': Icons.home_rounded, 'label': 'Home'},
        {'icon': Icons.campaign_rounded, 'label': 'News'},
        {'icon': Icons.currency_rupee_rounded, 'label': 'Fees'},
        {'icon': Icons.person_rounded, 'label': 'Profile'},
      ],
      pages: const [
        SizedBox(height: 0), // Placeholder for Home
        AnnouncementPage(),
        FeeScreen(),
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
          subtitle: 'Record class attendance',
          icon: Icons.edit_calendar_rounded,
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AttendanceInputPage()),
            );
          },
        ),
        DashboardFeature(
          title: 'Create Announcement',
          subtitle: 'Post updates',
          icon: Icons.campaign_rounded,
          color: Colors.indigo,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateAnnouncementPage()),
            );
          },
        ),
        DashboardFeature(
          title: 'Student History',
          subtitle: 'View student records',
          icon: Icons.history_edu_rounded,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentSelectionPage()),
            );
          },
        ),
        DashboardFeature(
          title: 'Timetable',
          subtitle: 'View your schedule',
          icon: Icons.calendar_today_rounded,
          color: Colors.teal,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TimetablePage(role: 'Teacher')),
            );
          },
        ),
      ],
      navItems: const [
        {'icon': Icons.home_rounded, 'label': 'Home'},
        {'icon': Icons.fact_check_outlined, 'label': 'Attend'},
        {'icon': Icons.campaign_rounded, 'label': 'News'},
        {'icon': Icons.person_rounded, 'label': 'Profile'},
      ],
      pages: const [
        SizedBox(height: 0), // Placeholder for Home
        StudentAttendancePage(),
        AnnouncementPage(),
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
          title: 'Create Announcement',
          subtitle: 'Broadcast messages',
          icon: Icons.campaign_rounded,
          color: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateAnnouncementPage()),
            );
          },
        ),
        DashboardFeature(
          title: 'Manage Users',
          subtitle: 'Add or edit users',
          icon: Icons.people_alt_rounded,
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ManageUsersPage()),
            );
          },
        ),
        DashboardFeature(
          title: 'Manage Classes',
          subtitle: 'Configure school structure',
          icon: Icons.school_rounded,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ManageClassesPage()),
            );
          },
        ),
        DashboardFeature(
          title: 'System Settings',
          subtitle: 'Global configurations',
          icon: Icons.settings_rounded,
          color: Colors.grey,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SystemSettingsPage()),
            );
          },
        ),
        DashboardFeature(
          title: 'Reports',
          subtitle: 'View analytics',
          icon: Icons.bar_chart_rounded,
          color: Colors.purple,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportsPage()),
            );
          },
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
          title: 'Create Announcement',
          subtitle: 'Broadcast messages',
          icon: Icons.campaign_rounded,
          color: Colors.redAccent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateAnnouncementPage()),
            );
          },
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
