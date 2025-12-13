import 'package:anant_client/anant_client.dart';
import 'package:serverpod_client/serverpod_client.dart';

Future<void> main() async {
  // Initialize the client
  final client = Client('http://localhost:8080/');
  
  try {
    print('🌱 Starting database seed...');
    // Call the seed endpoint
    // Note: This requires the client to be regenerated with 'serverpod generate'
    final result = await client.seed.seedDatabase();
    
    if (result['success'] == true) {
      print('✅ Seeding completed successfully!');
      print('Organization: ${result['organization']}');
      print('Users Created:');
      (result['users'] as Map).forEach((key, value) {
        print('  - $key: $value');
      });
    } else {
      print('❌ Seeding failed: ${result['error']}');
    }
  } catch (e) {
    print('❌ Error connecting to server: $e');
    print('Make sure the server is running and the endpoint is generated.');
  } finally {
    client.close();
  }
}
