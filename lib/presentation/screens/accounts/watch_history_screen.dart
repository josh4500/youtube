import 'package:flutter/material.dart';

import '../../widgets/appbar_action.dart';
import '../../widgets/over_scroll_glow_behavior.dart';
import '../../widgets/playable/playable_video_content.dart';
import 'widgets/popup/show_history_menu.dart';
import 'widgets/shorts_history.dart';

class WatchHistoryScreen extends StatefulWidget {
  const WatchHistoryScreen({super.key});

  @override
  State<WatchHistoryScreen> createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends State<WatchHistoryScreen>
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
            'History',
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
            onTapDown: (details) {
              final position = details.globalPosition;
              showHistoryMenu(
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
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'History',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SomeSearchTextfield(
                      focusNode: focusNode,
                      controller: textEditingController,
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: ShortsHistory(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Slidable(
                      child: InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: PlayableVideoContent(
                            width: 180,
                            height: 104,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
              const SliverToBoxAdapter(
                child: ShortsHistory(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: PlayableVideoContent(
                        width: 180,
                        height: 104,
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

class SomeSearchTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const SomeSearchTextfield({super.key, this.controller, this.focusNode});

  @override
  State<SomeSearchTextfield> createState() => _SomeSearchTextfieldState();
}

class _SomeSearchTextfieldState extends State<SomeSearchTextfield>
    with TickerProviderStateMixin {
  late final TextEditingController _effectiveController;
  late final FocusNode _effectiveFocusNode;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();
    _effectiveFocusNode = widget.focusNode ?? FocusNode();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _effectiveFocusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (_effectiveFocusNode.hasFocus) {
      _controller.forward();
    } else if (_effectiveController.text.isEmpty) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      color: const Color(0xff2c2c2c),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              focusNode: _effectiveFocusNode,
              controller: _effectiveController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Search watch history',
              ),
            ),
          ),
          ListenableBuilder(
            listenable: _effectiveController,
            builder: (context, child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInCubic,
                opacity: _effectiveController.text.isNotEmpty ? 1 : 0,
                child: child!,
              );
            },
            child: IconButton(
              onPressed: () {
                _effectiveController.clear();
                _focusNodeListener();
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
            axisAlignment: 0,
            child: ColoredBox(
              color: Colors.white12,
              child: TextButton(
                onPressed: () {
                  _effectiveFocusNode.unfocus();
                  _effectiveController.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Slidable extends StatefulWidget {
  final Widget child;
  const Slidable({super.key, required this.child});

  @override
  State<Slidable> createState() => _SlidableState();
}

class _SlidableState extends State<Slidable> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<RelativeRect> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = RelativeRectTween(
      begin: const RelativeRect.fromLTRB(0, 0, 0, 0),
      end: const RelativeRect.fromLTRB(0, 0, 100, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Slide to the left when dragging to the left
        if (details.primaryDelta! < 0) {
          _controller.forward();
        }
        // Slide to the right when dragging to the right
        else if (details.primaryDelta! > 0) {
          _controller.reverse();
        }
      },
      onHorizontalDragEnd: (details) {
        // You can add additional logic here if needed
      },
      child: Stack(
        children: [
          const SizedBox(
            width: 100,
            height: 112,
            child: Icon(
              Icons.delete,
              color: Colors.black,
            ),
          ),
          PositionedTransition(
            rect: _animation,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
