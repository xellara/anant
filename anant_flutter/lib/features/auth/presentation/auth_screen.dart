import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:anant_flutter/anant_progress_indicator.dart';
import 'package:anant_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

// Auth Events
abstract class AuthEvent {}

class AuthCheckSession extends AuthEvent {}

class AuthSignIn extends AuthEvent {
  final String username;
  final String password;
  AuthSignIn({
    required this.username,
    required this.password,
  });
}

class AuthLogout extends AuthEvent {}

class AuthReset extends AuthEvent {}

class AuthClearError extends AuthEvent {}

// Auth States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

class AuthStudentAuthenticated extends AuthState {}

class AuthTeacherAuthenticated extends AuthState {}

class AuthAdminAuthenticated extends AuthState {}

class AuthPrincipalAuthenticated extends AuthState {}

class AuthAccountantAuthenticated extends AuthState {}

class AuthClerkAuthenticated extends AuthState {}

class AuthLibrarianAuthenticated extends AuthState {}

class AuthTransportAuthenticated extends AuthState {}

class AuthHostelAuthenticated extends AuthState {}

class AuthParentAuthenticated extends AuthState {}

class AuthUpdatePassword extends AuthState {}

// AuthBloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    // Check session event: Simply checks for stored userId and sessionKey.
    on<AuthCheckSession>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final int? userId = prefs.getInt('userId');
        final String? sessionKey = prefs.getString('sessionKey');
        
        final int? serverpodUserId = prefs.getInt('serverpodUserId');
        final String? userName = prefs.getString('userName');
        
        // If valid userId and sessionKey exist, attempt to restore the session.
        if (userId != null && userId != 0 && sessionKey != null && sessionKey.isNotEmpty && serverpodUserId != null && userName != null && userName.isNotEmpty) {
          // Restore session key into the client's authentication key manager.
          await (client.authKeyProvider as FlutterAuthenticationKeyManager?)?.put('$serverpodUserId:$sessionKey');
          try {
            final userData = await client.user.getByAnantId(userName!);
            if (userData == null) {
              emit(AuthInitial());
              return;
            }
            // Emit state based on user's password status and role.
            if (userData.isPasswordCreated == false) {
              emit(AuthUpdatePassword());
            } else if (userData.role.toString() == 'student') {
              emit(AuthStudentAuthenticated());
            } else if (userData.role.toString() == 'teacher') {
              emit(AuthTeacherAuthenticated());
            } else if (userData.role.toString() == 'admin') {
              emit(AuthAdminAuthenticated());
            } else if (userData.role.toString() == 'principal') {
              emit(AuthPrincipalAuthenticated());
            } else if (userData.role.toString() == 'accountant') {
              emit(AuthAccountantAuthenticated());
            } else if (userData.role.toString() == 'clerk') {
              emit(AuthClerkAuthenticated());
            } else if (userData.role.toString() == 'librarian') {
              emit(AuthLibrarianAuthenticated());
            } else if (userData.role.toString() == 'transport') {
              emit(AuthTransportAuthenticated());
            } else if (userData.role.toString() == 'hostel') {
              emit(AuthHostelAuthenticated());
            } else if (userData.role.toString() == 'parent') {
              emit(AuthParentAuthenticated());
            } else {
              emit(AuthInitial());
            }
          } catch (e) {
            emit(AuthInitial());
          }
        } else {
          await (client.authKeyProvider as FlutterAuthenticationKeyManager?)?.remove();
          emit(AuthInitial());
        }
      } catch (e) {
        await (client.authKeyProvider as FlutterAuthenticationKeyManager?)?.remove();
        emit(AuthInitial());
      }
    });


    // Sign-in event remains unchanged.
    on<AuthSignIn>((event, emit) async {
      await (client.authKeyProvider as FlutterAuthenticationKeyManager?)?.remove();
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2));
      try {
        print('AuthBloc: Attempting login with username: ${event.username}');
        final result = await client.auth.signIn(event.username, event.password);
        print('AuthBloc: Server returned UserInfo ID: ${result.id}, sessionKey: ${result.key}');
        
        final prefs = await SharedPreferences.getInstance();

        // WORKAROUND: Due to User ID / UserInfo ID mismatch in the database,
        // we fetch user by anantId instead of by ID
        final userData = await client.user.getByAnantId(event.username);
        if (userData == null) throw Exception("User data not found");
        
        print('AuthBloc: Fetched user data - anantId: ${userData.anantId}, fullName: ${userData.fullName}, User ID: ${userData.id}');

        // Use userData.id (actual User ID from custom table)
        final newAccount = {
          'userId': userData.id,  // Use User ID from custom table
          'serverpodUserId': result.id, // Store Serverpod User ID for auth header
          'uid': userData.uid,
          'sessionKey': result.key,
          'userName': userData.anantId ?? '',
          'role': userData.role.toString(),
        };
        
        print('AuthBloc: Created newAccount with userId: ${newAccount['userId']}, userName: ${newAccount['userName']}');

        // Load existing accounts from prefs.
        List<String> accountsJson = prefs.getStringList('accounts') ?? [];
        List<Map<String, dynamic>> existingAccounts = accountsJson
            .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
            .toList();

        // Check if the user already exists.
        final alreadyExists = existingAccounts.any((acc) => acc['userId'] == newAccount['userId']);
        if (!alreadyExists) {
          existingAccounts.add(newAccount);
          print('AuthBloc: Added new account to list');
        } else {
          print('AuthBloc: Account already exists in list');
        }

        // IMPORTANT: Update the client's authentication key manager FIRST
        // This ensures subsequent API calls use the correct session
        await (client.authKeyProvider as FlutterAuthenticationKeyManager?)?.put('${result.id}:${result.key ?? ''}');
        print('AuthBloc: Updated client authentication key manager with new session');

        // Save updated list and active session details.
        await prefs.setStringList(
          'accounts',
          existingAccounts.map((e) => jsonEncode(e)).toList(),
        );
        await prefs.setInt('userId', userData.id!);  // Use User ID
        await prefs.setInt('serverpodUserId', result.id!); // Save Serverpod User ID
        await prefs.setString('uid', userData.uid ?? '');
        await prefs.setString('sessionKey', result.key ?? '');
        await prefs.setString('userName', newAccount['userName'] as String? ?? '');
        await prefs.setString('fullName', userData.fullName ?? '');
        await prefs.setString('role', newAccount['role'] as String? ?? '');
        
        print('AuthBloc: Saved to SharedPreferences - userId: ${userData.id}, userName: ${newAccount['userName']}, fullName: ${userData.fullName}');

        // Emit state based on password status and role.
        if (userData.isPasswordCreated == false) {
          emit(AuthUpdatePassword());
        } else if (userData.role.toString() == 'student') {
          emit(AuthStudentAuthenticated());
        } else if (userData.role.toString() == 'teacher') {
          emit(AuthTeacherAuthenticated());
        } else if (userData.role.toString() == 'admin') {
          emit(AuthAdminAuthenticated());
        } else if (userData.role.toString() == 'principal') {
          emit(AuthPrincipalAuthenticated());
        } else if (userData.role.toString() == 'accountant') {
          emit(AuthAccountantAuthenticated());
        } else if (userData.role.toString() == 'clerk') {
          emit(AuthClerkAuthenticated());
        } else if (userData.role.toString() == 'librarian') {
          emit(AuthLibrarianAuthenticated());
        } else if (userData.role.toString() == 'transport') {
          emit(AuthTransportAuthenticated());
        } else if (userData.role.toString() == 'hostel') {
          emit(AuthHostelAuthenticated());
        } else if (userData.role.toString() == 'parent') {
          emit(AuthParentAuthenticated());
        }
      } catch (e) {
        print('AuthBloc: Error during sign-in: $e');
        
        // Parse error and provide user-friendly messages
        String errorMessage;
        final errorStr = e.toString().toLowerCase();
        
        if (errorStr.contains('invalid credentials') || errorStr.contains('invalid password')) {
          errorMessage = 'Invalid username or password. Please try again.';
        } else if (errorStr.contains('user not found') || errorStr.contains('user data not found')) {
          errorMessage = 'Account not found. Please check your username.';
        } else if (errorStr.contains('network') || errorStr.contains('connection')) {
          errorMessage = 'Network error. Please check your internet connection.';
        } else if (errorStr.contains('timeout')) {
          errorMessage = 'Request timed out. Please try again.';
        } else if (errorStr.contains('500')) {
          errorMessage = 'Server error. Please try again later.';
        } else {
          errorMessage = 'Login failed. Please try again.';
        }
        
        emit(AuthError(message: errorMessage));
      }
    });

    // Logout event clears stored session and removes the key from the client's key manager.
    on<AuthLogout>((event, emit) async {
  final prefs = await SharedPreferences.getInstance();
  // Retrieve the active user id before removing it.
  final int? activeUserId = prefs.getInt('userId');

  // Remove active session keys.
  await prefs.remove('userId');
  await prefs.remove('serverpodUserId');
  await prefs.remove('sessionKey');
  await (client.authKeyProvider as FlutterAuthenticationKeyManager?)?.remove();

  // Load the stored accounts.
  final accountsJson = prefs.getStringList('accounts') ?? [];
  List<Map<String, dynamic>> accounts = accountsJson
      .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
      .toList();

  // Remove the active account from the accounts list.
  if (activeUserId != null) {
    accounts.removeWhere((acc) => acc['userId'] == activeUserId);
  }

  // Save the updated accounts list back to SharedPreferences.
  await prefs.setStringList(
    'accounts',
    accounts.map((acc) => jsonEncode(acc)).toList(),
  );

  // Emit initial state.
  emit(AuthInitial());
});


    on<AuthClearError>((event, emit) {
      emit(AuthInitial());
    });

    on<AuthReset>((event, emit) {
      emit(AuthInitial());
    });
  }
}


