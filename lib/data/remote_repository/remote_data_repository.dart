import '../data_repository.dart';
import '../data_resource.dart';
import '../data_resource_use_case.dart';

class RemoteDataRepository extends DataRepository {
  final _resourceStore = Expando<DataResource>('RemoteResourceStore');
  final _useCaseStore = Expando<Object>('RemoteUseCaseStore');

  @override
  void registerResource<T extends DataResource>(
    T? resource, {
    List<DataResourceUseCase> useCases = const <DataResourceUseCase>[],
  }) {
    if (resource == null) {
      throw NullResourceRegistration<T>();
    }

    _resourceStore[T] = resource;
    for (final useCase in useCases) {
      _useCaseStore[useCase.runtimeType] = useCase;
    }
  }

  @override
  T use<T extends DataResource>() {
    final DataResource? resource = _resourceStore[T];
    if (resource == null) {
      throw UnregisteredResource<T>();
    }
    return resource as T;
  }

  @override
  U getUseCase<U extends DataResourceUseCase>() {
    final Object? useCase = _useCaseStore[U];

    // TODO(Josh): Throw appropriate exception
    if (useCase == null) throw ArgumentError();

    useCase as U;
    if (useCase.hasResolvedDependencies == false) {
      for (final dependency in useCase.dependencies) {
        // TODO(Josh): Throw specific error if null
        useCase.inject(_resourceStore[dependency]!);
      }
      // Save resolved UseCase
      _useCaseStore[U] = useCase;
    }

    return useCase;
  }
}
