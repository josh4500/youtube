import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    required this.errorViewBuilder,
    required this.onException,
    required this.onCrash,
  });

  final Widget child;

  /// Builds a custom error view when an error occurs in the subtree.
  final Widget Function(FlutterErrorDetails details) errorViewBuilder;

  /// Called when a build error or a widget-related exception occurs.
  final void Function(Object error, StackTrace stackTrace) onException;

  /// Called when a serious Flutter framework crash occurs.
  final void Function(FlutterErrorDetails details) onCrash;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();

  static void Function(Object, StackTrace)? onErrorOf(BuildContext context) {
    return _ErrorBoundaryScope.of(context)!.onError;
  }
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  FlutterErrorDetails? _errorDetails;
  final FlutterExceptionHandler? oldFlutterErrorHandler = FlutterError.onError;
  final ErrorWidgetBuilder oldErrorWidgetBuilder = ErrorWidget.builder;

  @override
  void initState() {
    super.initState();
    // Override the global Flutter error handler to capture framework crashes.
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kReleaseMode) {
        widget.onCrash(details);
      } else {
        oldFlutterErrorHandler?.call(details);
      }
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorDetails = details;
        });
      }
    };
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      widget.onException(error, stack);
      return true;
    };
  }

  /// This function is called to catch build-time errors in the subtree.
  void _catchException(Object error, StackTrace stackTrace) {
    widget.onException(error, stackTrace);
    setState(() {
      _hasError = true;
      _errorDetails = FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        context: ErrorDescription('While building a widget subtree.'),
      );
    });
  }

  @override
  void dispose() {
    FlutterError.onError = oldFlutterErrorHandler;
    ErrorWidget.builder = oldErrorWidgetBuilder;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _errorDetails != null) {
      return widget.errorViewBuilder(_errorDetails!);
    }

    return _ErrorBoundaryScope(
      onError: _catchException,
      child: widget.child,
    );
  }
}

/// Inherited widget that provides error handling to descendant widgets.
class _ErrorBoundaryScope extends InheritedWidget {
  const _ErrorBoundaryScope({
    required super.child,
    required this.onError,
  });
  final void Function(Object error, StackTrace stackTrace) onError;

  @override
  bool updateShouldNotify(_ErrorBoundaryScope oldWidget) {
    return onError != oldWidget.onError;
  }

  static _ErrorBoundaryScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ErrorBoundaryScope>();
  }
}
