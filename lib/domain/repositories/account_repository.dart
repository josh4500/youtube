import 'package:youtube_clone/data/injector.dart';
import 'package:youtube_clone/data/remote_repository/grpc_resource_client.dart';

class AccountRepository extends DataResource<GrpcResourceClient> {
  AccountRepository(super.client);

  void testFunc() {
    print('AccountRepository Test func');
  }
}
