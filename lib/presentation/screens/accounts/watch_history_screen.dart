// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../providers.dart';
import 'widgets/history_search_text_field.dart';
import 'widgets/popup/show_history_menu.dart';
import 'widgets/shorts_history.dart';

class WatchHistoryScreen extends StatefulWidget {
  const WatchHistoryScreen({super.key});

  @override
  State<WatchHistoryScreen> createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends State<WatchHistoryScreen>
    with TickerProviderStateMixin {
  final ScrollController controller = ScrollController();
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  final SharedSlidableState<int?> sharedSlidableState =
      SharedSlidableState<int?>(null);

  late final AnimationController opacityController;
  late final Animation animation;

  @override
  void initState() {
    super.initState();
    opacityController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 150),
    );
    animation = CurvedAnimation(parent: opacityController, curve: Curves.ease);

    controller.addListener(() {
      if (controller.offset <= 150) {
        opacityController.value = controller.offset / 150;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    opacityController.dispose();
    textEditingController.dispose();
    sharedSlidableState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: animation.value,
              child: child,
            );
          },
          child: const Text(
            'History',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: <Widget>[
          AppbarAction(
            icon: YTIcons.cast_outlined,
            onTap: () {},
          ),
          Consumer(
            builder: (context, ref, child) {
              return AppbarAction(
                icon: YTIcons.search_outlined,
                onTap: () async {
                  ref.read(homeRepositoryProvider).lockNavBarPosition();
                  await context.goto(AppRoutes.search);
                },
              );
            },
          ),
          AppbarAction(
            icon: YTIcons.more_vert_outlined,
            onTapDown: (TapDownDetails details) {
              final Offset position = details.globalPosition;
              showHistoryMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: focusNode.unfocus,
        child: ScrollConfiguration(
          behavior: const OverScrollGlowBehavior(enabled: false),
          child: CustomScrollView(
            controller: controller,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'History',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    HistorySearchTextField(
                      focusNode: focusNode,
                      controller: textEditingController,
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: ShortsHistory(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Slidable(
                      maxOffset: 0.3,
                      key: ValueKey(-index),
                      sharedSlidableState: sharedSlidableState,
                      items: const <SlidableItem>[
                        SlidableItem(
                          icon: Icon(Icons.delete, color: Colors.black),
                        ),
                      ],
                      child: Material(
                        child: InkWell(
                          onTap: () {},
                          child: const PlayableVideoContent(
                            width: 180,
                            height: 104,
                            margin: EdgeInsets.all(12.0),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
              const SliverToBoxAdapter(
                child: ShortsHistory(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Slidable(
                      key: ValueKey(index),
                      maxOffset: 0.3,
                      sharedSlidableState: sharedSlidableState,
                      items: const <SlidableItem>[
                        SlidableItem(
                          icon: Icon(Icons.delete, color: Colors.black),
                        ),
                      ],
                      child: Material(
                        child: InkWell(
                          onTap: () {},
                          child: const PlayableVideoContent(
                            width: 180,
                            height: 104,
                            margin: EdgeInsets.all(12.0),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
