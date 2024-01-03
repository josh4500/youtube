import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/option_button.dart';
import 'package:youtube_clone/presentation/widgets/playable/playable_content.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';
import '../../widgets/appbar_action.dart';
import '../../widgets/over_scroll_glow_behavior.dart';
import 'widgets/popup/show_accounts_playlist_menu.dart';

class AccountPlaylistsScreen extends StatefulWidget {
  const AccountPlaylistsScreen({super.key});

  @override
  State<AccountPlaylistsScreen> createState() => _AccountPlaylistsScreenState();
}

class _AccountPlaylistsScreenState extends State<AccountPlaylistsScreen>
    with TickerProviderStateMixin {
  final ScrollController controller = ScrollController();
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

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
    focusNode.dispose();
    opacityController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: child!,
            );
          },
          child: const Text(
            'Playlists',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
              await showAccountsPlaylistMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: focusNode.unfocus,
        child: ScrollConfiguration(
          behavior: const OverScrollGlowBehavior(enabled: false),
          child: CustomScrollView(
            controller: controller,
            slivers: [
              const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Text(
                        'Playlists',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: OptionButton(
                        title: 'A-Z',
                      ),
                    )
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TappableArea(
                      onPressed: () {},
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: const PlayableContent(
                        width: 180,
                        height: 112,
                        direction: Axis.horizontal,
                        isPlaylist: true,
                      ),
                    );
                  },
                  childCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
