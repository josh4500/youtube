import 'data_resource_client.dart';

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
