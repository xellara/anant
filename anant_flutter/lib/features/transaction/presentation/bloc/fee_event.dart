abstract class FeeEvent {}

class LoadUserFeesEvent extends FeeEvent {
  final String anantId;
  
  LoadUserFeesEvent(this.anantId);
}
