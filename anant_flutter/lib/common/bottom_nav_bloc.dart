import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// EVENT
abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();
  @override
  List<Object> get props => [];
}

class NavItemSelectedEvent extends BottomNavEvent {
  final int selectedIndex;
  const NavItemSelectedEvent({required this.selectedIndex});
  @override
  List<Object> get props => [selectedIndex];
}

// STATE
class BottomNavState extends Equatable {
  final int selectedIndex;
  const BottomNavState({required this.selectedIndex});
  @override
  List<Object> get props => [selectedIndex];
}

// BLoC
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState(selectedIndex: 0)) {
    on<NavItemSelectedEvent>((event, emit) {
      emit(BottomNavState(selectedIndex: event.selectedIndex));
    });
  }
}
