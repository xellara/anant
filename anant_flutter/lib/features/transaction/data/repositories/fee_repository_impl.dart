import 'package:anant_flutter/main.dart';
import '../../domain/entities/fee_transaction.dart';
import '../../domain/repositories/fee_repository.dart';

class FeeRepositoryImpl implements FeeRepository {
  @override
  Future<List<FeeTransaction>> getFeesForUser(String anantId) async {
    try {
      final transactions = await client.transaction.getAllMonthlyFeeTransactionUser(anantId);
      return transactions.map((t) => FeeTransaction.fromClient(t)).toList();
    } catch (e) {
      throw Exception('Failed to fetch fee transactions: $e');
    }
  }

  @override
  Future<FeeTransaction?> getFeeForMonth(String anantId, String month) async {
    try {
      final transaction = await client.transaction.getMonthlyFeeTransaction(month, anantId);
      if (transaction == null) return null;
      return FeeTransaction.fromClient(transaction);
    } catch (e) {
      throw Exception('Failed to fetch fee transaction for $month: $e');
    }
  }
}
