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
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/appbar_action.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import 'widgets/channel_desc_link.dart';

class ChannelDescriptionScreen extends StatelessWidget {
  const ChannelDescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marques Brownlee'),
        actions: <Widget>[
          AppbarAction(
            icon: Icons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.notification_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.search_outlined,
            onTap: () {},
          ),
        ],
      ),
      body: const ScrollConfiguration(
        behavior: OverScrollGlowBehavior(enabled: false),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
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
                    SizedBox(height: 16),
                    Text(
                      'MKBHD Quality Tech Videos | YouTube | Geek | Consumer Electronics | Tech Head | Internet Personality!\n\nbusiness@MKBHD.com\n\nNYC',
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'More info',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TappableArea(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.circle_outlined,
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'htttp://www.youtube.com/MKBHD',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.no_accounts_rounded,
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'United States',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.info_outline_rounded,
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Joined Mar 21, 2008',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.trending_up,
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '3,952,243,270 views',
                          ),
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
