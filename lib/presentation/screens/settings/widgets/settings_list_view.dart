import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';

class SettingsListView extends StatefulWidget {
  final List<Widget> children;

  const SettingsListView({super.key, required this.children});

  @override
  State<SettingsListView> createState() => _SettingsListViewState();
}

class _SettingsListViewState extends State<SettingsListView> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const OverScrollGlowBehavior(
        color: Colors.grey,
      ),
      child: Scrollbar(
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          children: widget.children,
        ),
      ),
    );
  }
}
