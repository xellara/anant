import 'dart:math';
import 'package:serverpod/serverpod.dart';
import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/generated/endpoints.dart';

void main(List<String> args) async {
  final serverpod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  final session = await serverpod.createSession(enableLogging: true);
  final random = Random();

  try {
    print('🌱 Starting Fee Seeding...');

    // 1. Check if Fee Data Exists
    final existingFees = await MonthlyFeeTransaction.db.find(
      session,
      limit: 1,
    );

    if (existingFees.isNotEmpty) {
      print('⚠️ Fee data already exists. Skipping seeding to prevent duplicates.');
      print('To force re-seed, clear the "monthly_fee_transaction" table first.');
      return;
    }

    // 2. Fetch Students
    // We assume students have role 'student' or we filter by it if needed.
    // Since UserRole is an enum, we might not be able to query by it easily in all setups without precise knowledge of serialization, 
    // but usually checking `role` field works if it maps correctly. 
    // Alternatively, we can just fetch all users and filter in Dart if dataset is small (it is for seeding).
    final allUsers = await User.db.find(session, where: (t) => Constant.bool(true));
    final students = allUsers.where((u) => u.role == UserRole.student).toList();

    if (students.isEmpty) {
      print('❌ No students found. Please run the main seeding script first to create users.');
      return;
    }

    print('Found ${students.length} students. Generating fee records...');

    int createdCount = 0;
    
    // Fee Config
    final feeAmount = 5000.0;
    final months = [
      'April', 'May', 'June', 'July', 'August', 'September', // Pasts (Paid)
      'October', 'November', 'December', 'January', 'February', 'March' // Upcoming (Pending)
    ];

    // Current imaginary date for seeding context: Let's assume we are in October
    // So April-Sept are Paid, Oct-March are Pending.
    
    for (var student in students) {
      if (student.anantId == null) {
        print('⚠️ Skipping student with no anantId: ${student.fullName}');
        continue;
      }

      for (int i = 0; i < months.length; i++) {
        final month = months[i];
        
        // Determine if this is Paid (Past) or Pending (Future)
        // We'll arbitrarily say first 6 months are PAID, rest are PENDING
        final isPaid = i < 6;
        
        // Status & Dates
        String status = isPaid ? 'Success' : 'Pending';
        DateTime dueDate;
        
        // Calculate dates
        final baseYear = 2024;
        final monthIndex = i + 4; // April is 4th month
        int year = baseYear;
        int monthNum = monthIndex;
        if (monthNum > 12) {
          monthNum -= 12;
          year++;
        }
        
        dueDate = DateTime(year, monthNum, 10);
        
        // Fee Config
        final feeVal = feeAmount;

        final fee = MonthlyFeeTransaction(
          anantId: student.anantId!,
          organizationName: student.organizationName,
          month: month,
          feeAmount: feeVal,
          discount: 0,
          fine: 0,
          transactionDate: dueDate,
          transactionGateway: isPaid ? 'Cash' : '', // Required String
          transactionRef: isPaid ? 'REF-${random.nextInt(100000)}' : '', // Required String
          transactionId: isPaid ? 'TXN-${random.nextInt(100000)}' : '', // Required String
          transactionStatus: status,
          transactionType: 'Tuition Fee',
          markedByAnantId: 'system',
          isRefunded: false, 
        );

        await MonthlyFeeTransaction.db.insertRow(session, fee);
        createdCount++;
      }
    }

    print('✅ Successfully seeded $createdCount fee transactions for ${students.length} students.');

  } catch (e, stack) {
    print('❌ Error seeding fees: $e');
    print(stack);
  } finally {
    await session.close();
    await serverpod.shutdown();
  }
}
