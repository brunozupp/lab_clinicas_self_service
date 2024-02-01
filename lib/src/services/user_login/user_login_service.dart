import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/repositories/user/i_user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './i_user_login_service.dart';

class UserLoginService implements IUserLoginService {

  final IUserRepository userRepository;

  UserLoginService({required this.userRepository});

  @override
  Future<Either<ServiceException, Unit>> execute(String email, String password) async {

    final loginResult = await userRepository.login(email, password);

    switch(loginResult) {
      case Left(value: AuthError()):
        return Left(ServiceException(message: "Erro ao realizar login"));
      case Left(value: AuthUnaunthorizedException()):
        return Left(ServiceException(message: "Login ou senha inválidos"));
      case Right(value: final accessToken):
        final sp = await SharedPreferences.getInstance();
        sp.setString(LocalStorageConstants.accessToken, accessToken);
        return Right(unit);
    }
  }

}