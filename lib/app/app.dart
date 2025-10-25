import 'package:aggregator_app/core/theme/app_theme.dart';
import 'package:aggregator_app/features/home/screens/home_screen.dart';
import 'package:aggregator_app/features/settings/bloc/theme_bloc.dart';
import 'package:aggregator_app/features/settings/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class App extends StatelessWidget {
// region constructor
  const App({super.key});
// endregion

// region build
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'News Aggregator',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
// endregion
}