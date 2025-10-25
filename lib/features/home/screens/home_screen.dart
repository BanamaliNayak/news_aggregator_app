import 'package:aggregator_app/features/home/widgets/news_category_tab.dart';
import 'package:aggregator_app/features/search/screens/search_screen.dart';
import 'package:aggregator_app/features/settings/bloc/theme_bloc.dart';
import 'package:aggregator_app/features/settings/bloc/theme_event.dart';
import 'package:aggregator_app/features/settings/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatefulWidget {
// region constructor
  const HomeScreen({super.key});
// endregion

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
// region properties
  late final TabController _tabController;
  final List<String> _categories = [
    'general',
    'business',
    'sports',
    'health',
    'entertainment',
    'technology',
  ];
// endregion

// region lifecycle
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
// endregion

// region build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        actions: [
          // region Search Button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          // endregion
          // region Theme Toggle Button
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              final isDark = state.themeMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () async {
                  context.read<ThemeBloc>().add(ToggleThemeEvent(!isDark));
                },
              );
            },
          ),
          // endregion
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories
              .map((c) =>
              Tab(text: c.substring(0, 1).toUpperCase() + c.substring(1)))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories
            .map((category) => NewsCategoryTab(category: category))
            .toList(),
      ),
    );
  }
// endregion
}