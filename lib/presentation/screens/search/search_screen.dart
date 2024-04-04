import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/screens/search/widgets/search_results.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../providers.dart';
import 'widgets/search_suggestions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();
  final _hasTextNotifier = ValueNotifier<bool>(false);
  // TODO(jos4500): Will use results from a riverpod provider
  final _hasSearchResultNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => _hasTextNotifier.value = _controller.text.isNotEmpty,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _hasTextNotifier.dispose();
    _hasSearchResultNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Consumer(
                  builder: (
                    BuildContext context,
                    WidgetRef ref,
                    Widget? childWidget,
                  ) {
                    return CustomBackButton(
                      onPressed: () {
                        if (_focusNode.hasFocus &&
                            _hasSearchResultNotifier.value) {
                          _focusNode.unfocus();
                          return;
                        }
                        ref.read(homeRepositoryProvider).unlockNavBarPosition();
                        context.pop();
                      },
                    );
                  },
                ),
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
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      hintText: 'Search YouTube',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 6.5,
                                        horizontal: 10,
                                      ),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.search,
                                    cursorColor: _hasTextNotifier.value
                                        ? Colors.white
                                        : Colors.white54,
                                    cursorWidth:
                                        _hasTextNotifier.value ? 1.5 : 3,
                                    onSubmitted: _onSearch,
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
                  hasSearchResultNotifier: _hasSearchResultNotifier,
                  hasTextNotifier: _hasTextNotifier,
                ),
              ],
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  _focusNode,
                  _hasSearchResultNotifier,
                ]),
                builder: (
                  BuildContext context,
                  Widget? childWidget,
                ) {
                  final hasFocus = _focusNode.hasFocus;
                  final hasSearchResult = _hasSearchResultNotifier.value;
                  // TODO(josh4500): This has to be the loading state of search
                  if (hasFocus || !hasSearchResult) {
                    return SearchSuggestions(
                      textController: _controller,
                    );
                  }
                  return const SearchResults();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearSearchField() {
    _focusNode.requestFocus();
    _controller.clear();
    _hasSearchResultNotifier.value = false;
  }

  void _onSearch(String text) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        _hasSearchResultNotifier.value = true;
      },
    );
  }
}

class SearchActions extends StatelessWidget {
  const SearchActions({
    super.key,
    required this.focusNode,
    required this.hasSearchResultNotifier,
    required this.hasTextNotifier,
  });

  final FocusNode focusNode;
  final ValueNotifier<bool> hasSearchResultNotifier;
  final ValueNotifier<bool> hasTextNotifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        focusNode,
        hasSearchResultNotifier,
      ]),
      builder: (BuildContext context, Widget? childWidget) {
        final hasFocus = focusNode.hasFocus;
        final hasSearchResult = hasSearchResultNotifier.value;
        return Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: hasTextNotifier,
              builder: (
                BuildContext context,
                bool hasText,
                Widget? _,
              ) {
                if (hasText && (hasFocus || !hasSearchResult)) {
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
                if (hasFocus || !hasSearchResult) {
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
                        if (!hasSearchResult) {
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
