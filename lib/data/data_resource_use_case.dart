import 'package:flutter/foundation.dart';
import 'package:youtube_clone/data/data_resource.dart';

typedef Dependency = Type;

/// A base class representing a use case that operates on data resources.
abstract class DataResourceUseCase {
  /// A list of types representing the dependencies required by this use case.
  List<Dependency> get dependencies;

  /// Internal getter for the number of dependencies (for efficiency).
  int get _dependencyCount => dependencies.length;

  /// A map that stores bound dependencies for this use case.
  final Map<Dependency, Object> _dependencies = <Dependency, Object>{};

  /// Checks if all required dependencies have been bound to the use case.
  bool get hasResolvedDependencies => _dependencies.length == _dependencyCount;

  /// Retrieves a bound dependency of a specific type.
  ///
  /// Throws an [UnresolvedDependencyException] if the dependency is not bound.
  @protected
  @visibleForTesting
  R use<R>() {
    // Ensure required resource is available
    final resource = _dependencies[R];
    if (resource == null) {
      throw UnresolvedDependencyException<R>();
    }
    return resource as R;
  }

  /// Binds a data resource to this use case.
  ///
  /// Throws an [UnsupportedResourceException] if the provided resource
  /// is not supported by the use case.
  @mustCallSuper
  void inject(DataResource resource) {
    if (!dependencies.contains(resource.runtimeType)) {
      throw UnsupportedResourceException(resource.runtimeType);
    }
    _dependencies.putIfAbsent(resource.runtimeType, () => resource);
  }
}

/// Exception thrown when a required dependency is not bound to a use case.
class UnresolvedDependencyException<T> implements Exception {
  @override
  String toString() =>
      "Required dependency of type '${T.toString()}' is not bound to the use case.";
}

/// Exception thrown when an unsupported resource is provided to a use case.
class UnsupportedResourceException implements Exception {
  UnsupportedResourceException(this.resourceType);
  final Type resourceType;

  @override
  String toString() =>
      "Resource of type '${resourceType.toString()}' is not supported by the use case.";
}
