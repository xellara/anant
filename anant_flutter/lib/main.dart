import 'dart:io';
import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/app.dart';
import 'package:anant_flutter/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

// Export client for other files that import main.dart
export 'package:anant_flutter/client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && Platform.isAndroid) {
    await ph.Permission.storage.request();
  }

  // DEVELOPMENT ENVIRONMENT
  // Change this to your local server IP
  // Use localhost for Web, otherwise use the network IP
  String baseUrl = kIsWeb ? 'http://localhost:8080/' : 'http://192.168.31.151:8080/';
  
  client = Client(
    baseUrl,
  );
  client.authKeyProvider = FlutterAuthenticationKeyManager();

  // Other Common Development IPs:
  // 'http://10.0.2.2:8080/' (Android Emulator)
  // 'http://localhost:8080/' (iOS Simulator / Web)

  runApp(MyApp(client: client));
}
