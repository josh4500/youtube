import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/screens/search/widgets/search_results.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/search_suggestions.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  final _hasTextNotifier = ValueNotifier<bool>(false);
  // TODO(jos4500): Will use results from a riverpod provider
  final _showSearchResultNotifier = ValueNotifier<bool>(false);

  final Set<String> _searchedTextHistory = <String>{};
  late final List<Widget> _screens = <Widget>[
    SearchSuggestions(
      textController: _textController,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(
      () => _hasTextNotifier.value = _textController.text.isNotEmpty,
    );
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showSearchResultNotifier.value = false;
        ref.read(homeRepositoryProvider).lockNavBarPosition();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    _hasTextNotifier.dispose();
    _showSearchResultNotifier.dispose();
    super.dispose();
  }

  void _clearSearchField() {
    _focusNode.requestFocus();
    _textController.clear();
  }

  void _onTapSearchField() {
    if (_focusNode.hasFocus) {
      ref.read(homeRepositoryProvider).lockNavBarPosition();
    }
  }

  void _onSubmitSearch(String text) {
    final added = _searchedTextHistory.add(text);
    if (added) {
      _screens.add(SearchResults(key: GlobalObjectKey(text)));
    }

    Future.delayed(
      const Duration(seconds: 2),
      () {
        _showSearchResultNotifier.value = true;
        ref.read(homeRepositoryProvider).unlockNavBarPosition();
      },
    );
  }

  void _onPressBack() {
    if (_focusNode.hasFocus && _searchedTextHistory.isNotEmpty) {
      _focusNode.unfocus();

      _showSearchResultNotifier.value = true;
      _textController.text = _searchedTextHistory.last;
      ref.read(homeRepositoryProvider).unlockNavBarPosition();

      return;
    }

    if (_searchedTextHistory.isNotEmpty) {
      _searchedTextHistory.remove(_searchedTextHistory.last);
      _screens.removeLast();

      if (_searchedTextHistory.isNotEmpty) {
        _showSearchResultNotifier.value = true;
        _textController.text = _searchedTextHistory.last;
        ref.read(homeRepositoryProvider).unlockNavBarPosition();
      }
    }

    if (_searchedTextHistory.isEmpty) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                CustomBackButton(onPressed: _onPressBack),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: ListenableBuilder(
                          listenable: _hasTextNotifier,
                          builder: (
                            BuildContext context,
                            Widget? childWidget,
                          ) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    focusNode: _focusNode,
                                    controller: _textController,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      hintText: 'Search YouTube',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 6.5,
                                        horizontal: 10,
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.search,
                                    cursorColor: _hasTextNotifier.value
                                        ? Colors.white
                                        : Colors.white54,
                                    cursorWidth:
                                        _hasTextNotifier.value ? 1.5 : 3,
                                    onSubmitted: _onSubmitSearch,
                                    onTap: _onTapSearchField,
                                    showCursor: true,
                                  ),
                                ),
                                const SizedBox(width: 28),
                              ],
                            );
                          },
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _hasTextNotifier,
                        builder: (
                          BuildContext context,
                          bool hasText,
                          Widget? _,
                        ) {
                          if (!hasText) {
                            return const SizedBox();
                          }
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: TappableArea(
                                onPressed: _clearSearchField,
                                padding: const EdgeInsets.all(16),
                                borderRadius: BorderRadius.circular(24),
                                child: const Icon(
                                  YTIcons.close_outlined,
                                  size: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SearchActions(
                  focusNode: _focusNode,
                  showSearchResultNotifier: _showSearchResultNotifier,
                  hasTextNotifier: _hasTextNotifier,
                ),
              ],
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  _focusNode,
                  _showSearchResultNotifier,
                ]),
                builder: (
                  BuildContext context,
                  Widget? childWidget,
                ) {
                  final hasFocus = _focusNode.hasFocus;
                  final showSearchResult = _showSearchResultNotifier.value;
                  return IndexedStack(
                    index: hasFocus || !showSearchResult
                        ? 0
                        : _searchedTextHistory.length,
                    children: _screens,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchActions extends StatelessWidget {
  const SearchActions({
    super.key,
    required this.focusNode,
    required this.showSearchResultNotifier,
    required this.hasTextNotifier,
  });

  final FocusNode focusNode;
  final ValueNotifier<bool> showSearchResultNotifier;
  final ValueNotifier<bool> hasTextNotifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        focusNode,
        showSearchResultNotifier,
      ]),
      builder: (BuildContext context, Widget? childWidget) {
        final hasFocus = focusNode.hasFocus;
        final showSearchResult = showSearchResultNotifier.value;
        return Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: hasTextNotifier,
              builder: (
                BuildContext context,
                bool hasText,
                Widget? _,
              ) {
                if (hasText && (hasFocus || !showSearchResult)) {
                  return const SizedBox(width: 8);
                }
                return TappableArea(
                  padding: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(24),
                  onPressed: () async {
                    await Permission.microphone.onDeniedCallback(() {
                      context.goto(AppRoutes.searchVoiceRequest);
                    }).onGrantedCallback(() {
                      // Your code
                      print('Granted');
                    }).request();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(YTIcons.mic_outlined),
                  ),
                );
              },
            ),
            Builder(
              builder: (context) {
                if (hasFocus || !showSearchResult) {
                  return const SizedBox();
                }

                return Row(
                  children: [
                    AppbarAction(
                      icon: YTIcons.cast_outlined,
                      onTap: () {},
                    ),
                    // TODO(josh4500): Show this on only Tablet device
                    Builder(
                      builder: (BuildContext context) {
                        if (!showSearchResult) {
                          return const SizedBox();
                        }
                        return AppbarAction(
                          icon: YTIcons.tune_outlined,
                          onTap: () {},
                        );
                      },
                    ),
                    AppbarAction(
                      icon: YTIcons.more_vert_outlined,
                      onTap: () {},
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
