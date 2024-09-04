import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class AddSoundScreen extends StatelessWidget {
  const AddSoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ['Browse', 'Saved'];
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: context.pop,
          splashFactory: NoSplash.splashFactory,
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12,
            ),
            child: Icon(
              YTIcons.close_outlined,
              size: 20,
              color: Colors.white70,
            ),
          ),
        ),
        leadingWidth: 28,
        title: const Text(
          'Sounds',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: ScrollConfiguration(
          behavior: const OverScrollGlowBehavior(enabled: false),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TabBar(
                      isScrollable: true,
                      padding: EdgeInsets.zero,
                      indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.white,
                      indicatorColor: Colors.white,
                      tabs: tabs.map((String name) => Tab(text: name)).toList(),
                    ),
                  ],
                ),
              ),
              const Divider(height: .75, thickness: 1),
              const Expanded(
                child: TabBarView(
                  children: [
                    BrowsePage(),
                    SavedPage(),
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

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(
            'Nothing to hear here',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'You don\'t have anything saved. Save sounds to create Shorts with later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return const SoundTile();
            },
            childCount: 3,
          ),
        ),
      ],
    );
  }
}

class BrowsePage extends StatelessWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: GroupedPageViewBuilder(
            title: 'Recommended',
            onTap: () {},
            leading: const Icon(Icons.star_outline),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SoundTile(),
                    SoundTile(),
                    SoundTile(),
                  ],
                ),
              );
            },
            itemCount: 3,
          ),
        ),
        SliverToBoxAdapter(
          child: GroupedPageViewBuilder(
            title: 'Top rated',
            onTap: () {},
            leading: const Icon(YTIcons.trending_up_outlined),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SoundTile(),
                    SoundTile(),
                    SoundTile(),
                  ],
                ),
              );
            },
            itemCount: 3,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return const SoundTile();
            },
            childCount: 5,
          ),
        ),
      ],
    );
  }
}

class SoundTile extends StatefulWidget {
  const SoundTile({super.key});

  @override
  State<SoundTile> createState() => _SoundTileState();
}

class _SoundTileState extends State<SoundTile>
    with SingleTickerProviderStateMixin<SoundTile> {
  late final AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressEnd: (LongPressEndDetails details) {
        controller.forward();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Epic Inspiration',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Ludovico Einaudi, Daniel Hope',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '1:00 $kDotSeparator 647k Shorts',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(width: 12),
            // TODO(josh4500): Get filled save icon
            const Icon(YTIcons.save_outlined),
            SizeTransition(
              axis: Axis.horizontal,
              axisAlignment: -1,
              sizeFactor: controller,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppPalette.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const RotatedBox(
                      quarterTurns: 2,
                      child: Icon(
                        YTIcons.arrow_back_outlined,
                        size: 18,
                        color: Colors.black,
                      ),
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