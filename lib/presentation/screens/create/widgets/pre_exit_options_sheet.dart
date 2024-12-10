import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/themes.dart';

enum PreExitAction { save, discard, exit }

class PreExitEntry {
  PreExitEntry({
    required this.label,
    required this.icon,
    required this.action,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final PreExitAction action;
  final VoidCallback onTap;
}

class PreExitOptionsSheet extends ConsumerWidget {
  const PreExitOptionsSheet({
    super.key,
    this.items = const <PreExitEntry>[],
  });

  final List<PreExitEntry> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in items)
            ListTile(
              title: Text(item.label),
              leading: item.icon,
              titleTextStyle: const TextStyle(fontSize: 12.5),
              hoverColor: Colors.white24,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              onTap: () {
                item.onTap();
                context.pop(item.action);
              },
            ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(YTIcons.close_outlined),
            title: const Text('Cancel'),
            titleTextStyle: const TextStyle(fontSize: 12.5),
            hoverColor: Colors.white24,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            onTap: () => context.pop(PreExitAction.exit),
          ),
        ],
      ),
    );
  }
}

Future<PreExitAction?> showPreExitSheet(
  BuildContext context, {
  required List<PreExitEntry> items,
}) {
  return showModalBottomSheet<PreExitAction>(
    context: context,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return PreExitOptionsSheet(items: items);
    },
  );
}
