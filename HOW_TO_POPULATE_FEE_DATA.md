# How to Populate Fee Transaction Test Data

## Using the Serverpod Endpoint

You can add fee transactions through the server endpoint or create a seed script.

### Option 1: Via Server Seed Script

Add this to your seed_endpoint.dart to populate fee transactions:

```dart
// Add to seed_endpoint.dart

Future<void> _seedFeeTransactions(Session session) async {
  final students = await User.db.find(
    session,
    where: (t) => t.role.equals(UserRole.student.name),
  );

  final months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final currentMonth = DateTime.now().month;

  for (var student in students) {
    // Create paid transactions for past months (Jan-current month -1)
    for (int i = 0; i < currentMonth - 1; i++) {
      final transaction = MonthlyFeeTransaction(
        anantId: student.anantId!,
        organizationName: student.organizationName,
        month: months[i],
        feeAmount: 5000.0,
        discount: 0.0,
        fine: 0.0,
        transactionDate: DateTime(2025, i + 1, Random().nextInt(10) + 1),
        transactionGateway: 'RazorPay',
        transactionRef: 'REF${Random().nextInt(999999)}',
        transactionId: 'TXN${Random().nextInt(999999)}',
        transactionStatus: 'Paid',
        transactionType: 'Monthly Tuition Fee',
        markedByAnantId: 'SYSTEM',
        isRefunded: false,
      );
      await MonthlyFeeTransaction.db.insertRow(session, transaction);
    }

    // Create pending transactions for current and future months
    for (int i = currentMonth - 1; i < 12; i++) {
      final transaction = MonthlyFeeTransaction(
        anantId: student.anantId!,
        organizationName: student.organizationName,
        month: months[i],
        feeAmount: 5000.0,
        discount: 0.0,
        fine: i == currentMonth - 1 ? 100.0 : 0.0, // Add fine for current month
        transactionDate: DateTime(2025, i + 1, 10),
        transactionGateway: '',
        transactionRef: '',
        transactionId: '',
        transactionStatus: 'Pending',
        transactionType: 'Monthly Tuition Fee',
        markedByAnantId: '',
        isRefunded: false,
      );
      await MonthlyFeeTransaction.db.insertRow(session, transaction);
    }

    // Add some additional fees randomly
    if (Random().nextBool()) {
      final extraFee = MonthlyFeeTransaction(
        anantId: student.anantId!,
        organizationName: student.organizationName,
        month: months[Random().nextInt(currentMonth)],
        feeAmount: 1500.0,
        discount: 0.0,
        fine: 0.0,
        transactionDate: DateTime.now().subtract(Duration(days: Random().nextInt(90))),
        transactionGateway: 'RazorPay',
        transactionRef: 'REF${Random().nextInt(999999)}',
        transactionId: 'TXN${Random().nextInt(999999)}',
        transactionStatus: 'Paid',
        transactionType: 'Library Fee',
        markedByAnantId: 'ADMIN001',
        isRefunded: false,
      );
      await MonthlyFeeTransaction.db.insertRow(session, extraFee);
    }
  }
}
```

### Option 2: Manual Direct API Call

You can also create transactions directly using the client:

```dart
import 'package:anant_client/anant_client.dart';

Future<void> createSampleFeeTransaction() async {
  final transaction = MonthlyFeeTransaction(
    anantId: 'ST001',  // Student's anantId
    organizationName: 'TestSchool',
    month: 'January',
    feeAmount: 5000.0,
    discount: 0.0,
    fine: 0.0,
    transactionDate: DateTime(2025, 1, 10),
    transactionGateway: 'RazorPay',
    transactionRef: 'REF123456',
    transactionId: 'TXN123456',
    transactionStatus: 'Paid',
    transactionType: 'Monthly Tuition Fee',
    markedByAnantId: 'ADMIN001',
    isRefunded: false,
  );

  await client.transaction.createMonthlyFeeTransaction(transaction);
}
```

### Option 3: Via Accountant/Admin Role UI

Create a UI page for accountants to:
1. Select student
2. Select month
3. Enter fee amount
4. Add discounts/fines
5. Mark as paid/pending
6. Submit to backend

## Transaction Status Values

- **"Paid"** - For completed payments (shows in "Paid History" tab)
- **"Pending"** - For upcoming fees (shows in "Upcoming" tab)

## Transaction Types Examples

- "Monthly Tuition Fee"
- "Transportation Fee"
- "Library Fee"
- "Lab Material Fee"
- "Annual Development Charge"
- "Sports Fee"
- "Examination Fee"

## Testing the Student Fee Screen

1. **Start the server:**
   ```bash
   cd d:\anant\anant_server
   dart bin/main.dart
   ```

2. **Populate data using seed endpoint** (if implemented)

3. **Run Flutter app:**
   ```bash
   cd d:\anant\anant_flutter
   flutter run
   ```

4. **Navigate to Fees:**
   - Login as student
   - Tap on "Fees" in bottom navigation
   - Verify data loads from backend

## Verify Data in Database

Check if data exists:

```sql
SELECT * FROM monthly_fee_transaction WHERE anant_id = 'ST001';
```

## Common Issues

### 1. No Data Showing
- Ensure fee transactions exist in database for the logged-in student's `anantId`
- Check server logs for errors
- Verify student's `anantId` is correct

### 2. Error Loading
- Check network connection
- Verify server is running
- Check server endpoint implementation

### 3. Wrong Data Showing
- Verify `anantId` matches between student and transactions
- Check transaction status values ('Paid' vs 'Pending')
