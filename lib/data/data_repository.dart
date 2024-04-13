import 'data_resource.dart';
import 'data_resource_use_case.dart';

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
    return 'Resource ${T.runtimeType} was not registered in this repository';
  }
}

class NullResourceRegistration<T> implements Exception {
  @override
  String toString() {
    return 'Cannot register ${T.runtimeType} as null';
  }
}
