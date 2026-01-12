import 'package:anant_flutter/features/auth/presentation/auth_screen.dart';
import 'package:anant_flutter/features/transaction/membership_page.dart';
import 'package:anant_flutter/features/profile_screen.dart';
import 'package:anant_flutter/features/password/initial_password_update.dart';
import 'package:anant_flutter/splash_screen.dart';
import 'package:anant_flutter/time_table_screen.dart';
import 'package:flutter/material.dart';
import 'package:anant_flutter/features/role_dashboards/role_dashboards.dart';
import 'package:anant_flutter/features/role_dashboards/anant/anant_dashboard.dart';
import 'package:anant_flutter/features/legal/terms_of_use_page.dart';
import 'package:anant_flutter/features/legal/privacy_policy_page.dart';

class AppRoutes {
  static const String home= "/home";
  static const String splash= "/splash";
  static const String teacherHome= "/teacher-home";
  static const String profile= "/profile";
  static const String auth= "/auth";
  static const String timeTable= "/time-table";
  static const String attendance= "/attendance";
  static const String initialPasswordUpdate= "/initial-password-update";
  static const String membership= "/membership";
  static const String paymentGateway= "/payment-gateway";

  static const String adminHome = "/admin-home";
  static const String anantHome = "/anant-home";
  static const String principalHome = "/principal-home";
  static const String accountantHome = "/accountant-home";
  static const String clerkHome = "/clerk-home";
  static const String librarianHome = "/librarian-home";
  static const String transportHome = "/transport-home";
  static const String hostelHome = "/hostel-home";
  static const String parentHome = "/parent-home";
  
  // Legal Routes
  static const String termsOfUse = "/terms-of-use";
  static const String privacyPolicy = "/privacy-policy";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auth:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(builder: (_) => const StudentDashboard());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case timeTable:
        return MaterialPageRoute(builder: (_) => const TimeTableScreen());
      case initialPasswordUpdate:
        return MaterialPageRoute(builder: (_) => const InitialPasswordUpdate());
      case teacherHome:
        return MaterialPageRoute(builder: (_) => const TeacherDashboard());
      case membership:
        return MaterialPageRoute(builder: (_) => const MembershipPage());
      case adminHome:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case anantHome:
        return MaterialPageRoute(builder: (_) => const AnantDashboardScreen());
      case principalHome:
        return MaterialPageRoute(builder: (_) => const PrincipalDashboard());
      case accountantHome:
        return MaterialPageRoute(builder: (_) => const AccountantDashboard());
      case clerkHome:
        return MaterialPageRoute(builder: (_) => const ClerkDashboard());
      case librarianHome:
        return MaterialPageRoute(builder: (_) => const LibrarianDashboard());
      case transportHome:
        return MaterialPageRoute(builder: (_) => const TransportDashboard());
      case hostelHome:
        return MaterialPageRoute(builder: (_) => const HostelDashboard());
      case parentHome:
        return MaterialPageRoute(builder: (_) => const ParentDashboard());
      case termsOfUse:
        return MaterialPageRoute(builder: (_) => const TermsOfUsePage());
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Unknown Route ${settings.name}')),
          ),
        );
    } 
  }
}
