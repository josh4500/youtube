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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';
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
        actions: <Widget>[
          AppbarAction(
            icon: Icons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.search_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.more_vert_outlined,
            onTapDown: (TapDownDetails details) async {
              final Offset position = details.globalPosition;
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
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.sizeOf(context).height * .45,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topCenter,
                    end: AlignmentDirectional.bottomCenter,
                    colors: <Color>[
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
                    children: <Widget>[
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
                        children: <Widget>[
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Josh',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '17 videos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.lock,
                                    size: 13,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Private',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
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
                        children: <Widget>[
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
                (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Slidable(
                      maxOffset: 0.3,
                      items: [
                        SlidableItem(
                          icon: Icon(Icons.delete, color: Colors.black),
                        ),
                      ],
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.sort_rounded),
                          Expanded(
                            child: PlayableVideoContent(
                              width: 180,
                              height: 112,
                              margin: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
