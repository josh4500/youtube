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
import 'package:youtube_clone/presentation/screens/subscriptions/widgets/subscription_tile.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../../providers.dart';
import '../../widgets/appbar_action.dart';
import 'widgets/popup/show_all_subscriptions_menu.dart';

class AllSubscriptionsScreen extends StatelessWidget {
  const AllSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<bool>(
          initialData: false,
          future: Future<bool>.delayed(const Duration(seconds: 2), () => true),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.data!) {
              return const SizedBox();
            }
            return const Text('All subscriptions');
          },
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
            onTapDown: (TapDownDetails details) async {
              final Offset position = details.globalPosition;
              await showAllSubscriptionsMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(
          enabled: false,
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TappableArea(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          Text('Most relevant'),
                          SizedBox(width: 4),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return const SubscriptionTile();
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
