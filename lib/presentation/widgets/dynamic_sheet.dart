import 'package:flutter/material.dart';
import 'package:youtube_clone/core.dart';

import '../../infrastructure.dart';
import 'custom_ink_well.dart';
import 'over_scroll_glow_behavior.dart';

class DynamicSheet extends StatelessWidget {
  const DynamicSheet({
    super.key,
    this.title,
    this.trailing,
    this.children = const <DynamicSheetItem>[],
  });

  final Widget? title;
  final Widget? trailing;
  final List<DynamicSheetItem> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: const Color(0xFF212121),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              ScrollConfiguration(
                behavior: const OverScrollGlowBehavior(
                  enabled: false,
                ),
                child: Column(
                  children: List.generate(
                    children.length + (trailing == null ? 0 : 1),
                    (index) => index == children.length && trailing != null
                        ? trailing!
                        : children[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DynamicSheetItemDependent {
  auth,
  channel,
  network,
  orientation,
}

class DynamicSheetItem<T> extends StatelessWidget {
  const DynamicSheetItem({
    super.key,
    this.value,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.dependents = const <DynamicSheetItemDependent>[],
  });

  final T? value;
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<DynamicSheetItemDependent> dependents;

  @override
  Widget build(BuildContext context) {
    Widget child = CustomInkWell(
      onTap: () => Navigator.of(context).pop(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 12,
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(fontSize: 15),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white30,
                    ),
                  ),
                ],
              ],
            ),
            const Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );

    // Note: Avoid using builder widgets
    final uniqueDependents = dependents.toSet();
    for (final dependent in uniqueDependents) {
      if (dependent == DynamicSheetItemDependent.auth) {
        child = Visibility(
          visible: AuthState.authenticated.isAuthenticated,
          child: child,
        );
      } else if (dependent == DynamicSheetItemDependent.network) {
        child = Visibility(
          visible: InternetConnectivity.instance.state.isConnected,
          child: child,
        );
      }
    }

    return child;
  }
}

Future<T?> showDynamicSheet<T>(
  BuildContext context, {
  Widget? title,
  Widget? trailing,
  List<DynamicSheetItem> items = const <DynamicSheetItem>[],
}) {
  return showModalBottomSheet<T>(
    context: context,
    barrierLabel: '',
    shape: const RoundedRectangleBorder(),
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DynamicSheet(
        title: title,
        trailing: trailing,
        children: items,
      );
    },
  );
}
