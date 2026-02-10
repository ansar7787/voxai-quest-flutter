import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/core/utils/seeding_service.dart';
import 'package:voxai_quest/core/utils/sound_service.dart';
import 'package:voxai_quest/core/utils/haptic_service.dart';
import 'package:voxai_quest/core/utils/local_smart_tutor.dart';
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/utils/payment_service.dart';
import 'package:voxai_quest/core/utils/speech_service.dart';
import 'package:voxai_quest/core/theme/theme_cubit.dart';
import 'package:voxai_quest/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:voxai_quest/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/features/reading/domain/repositories/reading_repository.dart';
import 'package:voxai_quest/features/reading/data/repositories/reading_repository_impl.dart';
import 'package:voxai_quest/features/reading/data/datasources/reading_remote_data_source.dart';
import 'package:voxai_quest/features/reading/domain/usecases/get_reading_quest.dart';

import 'package:voxai_quest/features/writing/domain/repositories/writing_repository.dart';
import 'package:voxai_quest/features/writing/data/repositories/writing_repository_impl.dart';
import 'package:voxai_quest/features/writing/data/datasources/writing_remote_data_source.dart';
import 'package:voxai_quest/features/writing/domain/usecases/get_writing_quest.dart';

import 'package:voxai_quest/features/speaking/domain/repositories/speaking_repository.dart';
import 'package:voxai_quest/features/speaking/data/repositories/speaking_repository_impl.dart';
import 'package:voxai_quest/features/speaking/data/datasources/speaking_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/domain/usecases/get_speaking_quest.dart';

import 'package:voxai_quest/features/grammar/domain/repositories/grammar_repository.dart';
import 'package:voxai_quest/features/grammar/data/repositories/grammar_repository_impl.dart';
import 'package:voxai_quest/features/grammar/data/datasources/grammar_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/domain/usecases/get_grammar_quest.dart';

import 'package:voxai_quest/features/auth/domain/usecases/sign_up.dart';
import 'package:voxai_quest/features/auth/domain/usecases/log_in_with_email.dart';
import 'package:voxai_quest/features/auth/domain/usecases/log_in_with_google.dart';
import 'package:voxai_quest/features/auth/domain/usecases/log_out.dart';
import 'package:voxai_quest/features/auth/domain/usecases/get_user_stream.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_user_coins.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_category_stats.dart';
import 'package:voxai_quest/features/game/domain/usecases/get_smart_category.dart';
import 'package:voxai_quest/features/auth/domain/usecases/award_badge.dart'; // New
import 'package:voxai_quest/features/auth/domain/usecases/forgot_password.dart';
import 'package:voxai_quest/features/auth/domain/usecases/send_email_verification.dart';
import 'package:voxai_quest/features/auth/domain/usecases/reload_user.dart';
import 'package:voxai_quest/features/auth/domain/usecases/get_current_user.dart';

import 'package:voxai_quest/features/leaderboard/domain/repositories/leaderboard_repository.dart';
import 'package:voxai_quest/features/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:voxai_quest/features/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/login_cubit.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/signup_cubit.dart';
import 'package:voxai_quest/features/game/presentation/bloc/game_bloc.dart';

// Conversation & Pronunciation
import 'package:voxai_quest/features/speaking/domain/repositories/conversation_repository.dart';
import 'package:voxai_quest/features/speaking/data/repositories/conversation_repository_impl.dart';
import 'package:voxai_quest/features/speaking/data/datasources/conversation_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/domain/usecases/get_conversation_quest.dart';

import 'package:voxai_quest/features/speaking/domain/repositories/pronunciation_repository.dart';
import 'package:voxai_quest/features/speaking/data/repositories/pronunciation_repository_impl.dart';
import 'package:voxai_quest/features/speaking/data/datasources/pronunciation_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/domain/usecases/get_pronunciation_quest.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => InternetConnection());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<SeedingService>(() => SeedingService(sl()));
  sl.registerLazySingleton(() => SoundService());
  sl.registerLazySingleton(() => HapticService());
  sl.registerLazySingleton(() => LocalSmartTutor());
  sl.registerLazySingleton(() => AdService());
  sl.registerLazySingleton(
    () => PaymentService(authRepository: sl(), firestore: sl()),
  );
  sl.registerLazySingleton(() => SpeechService());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), googleSignIn: sl()),
  );
  sl.registerLazySingleton<ReadingRemoteDataSource>(
    () => ReadingRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<WritingRemoteDataSource>(
    () => WritingRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SpeakingRemoteDataSource>(
    () => SpeakingRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<GrammarRemoteDataSource>(
    () => GrammarRemoteDataSourceImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetReadingQuest(sl()));
  sl.registerLazySingleton(() => GetWritingQuest(sl()));
  sl.registerLazySingleton(() => GetSpeakingQuest(sl()));
  sl.registerLazySingleton(() => GetGrammarQuest(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => LogInWithEmail(sl()));
  sl.registerLazySingleton(() => LogInWithGoogle(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => LogOut(sl()));
  sl.registerLazySingleton(() => GetUserStream(sl()));
  sl.registerLazySingleton(() => UpdateUserCoins(sl()));
  sl.registerLazySingleton(() => UpdateCategoryStats(sl()));
  sl.registerLazySingleton(() => AwardBadge(sl())); // New
  sl.registerLazySingleton(() => SendEmailVerification(sl())); // New
  sl.registerLazySingleton(() => ReloadUser(sl())); // New
  sl.registerLazySingleton(() => GetCurrentUser(sl())); // New
  sl.registerLazySingleton(
    () => GetSmartCategory(authRepository: sl(), smartTutor: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), firebaseAuth: sl()),
  );
  sl.registerLazySingleton<ReadingRepository>(
    () => ReadingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<WritingRepository>(
    () => WritingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SpeakingRepository>(
    () => SpeakingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GrammarRepository>(
    () => GrammarRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LeaderboardRepository>(
    () => LeaderboardRepositoryImpl(sl()),
  );

  // Blocs
  sl.registerLazySingleton(
    () => AuthBloc(
      getUserStream: sl(),
      logOut: sl(),
      reloadUser: sl(),
      getCurrentUser: sl(),
    ),
  );
  sl.registerFactory(
    () => LoginCubit(
      logInWithEmail: sl(),
      logInWithGoogle: sl(),
      forgotPassword: sl(),
    ),
  );
  sl.registerFactory(
    () => SignUpCubit(signUp: sl(), sendEmailVerification: sl()),
  );
  sl.registerFactory(
    () => GameBloc(
      getReadingQuest: sl(),
      getWritingQuest: sl(),
      getSpeakingQuest: sl(),
      getGrammarQuest: sl(),
      updateUserCoins: sl(),
      updateCategoryStats: sl(), // New
      getSmartCategory: sl(), // New
      awardBadge: sl(), // New
      soundService: sl(),
      hapticService: sl(),
      getConversationQuest: sl(),
      getPronunciationQuest: sl(),
    ),
  );
  sl.registerFactory(() => LeaderboardBloc(repository: sl()));
  sl.registerFactory(() => ThemeCubit());

  // Conversation & Pronunciation
  sl.registerLazySingleton<ConversationRemoteDataSource>(
    () => ConversationRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetConversationQuest(sl()));

  sl.registerLazySingleton<PronunciationRemoteDataSource>(
    () => PronunciationRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<PronunciationRepository>(
    () =>
        PronunciationRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetPronunciationQuest(sl()));
}
