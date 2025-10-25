// lib/main.dart
import 'package:aggregator_app/app/app.dart';
import 'package:aggregator_app/core/database/hive_service.dart';
import 'package:aggregator_app/features/settings/bloc/theme_bloc.dart';
import 'package:aggregator_app/features/settings/bloc/theme_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:aggregator_app/injection_container.dart' as di;
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  // region setup
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveServiceImpl.init();
  await di.init();
  final themeBloc = di.sl<ThemeBloc>()..add(LoadThemeEvent());
  // endregion

  runApp(
    BlocProvider.value(
      value: themeBloc,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const App();
        },
      ),
    ),
  );
}