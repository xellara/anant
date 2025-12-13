import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// EVENT
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object> get props => [];
}

class ToggleThemeEvent extends ThemeEvent {
  final bool isDark;
  const ToggleThemeEvent({required this.isDark});
  @override
  List<Object> get props => [isDark];
}

// STATE
class ThemeState extends Equatable {
  final bool isDarkMode;
  const ThemeState({required this.isDarkMode});
  @override
  List<Object> get props => [isDarkMode];
}

// BLoC with SharedPreferences integration
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(isDarkMode: false)) {
    on<ToggleThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', event.isDark);
      emit(ThemeState(isDarkMode: event.isDark));
    });
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    add(ToggleThemeEvent(isDark: isDark));
  }
}
