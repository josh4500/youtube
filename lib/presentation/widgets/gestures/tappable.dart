import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'tap_release_highlight.dart';

enum GestureEvent {
  add,
  remove;

  bool get value => this == GestureEvent.add;
  static GestureEvent fromBool(bool value) {
    return value ? GestureEvent.add : GestureEvent.remove;
  }
}

abstract class GestureResponseState {
  void markChildInkResponsePressed(
    GestureResponseState childState,
    GestureEvent event,
  );
}

class GestureResponseProvider extends InheritedWidget {
  const GestureResponseProvider({
    super.key,
    required this.state,
    required super.child,
  });

  final GestureResponseState state;

  @override
  bool updateShouldNotify(GestureResponseProvider oldWidget) =>
      state != oldWidget.state;

  static GestureResponseState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GestureResponseProvider>()
        ?.state;
  }
}

enum HighlightType {
  pressed,
  hover,
  released,
  focus,
}

class Tappable extends StatelessWidget {
  const Tappable({
    super.key,
    this.child,
    this.padding,
    this.focusNode,
    this.parentState,
    this.onTap,
    this.statesController,
    this.highlightColor,
    this.releasedColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.borderRadius,
    this.customBorder,
    this.radius,
    this.hoverDuration,
    this.highlightShape = BoxShape.rectangle,
    this.splashFactory,
    this.splashColor,
    this.onFocusChange,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.containedInkWell = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapUp,
    this.onTapDown,
    this.onSecondaryTap,
    this.onSecondaryTapUp,
    this.onSecondaryTapDown,
    this.onTapCancel,
    this.onSecondaryTapCancel,
    this.mouseCursor,
  });

  final bool autofocus;
  final EdgeInsets? padding;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final bool enabled;
  final bool containedInkWell;
  final Color? highlightColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? releasedColor;
  final Color? splashColor;
  final double? radius;
  final Duration? hoverDuration;
  final BoxShape highlightShape;
  final InteractiveInkFeatureFactory? splashFactory;
  final WidgetStateProperty<Color?>? overlayColor;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final bool enableFeedback;
  final WidgetStatesController? statesController;
  final GestureResponseState? parentState;
  final Widget? child;

  final ValueChanged<bool>? onFocusChange;

  final GestureTapCallback? onTap;
  final GestureDoubleTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapUpCallback? onTapUp;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;

  final GestureTapCallback? onSecondaryTap;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapCancelCallback? onSecondaryTapCancel;

  RectCallback? getRectCallback(RenderBox referenceBox) => null;
  final bool excludeFromSemantics;

  final MouseCursor? mouseCursor;

  @override
  Widget build(BuildContext context) {
    final GestureResponseState? parentState =
        GestureResponseProvider.maybeOf(context);
    return TappableWidget(
      onTap: onTap,
      padding: padding,
      releasedColor: releasedColor,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onSecondaryTap: onSecondaryTap,
      onSecondaryTapUp: onSecondaryTapUp,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapCancel: onSecondaryTapCancel,
      mouseCursor: mouseCursor,
      containedInkWell: containedInkWell,
      highlightShape: highlightShape,
      radius: radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      overlayColor: overlayColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      parentState: parentState,
      getRectCallback: getRectCallback,
      statesController: statesController,
      hoverDuration: hoverDuration,
      enabled: true,
      child: child,
    );
  }
}

class TappableWidget extends StatefulWidget {
  const TappableWidget({
    super.key,
    required this.autofocus,
    this.padding,
    this.focusNode,
    required this.canRequestFocus,
    required this.enabled,
    required this.containedInkWell,
    this.highlightColor,
    this.focusColor,
    this.hoverColor,
    this.releasedColor,
    this.splashColor,
    this.radius,
    this.hoverDuration,
    required this.highlightShape,
    this.splashFactory,
    this.getRectCallback,
    this.overlayColor,
    this.borderRadius,
    this.customBorder,
    required this.enableFeedback,
    this.statesController,
    this.parentState,
    this.child,
    this.onFocusChange,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapUp,
    this.onTapDown,
    this.onTapCancel,
    this.onSecondaryTap,
    this.onSecondaryTapUp,
    this.onSecondaryTapDown,
    this.onSecondaryTapCancel,
    required this.excludeFromSemantics,
    this.mouseCursor,
  });

