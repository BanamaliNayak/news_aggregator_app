import 'package:aggregator_app/core/constants/hive_constants.dart';
import 'package:aggregator_app/data/models/article_model.dart';
import 'package:aggregator_app/data/models/source_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


abstract class HiveService {
  Future<void> saveTheme(ThemeMode mode);
  ThemeMode loadTheme();
  Box<ArticleModel> get articlesBox;
}

class HiveServiceImpl implements HiveService {
// region properties
  final Box<dynamic> settingsBox;
  @override
  final Box<ArticleModel> articlesBox;
// endregion

// region constructor
  HiveServiceImpl({required this.settingsBox, required this.articlesBox});
// endregion

// region static_init
  static Future<void> init() async {
    // Register Adapters
    Hive.registerAdapter(ArticleModelAdapter());
    Hive.registerAdapter(SourceModelAdapter());

    // Open Boxes
    await Hive.openBox(HiveConstants.settingsBox);
    await Hive.openBox<ArticleModel>(HiveConstants.articlesBox);
  }
// endregion

// region methods
  @override
  ThemeMode loadTheme() {
    final isDark =
    settingsBox.get(HiveConstants.themeKey, defaultValue: false) as bool;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Future<void> saveTheme(ThemeMode mode) async {
    await settingsBox.put(HiveConstants.themeKey, mode == ThemeMode.dark);
  }
// endregion
}