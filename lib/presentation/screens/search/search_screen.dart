import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../providers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();
  final _hasTextNotifier = ValueNotifier<bool>(false);

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        return CustomBackButton(
                          onPressed: () {
                            ref
                                .read(homeRepositoryProvider)
                                .unlockNavBarPosition();
                            context.pop();
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: ListenableBuilder(
                          listenable: _hasTextNotifier,
                          builder: (context, c) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextField(
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
                                  ),
                                ),
                                if (_hasTextNotifier.value)
                                  const SizedBox(width: 28),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _hasTextNotifier,
                      builder: (
                        BuildContext context,
                        bool value,
                        Widget? _,
                      ) {
                        if (value) return const SizedBox(width: 8);
                        return TappableArea(
                          padding: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(24),
                          onPressed: () async {
                            await Permission.microphone.onDeniedCallback(() {
                              print('Denied');
                              context.goto(AppRoutes.searchVoiceRequest);
                            }).onGrantedCallback(() {
                              // Your code
                              print('Granted');
                            }).onPermanentlyDeniedCallback(() {
                              // Your code
                              print('PermanentlyDenied');
                            }).onRestrictedCallback(() {
                              // Your code
                              print('Restricted');
                            }).onLimitedCallback(() {
                              // Your code
                              print('Limited');
                            }).onProvisionalCallback(() {
                              // Your code
                              print('Provisional');
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
                  ],
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _hasTextNotifier,
                  builder: (
                    BuildContext context,
                    bool value,
                    Widget? _,
                  ) {
                    if (!value) return const SizedBox();
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        child: TappableArea(
                          onPressed: _controller.clear,
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(24),
                          child: const Icon(YTIcons.close_outlined, size: 16),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