/// AuthScreen with the universe background.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isAddingAccount = false;
  bool _isButtonEnabled = false;
  String _lastUsername = "";
  String _lastPassword = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _isAddingAccount = args?['isAddingAccount'] ?? false;
    print('AuthScreen: didChangeDependencies, isAddingAccount: $_isAddingAccount');
  }

  @override
  void initState() {
    super.initState();
    _usernameCtrl.addListener(_validateForm);
    _passwordCtrl.addListener(_validateForm);

    Future.microtask(() async {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final isAdding = args?['isAddingAccount'] ?? false;
      print('AuthScreen: microtask, isAdding: $isAdding');

      if (isAdding) {
        print('AuthScreen: Clearing session and sending AuthReset');
        // Clear client session for new login
        await (client.authKeyProvider as FlutterAuthenticationKeyManager?)?.remove();
        // Reset Bloc to Initial state so listener doesn't trigger immediately
        if (mounted) context.read<AuthBloc>().add(AuthReset());
      } else {
        print('AuthScreen: Sending AuthCheckSession');
        if (mounted) context.read<AuthBloc>().add(AuthCheckSession());
      }
    });
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _validateForm() {
    final authBloc = context.read<AuthBloc>();
    if (_usernameCtrl.text != _lastUsername ||
        _passwordCtrl.text != _lastPassword) {
      _lastUsername = _usernameCtrl.text;
      _lastPassword = _passwordCtrl.text;
      setState(() {
        _isButtonEnabled = _usernameCtrl.text.isNotEmpty &&
            _passwordCtrl.text.isNotEmpty &&
            _passwordCtrl.text.length >= 8;
      });
      if (authBloc.state is AuthError) {
        authBloc.add(AuthClearError());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _isButtonEnabled = false;
        }
        
        if (state is AuthStudentAuthenticated || 
            state is AuthTeacherAuthenticated ||
            state is AuthAdminAuthenticated ||
            state is AuthPrincipalAuthenticated ||
            state is AuthAccountantAuthenticated ||
            state is AuthClerkAuthenticated ||
            state is AuthLibrarianAuthenticated ||
            state is AuthTransportAuthenticated ||
            state is AuthHostelAuthenticated ||
            state is AuthParentAuthenticated) {
          
          String routeName = '/home'; // Default
          if (state is AuthTeacherAuthenticated) routeName = '/teacher-home';
          if (state is AuthAdminAuthenticated) routeName = '/admin-home';
          if (state is AuthPrincipalAuthenticated) routeName = '/principal-home';
          if (state is AuthAccountantAuthenticated) routeName = '/accountant-home';
          if (state is AuthClerkAuthenticated) routeName = '/clerk-home';
          if (state is AuthLibrarianAuthenticated) routeName = '/librarian-home';
          if (state is AuthTransportAuthenticated) routeName = '/transport-home';
          if (state is AuthHostelAuthenticated) routeName = '/hostel-home';
          if (state is AuthParentAuthenticated) routeName = '/parent-home';

          if (_isAddingAccount) {
            Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
          } else {
            Navigator.pushReplacementNamed(context, routeName);
          }
        } else if (state is AuthUpdatePassword) {
          Navigator.pushReplacementNamed(context, '/initial-password-update');
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: AnantProgressIndicator()),
          );
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Star field (static background).
                CustomPaint(painter: StarFieldPainter()),
                // Galaxy background filling the full screen.
                CustomPaint(painter: GalaxyPainter()),
                // Moving planets layer.
                const MovingPlanetsBackground(),
                // Full-screen overlay with gradient for the auth form.
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.withOpacity(0.35),
                        Colors.black.withOpacity(0.35),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 32),
                        child: Card(
                          color: Color(0xFF70D9CE).withAlpha(1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: Colors.white24,
                              width: 1,
                            ),
                          ),
                          elevation: 6,
                          margin: const EdgeInsets.all(16),
                          child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                              // Form content wrapped in Padding.
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                                child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  // Add spacing to account for the overlapping image.
                                  const SizedBox(height: 50),
                                  TextFormField(
                                    controller: _usernameCtrl,
                                    decoration: InputDecoration(
                                    hintText: "Anant ID",
                                    hintStyle: const TextStyle(
                                      color: Colors.white70),
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                      color: Colors.white70,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.2),
                                    
                                    contentPadding:
                                      const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                        BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    ),
                                    cursorColor: Colors.white,
                                    style:
                                      const TextStyle(color: Colors.white),
                                    validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Username cannot be empty';
                                    }
                                    return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _passwordCtrl,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: const TextStyle(
                                    color: Colors.white70),
                                    prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.white70,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.2),
                                    contentPadding:
                                    const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                    borderRadius:
                                      BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                    ),
                                    ),
                                    style:
                                    const TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    validator: (value) {
                                    if (value == null || value.isEmpty) {
                                    return 'Password cannot be empty';
                                    }
                                    return null;
                                    },
                                  ),
                                  if (state is AuthError) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                    state.message,
                                    style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                    ),
                                  ],
                                  const SizedBox(height: 32),
                                  Center(
                                    child: Column(
                                    children: [
                                      RichText(
                                      text: TextSpan(
                                        text:
                                          'By continuing, you accept our ',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white70),
                                        children: [
                                        TextSpan(
                                          text: 'Terms of Use',
                                          style: const TextStyle(
                                          decoration: TextDecoration
                                            .underline,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          ),
                                          recognizer:
                                            TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(context, '/terms-of-use');
                                            },
                                        ),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: const TextStyle(
                                          decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            Navigator.pushNamed(context, '/privacy-policy');
                                                          },
                                                  ),
                                                ],
                                              ),
                                            ),
                                              const SizedBox(height: 24),
                                              InkWell(
                                              onTap: _isButtonEnabled
                                                ? () {
                                                  if (_formKey.currentState!
                                                    .validate()) {
                                                    context
                                                      .read<AuthBloc>()
                                                      .add(AuthSignIn(
                                                      username:
                                                        _usernameCtrl
                                                          .text
                                                          .trim(),
                                                      password:
                                                        _passwordCtrl
                                                          .text
                                                          .trim(),
                                                      ));
                                                  }
                                                  }
                                                : null,
                                              borderRadius:
                                                BorderRadius.circular(50),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color:Color(0xFF70D9CE)
                                                    ,
                                                  width: 2,
                                                ),
                                                color: _isButtonEnabled
                                                  ? Color(0xFF70D9CE)
                                                  : Colors.transparent,
                                                ),
                                                child: Container(
                                                alignment: Alignment.center,
                                                height: 50,
                                                width: 50,
                                                child: Icon(
                                                  Icons
                                                    .arrow_forward_ios_outlined,
                                                  color: _isButtonEnabled
                                                    ? Colors.white
                                                    : Color(0xFF70D9CE),
                                                ),
                                                ),
                                              ),
                                              ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // Positioned placeholder image overlapping at the top center.
                              Positioned(
                                top: -120,
                                left: 0,
                                right: 0,
                                child: Center(
                                child: Image.asset(
                                'assets/images/login.png',
                                height: 180,
                                ),
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
        );
      },
    );
  }
}

