import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get user;
  Future<UserEntity> signUp({required String email, required String password});
  Future<UserEntity> logInWithEmail({
    required String email,
    required String password,
  });
  Future<void> logInWithGoogle();
  Future<void> logOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
}
