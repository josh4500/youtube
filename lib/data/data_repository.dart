import 'package:youtube_clone/data/data_resource.dart';

abstract class DataRepository {
  /// Use Resource
  T use<T extends DataResource>();

  /// Register data resource
  void registerResource<T extends DataResource>(T resource);
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
