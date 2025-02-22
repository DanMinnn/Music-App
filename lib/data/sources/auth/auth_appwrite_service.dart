import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:music/core/configs/appwrite/AppwriteService.dart';
import 'package:music/data/models/auth/create_user_req.dart';
import 'package:music/data/models/auth/signin_user_req.dart';

abstract class AuthAppWriteService {
  Future<Either> signUp(CreateUserReq createUserReq);

  Future<Either> signIn(SigninUserReq signInUserReq);
}

class AuthAppWriteServiceImpl extends AuthAppWriteService {
  final AppwriteService _appwriteService = AppwriteService();

  @override
  Future<Either> signIn(SigninUserReq signInUserReq) async {
    try {
      await _appwriteService.account.createEmailPasswordSession(
        email: signInUserReq.email,
        password: signInUserReq.password,
      );

      return Right('Sign in was successful');
    } on AppwriteException catch (e) {
      String message = '';

      if (e.type == 'user_invalid_credentials') {
        message = 'Please check the email and password.';
      } else {
        message = '${e.type}';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signUp(CreateUserReq createUserReq) async {
    try {
      await _appwriteService.account.create(
        userId: ID.unique(),
        email: createUserReq.email,
        password: createUserReq.password,
      );

      return Right('Sign up was successful');
    } on AppwriteException catch (e) {
      String message = '';

      if (e.type == 'user_email_already_exists') {
        message = 'An account already exists with that email.';
      } else if (e.type == 'general_argument_invalid') {
        message = '${e.type}';
      }
      return Left(message);
    }
  }
}
