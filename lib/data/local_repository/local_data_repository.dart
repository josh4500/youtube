import 'package:youtube_clone/data/data_resource.dart';

import '../data_repository.dart';
import '../data_resource_use_case.dart';

class LocalDataRepository extends DataRepository {
  @override
  void registerResource<T extends DataResource>(
    T resource, {
    List<DataResourceUseCase> useCases = const <DataResourceUseCase>[],
  }) {
    // TODO(Josh): implement registerResource
  }

  @override
  T use<T extends DataResource>() {
    // TODO(Josh): implement use
    throw UnimplementedError();
  }

  @override
  U getUseCase<U extends DataResourceUseCase>() {
    // TODO: implement getUseCase
    throw UnimplementedError();
  }
}
