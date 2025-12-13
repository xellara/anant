import 'dart:convert';
import 'package:anant_flutter/features/auth/domain/auth_usecase.dart';
import 'package:anant_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:anant_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;

  AuthBloc(this.authUseCase) : super(AuthInitial()) {
    on<AuthCheckSession>(_onCheckSession);
    on<AuthLoginOrSignUp>(_onLoginOrSignUp);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthClearError>(_onClearError);
    on<AuthReset>(_onReset);
  }

  Future<void> _onCheckSession(AuthCheckSession event, Emitter<AuthState> emit) async {
    final user = await authUseCase.checkSession();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onLoginOrSignUp(AuthLoginOrSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authUseCase.login(event.username, event.password);
      if (user != null) {
        // Save account to SharedPreferences for multi-user support
        final prefs = await SharedPreferences.getInstance();
        final sessionKey = await FlutterAuthenticationKeyManager().get();
        
        final accountsJson = prefs.getStringList('accounts') ?? [];
        final accounts = accountsJson
            .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
            .toList();
            
        final newAccount = {
          'userId': user.id,
          'userName': user.username,
          'anantId': user.username,
          'sessionKey': sessionKey,
          'role': 'student', // Default, will be updated by ProfileBloc later
        };
        
        accounts.removeWhere((acc) => acc['userId'] == user.id);
        accounts.insert(0, newAccount);
        
        final updatedAccountsJson = accounts.map((acc) => jsonEncode(acc)).toList();
        await prefs.setStringList('accounts', updatedAccountsJson);
        
        await prefs.setInt('userId', user.id);
        if (sessionKey != null) {
            await prefs.setString('sessionKey', sessionKey);
        }

        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError("Either username or password is incorrect"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await authUseCase.logout();
    await FlutterAuthenticationKeyManager().remove();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    emit(AuthInitial());
  }

  void _onClearError(AuthClearError event, Emitter<AuthState> emit) {
    if (state is AuthError) {
      emit(AuthInitial());
    }
  }

  void _onReset(AuthReset event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }
}