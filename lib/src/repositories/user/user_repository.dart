import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';

import './i_user_repository.dart';

class UserRepository implements IUserRepository {

  final RestClient restClient;

  UserRepository({required this.restClient});

  @override
  Future<Either<AuthException, String>> login(String email, String password) async {
    
    try {
      final Response(data: {"access_token": accessToken}) = await restClient.unauth.post("/auth", data: {
        "email": email,
        "password": password,
        "admin": true,
      });

      return Right(accessToken);

    } on DioException catch(e, s) {

      const errorMessage = "Erro ao realizar login";

      log(errorMessage, error: e, stackTrace: s);

      return switch(e) {
        DioException(response: Response(statusCode: HttpStatus.forbidden)?) => Left(AuthUnaunthorizedException()),
        _ => Left(AuthError(message: errorMessage)),
      };
    }
  }

}