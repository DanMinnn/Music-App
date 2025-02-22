import 'package:dartz/dartz.dart';
import 'package:music/data/models/auth/create_user_req.dart';
import 'package:music/data/models/auth/signin_user_req.dart';
import 'package:music/data/sources/auth/auth_appwrite_service.dart';
import 'package:music/domain/repository/auth/auth.dart';
import 'package:music/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signIn(SigninUserReq signInUserReq) async {
    return await sl<AuthAppWriteService>().signIn(signInUserReq);
  }

  @override
  Future<Either> signUp(CreateUserReq createUserReq) async {
    return await sl<AuthAppWriteService>().signUp(createUserReq);
  }
}
