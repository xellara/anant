import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/transaction_service.dart';

class TransactionEndpoint extends Endpoint {
  /// Create a new MonthlyFeeTransaction in the database.
  Future<MonthlyFeeTransaction> createMonthlyFeeTransaction(
    Session session,
    MonthlyFeeTransaction txn,
  ) async {
    return await TransactionService.createTransaction(session, txn);
  }

  /// Retrieve a single MonthlyFeeTransaction by its month
  Future<MonthlyFeeTransaction?> getMonthlyFeeTransaction(
    Session session,
    String month,
    String anantId,
  ) async {
    return await TransactionService.getTransaction(session, month, anantId);
  }

  /// Retrieve all MonthlyFeeTransactions for a user
  Future<List<MonthlyFeeTransaction>> getAllMonthlyFeeTransactionUser(
    Session session,
    String anantId,
  ) async {
    return await TransactionService.getTransactionsByUser(session, anantId);
  }

  /// Retrieve all MonthlyFeeTransactions for an organization
  Future<List<MonthlyFeeTransaction>> getAllMonthlyFeeTransactionOrg(
    Session session,
    String organizationName,
  ) async {
    return await TransactionService.getTransactionsByOrg(session, organizationName);
  }

  /// Updates an existing MonthlyFeeTransaction.
  Future<MonthlyFeeTransaction?> updateMonthlyFeeTransaction(
    Session session,
    MonthlyFeeTransaction txn,
  ) async {
    return await TransactionService.updateTransaction(session, txn);
  }

  /// Delete a MonthlyFeeTransaction by month
  Future<bool> deleteMonthlyFeeTransaction(
    Session session,
    String month,
    String anantId,
  ) async {
    return await TransactionService.deleteTransaction(session, month, anantId);
  }
}
