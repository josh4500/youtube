import 'package:youtube_clone/data/data_resource_client.dart';

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
