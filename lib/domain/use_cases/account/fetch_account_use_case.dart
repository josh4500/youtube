import 'package:youtube_clone/data/data_resource_use_case.dart';
import 'package:youtube_clone/domain/repositories/account_repository.dart';
import 'package:youtube_clone/domain/repositories/authentication_repository.dart';

class FetchAccountUseCase extends DataResourceUseCase {
  FetchAccountUseCase();

  @override
  List<Dependency> get dependencies => [
        AccountRepository,
        AuthenticationRepository,
      ];
  void runTestFuc() => use<AccountRepository>().testFunc();
}
