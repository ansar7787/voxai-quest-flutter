import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voxai_quest/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: sl(), googleSignIn: sl()),
  );

  // Blocs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
}
