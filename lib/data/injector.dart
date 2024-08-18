import 'package:flutter/widgets.dart';

typedef Dependency = Type;

/// A base class representing a use case that operates on data resources.
abstract class Injector<R> {
  /// A list of types representing the dependencies required by this use case.
  List<Dependency> get dependencies;

  /// Internal getter for the number of dependencies (for efficiency).
  int get _dependencyCount => dependencies.length;

  /// A map that stores bound dependencies for this use case.
  final Map<Dependency, R> _dependencies = <Dependency, R>{};

  /// Checks if all required dependencies have been bound to the use case.
  bool get hasResolvedDependencies => _dependencies.length == _dependencyCount;

  /// Retrieves a bound dependency of a specific type [D].
  ///
  /// Throws an [UnresolvedDependencyException] if the dependency is not bound.
  @protected
  @visibleForTesting
  D use<D extends R>() {
    // Ensure required resource is available
    final resource = _dependencies[D];
    if (resource == null) {
      throw UnresolvedDependencyException<D>();
    }
    return resource as D;
  }

  /// Binds a data resource to this use case.
  ///
  /// Throws an [UnsupportedDependencyException] if the provided resource
  /// is not supported by the use case.
  @mustCallSuper
  void inject(R resource) {
    if (!dependencies.contains(resource.runtimeType)) {
      throw UnsupportedDependencyException(resource.runtimeType);
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
class UnsupportedDependencyException implements Exception {
  UnsupportedDependencyException(this.resourceType);
  final Type resourceType;

  @override
  String toString() =>
      "Resource of type '${resourceType.toString()}' is not supported by the use case.";
}

abstract class DataResourceClient {}

class GroupResourceClient extends DataResourceClient {
  final _resourceClientStore = Expando<DataResourceClient>();

  void add<T extends DataResourceClient>(T? resource) {
    if (resource == null) {
      throw Exception();
    }
    _resourceClientStore[T] = resource;
  }

  T use<T extends DataResourceClient>() {
    final DataResourceClient? resource = _resourceClientStore[T];
    if (resource == null) {
      throw Exception();
    }
    return resource as T;
  }
}

/// Abstract base class representing a data resource.
///
/// A DataResource provides access to data through a specific client implementation.
/// This class enforces a design principle where DataResources should be **independent**
/// of each other.
///
/// If multiple [DataResource]s need to collaborate or share data, consider creating
/// a specific use case class that encapsulates that logic instead of introducing
/// dependencies between [DataResource]s themselves.
abstract class DataResource<T extends DataResourceClient> {
  DataResource(this.client);

  final T client;
}

abstract class DataResourceUseCase extends Injector<DataResource> {}

typedef ResourceUseCaseFactory<U extends DataResourceUseCase> = U Function();

abstract class DataRepository {
  /// Use Resource
  T use<T extends DataResource>();

  U getUseCase<U extends DataResourceUseCase>();

  /// Register data resource
  void registerResource<T extends DataResource>(
    T resource, {
    List<DataResourceUseCase> useCases = const <DataResourceUseCase>[],
  });
}

class UnregisteredResource<T> implements Exception {
  @override
  String toString() {
    GlobalKey();
    return 'Resource ${T.runtimeType} was not registered in this repository';
  }
}

class NullResourceRegistration<T> implements Exception {
  @override
  String toString() {
    return 'Cannot register ${T.runtimeType} as null';
  }
}
