import 'package:aggregator_app/data/models/article_model.dart';
import 'package:aggregator_app/features/article_detail/screens/article_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(article.source?.name ?? 'Article'),
        elevation: 2.0.h,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 20.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // region Title
              Text(
                article.title,
                style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, height: 1.3.h),
              ),
              SizedBox(height: 16.h),
              // endregion

              // region Metadata - Improved Styling
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'By ${article.author ?? article.source?.name ?? 'Unknown'}',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey[700]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              if (article.publishedAt != null)
                Row(
                  children: [
                    Text(
                      DateFormat.yMMMd()
                          .add_jm()
                          .format(article.publishedAt!.toLocal()),
                      style: textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              SizedBox(height: 24.h),
              // endregion

              // region Image
              if (article.urlToImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    article.urlToImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200.h,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200.h,
                        color: Colors.grey[200],
                        child: Icon(Icons.broken_image,
                            color: Colors.grey, size: 40.sp),
                      );
                    },
                  ),
                ),
              if (article.urlToImage != null) SizedBox(height: 24.h),
              // endregion

              // region Description
              if (article.description != null &&
                  article.description!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0.h),
                  child: Text(
                    article.description!,
                    style: textTheme.bodyLarge?.copyWith(
                        fontSize: 17.sp,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[800]),
                  ),
                ),
              if (article.description != null &&
                  article.description!.isNotEmpty &&
                  article.content != null &&
                  article.content!.isNotEmpty)
                Divider(
                  height: 32.h,
                  thickness: 0.5.h,
                  color: Colors.grey[400],
                ),
              // endregion

              // region Content
              if (article.content != null && article.content!.isNotEmpty) ...[
                Text(
                  article.content!
                      .split('[+')[0]
                      .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
                      .trim(),
                  style: textTheme.bodyLarge
                      ?.copyWith(fontSize: 17.sp, height: 1.6.h),
                ),
                SizedBox(height: 32.h),
              ],
              // endregion

              // region Read More Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () => _openInAppWebView(context),
                  child: Text(
                    'Read Full Article',
                    style: textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
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
      builder: (_) => ArticleWebViewScreen(
        url: article.url,
        title: article.source?.name ?? 'Article',
      ),
    ));
  }
// endregion
}