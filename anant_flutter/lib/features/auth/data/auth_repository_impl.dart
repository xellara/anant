import 'package:anant_flutter/common/auth_session.dart';
import 'package:anant_flutter/features/auth/data/auth_remote_data_source.dart';
import 'package:anant_flutter/features/auth/domain/auth_repository.dart';
import 'package:anant_flutter/features/auth/domain/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity?> login(String username, String password) async {
    final userModel = await remoteDataSource.login(username, password);
    if (userModel != null) {
      authSession.userId = userModel.id;
      return userModel;
    }
    return null;
  }

  @override
  Future<UserEntity?> checkSession() async {
    if (authSession.userId != null) {
      return UserEntity(id: authSession.userId!, username: "");
    }
    
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      authSession.userId = userId;
      final userName = prefs.getString('userName') ?? "";
      return UserEntity(id: userId, username: userName);
    }
    
    return null;
  }

  @override
  Future<void> logout() async {
    authSession.userId = null;
  }

}