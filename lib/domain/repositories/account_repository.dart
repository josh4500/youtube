import 'package:flutter/foundation.dart';
import 'package:youtube_clone/data/injector.dart';
import 'package:youtube_clone/data/remote_repository/grpc_resource_client.dart';

class AccountRepository extends DataResource<GrpcResourceClient> {
  AccountRepository(super.client);

  void testFunc() {
    debugPrint('AccountRepository Test func');
  }
}
