import '../../domain/entities/fee_transaction.dart';

abstract class FeeState {}

class FeeInitial extends FeeState {}

class FeeLoading extends FeeState {}

class FeeLoaded extends FeeState {
  final List<FeeTransaction> transactions;
  
  FeeLoaded(this.transactions);
}

class FeeError extends FeeState {
  final String message;
  
  FeeError(this.message);
}
