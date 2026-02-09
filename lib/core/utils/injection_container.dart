import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voxai_quest/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:voxai_quest/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/features/reading/domain/repositories/reading_repository.dart';
import 'package:voxai_quest/features/reading/data/repositories/mock_reading_repository.dart';
import 'package:voxai_quest/features/writing/domain/repositories/writing_repository.dart';
import 'package:voxai_quest/features/writing/data/repositories/mock_writing_repository.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/speaking_repository.dart';
import 'package:voxai_quest/features/speaking/data/repositories/mock_speaking_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), googleSignIn: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), firebaseAuth: sl()),
  );

  // Blocs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
}
