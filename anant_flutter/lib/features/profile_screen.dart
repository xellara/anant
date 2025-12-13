import 'dart:async';
import 'dart:convert';
import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// =====================
/// BLoC Events
/// =====================
abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class ClearSelectedAccountEvent extends ProfileEvent {}

class LoadAccountInfoEvent extends ProfileEvent {
  final Map<String, dynamic> account;
  LoadAccountInfoEvent(this.account);
}

class SwitchAccountEvent extends ProfileEvent {
  final Map<String, dynamic> account;
  SwitchAccountEvent(this.account);
}

class LogoutEvent extends ProfileEvent {}

/// =====================
/// BLoC States
/// =====================
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final int activeUserId;
  final List<Map<String, dynamic>> accounts;
  final Map<String, dynamic>? selectedAccount;
  ProfileLoaded({
    required this.user,
    required this.activeUserId,
    required this.accounts,
    this.selectedAccount,
  });

  ProfileLoaded copyWith({
    User? user,
    int? activeUserId,
    List<Map<String, dynamic>>? accounts,
    Map<String, dynamic>? selectedAccount,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      activeUserId: activeUserId ?? this.activeUserId,
      accounts: accounts ?? this.accounts,
      selectedAccount: selectedAccount,
    );
  }
}

class ProfileActionState extends ProfileState {
  final String route;
  final bool removeAll;
  ProfileActionState({required this.route, this.removeAll = false});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

/// =====================
/// BLoC Implementation
/// =====================
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  // Flag to record clear intent when state is not loaded.
  bool _pendingClearSelectedAccount = false;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<LoadAccountInfoEvent>(_onLoadAccountInfo);
    on<SwitchAccountEvent>(_onSwitchAccount);
    on<LogoutEvent>(_onLogout);
    on<ClearSelectedAccountEvent>(_onClearSelectedAccount);
  }

  Future<int?> _loadActiveUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> _onClearSelectedAccount(
      ClearSelectedAccountEvent event, Emitter<ProfileState> emit) async {
    if (state is! ProfileLoaded) {
      _pendingClearSelectedAccount = true;
      return;
    }

    // When state is ProfileLoaded, clear the selected account.
    final currentState = state as ProfileLoaded;
    if (currentState.selectedAccount != null) {
      final newState = currentState.copyWith(selectedAccount: null);
      emit(newState);
    } else {
    }
  }

  Future<List<Map<String, dynamic>>> _loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getStringList('accounts') ?? [];
    return accountsJson
        .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
        .toList();
  }

  Future<User> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final int userId = prefs.getInt('userId') ?? 0;
    final userData = await client.user.me(userId);
    if (userData == null) throw Exception("User data is null");
    return userData;
  }

  Future<void> _onLoadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final activeUserId = await _loadActiveUserId() ?? 0;
      final userData = await _fetchUserData();
      var accounts = await _loadAccounts();

      // Sync fetched user data with stored accounts
      final index = accounts.indexWhere((acc) => acc['userId'] == activeUserId);
      if (index != -1) {
        accounts[index]['userName'] = userData.fullName;
        accounts[index]['anantId'] = userData.anantId;
        accounts[index]['role'] = userData.role.toString().split('.').last; // Assuming enum
        
        // Save updated accounts list
        final prefs = await SharedPreferences.getInstance();
        final updatedAccountsJson = accounts.map((acc) => jsonEncode(acc)).toList();
        await prefs.setStringList('accounts', updatedAccountsJson);
        
        // Also update current session details
        await prefs.setString('userName', userData.fullName ?? '');
        await prefs.setString('role', accounts[index]['role']);
      }

      // Create the new profile loaded state
      ProfileLoaded newState = ProfileLoaded(
        user: userData,
        activeUserId: activeUserId,
        accounts: accounts,
        selectedAccount: null,
      );

      // If a clear intent is pending and there is a selectedAccount, clear it.
      if (_pendingClearSelectedAccount && newState.selectedAccount != null) {
        newState = newState.copyWith(selectedAccount: null);
        _pendingClearSelectedAccount = false;
      }

      emit(newState);
    } catch (error) {
      emit(ProfileError("Error fetching profile data: $error"));
    }
  }

  Future<void> _onLoadAccountInfo(
      LoadAccountInfoEvent event, Emitter<ProfileState> emit) async {
    try {
      final User? updatedUser = await client.user.me(event.account['userId']);
      if (state is ProfileLoaded && updatedUser != null) {
        final currentState = state as ProfileLoaded;
        final newSelectedAccount = {
          'userName': updatedUser.fullName ?? '',
          'anantId': updatedUser.anantId,
          // add additional fields as needed
        };
        emit(currentState.copyWith(selectedAccount: newSelectedAccount));
      }
    } catch (error) {
      debugPrint('Error fetching account info: $error');
    }
  }

  Future<void> _onSwitchAccount(
      SwitchAccountEvent event, Emitter<ProfileState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', event.account['userId']);
      await prefs.setString('sessionKey', event.account['sessionKey']);
      await prefs.setString('userName', event.account['userName'] ?? '');
      await prefs.setString('role', event.account['role'] ?? '');
      
      // Update Serverpod client with new session
      await client.authenticationKeyManager?.put(
        event.account['sessionKey'],
      );
      
      emit(ProfileActionState(route: '/splash'));
    } catch (error) {
      emit(ProfileError("Error switching account: $error"));
    }
  }

  Future<void> _onLogout(
      LogoutEvent event, Emitter<ProfileState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountsJson = prefs.getStringList('accounts') ?? [];
      final accounts = accountsJson
          .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
          .toList();
      final activeUserId = prefs.getInt('userId');

      // Remove the active account from the list.
      accounts.removeWhere((account) => account['userId'] == activeUserId);

      if (accounts.isEmpty) {
        await prefs.clear();
        await client.authenticationKeyManager?.remove();
        emit(ProfileActionState(route: '/', removeAll: true));
      } else {
        final updatedAccountsJson = accounts.map((account) => jsonEncode(account)).toList();
        await prefs.setStringList('accounts', updatedAccountsJson);

        final newActiveAccount = accounts.first;
        await prefs.setInt('userId', newActiveAccount['userId']);
        await prefs.setString('sessionKey', newActiveAccount['sessionKey']);
        await prefs.setString('userName', newActiveAccount['userName'] ?? '');
        await prefs.setString('role', newActiveAccount['role'] ?? '');

        // Update Serverpod client with new session
        await client.authenticationKeyManager?.put(
          newActiveAccount['sessionKey'],
        );

        emit(ProfileActionState(route: '/splash'));
      }
    } catch (error) {
      emit(ProfileError("Error during logout: $error"));
    }
  }
}

