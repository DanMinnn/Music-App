import 'package:get_it/get_it.dart';
import 'package:music/data/repository/auth/auth_repository_impl.dart';
import 'package:music/data/sources/auth/auth_appwrite_service.dart';
import 'package:music/domain/repository/auth/auth.dart';
import 'package:music/domain/usecases/auth/signin_use_case.dart';
import 'package:music/domain/usecases/auth/signup_use_case.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthAppWriteService>(AuthAppWriteServiceImpl());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
}
