import 'package:aggregator_app/data/models/article_model.dart';
import 'package:aggregator_app/features/article_detail/screens/article_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleDetailScreen extends StatelessWidget {
// region properties
  final ArticleModel article;

// endregion

// region constructor
  const ArticleDetailScreen({super.key, required this.article});

// endregion

// region build
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(article.source?.name ?? 'Article'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // region Title
              Text(
                article.title,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // endregion

              // region Metadata
              Text(
                'By ${article.author ?? article.source?.name ?? 'Unknown'}',
                style: textTheme.titleSmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              if (article.publishedAt != null)
                Text(
                  DateFormat.yMMMd()
                      .add_jm()
                      .format(article.publishedAt!.toLocal()),
                  style: textTheme.titleSmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
              const SizedBox(height: 16),
              // endregion

              // region Image
              if (article.urlToImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    article.urlToImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink(); // Hide if error
                    },
                  ),
                ),
              if (article.urlToImage != null) const SizedBox(height: 16),
              // endregion

              // region Description
              if (article.description != null)
                Text(
                  article.description!,
                  style: textTheme.bodyLarge?.copyWith(fontSize: 18),
                ),
              const SizedBox(height: 16),
              // endregion

              // region Content
              if (article.content != null)
                Text(
                  // NewsAPI often truncates content
                  article.content!.split('[+')[0],
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              const SizedBox(height: 24),
              // endregion

              // region Read More Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _openInAppWebView(context),
                  child: const Text('Read Full Article'),
                ),
              ),
              // endregion
            ],
          ),
        ),
      ),
    );
  }

// endregion

// region helpers
  void _openInAppWebView(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          ArticleWebViewScreen(
            url: article.url,
            title: article.source?.name ?? 'Article',
          ),
    ));
// endregion
  }
}