  final bool autofocus;
  final EdgeInsets? padding;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final bool enabled;
  final bool containedInkWell;
  final Color? highlightColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? releasedColor;
  final Color? splashColor;
  final double? radius;
  final Duration? hoverDuration;
  final BoxShape highlightShape;
  final InteractiveInkFeatureFactory? splashFactory;
  final RectCallback? Function(RenderBox referenceBox)? getRectCallback;
  final WidgetStateProperty<Color?>? overlayColor;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final bool enableFeedback;
  final WidgetStatesController? statesController;
  final GestureResponseState? parentState;
  final Widget? child;

  final ValueChanged<bool>? onFocusChange;

  final GestureTapCallback? onTap;
  final GestureDoubleTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapUpCallback? onTapUp;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;

  final GestureTapCallback? onSecondaryTap;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapCancelCallback? onSecondaryTapCancel;

  final bool excludeFromSemantics;

  final MouseCursor? mouseCursor;

  @override
  State<TappableWidget> createState() => _TappableWidgetState();
}

class _TappableWidgetState extends State<TappableWidget>
    with AutomaticKeepAliveClientMixin<TappableWidget>
    implements GestureResponseState {
  bool _hasFocus = false;
  bool _pressing = false;
  bool _hovering = false;

  // GestureResponseState
  final ObserverList<GestureResponseState> _activeChildren =
      ObserverList<GestureResponseState>();
  bool get _anyChildInkResponsePressed => _activeChildren.isNotEmpty;

  // Splash
  Set<InteractiveInkFeature>? _splashes;
  InteractiveInkFeature? _currentSplash;

  // Highlights
  final Map<HighlightType, InkHighlight?> _highlights =
      <HighlightType, InkHighlight?>{};
  bool get hasHighlights => _highlights.isNotEmpty;
  bool get highlightsExist => _highlights.values
      .where((InkHighlight? highlight) => highlight != null)
      .isNotEmpty;

  // Intents
  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: activateOnIntent),
    ButtonActivateIntent:
        CallbackAction<ButtonActivateIntent>(onInvoke: activateOnIntent),
  };
  static const Duration _activationDuration = Duration(milliseconds: 100);
  Timer? _activationTimer;

  @override
  bool get wantKeepAlive =>
      highlightsExist || (_splashes != null && _splashes!.isNotEmpty);

  bool isWidgetEnabled(TappableWidget widget) {
    return _primaryButtonEnabled(widget) || _secondaryButtonEnabled(widget);
  }

  bool _primaryButtonEnabled(TappableWidget widget) {
    return widget.onTap != null ||
        widget.onDoubleTap != null ||
        widget.onLongPress != null ||
        widget.onTapUp != null ||
        widget.onTapDown != null;
  }

  bool _secondaryButtonEnabled(TappableWidget widget) {
    return widget.onSecondaryTap != null ||
        widget.onSecondaryTapUp != null ||
        widget.onSecondaryTapDown != null;
  }

  bool get enabled => isWidgetEnabled(widget);

  bool get _primaryEnabled => _primaryButtonEnabled(widget);
  bool get _secondaryEnabled => _secondaryButtonEnabled(widget);

  WidgetStatesController? internalStatesController;
  WidgetStatesController get statesController =>
      widget.statesController ?? internalStatesController!;

  void initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = WidgetStatesController();
    }
    statesController.update(WidgetState.disabled, !enabled);
    statesController.addListener(handleStatesControllerChange);
  }

  @override
  void initState() {
    super.initState();
    initStatesController();
    FocusManager.instance.addHighlightModeListener(
      handleFocusHighlightModeChange,
    );
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(
      handleFocusHighlightModeChange,
    );
    statesController.removeListener(handleStatesControllerChange);
    internalStatesController?.dispose();
    _activationTimer?.cancel();
    _activationTimer = null;
    super.dispose();
  }

  void handleStatesControllerChange() {
    // Force a rebuild to resolve widget.overlayColor, widget.mouseCursor
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant TappableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statesController != oldWidget.statesController) {
      oldWidget.statesController?.removeListener(handleStatesControllerChange);
      if (widget.statesController != null) {
        internalStatesController?.dispose();
        internalStatesController = null;
      }
      initStatesController();
    }
    if (widget.radius != oldWidget.radius ||
        widget.highlightShape != oldWidget.highlightShape ||
        widget.borderRadius != oldWidget.borderRadius) {
      final InkHighlight? hoverHighlight = _highlights[HighlightType.hover];
      if (hoverHighlight != null) {
        hoverHighlight.dispose();
        updateHighlight(
          HighlightType.hover,
          event: GestureEvent.fromBool(_hovering),
        );
      }
      final InkHighlight? focusHighlight = _highlights[HighlightType.focus];
      if (focusHighlight != null) {
        focusHighlight.dispose();
        // Do not call updateFocusHighlights() here because it is called below
      }
    }

    if (widget.customBorder != oldWidget.customBorder) {
      _widgetUpdateHighlightsAndSplashes();
    }

    if (enabled != isWidgetEnabled(oldWidget)) {
      statesController.update(WidgetState.disabled, !enabled);
      if (!enabled) {
        statesController.update(WidgetState.pressed, false);
        // Remove the existing hover highlight immediately when enabled is false.
        // Do not rely on updateHighlight or InkHighlight.deactivate to not break
        // the expected lifecycle which is updating _hovering when the mouse exit.
        // Manually updating _hovering here or calling InkHighlight.deactivate
        // will lead to onHover not being called or call when it is not allowed.
        final InkHighlight? hoverHighlight = _highlights[HighlightType.hover];
        hoverHighlight?.dispose();
      }
      // Don't call widget.onHover because many widgets, including the button
      // widgets, apply setState to an ancestor context from onHover.
      updateHighlight(
        HighlightType.hover,
        event: GestureEvent.fromBool(_hovering),
      );
    }
    updateFocusHighlights();
  }

  @override
  void markChildInkResponsePressed(
    GestureResponseState childState,
    GestureEvent event,
  ) {
    final bool lastAnyPressed = _anyChildInkResponsePressed;
    if (event == GestureEvent.add) {
      _activeChildren.add(childState);
    } else {
      _activeChildren.remove(childState);
    }

    final bool nowAnyPressed = _anyChildInkResponsePressed;
    if (nowAnyPressed != lastAnyPressed) {
      widget.parentState?.markChildInkResponsePressed(this, event);
    }
  }

  void _widgetUpdateHighlightsAndSplashes() {
    for (final InkHighlight? highlight in _highlights.values) {
      if (highlight != null) {
        highlight.customBorder = widget.customBorder;
      }
    }
    if (_currentSplash != null) {
      _currentSplash!.customBorder = widget.customBorder;
    }
    if (_splashes != null && _splashes!.isNotEmpty) {
      for (final InteractiveInkFeature inkFeature in _splashes!) {
        inkFeature.customBorder = widget.customBorder;
      }
    }
  }

  void activateOnIntent(Intent? intent) {
    _activationTimer?.cancel();
    _activationTimer = null;
    _startNewSplash(context: context);
    _currentSplash?.confirm();
    _currentSplash = null;
    if (widget.onTap != null) {
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      widget.onTap?.call();
    }
    // Delay the call to `updateHighlight` to simulate a pressed delay
    // and give MaterialStatesController listeners a chance to react.
    _activationTimer = Timer(_activationDuration, () {
      updateHighlight(HighlightType.pressed, event: GestureEvent.remove);
    });
  }

  // There are 2 ways of creating new splash,
  //  1: [TapDownDetails] When Tappable is been interacted physically through the
  //     device touch or pointer surface. Pass the TapDownDetails
  //  2: [BuildContext] When interactions is through accessibility interfaces on device
  void _startNewSplash({TapDownDetails? details, BuildContext? context}) {
    assert(details != null || context != null);

    final Offset globalPosition;

    if (context != null) {
      final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
      assert(
        referenceBox.hasSize,
        'InkResponse must be done with layout before starting a splash.',
      );
      globalPosition = referenceBox.localToGlobal(
        referenceBox.paintBounds.center,
      );
    } else {
      globalPosition = details!.globalPosition;
    }
    statesController.update(WidgetState.pressed, true);
    final InteractiveInkFeature splash = _createSplash(globalPosition);
    _splashes ??= HashSet<InteractiveInkFeature>();
    _splashes!.add(splash);
    _currentSplash?.cancel();
    _currentSplash = splash;
    updateKeepAlive();
    updateHighlight(HighlightType.pressed, event: GestureEvent.add);
  }

  Duration getFadeDurationForType(HighlightType type) {
    switch (type) {
      case HighlightType.pressed:
        return const Duration(milliseconds: 200);
      case HighlightType.released:
        return const Duration(milliseconds: 300);
      case HighlightType.hover:
      case HighlightType.focus:
        return widget.hoverDuration ?? const Duration(milliseconds: 50);
    }
  }

  Color getOverlayColorForType(HighlightType type) {
    return widget.overlayColor?.resolve(statesController.value) ??
        switch (type) {
          HighlightType.pressed =>
            widget.highlightColor ?? Theme.of(context).highlightColor,
          HighlightType.focus =>
            widget.focusColor ?? Theme.of(context).focusColor,
          HighlightType.hover =>
            widget.hoverColor ?? Theme.of(context).hoverColor,
          HighlightType.released =>
            widget.releasedColor ?? Theme.of(context).highlightColor,
        };
  }

  void _createHighlight(HighlightType type, {required VoidCallback onRemoved}) {
    final Color resolvedOverlayColor = getOverlayColorForType(type);
    final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
    // TODO(josh4500): Use predefined InkHighlights
    _highlights[type] = type == HighlightType.released
        ? TapReleaseHighlight(
            controller: Material.of(context),
            referenceBox: referenceBox,
            color: enabled
                ? resolvedOverlayColor
                : resolvedOverlayColor.withAlpha(0),
            shape: widget.highlightShape,
            radius: widget.radius,
            borderRadius: widget.borderRadius,
            customBorder: widget.customBorder,
            rectCallback: widget.getRectCallback!(referenceBox),
            textDirection: Directionality.of(context),
            fadeDuration: getFadeDurationForType(type),
            onRemoved: onRemoved,
          )
        : InkHighlight(
            controller: Material.of(context),
            referenceBox: referenceBox,
            color: enabled
                ? resolvedOverlayColor
                : resolvedOverlayColor.withAlpha(0),
            shape: widget.highlightShape,
            radius: widget.radius,
            borderRadius: widget.borderRadius,
            customBorder: widget.customBorder,
            rectCallback: widget.getRectCallback!(referenceBox),
            textDirection: Directionality.of(context),
            fadeDuration: getFadeDurationForType(type),
            onRemoved: onRemoved,
          );
  }

  InteractiveInkFeature _createSplash(Offset globalPosition) {
    final MaterialInkController inkController = Material.of(context);
    final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
    final Offset position = referenceBox.globalToLocal(globalPosition);
    final Color color = widget.overlayColor?.resolve(statesController.value) ??
        widget.splashColor ??
        Theme.of(context).splashColor;
    final RectCallback? rectCallback =
        widget.containedInkWell ? widget.getRectCallback!(referenceBox) : null;
    final BorderRadius? borderRadius = widget.borderRadius;
    final ShapeBorder? customBorder = widget.customBorder;

    InteractiveInkFeature? splash;
    void onRemoved() {
      if (_splashes != null) {
        assert(_splashes!.contains(splash));
        _splashes!.remove(splash);
        if (_currentSplash == splash) {
          _currentSplash = null;
        }
        updateKeepAlive();
      } // else we're probably in deactivate()
    }

    splash = (widget.splashFactory ?? Theme.of(context).splashFactory).create(
      controller: inkController,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: widget.containedInkWell,
      rectCallback: rectCallback,
      radius: widget.radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      onRemoved: onRemoved,
      textDirection: Directionality.of(context),
    );

    return splash;
  }

  void updateReleaseHighlight() {
    updateHighlight(HighlightType.released, event: GestureEvent.add);
  }

  void updateHighlight(
    HighlightType type, {
    required GestureEvent event,
  }) {
    // Get current highlight for type
    final InkHighlight? highlight = _highlights[type];

    switch (type) {
      case HighlightType.pressed:
        statesController.update(WidgetState.pressed, event.value);
      case HighlightType.hover:
        statesController.update(WidgetState.hovered, event.value);
      case HighlightType.focus:
        // see handleFocusUpdate()
        break;
      case HighlightType.released:
        // see handleTapUp and handleTapCancel
        break;
    }

    if (type == HighlightType.pressed || type == HighlightType.released) {
      widget.parentState?.markChildInkResponsePressed(this, event);
    }

    // Returns when current highlight for type is active
    if (event.value == (highlight != null && highlight.active)) {
      return;
    }

    if (event.value) {
      if (highlight == null) {
        // Adds a new highlight
        _createHighlight(
          type,
          onRemoved: () {
            assert(_highlights[type] != null);
            _highlights[type] = null;
            updateKeepAlive();
            if (type == HighlightType.released) {
              widget.parentState?.markChildInkResponsePressed(
                this,
                GestureEvent.remove,
              );
            }
          },
        );

        updateKeepAlive();
      } else {
        highlight.activate();
      }
    } else {
      // Removes highlight
      highlight!.deactivate();
    }
  }

  bool get _canRequestFocus {
    return switch (MediaQuery.maybeNavigationModeOf(context)) {
      NavigationMode.traditional || null => enabled && widget.canRequestFocus,
      NavigationMode.directional => true,
    };
  }

  bool get _shouldShowFocus {
    return switch (MediaQuery.maybeNavigationModeOf(context)) {
      NavigationMode.traditional || null => enabled && _hasFocus,
      NavigationMode.directional => _hasFocus,
    };
  }

  void handleFocusUpdate(bool hasFocus) {
    _hasFocus = hasFocus;
    // Set here rather than updateHighlight because this widget's
    // (MaterialState) states include MaterialState.focused if
    // the InkWell _has_ the focus, rather than if it's showing
    // the focus per FocusManager.instance.highlightMode.
    statesController.update(WidgetState.focused, hasFocus);
    updateFocusHighlights();
    widget.onFocusChange?.call(hasFocus);
  }

  void updateFocusHighlights() {
    updateHighlight(
      HighlightType.focus,
      event: GestureEvent.fromBool(_shouldShowFocus),
    );
  }

  void handleFocusHighlightModeChange(FocusHighlightMode mode) {
    if (!mounted) return;
    setState(updateFocusHighlights);
  }

  void handleTap() {
    _currentSplash?.confirm();
    _currentSplash = null;
    updateHighlight(HighlightType.pressed, event: GestureEvent.remove);
    if (widget.onTap != null) {
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      _pressing = true;
      widget.onTap?.call();
    }
  }

  void handleTapUp(TapUpDetails details) {
    _pressing = false;
    if (!_anyChildInkResponsePressed && enabled) updateReleaseHighlight();

    widget.onTapUp?.call(details);
  }

  void handleTapDown(TapDownDetails details) {
    handleAnyTapDown(details);
    widget.onTapDown?.call(details);
  }

  void handleAnyTapDown(TapDownDetails details) {
    if (_anyChildInkResponsePressed) {
      return; // Prevent showing highlights and splashes when child is marked
    }
    _startNewSplash(details: details);
  }

  void handleDoubleTap() {
    _currentSplash?.confirm();
    _currentSplash = null;
    updateHighlight(HighlightType.pressed, event: GestureEvent.remove);
    widget.onDoubleTap?.call();
  }

  void handleTapCancel() {
    _currentSplash?.cancel();
    _currentSplash = null;
    widget.onTapCancel?.call();
    _pressing = false;
    updateHighlight(HighlightType.pressed, event: GestureEvent.remove);
    if (!_anyChildInkResponsePressed && enabled) updateReleaseHighlight();
  }

  void handleLongPress() {
    _currentSplash?.confirm();
    _currentSplash = null;
    if (widget.onLongPress != null) {
      if (widget.enableFeedback) {
        Feedback.forLongPress(context);
      }
      widget.onLongPress!();
    }
  }

  void handleSecondaryTap() {
    _currentSplash?.confirm();
    _currentSplash = null;
    updateHighlight(HighlightType.pressed, event: GestureEvent.remove);
    widget.onSecondaryTap?.call();
  }

  void handleSecondaryTapCancel() {
    _currentSplash?.cancel();
    _currentSplash = null;
    widget.onSecondaryTapCancel?.call();
    updateHighlight(HighlightType.pressed, event: GestureEvent.remove);
  }

  void handleSecondaryTapDown(TapDownDetails details) {
    handleAnyTapDown(details);
    widget.onSecondaryTapDown?.call(details);
  }

  void handleSecondaryTapUp(TapUpDetails details) {
    widget.onSecondaryTapUp?.call(details);
  }

  void handleMouseEnter(PointerEnterEvent event) {
    _hovering = true;
    if (enabled) {
      updateHighlight(HighlightType.hover, event: GestureEvent.add);
    }
  }

  void handleMouseExit(PointerExitEvent event) {
    _hovering = false;
    updateHighlight(HighlightType.hover, event: GestureEvent.remove);
  }

  @override
  void deactivate() {
    if (_splashes != null) {
      final Set<InteractiveInkFeature> splashes = _splashes!;
      _splashes = null;
      for (final InteractiveInkFeature splash in splashes) {
        splash.dispose();
      }
      _currentSplash = null;
    }
    assert(_currentSplash == null);
    for (final HighlightType highlight in _highlights.keys) {
      _highlights[highlight]?.dispose();
      _highlights[highlight] = null;
    }
    widget.parentState?.markChildInkResponsePressed(this, GestureEvent.remove);
    super.deactivate();
  }

  void semanticTap() {
    _startNewSplash(context: context);
    handleTap();
  }

  void semanticLongPress() {
    _startNewSplash(context: context);
    handleLongPress();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _currentSplash?.color =
        widget.overlayColor?.resolve(statesController.value) ??
            widget.splashColor ??
            Theme.of(context).splashColor;
    final effectiveMouseCursor = WidgetStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? WidgetStateMouseCursor.clickable,
      statesController.value,
    );

    // GestureDetector
    Widget child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTapDown: _primaryEnabled ? handleTapDown : null,
      onTapUp: _primaryEnabled ? handleTapUp : null,
      onTap: _primaryEnabled ? handleTap : null,
      onTapCancel: _primaryEnabled ? handleTapCancel : null,
      onDoubleTap: widget.onDoubleTap != null ? handleDoubleTap : null,
      onLongPress: widget.onLongPress != null ? handleLongPress : null,
      onSecondaryTapDown: _secondaryEnabled ? handleSecondaryTapDown : null,
      onSecondaryTapUp: _secondaryEnabled ? handleSecondaryTapUp : null,
      onSecondaryTap: _secondaryEnabled ? handleSecondaryTap : null,
      onSecondaryTapCancel: _secondaryEnabled ? handleSecondaryTapCancel : null,
      child: widget.child,
    );

    // Semantics
    child = Semantics(
      enabled: enabled,
      onTap: widget.excludeFromSemantics || widget.onTap == null
          ? null
          : semanticTap,
      onLongPress: widget.excludeFromSemantics || widget.onLongPress == null
          ? null
          : semanticLongPress,
      child: child,
    );

    // MouseRegion
    child = MouseRegion(
      cursor: effectiveMouseCursor,
      onEnter: handleMouseEnter,
      onExit: handleMouseExit,
      child: DefaultSelectionStyle.merge(
        mouseCursor: effectiveMouseCursor,
        child: child,
      ),
    );

    // Focus
    child = Focus(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      canRequestFocus: _canRequestFocus,
      onFocusChange: handleFocusUpdate,
      child: child,
    );

    // Action
    child = Actions(actions: _actionMap, child: child);

    return GestureResponseProvider(
      state: this,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}

class TappableArea extends Tappable {
  const TappableArea({
    super.key,
    super.child,
    super.padding,
    super.onTap,
    super.onDoubleTap,
    super.onLongPress,
    super.onTapDown,
    super.onTapUp,
    super.onTapCancel,
    super.onSecondaryTap,
    super.onSecondaryTapUp,
    super.onSecondaryTapDown,
    super.onSecondaryTapCancel,
    super.mouseCursor,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.overlayColor,
    super.splashColor,
    super.releasedColor,
    InteractiveInkFeatureFactory? splashFactory,
    super.radius,
    super.borderRadius,
    super.customBorder,
    bool? enableFeedback = true,
    super.excludeFromSemantics,
    super.focusNode,
    super.canRequestFocus,
    super.onFocusChange,
    super.autofocus,
    super.statesController,
    super.hoverDuration,
  }) : super(
          containedInkWell: true,
          splashFactory: splashFactory ?? NoSplash.splashFactory,
          highlightShape: BoxShape.rectangle,
          enableFeedback: enableFeedback ?? true,
        );
}
