import 'package:aggregator_app/features/home/bloc/news_bloc.dart';
import 'package:aggregator_app/features/home/bloc/news_event.dart';
import 'package:aggregator_app/features/home/bloc/news_state.dart';
import 'package:aggregator_app/features/home/widgets/article_list_item.dart';
import 'package:aggregator_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NewsCategoryTab extends StatefulWidget {
// region properties
  final String category;
// endregion

// region constructor
  const NewsCategoryTab({super.key, required this.category});
// endregion

  @override
  State<NewsCategoryTab> createState() => _NewsCategoryTabState();
}

class _NewsCategoryTabState extends State<NewsCategoryTab>
    with AutomaticKeepAliveClientMixin {
// region properties
  late final NewsBloc _newsBloc;
  final _scrollController = ScrollController();
// endregion

// region lifecycle
  @override
  void initState() {
    super.initState();
    // Create a new BLoC instance for this tab
    _newsBloc = sl<NewsBloc>()..add(FetchNews(category: widget.category));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _newsBloc.close();
    super.dispose();
  }
// endregion

// region build
  @override
  Widget build(BuildContext context) {
    // AutomaticKeepAliveClientMixin requires this
    super.build(context);

    return BlocProvider.value(
      value: _newsBloc,
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return Column(
            children: [
              // region Offline/Cached Banner
              if (state.status == NewsStatus.cached)
                Container(
                  width: double.infinity,
                  color: Colors.orange.withOpacity(0.8),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Offline. Showing cached data.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onError),
                  ),
                ),
              // endregion
              // region Article List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _newsBloc.add(RefreshNews(category: widget.category));
                  },
                  child: _buildContent(context, state),
                ),
              ),
              // endregion
            ],
          );
        },
      ),
    );
  }
// endregion

// region helpers
  Widget _buildContent(BuildContext context, NewsState state) {
    switch (state.status) {
      case NewsStatus.initial:
      case NewsStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case NewsStatus.failure:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              state.errorMessage ?? 'Failed to fetch news.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      case NewsStatus.success:
      case NewsStatus.cached:
      case NewsStatus.loadingMore:
        if (state.articles.isEmpty) {
          return const Center(child: Text('No articles found.'));
        }
        return ListView.builder(
          controller: _scrollController,
          itemCount: state.hasReachedMax
              ? state.articles.length
              : state.articles.length + 1, // +1 for loader
          itemBuilder: (context, index) {
            if (index >= state.articles.length) {
              return state.status == NewsStatus.loadingMore
                  ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ))
                  : const SizedBox.shrink();
            }
            return ArticleListItem(article: state.articles[index]);
          },
        );
    }
  }

  void _onScroll() {
    if (_isBottom) {
      _newsBloc.add(FetchNews(category: widget.category));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger load a bit before the end
    return currentScroll >= (maxScroll * 0.9);
  }
// endregion

  @override
  bool get wantKeepAlive => true;
}