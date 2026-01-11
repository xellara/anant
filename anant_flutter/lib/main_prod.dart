import 'dart:io';
import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/app.dart';
import 'package:anant_flutter/client.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// Export client for compatibility
export 'package:anant_flutter/client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await ph.Permission.storage.request();
  }

  // PRODUCTION ENVIRONMENT
  client = Client('https://anant-server-32qta2j2eq-uc.a.run.app/');
  client.connectivityMonitor = FlutterConnectivityMonitor();
  client.authKeyProvider = FlutterAuthenticationKeyManager();

  runApp(MyApp(client: client));
}
