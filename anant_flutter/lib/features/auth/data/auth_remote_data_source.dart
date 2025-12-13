import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/features/auth/data/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel?> login(String username, String password) async {
    final response = await client.auth.signIn(username, password);
    
    // Fetch user details to get UID
    final user = await client.user.me(response.id!);
    
    final userMap = {
      'id': response.id,
      'username': username,
      'uid': user?.uid,
    };
    return UserModel.fromJson(userMap);
  }
}