
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';


class TransactionService {
  static const _ttl = Duration(minutes: 5);

  static Future<MonthlyFeeTransaction> createTransaction(Session session, MonthlyFeeTransaction txn) async {
    final newTxn = await MonthlyFeeTransaction.db.insertRow(session, txn);
    await session.caches.local.invalidateKey('monthly_txn_user_${txn.anantId}');
    return newTxn;
  }

  static Future<MonthlyFeeTransaction?> getTransaction(Session session, String month, String anantId) async {
    return await MonthlyFeeTransaction.db.findFirstRow(
      session,
      where: (t) => t.month.equals(month) & t.anantId.equals(anantId),
    );
  }

  static Future<List<MonthlyFeeTransaction>> getTransactionsByUser(Session session, String anantId) async {
    final cacheKey = 'monthly_txn_user_$anantId';
    final cached = await session.caches.local.get(cacheKey);
    if (cached != null && cached is TransactionListContainer) {
      return cached.transactions;
    }

    final txns = await MonthlyFeeTransaction.db.find(
      session,
      where: (t) => t.anantId.equals(anantId),
    );

    await session.caches.local.put(
      cacheKey,
      TransactionListContainer(transactions: txns),
      lifetime: _ttl,
    );
    return txns;
  }

  static Future<List<MonthlyFeeTransaction>> getTransactionsByOrg(Session session, String organizationName) async {
    if (organizationName.toLowerCase() == 'anant') {
      // Super Admin: Fetch everything
      return await MonthlyFeeTransaction.db.find(session);
    }
    return await MonthlyFeeTransaction.db.find(
      session,
      where: (t) => t.anantId.equals(organizationName), 
    );
  }

  static Future<MonthlyFeeTransaction?> updateTransaction(Session session, MonthlyFeeTransaction txn) async {
    final updated = await MonthlyFeeTransaction.db.updateRow(session, txn);
    await session.caches.local.invalidateKey('monthly_txn_user_${txn.anantId}');
    return updated;
  }

  static Future<bool> deleteTransaction(Session session, String month, String anantId) async {
    final txn = await MonthlyFeeTransaction.db.findFirstRow(
      session,
      where: (t) => t.month.equals(month) & t.anantId.equals(anantId),
    );
    if (txn == null) return false;
    
    await MonthlyFeeTransaction.db.deleteRow(session, txn);
    await session.caches.local.invalidateKey('monthly_txn_user_$anantId');
    return true;
  }
}
