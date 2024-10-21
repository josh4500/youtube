import 'package:flutter/material.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../../infrastructure.dart';
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
    this.heightConstraint,
    this.children = const <DynamicSheetItem>[],
  });

  final Widget? title;
  final Widget? trailing;
  final double? heightConstraint;
  final List<DynamicSheetItem> children;

  @override
  State<DynamicSheet> createState() => _DynamicSheetState();
}

class _DynamicSheetState extends State<DynamicSheet>
    with SingleTickerProviderStateMixin {
  final customScrollPhysics = CustomScrollPhysics();
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
    final DynamicSheetStyle theme = context.theme.appStyles.dynamicSheetStyle;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: theme.backgroundColor,
          child: Listener(
            onPointerMove: (event) {
              if (widget.heightConstraint != null) {
                final deltaY = event.delta.dy;
                final newHeight = heightNotifier.value + (deltaY * -1);

                heightNotifier.value = newHeight.clamp(
                  minSheetHeight,
                  maxSheetHeight,
                );

                customScrollPhysics.canScroll =
                    !(heightNotifier.value <= minSheetHeight && deltaY >= 0);
              }
            },
            child: ListenableBuilder(
              listenable: heightNotifier,
              builder: (BuildContext context, Widget? childWidget) {
                if (widget.heightConstraint == null) {
                  return SizedBox(child: childWidget);
                }
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: heightNotifier.value,
                  ),
                  child: childWidget,
                );
              },
              child: ScrollConfiguration(
                behavior: const OverScrollGlowBehavior(
                  enabled: false,
                ),
                child: Scrollbar(
                  controller: scrollController,
                  child: ListView(
                    physics: widget.heightConstraint == null
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    controller: scrollController,
                    children: [
                      Column(
                        children: <Widget>[
                          const SizedBox(height: 8),
                          SheetDragIndicator(color: theme.dragIndicatorColor),
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
  premium,
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
    final DynamicSheetStyle theme = context.theme.appStyles.dynamicSheetStyle;
    Widget child = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12,
      ),
      child: Row(
        children: [
          IconTheme(
            data: IconTheme.of(context).copyWith(
              color: enabled ? theme.iconColor : theme.disabledIconColor,
            ),
            child: leading,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style:
                    enabled ? theme.itemTextStyle : theme.disabledItemTextStyle,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: enabled
                      ? theme.itemSubtitleStyle
                      : theme.disabledItemSubtitleStyle,
                ),
              ],
            ],
          ),
          const Spacer(),
          if (trailing != null)
            IconTheme(
              data: IconTheme.of(context).copyWith(
                color: enabled ? theme.iconColor : theme.disabledIconColor,
              ),
              child: trailing!,
            ),
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
        child = TappableArea(
          onTap: () => performAction(context),
          child: child,
        );
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
  double? heightConstraint,
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
        heightConstraint: heightConstraint,
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
