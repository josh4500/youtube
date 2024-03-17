import 'package:youtube_clone/data/data_resource.dart';

import '../data_repository.dart';

class LocalDataRepository extends DataRepository {
  @override
  void registerResource<T extends DataResource>(T resource) {
    // TODO(Josh): implement registerResource
  }

  @override
  T use<T extends DataResource>() {
    // TODO(Josh): implement use
    throw UnimplementedError();
  }
}