/// ==========================
/// UNIVERSE BACKGROUND COMPONENTS
/// ==========================

/// Star field painter draws random stars.
class StarFieldPainter extends CustomPainter {
  final List<Offset> stars;
  final List<double> starSizes;
  StarFieldPainter()
      : stars = List.generate(
            200,
            (index) => Offset(
                  Random(index).nextDouble(),
                  Random(index * 2).nextDouble(),
                )),
        starSizes = List.generate(
            200, (index) => Random(index * 3).nextDouble() * 2 + 1);

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..color = Colors.white;
    for (int i = 0; i < stars.length; i++) {
      final star = stars[i];
      final position = Offset(star.dx * size.width, star.dy * size.height);
      canvas.drawCircle(position, starSizes[i], starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Galaxy painter fills the full screen with a radial gradient.
class GalaxyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        Colors.deepPurple.withOpacity(0.8),
        Colors.indigo.withOpacity(0.6),
        Colors.blue.withOpacity(0.4),
        Colors.black,
      ],
      stops: [0.0, 0.4, 0.7, 1.0],
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MovingPlanetsBackground extends StatefulWidget {
  const MovingPlanetsBackground({Key? key}) : super(key: key);

  @override
  _MovingPlanetsBackgroundState createState() =>
      _MovingPlanetsBackgroundState();
}

class _MovingPlanetsBackgroundState extends State<MovingPlanetsBackground> {
  List<MovingPlanet> planets = [];
  late Size screenSize;
  final Random random = Random();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenSize = MediaQuery.of(context).size;
      initPlanets();
      startTimer(); // Start the periodic timer.
    });
  }

  void initPlanets() {
    // Generate 12 planets with random positions, velocities, and sizes.
    planets = List.generate(12, (i) {
      final position = Offset(
        random.nextDouble() * screenSize.width,
        random.nextDouble() * screenSize.height,
      );
      final velocity = Offset(
        (random.nextDouble() * 4) - 2,
        (random.nextDouble() * 4) - 2,
      );
      // 50% chance to be small or large.
      final isSmall = random.nextBool();
      final radius = isSmall
          ? random.nextDouble() * 8 + 4  // small: 4 to 12
          : random.nextDouble() * 18 + 12; // large: 12 to 30
      List<Gradient> gradients = [
        const LinearGradient(colors: [Colors.red, Colors.orange]),
        const LinearGradient(colors: [Colors.orange, Colors.yellow]),
        const LinearGradient(colors: [Colors.yellow, Colors.green]),
        const LinearGradient(colors: [Colors.green, Colors.blue]),
        const LinearGradient(colors: [Colors.blue, Colors.indigo]),
        const LinearGradient(colors: [Colors.indigo, Colors.purple]),
        const LinearGradient(colors: [Colors.purple, Colors.teal]),
        const LinearGradient(colors: [Colors.teal, Colors.cyan]),
        const LinearGradient(colors: [Colors.cyan, Colors.lime]),
        const LinearGradient(colors: [Colors.lime, Colors.pink]),
        const LinearGradient(colors: [Colors.pink, Colors.amber]),
        const LinearGradient(colors: [Colors.amber, Colors.red]),
      ];
      return MovingPlanet(
        position: position,
        velocity: velocity,
        radius: radius,
        gradient: gradients[i % gradients.length],
      );
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted) return;
      setState(() {
        // Update each planet's position and handle bouncing off edges.
        for (var planet in planets) {
          planet.position += planet.velocity;
          if (planet.position.dx - planet.radius < 0 ||
              planet.position.dx + planet.radius > screenSize.width) {
            planet.velocity = Offset(-planet.velocity.dx, planet.velocity.dy);
          }
          if (planet.position.dy - planet.radius < 0 ||
              planet.position.dy + planet.radius > screenSize.height) {
            planet.velocity = Offset(planet.velocity.dx, -planet.velocity.dy);
          }
        }
        // Handle collisions between planets.
        for (int i = 0; i < planets.length; i++) {
          for (int j = i + 1; j < planets.length; j++) {
            final p1 = planets[i];
            final p2 = planets[j];
            if ((p1.position - p2.position).distance <= p1.radius + p2.radius) {
              p1.velocity = Offset(
                (random.nextDouble() * 4) - 2,
                (random.nextDouble() * 4) - 2,
              );
              p2.velocity = Offset(
                (random.nextDouble() * 4) - 2,
                (random.nextDouble() * 4) - 2,
              );
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent callbacks after disposal.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MovingPlanetsPainter(planets: planets),
      child: Container(),
    );
  }
}

/// Updated planet model with gradient.
class MovingPlanet {
  Offset position;
  Offset velocity;
  final double radius;
  final Gradient gradient;

  MovingPlanet({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.gradient,
  });
}

// / Updated painter that uses the gradient to draw each planet.
class MovingPlanetsPainter extends CustomPainter {
  final List<MovingPlanet> planets;
  MovingPlanetsPainter({required this.planets});

  @override
  void paint(Canvas canvas, Size size) {
    for (final planet in planets) {
      // Draw a shadow for the planet.
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(
          planet.position + const Offset(2, 2), planet.radius, shadowPaint);

      // Create a shader from the planet's gradient.
      final Rect planetRect =
          Rect.fromCircle(center: planet.position, radius: planet.radius);
      final planetPaint = Paint()
        ..shader = planet.gradient.createShader(planetRect);

      canvas.drawCircle(planet.position, planet.radius, planetPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


/// Optional parallax container.
class ParallaxContainer extends StatelessWidget {
  final double xParallax;
  final double yParallax;
  final Widget child;
  const ParallaxContainer({
    Key? key,
    required this.xParallax,
    required this.yParallax,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform:
          Matrix4.translationValues(xParallax * 20, yParallax * 20, 0.0),
      child: child,
    );
  }
}
