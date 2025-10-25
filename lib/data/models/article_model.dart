import 'package:aggregator_app/data/models/source_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'article_model.g.dart';

@HiveType(typeId: 0)
class ArticleModel extends Equatable {
// region properties
  @HiveField(0)
  final SourceModel? source;
  @HiveField(1)
  final String? author;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String url;
  @HiveField(5)
  final String? urlToImage;
  @HiveField(6)
  final DateTime? publishedAt;
  @HiveField(7)
  final String? content;
  @HiveField(8)
  final String category; // Custom field to track category for caching
// endregion

// region constructor
  const ArticleModel({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.category = 'general', // Default category
  });
// endregion

// region factory
  factory ArticleModel.fromJson(Map<String, dynamic> json,
      {String category = 'general'}) {
    return ArticleModel(
      source:
      json['source'] != null ? SourceModel.fromJson(json['source']) : null,
      author: json['author'],
      title: json['title'] ?? 'No Title',
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
      content: json['content'],
      category: category,
    );
  }
// endregion

// region methods
  ArticleModel copyWith({String? category}) {
    return ArticleModel(
      source: source,
      author: author,
      title: title,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
    source,
    author,
    title,
    description,
    url,
    urlToImage,
    publishedAt,
    content,
    category
  ];
// endregion
}