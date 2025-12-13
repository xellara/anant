import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart'; // imports generated MonthlyFeeTransaction class

class TransactionEndpoint extends Endpoint {
  /// Create a new MonthlyFeeTransaction in the database (no checks).
  Future<MonthlyFeeTransaction> createMonthlyFeeTransaction(
    Session session,
    MonthlyFeeTransaction txn,
  ) async {
    return await MonthlyFeeTransaction.db.insertRow(session, txn);
  }

  /// Retrieve a single MonthlyFeeTransaction by its month
  Future<MonthlyFeeTransaction?> getMonthlyFeeTransaction(
    Session session,
    String month,
    String anantId,
  ) async {
    return await MonthlyFeeTransaction.db.findFirstRow(
      session,
      where: (t) => t.month.equals(month) & t.anantId.equals(anantId),
    );
  }

  /// Retrieve all MonthlyFeeTransactions
  Future<List<MonthlyFeeTransaction>> getAllMonthlyFeeTransactionUser(
    Session session,
    String anantId,
  ) async {
    return await MonthlyFeeTransaction.db.find(session,
      where: (t) => t.anantId.equals(anantId),
    );
  }

  Future<List<MonthlyFeeTransaction>> getAllMonthlyFeeTransactionOrg(
    Session session,
    String organizationName,
  ) async {
    return await MonthlyFeeTransaction.db.find(session,
      where: (t) => t.anantId.equals(organizationName),
    );
  }

  /// Delete a MonthlyFeeTransaction by month
  Future<bool> deleteMonthlyFeeTransaction(
    Session session,
    String month,
    String anantId,
  ) async {
    final txn = await MonthlyFeeTransaction.db.findFirstRow(
      session,
      where: (t) => t.month.equals(month) & t.anantId.equals(anantId),
    );
    if (txn == null) return false;
    await MonthlyFeeTransaction.db.deleteRow(session, txn);
    return true;
  }
}
