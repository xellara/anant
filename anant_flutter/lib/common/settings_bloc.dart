import 'package:anant_client/anant_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Event
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

// State
abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final OrganizationSettings settings;
  const SettingsLoaded(this.settings);
  
  @override
  List<Object> get props => [settings];
  
  bool isModuleEnabled(String moduleName) {
    return settings.enabledModules.contains(moduleName);
  }
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Client client;

  SettingsBloc({required this.client}) : super(SettingsInitial()) {
    on<LoadSettings>((event, emit) async {
      emit(SettingsLoading());
      try {
        final settings = await client.settings.getSettings();
        if (settings != null) {
          emit(SettingsLoaded(settings));
        } else {
          // Fallback or empty settings if none found
          emit(const SettingsError("No settings found for this organization"));
        }
      } catch (e) {
        emit(SettingsError(e.toString()));
      }
    });
  }
}
