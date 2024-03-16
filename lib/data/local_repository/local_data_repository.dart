import 'package:youtube_clone/data/data_resource.dart';

import '../data_repository.dart';

class LocalDataRepository extends DataRepository {
  @override
  void registerResource<T extends DataResource>(T resource) {
    // TODO: implement registerResource
  }

  @override
  T use<T extends DataResource>() {
    // TODO: implement use
    throw UnimplementedError();
  }
}