/// =====================
/// UI - ProfileScreen using Bloc
/// =====================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late ProfileBloc _profileBloc;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _accountInfoTimer;
  int _remainingSeconds = 3;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc()..add(LoadProfileEvent());
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileBloc.add(LoadProfileEvent());
  }

  @override
  void dispose() {
    _accountInfoTimer?.cancel();
    _animationController.dispose();
    _profileBloc.close();
    super.dispose();
  }

  String _getInitials(String userName) {
    final parts = userName.split(RegExp(r'[\s@.]'));
    String initials = '';
    for (final part in parts) {
      if (part.isNotEmpty && RegExp(r'[A-Za-z]').hasMatch(part[0])) {
        initials += part[0].toUpperCase();
      }
    }
    return initials.substring(0, initials.length > 2 ? 2 : initials.length);
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return const Color(0xFF667EEA);
      case 'teacher':
        return const Color(0xFF10B981);
      case 'admin':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6366F1);
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return Icons.school_rounded;
      case 'teacher':
        return Icons.person_rounded;
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      default:
        return Icons.account_circle_rounded;
    }
  }

  List<Widget> _buildRoleSpecificDetails(User userData) {
    final role = userData.role.toString().toLowerCase();
    if (role == 'student') {
      return [
        _modernInfoTile(Icons.confirmation_number_rounded, "Admission Number", userData.admissionNumber ?? ''),
        _modernInfoTile(Icons.class_rounded, "Class", userData.className ?? ''),
        _modernInfoTile(Icons.group_rounded, "Section", userData.sectionName ?? ''),
        _modernInfoTile(Icons.format_list_numbered_rounded, "Roll Number", userData.rollNumber?.toString() ?? ""),
      ];
    } else if (role == 'teacher') {
      return [
        if (userData.subjectTeaching != null && userData.subjectTeaching!.isNotEmpty)
          _modernInfoTile(Icons.book_rounded, "Subjects", userData.subjectTeaching!.join(', ')),
        if (userData.classAndSectionTeaching != null && userData.classAndSectionTeaching!.isNotEmpty)
          _modernInfoTile(Icons.class_rounded, "Classes", userData.classAndSectionTeaching!.join(', ')),
      ];
    }
    return [];
  }

  Widget _modernInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF6B7280)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? 'N/A' : value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernInfoCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _accountSwitcherWidget(BuildContext context, ProfileLoaded state) {
    if (state.accounts.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            "Accounts",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.accounts.length + 1,
            itemBuilder: (context, index) {
              if (index < state.accounts.length) {
                final account = state.accounts[index];
                final bool isActive = account['userId'] == state.activeUserId;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (!isActive) {
                                context.read<ProfileBloc>().add(SwitchAccountEvent(account));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: isActive
                                    ? const LinearGradient(
                                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                                      )
                                    : LinearGradient(
                                        colors: [Colors.grey.shade300, Colors.grey.shade400],
                                      ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isActive
                                        ? const Color(0xFF10B981).withOpacity(0.4)
                                        : Colors.black.withOpacity(0.1),
                                    blurRadius: isActive ? 12 : 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  _getInitials(account['userName'] ?? ''),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isActive)
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            )
                          else
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: GestureDetector(
                                onTap: () {
                                  _accountInfoTimer?.cancel();
                                  setState(() {
                                    _remainingSeconds = 3;
                                  });
                                  context.read<ProfileBloc>().add(LoadAccountInfoEvent(account));
                                  
                                  _accountInfoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                                    if (mounted) {
                                      setState(() {
                                        _remainingSeconds--;
                                      });
                                      if (_remainingSeconds <= 0) {
                                        timer.cancel();
                                        context.read<ProfileBloc>().add(ClearSelectedAccountEvent());
                                      }
                                    } else {
                                      timer.cancel();
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF3B82F6), width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.info,
                                    size: 14,
                                    color: Color(0xFF3B82F6),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/auth', arguments: {'isAddingAccount': true});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        if (state.selectedAccount != null)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF3B82F6).withOpacity(0.1), const Color(0xFF2563EB).withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "Account Details",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Name: ${state.selectedAccount!['userName'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Anant ID: ${state.selectedAccount!['anantId'] ?? ''}",
                      style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF3B82F6)),
                        const SizedBox(width: 4),
                        Text(
                          "${_remainingSeconds}s",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileActionState) {
            if (state.removeAll) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
                (route) => false,
              );
            } else {
              Navigator.pushReplacementNamed(context, state.route);
            }
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            Widget content;
            
            if (state is ProfileLoading || state is ProfileInitial) {
              content = Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.shade50,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                    ),
                  ),
                ),
              );
            } else if (state is ProfileError) {
              content = Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
                      const SizedBox(height: 16),
                      const Text(
                        "Error fetching user data",
                        style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileLoaded) {
              final userData = state.user;
              final userRole = userData.role.toString().toLowerCase();
              final roleColor = _getRoleColor(userRole);
              
              content = Scaffold(
                body: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            roleColor.withOpacity(0.05),
                            Colors.white,
                          ],
                          stops: const [0.0, 0.3],
                        ),
                      ),
                      child: CustomScrollView(
                        slivers: [
                          // App Bar with integrated profile card
                          SliverAppBar(
                            expandedHeight: 380,
                            floating: false,
                            pinned: true,
                            backgroundColor: roleColor,
                            flexibleSpace: LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                // Calculate opacity based on scroll - clamp to valid range
                                final double appBarHeight = constraints.biggest.height;
                                final double expandRatio = ((appBarHeight - kToolbarHeight) / (380 - kToolbarHeight)).clamp(0.0, 1.0);
                                
                                return FlexibleSpaceBar(
                                  background: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          roleColor,
                                          roleColor.withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Decorative circles
                                        Positioned(
                                          right: -30,
                                          top: -30,
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(0.1),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: -50,
                                          bottom: -50,
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(0.1),
                                            ),
                                          ),
                                        ),
                                        
                                        // Profile Card in Header
                                        Positioned.fill(
                                          child: SafeArea(
                                            child: Opacity(
                                              opacity: expandRatio,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.95),
                                                    borderRadius: BorderRadius.circular(24),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.15),
                                                        blurRadius: 20,
                                                        offset: const Offset(0, 10),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Avatar
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          gradient: LinearGradient(
                                                            colors: [roleColor, roleColor.withOpacity(0.7)],
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: roleColor.withOpacity(0.4),
                                                              blurRadius: 15,
                                                              offset: const Offset(0, 5),
                                                            ),
                                                          ],
                                                        ),
                                                        child: CircleAvatar(
                                                          radius: 50,
                                                          backgroundColor: Colors.transparent,
                                                          child: Text(
                                                            _getInitials(userData.fullName ?? ""),
                                                            style: const TextStyle(
                                                              fontSize: 30,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              letterSpacing: 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 16),
                                                      
                                                      // Name
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                                        child: Text(
                                                          userData.fullName ?? '',
                                                          textAlign: TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight: FontWeight.w700,
                                                            color: Color(0xFF1F2937),
                                                            letterSpacing: -0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      
                                                      // Role Badge
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [roleColor.withOpacity(0.2), roleColor.withOpacity(0.1)],
                                                          ),
                                                          borderRadius: BorderRadius.circular(20),
                                                          border: Border.all(
                                                            color: roleColor.withOpacity(0.3),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(_getRoleIcon(userRole), color: roleColor, size: 16),
                                                            const SizedBox(width: 6),
                                                            Text(
                                                              userRole == 'student'
                                                                  ? 'Student'
                                                                  : userRole[0].toUpperCase() + userRole.substring(1),
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w600,
                                                                color: roleColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 12),
                                                      
                                                      // Anant ID
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFF9FAFB),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const Icon(Icons.badge_rounded, size: 16, color: Color(0xFF6B7280)),
                                                            const SizedBox(width: 6),
                                                            Text(
                                                              userData.anantId ?? "",
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w500,
                                                                color: Color(0xFF6B7280),
                                                                fontFamily: 'monospace',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: Opacity(
                                    opacity: (1.0 - expandRatio).clamp(0.0, 1.0),
                                    child: const Text(
                                      'Profile',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                                  centerTitle: false,
                                );
                              },
                            ),
                          ),
                          
                          // Content
                          SliverToBoxAdapter(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                 child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       // Account Switcher
                                      if (state.accounts.isNotEmpty)
                                        _accountSwitcherWidget(context, state),
                                      
                                      // Contact Information
                                      if ((userData.email != null && userData.email!.isNotEmpty) ||
                                          (userData.mobileNumber != null && userData.mobileNumber!.isNotEmpty))
                                        _modernInfoCard(
                                          title: "Contact Information",
                                          icon: Icons.contact_mail_rounded,
                                          children: [
                                            if (userData.email != null && userData.email!.isNotEmpty)
                                              _modernInfoTile(Icons.email_rounded, "Email", userData.email ?? ""),
                                            if (userData.mobileNumber != null && userData.mobileNumber!.isNotEmpty)
                                              _modernInfoTile(Icons.phone_rounded, "Phone", userData.mobileNumber ?? ""),
                                          ],
                                        ),
                                      
                                      // Role Specific Details
                                      if (_buildRoleSpecificDetails(userData).isNotEmpty)
                                        _modernInfoCard(
                                          title: userRole == 'student' ? "Academic Details" : "Professional Details",
                                          icon: userRole == 'student' ? Icons.school_rounded : Icons.work_rounded,
                                          children: _buildRoleSpecificDetails(userData),
                                        ),
                                      
                                      const SizedBox(height: 10),
                                      
                                      // Logout Button
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFEF4444).withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(16),
                                            onTap: () {
                                              context.read<ProfileBloc>().add(LogoutEvent());
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    "Logout",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              content = const SizedBox.shrink();
            }
            
            return state is ProfileLoaded
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _accountInfoTimer?.cancel();
                      FocusScope.of(context).unfocus();
                      context.read<ProfileBloc>().add(ClearSelectedAccountEvent());
                    },
                    child: content,
                  )
                : content;
          },
        ),
      ),
    );
  }
}


