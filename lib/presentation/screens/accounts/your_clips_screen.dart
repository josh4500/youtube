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

import '../create/widgets/filter_selector.dart';

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
    return const EditView();
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

const double kFilterBoxHeight = 88;
const double kVerticalActionMargin = 12;
const double kTopPadding = (kVerticalActionMargin * 2) + 28 + (8 * 2);

class EditView extends StatefulWidget {
  const EditView({super.key});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView>
    with SingleTickerProviderStateMixin {
  final FocusNode focusNode = FocusNode();
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: Durations.short2,
  );

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!focusNode.hasFocus) {
      controller.value -= details.primaryDelta! / kFilterBoxHeight;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (controller.value < .5) {
      controller.reverse();
    } else {
      controller.forward();
    }
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: Stack(
          children: [
            Column(
              children: [
                SizeTransition(
                  sizeFactor: controller.view,
                  child: const SizedBox(height: kTopPadding),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: CustomNetworkImage(
                            'https://picsum.photos/900/400',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizeTransition(
                  sizeFactor: controller.view,
                  axisAlignment: -1,
                  child: const FilterSelector(),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: kVerticalActionMargin,
                horizontal: 4,
              ),
              child: Row(
                children: [
                  CustomActionButton(Icons.close),
                  Spacer(),
                  CustomActionButton(Icons.crop_rotate_rounded),
                  CustomActionButton(Icons.sticky_note_2),
                  CustomActionButton(Icons.sort_by_alpha),
                  CustomActionButton(Icons.edit),
                ],
              ),
            ),
            FadeTransition(
              opacity: ReverseAnimation(controller.view),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.keyboard_arrow_up_sharp),
                  const SizedBox(height: 4),
                  const Text('Filter'),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.account_circle),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  focusNode: focusNode,
                                  decoration: const InputDecoration.collapsed(
                                    hintText: 'Add a caption...',
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.numbers),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Majid'),
                            IconButton(
                              onPressed: () {},
                              color: Colors.green,
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.send),
                            ),
                          ],
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: MediaQuery.viewInsetsOf(context).bottom,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomActionButton extends StatelessWidget {
  const CustomActionButton(this.iconData, {super.key});
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(8),
      child: Icon(iconData),
    );
  }
}
