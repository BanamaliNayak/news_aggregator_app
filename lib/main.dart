import 'package:aggregator_app/app/app.dart';
import 'package:aggregator_app/core/database/hive_service.dart';
import 'package:aggregator_app/features/settings/bloc/theme_bloc.dart';
import 'package:aggregator_app/features/settings/bloc/theme_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:aggregator_app/injection_container.dart' as di;

Future<void> main() async {
// region setup
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await HiveServiceImpl.init();

  // Initialize Dependency Injection
  await di.init();

  // Initialize ThemeBloc to load saved theme
  final themeBloc = di.sl<ThemeBloc>()..add(LoadThemeEvent());
// endregion

  runApp(
    BlocProvider.value(
      value: themeBloc,
      child: const App(),
    ),
  );
}