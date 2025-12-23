import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/common/theme_bloc.dart';
import 'package:anant_flutter/config/providers.dart';
import 'package:anant_flutter/config/routes.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/features/profile_screen.dart';
import 'package:anant_flutter/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  final Client client;

  const MyApp({super.key, required this.client});

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
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                // Determine Role Theme
                ThemeData activeTheme = RoleTheme.defaultTheme;
                if (profileState is ProfileLoaded) {
                  activeTheme = RoleTheme.getThemeForRole(profileState.user.role.name);
                }

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: SplashScreen(),
                  onGenerateRoute: AppRoutes.generateRoute,
                  theme: activeTheme,
                  // We can create specific dark themes later, for now use a generic dark aligned with the active primary if possible,
                  // or just the standard dark theme.
                  darkTheme: darkTheme.copyWith(
                    primaryColor: activeTheme.primaryColor,
                    colorScheme: darkTheme.colorScheme.copyWith(
                      primary: activeTheme.primaryColor,
                      secondary: activeTheme.colorScheme.secondary,
                    ),
                  ),
                  themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
