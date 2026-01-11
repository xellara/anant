import 'package:anant_flutter/anant_progress_indicator.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:anant_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 2 seconds then check the login state.
    Future.delayed(const Duration(seconds: 2), _checkUserSession);
  }

  Future<void> _checkUserSession() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    final String? sessionKey = prefs.getString('sessionKey');
    final int? serverpodUserId = prefs.getInt('serverpodUserId');
    print('Found userId: $userId');
    print('Found sessionKey: $sessionKey');
    print('Found serverpodUserId: $serverpodUserId');
    
    // Check for existence of userId, sessionKey, and serverpodUserId
    if (userId != null && userId != 0 && sessionKey != null && sessionKey.isNotEmpty && serverpodUserId != null) {
      // Restore session key into the client's authentication manager using the correct format.
      var keyManager = client.authKeyProvider as FlutterAuthenticationKeyManager?;
      await keyManager?.put('$serverpodUserId:$sessionKey');
      
      // Fetch the user data using the restored session key.
      final userData = await client.user.me(userId);
      if (userData == null) {
        Navigator.pushReplacementNamed(context, '/auth');
        return;
      }
      print('Logged in as: ${userData.anantId}, role: ${userData.role}');
      
      if (!mounted) return;
      
      // Navigate based on user's password status and role.
      // Navigate based on user's password status and role.
      if (userData.isPasswordCreated == false) {
        Navigator.pushReplacementNamed(context, '/initial-password-update');
      } else {
        // Handle role-based navigation
        // userData.role is an enum, so we convert to string and clean it up
        final roleName = userData.role.toString().split('.').last.toLowerCase();
        print('Navigating for role: $roleName');

        switch (roleName) {
          case 'student':
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 'teacher':
            Navigator.pushReplacementNamed(context, '/teacher-home');
            break;
          case 'admin':
            Navigator.pushReplacementNamed(context, '/admin-home');
            break;
          case 'principal':
            Navigator.pushReplacementNamed(context, '/principal-home');
            break;
          case 'accountant':
            Navigator.pushReplacementNamed(context, '/accountant-home');
            break;
          case 'clerk':
            Navigator.pushReplacementNamed(context, '/clerk-home');
            break;
          case 'librarian':
            Navigator.pushReplacementNamed(context, '/librarian-home');
            break;
          case 'transport':
            Navigator.pushReplacementNamed(context, '/transport-home');
            break;
          case 'hostel':
            Navigator.pushReplacementNamed(context, '/hostel-home');
            break;
          case 'parent':
            Navigator.pushReplacementNamed(context, '/parent-home');
            break;
          default:
            print('Unknown role: $roleName');
            Navigator.pushReplacementNamed(context, '/auth');
        }
      }
    } else {
      // If no valid userId or sessionKey is found, go to the auth screen.
      Navigator.pushReplacementNamed(context, '/auth');
    }
  } catch (error) {
    print("Error during session restoration: $error");
    // Clear stored session data on error to force fresh login
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('sessionKey');
    await prefs.remove('serverpodUserId');
    await prefs.remove('userName');
    // Also clear the auth key manager
    var keyManager = client.authKeyProvider as FlutterAuthenticationKeyManager?;
    await keyManager?.remove();
    
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/auth');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF335762),
      body: const Center(
        child: CustomCircularProgressIndicator(),
      ),
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnantProgressIndicator(
      showBackground: true, // Show background on splash screen
    );
  }
}
