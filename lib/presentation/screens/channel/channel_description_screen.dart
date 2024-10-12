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
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/channel_desc_link.dart';
import 'widgets/menu/show_channel_menu.dart';

class ChannelDescriptionScreen extends StatelessWidget {
  const ChannelDescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marques Brownlee'),
        leading: CustomBackButton(
          onPressed: context.pop,
        ),
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
            onTapDown: (TapDownDetails details) {
              final Offset position = details.globalPosition;
              showChannelMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(enabled: false),
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'MKBHD Quality Tech Videos | YouTube | Geek | Consumer Electronics | Tech Head | Internet Personality!\n\nbusiness@MKBHD.com\n\nNYC',
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Links',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ChannelDescLink(),
                    ChannelDescLink(),
                    ChannelDescLink(),
                    ChannelDescLink(),
                    ChannelDescLink(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'More info',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TappableArea(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(YTIcons.network_outlined),
                          const SizedBox(width: 8),
                          Text(
                            'http://www.youtube.com/MKBHD',
                            style: TextStyle(color: context.theme.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(YTIcons.location_outlined),
                          SizedBox(width: 8),
                          Text('United States'),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(YTIcons.info_outlined),
                          SizedBox(width: 8),
                          Text(
                            'Joined Mar 21, 2008',
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(YTIcons.trending_up_outlined),
                          SizedBox(width: 8),
                          Text('3,952,243,270 views'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
