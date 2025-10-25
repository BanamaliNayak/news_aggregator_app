import 'package:aggregator_app/features/home/widgets/article_list_item.dart';
import 'package:aggregator_app/features/search/bloc/search_bloc.dart';
import 'package:aggregator_app/features/search/bloc/search_event.dart';
import 'package:aggregator_app/features/search/bloc/search_state.dart';
import 'package:aggregator_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SearchScreen extends StatefulWidget {
// region constructor
  const SearchScreen({super.key});
// endregion

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
// region properties
  late final SearchBloc _searchBloc;
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
// endregion

// region lifecycle
  @override
  void initState() {
    super.initState();
    _searchBloc = sl<SearchBloc>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _textController.dispose();
    _searchBloc.close();
    super.dispose();
  }
// endregion

// region build
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        appBar: AppBar(
          title: _buildSearchField(),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return _buildContent(context, state);
          },
        ),
      ),
    );
  }
// endregion

// region helpers
  Widget _buildSearchField() {
    return TextField(
      controller: _textController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search for news...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[600]),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _textController.clear();
            _searchBloc.add(const SearchQueryChanged(''));
          },
        ),
      ),
      style: const TextStyle(fontSize: 18),
      onChanged: (query) {
        _searchBloc.add(SearchQueryChanged(query));
      },
    );
  }

  Widget _buildContent(BuildContext context, SearchState state) {
    switch (state.status) {
      case SearchStatus.initial:
        return const Center(
          child: Text('Start typing to search 📰',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        );
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.empty:
        return Center(
          child: Text('No results found for "${state.query}"',
              style: const TextStyle(fontSize: 18, color: Colors.grey)),
        );
      case SearchStatus.failure:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              state.errorMessage ?? 'Failed to search.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        );
      case SearchStatus.success:
      case SearchStatus.loadingMore:
        return ListView.builder(
          controller: _scrollController,
          itemCount: state.hasReachedMax
              ? state.articles.length
              : state.articles.length + 1,
          itemBuilder: (context, index) {
            if (index >= state.articles.length) {
              return state.status == SearchStatus.loadingMore
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
      _searchBloc.add(LoadMoreSearch());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
// endregion
}