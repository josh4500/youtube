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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/account_repository_provider.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/subscriptions_tabs.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int?> _selectedChannel = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    return AuthStateBuilder(
      builder: (context, state) {
        if (state.isInIncognito) {
          return const SubscriptionsIncognitoScreen();
        } else if (state.isNotAuthenticated) {
          return const UnAuthenticatedSubscriptionScreen();
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(
              enabled: false,
            ),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
                    AppbarAction(
                      icon: YTIcons.cast_outlined,
                      onTap: () {},
                    ),
                    AppbarAction(
                      icon: YTIcons.notification_outlined,
                      onTap: () => context.goto(AppRoutes.notifications),
                    ),
                    AppbarAction(
                      icon: YTIcons.search_outlined,
                      onTap: () => context.goto(AppRoutes.search),
                    ),
                  ],
                  floating: true,
                  // TODO(josh4500): Fix rebuild caused by bottom
                  bottom: PreferredSize(
                    preferredSize: const Size(double.infinity, 125 + 44),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 120,
                          child: SubscriptionsTabs(
                            valueListenable: _selectedChannel,
                            onChange: (int? value) {},
                          ),
                        ),
                        const SizedBox(height: 8),
                        ValueListenableBuilder<int?>(
                          valueListenable: _selectedChannel,
                          builder: (
                            BuildContext context,
                            int? value,
                            Widget? childWidget,
                          ) {
                            if (value != null) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    CustomActionChip(
                                      title: 'View channel',
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 16,
                                      ),
                                      backgroundColor: Colors.white12,
                                      onTap: () {
                                        context.goto(
                                          AppRoutes.channel.withPrefixParent(
                                            AppRoutes.subscriptions,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.05,
                              child: childWidget,
                            );
                          },
                          child: DynamicTab(
                            initialIndex: 1,
                            useTappable: true,
                            trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TappableArea(
                                onTap: () {},
                                padding: const EdgeInsets.all(4.0),
                                child: const Text(
                                  'Settings',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                            options: const <String>[
                              'All',
                              'Today',
                              'Live',
                              'Shorts',
                              'Continue watching',
                              'Unwatched',
                              'Post',
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: ViewablePostContent(),
                ),
                SliverToBoxAdapter(
                  // TODO(josh4500): What is the use of this Widget
                  child: ViewableGroupShorts(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            AssetsPath.logoShorts32,
                            filterQuality: FilterQuality.high,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Shorts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder<int?>(
                  valueListenable: _selectedChannel,
                  builder:
                      (BuildContext context, int? value, Widget? childWidget) {
                    if (value != null) {
                      return const SliverFillRemaining();
                    }
                    return childWidget!;
                  },
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ViewableVideoContent(
                          onMore: () {
                            showDynamicSheet(
                              context,
                              items: [
                                DynamicSheetOptionItem(
                                  leading: const Icon(
                                    YTIcons.playlist_play_outlined,
                                  ),
                                  title: 'Play next in queue',
                                  trailing: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Image.asset(
                                      AssetsPath.ytPAccessIcon48,
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ),
                                const DynamicSheetOptionItem(
                                  leading: Icon(YTIcons.watch_later_outlined),
                                  title: 'Save to Watch later',
                                ),
                                const DynamicSheetOptionItem(
                                  leading: Icon(YTIcons.save_outlined),
                                  title: 'Save to playlist',
                                ),
                                const DynamicSheetOptionItem(
                                  leading: Icon(YTIcons.download_outlined),
                                  title: 'Download video',
                                ),
                                const DynamicSheetOptionItem(
                                  leading: Icon(YTIcons.share_outlined),
                                  title: 'Share',
                                ),
                                const DynamicSheetOptionItem(
                                  leading: Icon(YTIcons.close_circle_outlined),
                                  title: 'Unsubscribe',
                                  dependents: [DynamicSheetItemDependent.auth],
                                ),
                                const DynamicSheetOptionItem(
                                  leading: Icon(
                                    YTIcons.not_interested_outlined,
                                  ),
                                  title: 'Hide',
                                  dependents: [DynamicSheetItemDependent.auth],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      childCount: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UnAuthenticatedSubscriptionScreen extends StatelessWidget {
  const UnAuthenticatedSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: const AppLogo(),
        actions: <Widget>[
          AppbarAction(
            icon: YTIcons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.notification_outlined,
            onTap: () => context.goto(AppRoutes.notifications),
          ),
          AppbarAction(
            icon: YTIcons.search_outlined,
            onTap: () => context.goto(AppRoutes.search),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: const <Widget>[
          SizedBox(height: 24),
          Icon(Icons.subscriptions_sharp, size: 120),
          SizedBox(height: 48),
          Text(
            'Don\'t miss new videos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Sign in to see updates from your favorite\n YouTube channels',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomActionChip(
                alignment: Alignment.center,
                backgroundColor: Color(0xFF3EA6FF),
                title: 'Sign in',
                borderRadius: BorderRadius.zero,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SubscriptionsIncognitoScreen extends ConsumerWidget {
  const SubscriptionsIncognitoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: const AppLogo(),
        actions: <Widget>[
          AppbarAction(
            icon: YTIcons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.notification_outlined,
            onTap: () => context.goto(AppRoutes.notifications),
          ),
          AppbarAction(
            icon: YTIcons.search_outlined,
            onTap: () => context.goto(AppRoutes.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 56),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AssetsPath.accountIncognito108,
                        width: 96,
                        height: 96,
                        color: const Color(0xFFCCCCCC),
                      ),
                    ),
                    const SizedBox(height: 44),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 48.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Text(
                        'Your subscriptions are hidden while you\'re incognito',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TappableArea(
                      onTap: () {
                        ref.read(accountRepositoryProvider).turnOffIncognito();
                      },
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12,
                      ),
                      child: const Text(
                        'Turn off Incognito',
                        style: TextStyle(
                          color: Color(0xFF3EA6FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Expanded(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3EA6FF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoSubscriptionsScreen extends StatelessWidget {
  const NoSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [],
      ),
    );
  }
}
