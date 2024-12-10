import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/screens/create/provider/index_notifier.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/create_close_button.dart';
import 'widgets/notifications/create_notification.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with TabIndexListenerMixin {
  final GlobalKey textfieldKey = GlobalKey();
  final TextEditingController postTextController = TextEditingController();
  final FocusNode postTextFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    postTextFocusNode.addListener(onTextFieldFocusChange);
  }

  @override
  void dispose() {
    postTextFocusNode.dispose();
    postTextController.dispose();
    super.dispose();
  }

  void onTextFieldFocusChange() {
    if (context.mounted) {
      // if (postTextFocusNode.hasFocus) {
      //   CreateNotification();
      // } else {
      //   CreateNotification(collapseNavigator: true);
      // }
    }
  }

  @override
  void onIndexChanged(int newIndex) {
    if (newIndex != CreateTab.post.index) {
      postTextFocusNode.unfocus();
    }
  }

  void onTextFieldChange(String value) {
    if (value.isNotEmpty) {
      CreateNotification(hideNavigator: true);
    } else {
      CreateNotification(hideNavigator: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const CreateCloseButton(),
        title: const Text(
          'Create post',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const NoScrollGlowBehavior(),
        child: ScrollbarTheme(
          data: const ScrollbarThemeData(
            thumbColor: WidgetStatePropertyAll(Colors.white38),
          ),
          child: Scrollbar(
            controller: scrollController,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(12.0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        const AccountAvatar(),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Joshua',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  YTIcons.location_outlined,
                                  size: 14,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Public',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CustomInkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(16),
                                  splashFactory: NoSplash.splashFactory,
                                  padding: const EdgeInsets.all(4),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.white12,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      YTIcons.more_horiz_outlined,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          key: textfieldKey,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            focusNode: postTextFocusNode,
                            controller: postTextController,
                            expands: true,
                            maxLines: null,
                            decoration: const InputDecoration.collapsed(
                              hintText:
                                  'Share an image to start a caption contest.',
                            ),
                            onChanged: onTextFieldChange,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            CustomInkWell(
                              onTap: () {},
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child:
                                  const Icon(YTIcons.poll_outlined, size: 24),
                            ),
                            CustomInkWell(
                              onTap: () {},
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child:
                                  const Icon(YTIcons.image_outlined, size: 24),
                            ),
                            CustomInkWell(
                              onTap: () {},
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child:
                                  const Icon(YTIcons.answer_outlined, size: 24),
                            ),
                          ],
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: math.max(
                              0,
                              MediaQuery.viewInsetsOf(context).bottom - 88,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
