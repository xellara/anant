import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// App Gradients Extension
// -----------------------------------------------------------------------------
class AppGradients extends ThemeExtension<AppGradients> {
  final LinearGradient primaryGradient;
  final LinearGradient cardGradient;
  final LinearGradient backgroundGradient;

  const AppGradients({
    required this.primaryGradient,
    required this.cardGradient,
    required this.backgroundGradient,
  });

  @override
  AppGradients copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? cardGradient,
    LinearGradient? backgroundGradient,
  }) {
    return AppGradients(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      cardGradient: cardGradient ?? this.cardGradient,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    );
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) return this;
    return AppGradients(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      cardGradient: LinearGradient.lerp(cardGradient, other.cardGradient, t)!,
      backgroundGradient: LinearGradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
    );
  }
}

class RoleTheme {
  // ---------------------------------------------------------------------------
  // 1. STUDENT THEME (Vibrant, Energetic, Creative)
  // Primary: Premium Indigo | Accent: Light Blue
  // ---------------------------------------------------------------------------
  static ThemeData get studentTheme {
    const primary = Color(0xFF304FFE); // Deep Indigo Accent
    const secondary = Color(0xFF2979FF); // Blue Accent
    return _baseTheme(
      primary: primary,
      secondary: secondary,
      background: const Color(0xFFF0F4F8), // Soft Blue-Grey Background
      surface: Colors.white,
      brightness: Brightness.light,
      gradients: const AppGradients(
        primaryGradient: LinearGradient(
          colors: [Color(0xFF304FFE), Color(0xFF536DFE)], // Deep to Soft Indigo
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        cardGradient: LinearGradient(
          colors: [Colors.white, Color(0xFFE8EAF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        backgroundGradient: LinearGradient(
          colors: [Color(0xFFF0F4F8), Color(0xFFE1E5EB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. TEACHER THEME (Calm, Professional, Knowledgeable)
  // ---------------------------------------------------------------------------
  static ThemeData get teacherTheme {
    const primary = Color(0xFF10B981);
    const secondary = Color(0xFFF59E0B);
    return _baseTheme(
      primary: primary,
      secondary: secondary,
      background: const Color(0xFFF3FAF7),
      surface: Colors.white,
      brightness: Brightness.light,
       gradients: const AppGradients(
        primaryGradient: LinearGradient(colors: [primary, Color(0xFF34D399)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        cardGradient: LinearGradient(colors: [Colors.white, Color(0xFFECFDF5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        backgroundGradient: LinearGradient(colors: [Color(0xFFF3FAF7), Color(0xFFE0F2F1)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. ADMIN THEME (Authoritative, Serious, Structured)
  // ---------------------------------------------------------------------------
  static ThemeData get adminTheme {
    const primary = Color(0xFF1E293B);
    const secondary = Color(0xFFEF4444);
    return _baseTheme(
      primary: primary,
      secondary: secondary,
      background: const Color(0xFFF1F5F9),
      surface: Colors.white,
      brightness: Brightness.light,
       gradients: const AppGradients(
        primaryGradient: LinearGradient(colors: [primary, Color(0xFF334155)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        cardGradient: LinearGradient(colors: [Colors.white, Color(0xFFF8FAFC)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        backgroundGradient: LinearGradient(colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. PARENT THEME (Warm, Trusting, Caring)
  // ---------------------------------------------------------------------------
  static ThemeData get parentTheme {
    const primary = Color(0xFF8B5CF6);
    const secondary = Color(0xFFEC4899);
    return _baseTheme(
      primary: primary,
      secondary: secondary,
      background: const Color(0xFFF5F3FF),
      surface: Colors.white,
      brightness: Brightness.light,
       gradients: const AppGradients(
        primaryGradient: LinearGradient(colors: [primary, secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        cardGradient: LinearGradient(colors: [Colors.white, Color(0xFFFAF5FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        backgroundGradient: LinearGradient(colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. BUS DRIVER THEME (Alert, Transport, Industrial)
  // ---------------------------------------------------------------------------
  static ThemeData get driverTheme {
    const primary = Color(0xFFF97316);
    const secondary = Color(0xFF374151);
    return _baseTheme(
      primary: primary,
      secondary: secondary,
      background: const Color(0xFFFFF7ED),
      surface: Colors.white,
      brightness: Brightness.light,
       gradients: const AppGradients(
        primaryGradient: LinearGradient(colors: [primary, Color(0xFFFB923C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        cardGradient: LinearGradient(colors: [Colors.white, Color(0xFFFFF7ED)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        backgroundGradient: LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 6. SECURITY THEME (Guarded, Safe, Neutral)
  // ---------------------------------------------------------------------------
  static ThemeData get securityTheme {
    const primary = Color(0xFF475569);
    const secondary = Color(0xFF22C55E);
    return _baseTheme(
      primary: primary,
      secondary: secondary,
      background: const Color(0xFFF8FAFC),
      surface: Colors.white,
      brightness: Brightness.light,
       gradients: const AppGradients(
        primaryGradient: LinearGradient(colors: [primary, Color(0xFF64748B)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        cardGradient: LinearGradient(colors: [Colors.white, Color(0xFFF1F5F9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        backgroundGradient: LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DEFAULT / FALLBACK THEME
  // ---------------------------------------------------------------------------
  static ThemeData get defaultTheme {
    const primary = Color(0xFF3B82F6);
    const secondary = Color(0xFFEAB308);
    return _baseTheme(
      primary: primary,
      secondary: secondary,
      background: const Color(0xFFF8FAFC),
      surface: Colors.white,
      brightness: Brightness.light,
      gradients: const AppGradients(
        primaryGradient: LinearGradient(colors: [primary, secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        cardGradient: LinearGradient(colors: [Colors.white, Color(0xFFEFF6FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        backgroundGradient: LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFDBEAFE)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper to build a consistent ThemeData
  // ---------------------------------------------------------------------------
  static ThemeData _baseTheme({
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Brightness brightness,
    required AppGradients gradients,
  }) {
    return ThemeData(
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      extensions: [gradients], // Add extensions here
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 72, // Bigger height
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 28), // Slightly bigger icons
        actionsIconTheme: const IconThemeData(color: Colors.white, size: 28),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent, // Ensure transparency for floating navbar
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey.shade400,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        labelStyle: TextStyle(color: Colors.grey[600]),
      ),
      useMaterial3: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Helper method to get theme by Role Name
  // ---------------------------------------------------------------------------
  static ThemeData getThemeForRole(String? role) {
    if (role == null) return defaultTheme;
    
    switch (role.toLowerCase()) {
      case 'student':
        return studentTheme;
      case 'teacher':
      case 'faculty':
        return teacherTheme;
      case 'admin':
      case 'administrator':
      case 'principal':
        return adminTheme;
      case 'parent':
      case 'guardian':
        return parentTheme;
      case 'bus_driver':
      case 'driver':
      case 'transport':
        return driverTheme;
      case 'security':
      case 'guard':
        return securityTheme;
      default:
        return defaultTheme;
    }
  }
}
