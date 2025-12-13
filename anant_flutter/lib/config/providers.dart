import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/common/bottom_nav_bloc.dart';
import 'package:anant_flutter/common/settings_bloc.dart';
import 'package:anant_flutter/common/theme_bloc.dart';
import 'package:anant_flutter/features/auth/presentation/auth_screen.dart';
import 'package:anant_flutter/features/transaction/membership_page.dart';
import 'package:anant_flutter/features/profile_screen.dart';
import 'package:anant_flutter/features/student_home/home_screen.dart';
import 'package:anant_flutter/features/teacher_home/teacher_home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppProviders {
  static List<BlocProvider> getProviders({
    required Client client,
  }) {

    return [
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(),
      ),
      BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider<BottomNavBloc>(
          create: (_) => BottomNavBloc(),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => SettingsBloc(client: client)..add(LoadSettings()),
        ),
        BlocProvider<HomeScreenBloc>(
          create: (_) => HomeScreenBloc(),
        ),
        BlocProvider<TeacherHomePageBloc>(
          create: (_) => TeacherHomePageBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(),
        ),
        BlocProvider<MembershipBloc>(
          create: (_) => MembershipBloc(),
        ),
        
    ];
  }
}
