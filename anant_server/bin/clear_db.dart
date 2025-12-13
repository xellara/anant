import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/generated/endpoints.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

void main(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  var session = await pod.createSession(enableLogging: true);
  
  print('\n--- CLEARING DATABASE (Users & Auth) ---');

  try {
    // 1. Delete UserCredentials
    print('Deleting UserCredentials...');
    var creds = await UserCredentials.db.deleteWhere(session, where: (t) => Constant.bool(true));
    print('Deleted $creds credentials.');

    // 2. Delete Users
    print('Deleting Users...');
    var users = await User.db.deleteWhere(session, where: (t) => Constant.bool(true));
    print('Deleted $users users.');

    // 3. Delete Auth UserInfo
    // Note: Be careful deleting all auth info if there are system users, but for dev it's usually fine.
    print('Deleting Auth.UserInfo...');
    var authUsers = await auth.UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true));
    print('Deleted $authUsers auth users.');

  } catch (e, stack) {
    print('Error: $e');
    print(stack);
  }
  
  await session.close();
}
