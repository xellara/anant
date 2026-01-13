import 'package:serverpod/serverpod.dart';

class SeedEndpoint extends Endpoint {
  
  Future<Map<String, dynamic>> seedDatabase(Session session) async {
    return {
      "success": false,
      "message": "Seeding via API is deprecated. Please run 'dart bin/seed_data.dart' on the server directly for comprehensive seeding.",
    };
  }
}
