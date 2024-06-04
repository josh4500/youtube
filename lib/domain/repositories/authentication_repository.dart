import 'package:youtube_clone/data/injector.dart';
import 'package:youtube_clone/data/remote_repository/grpc_resource_client.dart';

class AuthenticationRepository extends DataResource<GrpcResourceClient> {
  AuthenticationRepository(super.client);
}
