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
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../providers.dart';

class SportsScreen extends StatelessWidget {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: CustomBackButton(onPressed: context.pop),
        title: const Text(
          'Sports',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
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
            onTap: () {},
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(enabled: false),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: ViewableContentSlides()),
            const SliverToBoxAdapter(
              child: ChannelSubscribeTile(title: 'Sports'),
            ),
            SliverToBoxAdapter(
              child: GroupedViewBuilder(
                title: 'Live',
                height: 300,
                onTap: () {},
                itemBuilder: (BuildContext context, int index) {
                  return const PlayableVideoContent(
                    width: 288,
                    height: 165,
                    margin: EdgeInsets.only(right: 12),
                    direction: Axis.vertical,
                  );
                },
                itemCount: 10,
              ),
            ),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
            const SliverToBoxAdapter(child: Divider(height: 0, thickness: 1)),
            SliverToBoxAdapter(
              child: GroupedViewBuilder(
                title: 'Highlights',
                height: 300,
                onTap: () {},
                itemBuilder: (BuildContext context, int index) {
                  return const PlayableVideoContent(
                    width: 288,
                    height: 165,
                    margin: EdgeInsets.only(right: 12),
                    direction: Axis.vertical,
                  );
                },
                itemCount: 10,
              ),
            ),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
            const SliverToBoxAdapter(child: Divider(height: 0, thickness: 1)),
            SliverToBoxAdapter(
              child: GroupedViewBuilder(
                title: 'Top Stories',
                height: 300,
                onTap: () {},
                itemBuilder: (BuildContext context, int index) {
                  return const PlayableVideoContent(
                    width: 288,
                    height: 165,
                    margin: EdgeInsets.only(right: 12),
                    direction: Axis.vertical,
                  );
                },
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
