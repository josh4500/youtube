import 'package:flutter/material.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/presentation/theme/device_theme.dart';

import '../../infrastructure.dart';
import '../theme/icon/y_t_icons_icons.dart';
import 'custom_scroll_physics.dart';
import 'gestures/custom_ink_well.dart';
import 'gestures/tappable_area.dart';
import 'over_scroll_glow_behavior.dart';
import 'sheet_drag_indicator.dart';

class DynamicSheet extends StatefulWidget {
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
  State<DynamicSheet> createState() => _DynamicSheetState();
}

class _DynamicSheetState extends State<DynamicSheet>
    with SingleTickerProviderStateMixin {
  final customScrollPhysics = const CustomScrollableScrollPhysics(
    tag: 'dynamic-sheet',
  );
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<double> heightNotifier = ValueNotifier<double>(0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    heightNotifier.value = minSheetHeight;
  }

  double get minSheetHeight {
    return context.orientation.isPortrait
        ? MediaQuery.sizeOf(context).height * .48
        : MediaQuery.sizeOf(context).height;
  }

  double get maxSheetHeight {
    return MediaQuery.sizeOf(context).height * .9;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: const Color(0xFF212121),
          child: Listener(
            onPointerMove: (event) {
              final deltaY = event.delta.dy;
              final newHeight = heightNotifier.value + (deltaY * -1);

              heightNotifier.value = newHeight.clamp(
                minSheetHeight,
                maxSheetHeight,
              );

              customScrollPhysics.canScroll(
                !(heightNotifier.value <= minSheetHeight && deltaY >= 0),
              );
            },
            child: ListenableBuilder(
              listenable: heightNotifier,
              builder: (BuildContext context, Widget? childWidget) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: heightNotifier.value),
                  child: childWidget,
                );
              },
              child: ScrollConfiguration(
                behavior: const OverScrollGlowBehavior(enabled: false),
                child: Scrollbar(
                  controller: scrollController,
                  child: ListView(
                    physics: customScrollPhysics,
                    shrinkWrap: true,
                    controller: scrollController,
                    children: [
                      const Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          SheetDragIndicator(),
                        ],
                      ),
                      if (widget.title != null) widget.title!,
                      ...widget.children,
                      if (widget.trailing != null) widget.trailing!,
                    ],
                  ),
                ),
              ),
            ),
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

class DynamicSheetOptionItem<T> extends DynamicSheetItem {
  const DynamicSheetOptionItem({
    super.key,
    this.value,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.useTappable = false,
    this.exitOnTap = true,
    this.enabled = true,
    this.action,
    this.dependents = const <DynamicSheetItemDependent>[],
  });

  final T? value;
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool enabled;
  final bool useTappable;
  final bool exitOnTap;
  final VoidCallback? action;
  final List<DynamicSheetItemDependent> dependents;

  void performAction(BuildContext context) {
    if (action != null) action?.call();
    if (exitOnTap && enabled) Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
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

    if (enabled) {
      if (useTappable) {
        child = TappableArea(onTap: () => performAction(context), child: child);
      } else {
        child = CustomInkWell(
          onTap: () => performAction(context),
          highlightColor: Colors.transparent,
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
    constraints: const BoxConstraints(maxWidth: 500),
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

class DynamicSheetItemCheck extends StatelessWidget {
  const DynamicSheetItemCheck({
    super.key,
    required this.selected,
    this.size = 28,
    this.color,
  });

  final double size;
  final Color? color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return selected
        ? Icon(YTIcons.check_outlined, size: size, color: color)
        : SizedBox(width: size);
  }
}

class DynamicSheetSection<T> extends DynamicSheetItem {
  const DynamicSheetSection({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return child ?? const SizedBox();
  }
}

abstract class DynamicSheetItem extends StatelessWidget {
  const DynamicSheetItem({super.key});
}
