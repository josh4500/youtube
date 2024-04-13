import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class SearchResultCompound extends StatefulWidget {
  const SearchResultCompound({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    required this.trailing,
    this.itemBuilder,
    this.itemCount,
    this.child,
  });

  final Widget firstTitle;
  final Widget secondTitle;
  final Widget trailing;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final int? itemCount;
  final Widget? child;

  @override
  State<SearchResultCompound> createState() => _SearchResultCompoundState();
}

class _SearchResultCompoundState extends State<SearchResultCompound>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final _showContent = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              TappableArea(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  if (_showContent.value == false) {
                    _showContent.value = true;
                    _animationController.forward();
                  } else {
                    _showContent.value = false;
                    _animationController.reverse();
                  }
                },
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _showContent,
                        builder: (
                          BuildContext context,
                          bool show,
                          Widget? childWidget,
                        ) {
                          if (show) {
                            return widget.secondTitle;
                          }
                          return widget.firstTitle;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: _showContent,
                          builder: (
                            BuildContext context,
                            bool show,
                            Widget? childWidget,
                          ) {
                            if (show) return const SizedBox();
                            return widget.trailing;
                          },
                        ),
                        const SizedBox(width: 4),
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: -.5)
                              .animate(_animationController),
                          child: const Icon(YTIcons.chevron_up),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              FadeTransition(
                opacity: _animationController,
                child: SizeTransition(
                  sizeFactor: _animationController,
                  child: widget.itemBuilder == null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: widget.child,
                        )
                      : SizedBox(
                          height: 180,
                          child: ScrollConfiguration(
                            behavior: const OverScrollGlowBehavior(
                              color: Colors.black12,
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              itemCount: widget.itemCount,
                              itemBuilder: widget.itemBuilder!,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
