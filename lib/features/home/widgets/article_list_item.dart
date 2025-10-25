import 'package:aggregator_app/data/models/article_model.dart';
import 'package:aggregator_app/features/article_detail/screens/article_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleListItem extends StatelessWidget {
// region properties
  final ArticleModel article;
// endregion

// region constructor
  const ArticleListItem({super.key, required this.article});
// endregion

// region build
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(article: article),
        ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // region Image
              if (article.urlToImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    article.urlToImage!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image,
                            color: Colors.grey, size: 40),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
              if (article.urlToImage != null) const SizedBox(height: 12),
              // endregion

              // region Title
              Text(
                article.title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // endregion

              // region Source and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.source?.name ?? 'Unknown Source',
                    style: textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                  if (article.publishedAt != null)
                    Text(
                      DateFormat.yMMMd().format(article.publishedAt!),
                      style: textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                ],
              ),
              // endregion
            ],
          ),
        ),
      ),
    );
  }
// endregion
}