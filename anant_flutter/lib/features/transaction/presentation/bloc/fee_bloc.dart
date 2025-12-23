import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_fees.dart';
import 'fee_event.dart';
import 'fee_state.dart';

class FeeBloc extends Bloc<FeeEvent, FeeState> {
  final GetUserFees getUserFees;

  FeeBloc({required this.getUserFees}) : super(FeeInitial()) {
    on<LoadUserFeesEvent>(_onLoadUserFees);
  }

  Future<void> _onLoadUserFees(
    LoadUserFeesEvent event,
    Emitter<FeeState> emit,
  ) async {
    emit(FeeLoading());
    try {
      final transactions = await getUserFees(event.anantId);
      emit(FeeLoaded(transactions));
    } catch (e) {
      emit(FeeError(e.toString()));
    }
  }
}
