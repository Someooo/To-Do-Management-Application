import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/storage_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final StorageService storageService;

  ThemeBloc({required this.storageService})
      : super(const ThemeState(ThemeMode.system)) {
    on<ThemeLoadStarted>(_onLoadStarted);
    on<ThemeThemeChanged>(_onThemeChanged);
  }

  Future<void> _onLoadStarted(
    ThemeLoadStarted event,
    Emitter<ThemeState> emit,
  ) async {
    final themeStr = await storageService.read<String>('settings', 'theme_mode');
    if (themeStr == 'dark') {
      emit(const ThemeState(ThemeMode.dark));
    } else if (themeStr == 'light') {
      emit(const ThemeState(ThemeMode.light));
    } else {
      emit(const ThemeState(ThemeMode.system));
    }
  }

  Future<void> _onThemeChanged(
    ThemeThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeState(event.themeMode));
    String themeStr = 'system';
    if (event.themeMode == ThemeMode.dark) {
      themeStr = 'dark';
    } else if (event.themeMode == ThemeMode.light) {
      themeStr = 'light';
    }
    await storageService.write<String>('settings', 'theme_mode', themeStr);
  }
}
