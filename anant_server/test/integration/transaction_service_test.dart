
import 'package:test/test.dart';
import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/services/transaction_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('TransactionService Integration Test', (sessionBuilder, endpoints) {
    var session = sessionBuilder.build();

    test('Create and Fetch Transaction', () async {
      final txn = MonthlyFeeTransaction(
        month: '2023-01',
        anantId: 'txn_student_1',
        transactionStatus: 'paid',
        feeAmount: 8000.0,
        organizationName: 'Test School',
        discount: 0.0,
        fine: 0.0,
        transactionDate: DateTime.now(),
        transactionGateway: 'Manual',
        transactionRef: 'REF123',
        transactionId: 'TXN123',
        transactionType: 'Cash',
        markedByAnantId: 'admin_user',
      );

      await TransactionService.createTransaction(session, txn);
      
      final fetched = await TransactionService.getTransaction(session, '2023-01', 'txn_student_1');
      expect(fetched, isNotNull);
      expect(fetched?.feeAmount, equals(8000.0));
    });

    test('Super Admin Global Transaction View', () async {
      // Create txns for different students
      await TransactionService.createTransaction(session, MonthlyFeeTransaction(
        month: '2023-02', anantId: 'A1', transactionStatus: 'pending', feeAmount: 100.0,
        organizationName: 'Org A', discount: 0, fine: 0, transactionDate: DateTime.now(),
        transactionGateway: 'G', transactionRef: 'R', transactionId: 'T1', transactionType: 'C', markedByAnantId: 'u'
      ));
      await TransactionService.createTransaction(session, MonthlyFeeTransaction(
        month: '2023-02', anantId: 'B1', transactionStatus: 'pending', feeAmount: 100.0,
        organizationName: 'Org B', discount: 0, fine: 0, transactionDate: DateTime.now(),
        transactionGateway: 'G', transactionRef: 'R', transactionId: 'T2', transactionType: 'C', markedByAnantId: 'u'
      ));

      // Normal Fetch (Org View - restricted to matching anantId/orgName)
      final orgView = await TransactionService.getTransactionsByOrg(session, 'A1'); // Acts as filter
      // Based on filter logic: t.anantId.equals(organizationName)
      expect(orgView.any((t) => t.anantId == 'A1'), isTrue);
      expect(orgView.any((t) => t.anantId == 'B1'), isFalse);

      // Super Admin Fetch (Pass 'Anant')
      final adminView = await TransactionService.getTransactionsByOrg(session, 'Anant');
      // Should see everything
      expect(adminView.length, greaterThanOrEqualTo(2));
      expect(adminView.any((t) => t.anantId == 'A1'), isTrue);
      expect(adminView.any((t) => t.anantId == 'B1'), isTrue);
    });
  });
}
