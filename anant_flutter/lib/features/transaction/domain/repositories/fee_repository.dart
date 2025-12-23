import '../entities/fee_transaction.dart';

abstract class FeeRepository {
  /// Get all fee transactions for a specific user by anantId
  Future<List<FeeTransaction>> getFeesForUser(String anantId);
  
  /// Get fee transaction for a specific month
  Future<FeeTransaction?> getFeeForMonth(String anantId, String month);
}
