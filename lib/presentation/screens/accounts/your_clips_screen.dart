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
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/screens/accounts/widgets/popup/show_your_clips_menu.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class YourClipsScreen extends StatefulWidget {
  const YourClipsScreen({super.key});

  @override
  State<YourClipsScreen> createState() => _YourClipsScreenState();
}

class _YourClipsScreenState extends State<YourClipsScreen>
    with TickerProviderStateMixin {
  final ScrollController controller = ScrollController();
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
      if (controller.offset <= 250) {
        opacityController.value = controller.offset / 250;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    opacityController.dispose();
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
            'Your clips',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: CustomBackButton(onPressed: context.pop),
        actions: <Widget>[
          AppbarAction(
            icon: YTIcons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.search_outlined,
            onTap: () => context.goto(AppRoutes.search),
          ),
          AppbarAction(
            icon: YTIcons.more_vert_outlined,
            onTapDown: (TapDownDetails details) async {
              final Offset position = details.globalPosition;
              await showYourClipsMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(
          color: Colors.black12,
        ),
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12,
                ),
                child: Text(
                  'Your clips',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return TappableArea(
                    onTap: () {},
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12,
                    ),
                    child: PlayableClipContent(
                      width: 160.w,
                      height: 90.h,
                    ),
                  );
                },
                childCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
