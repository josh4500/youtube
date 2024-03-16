import 'package:youtube_clone/data/data_resource.dart';

import '../data_repository.dart';

class RemoteDataRepository extends DataRepository {
  final Expando<DataResource> _resourceStore = Expando<DataResource>();

  @override
  void registerResource<T extends DataResource>(T? resource) {
    if (resource == null) {
      throw NullResourceRegistration<T>();
    }
    _resourceStore[T] = resource;
  }

  @override
  T use<T extends DataResource>() {
    final resource = _resourceStore[T];
    if (resource == null) throw UnregisteredResource<T>();
    return resource as T;
  }
}
