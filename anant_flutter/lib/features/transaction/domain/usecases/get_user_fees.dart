import '../entities/fee_transaction.dart';
import '../repositories/fee_repository.dart';

class GetUserFees {
  final FeeRepository repository;

  GetUserFees(this.repository);

  Future<List<FeeTransaction>> call(String anantId) async {
    return await repository.getFeesForUser(anantId);
  }
}
