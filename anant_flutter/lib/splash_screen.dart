import 'package:anant_flutter/anant_progress_indicator.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:anant_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anant_client/anant_client.dart'; // Import for ServerpodClientException

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
    final String? userName = prefs.getString('userName');

    print('Found userId: $userId');
    print('Found sessionKey: $sessionKey');
    print('Found serverpodUserId: $serverpodUserId');
    print('Found userName: $userName');
    
    // Check for existence of essential credentials
    if (userId != null && userId != 0 && sessionKey != null && sessionKey.isNotEmpty && serverpodUserId != null && userName != null && userName.isNotEmpty) {
      // Restore session key into the client's authentication manager using the correct format.
      var keyManager = client.authKeyProvider as FlutterAuthenticationKeyManager?;
      await keyManager?.put('$serverpodUserId:$sessionKey');
      
      // Fetch the user data using the restored session key via getByAnantId logic (matching AuthBloc)
      final userData = await client.user.getByAnantId(userName);
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
          case 'anant':
            Navigator.pushReplacementNamed(context, '/anant-home');
            break;  
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
    
    // Check if it's an authentication error
    bool isAuthError = false;
    if (error is ServerpodClientException) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        isAuthError = true;
      }
    }

    if (isAuthError) {
      // Clear stored session data on auth error (session expired/invalid)
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
    } else {
      // For other errors (500, Network), show retry dialog and DO NOT clear session
      if (!mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Connection Issue'),
          content: Text('Unable to connect to server. Please check your internet connection or try again later.\n\nError: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _checkUserSession(); // Retry
              },
              child: const Text('Retry'),
            ),
             TextButton(
              onPressed: () async {
                 // Option to logout manually if stuck
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('userId');
                await prefs.remove('sessionKey');
                await prefs.remove('serverpodUserId');
                await prefs.remove('userName');
                var keyManager = client.authKeyProvider as FlutterAuthenticationKeyManager?;
                await keyManager?.remove();
                
                if (context.mounted) {
                   Navigator.of(context).pop();
                   Navigator.pushReplacementNamed(context, '/auth');
                }
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
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
