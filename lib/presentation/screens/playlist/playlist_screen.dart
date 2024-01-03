import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/playable/playable_video_content.dart';

import '../../widgets/appbar_action.dart';
import 'widgets/popup/show_playlist_menu.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          AppbarAction(
            icon: Icons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: Icons.search,
            onTap: () {},
          ),
          AppbarAction(
            icon: Icons.more_vert_outlined,
            onTapDown: (details) async {
              final position = details.globalPosition;
              await showPlaylistMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(color: Colors.black12),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.sizeOf(context).height * .45,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topCenter,
                    end: AlignmentDirectional.bottomCenter,
                    colors: [
                      Colors.indigoAccent,
                      Colors.indigoAccent,
                      Colors.white38,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Cryptography',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Josh',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '17 videos',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.lock,
                                      size: 13, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    'Private',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.download),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Expanded(
                            child: CustomActionChip(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                              ),
                              title: 'Play all',
                              padding: EdgeInsets.all(8),
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: CustomActionChip(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.shuffle,
                                color: Colors.white,
                              ),
                              title: 'Shuffle',
                              padding: EdgeInsets.all(8),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              backgroundColor: Colors.white12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListTile(
                    onTap: () {},
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    title: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.sort_rounded),
                        ),
                        Expanded(
                          child: PlayableVideoContent(
                            width: 180,
                            height: 112,
                          ),
                        )
                      ],
                    ),
                  );
                },
                childCount: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
