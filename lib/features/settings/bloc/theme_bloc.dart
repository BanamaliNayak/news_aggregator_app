import 'package:aggregator_app/core/database/hive_service.dart';
import 'package:aggregator_app/features/settings/bloc/theme_event.dart';
import 'package:aggregator_app/features/settings/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
// region properties
  final HiveService hiveService;
// endregion

// region constructor
  ThemeBloc({required this.hiveService})
      : super(const ThemeState(themeMode: ThemeMode.light)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }
// endregion

// region handlers
  void _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) {
    final themeMode = hiveService.loadTheme();
    emit(ThemeState(themeMode: themeMode));
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final newThemeMode = event.isDark ? ThemeMode.dark : ThemeMode.light;
    hiveService.saveTheme(newThemeMode);
    emit(ThemeState(themeMode: newThemeMode));
  }
// endregion
}