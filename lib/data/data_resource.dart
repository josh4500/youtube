import 'package:youtube_clone/data/data_resource_client.dart';

abstract class DataResource<T extends DataResourceClient> {
  DataResource(this.client);

  final T client;
}
