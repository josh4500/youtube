import '../injector.dart';

class LocalDataRepository extends DataRepository {
  @override
  void registerResource<T extends DataResource>(
    T resource, {
    List<DataResourceUseCase> useCases = const <DataResourceUseCase>[],
  }) {
    // TODO(josh4500): implement registerResource
  }

  @override
  T use<T extends DataResource>() {
    // TODO(josh4500): implement use
    throw UnimplementedError();
  }

  @override
  U getUseCase<U extends DataResourceUseCase>() {
    // TODO(josh4500): implement getUseCase
    throw UnimplementedError();
  }
}
