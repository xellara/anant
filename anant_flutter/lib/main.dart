import 'dart:io';
import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/common/theme_bloc.dart';
import 'package:anant_flutter/config/providers.dart';
import 'package:anant_flutter/config/routes.dart';
import 'package:anant_flutter/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

final client = Client(
    'http://192.168.31.151:8080/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  );

// final client = Client(
//   'http://10.0.2.2:8080/',
//   authenticationKeyManager: FlutterAuthenticationKeyManager(),
// );

// final client = Client(
//   'http://192.168.31.135:8080/',
//   authenticationKeyManager: FlutterAuthenticationKeyManager(),
// );

// final client = Client(
//   'http://54.185.188.142:8080/',
//   authenticationKeyManager: FlutterAuthenticationKeyManager(),
// );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await ph.Permission.storage.request();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key,});

  // Light theme configuration
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF4CAF50),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 8,
        ),
      );

  // Dark theme configuration
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          elevation: 2,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: const Color(0xFF4CAF50),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.grey[850],
          elevation: 8,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<Client>.value(
      value: client,
      child: MultiBlocProvider(
        providers: AppProviders.getProviders(client: client),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
              onGenerateRoute: AppRoutes.generateRoute,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            );
          },
        ),
      ),
    );
  }
}
