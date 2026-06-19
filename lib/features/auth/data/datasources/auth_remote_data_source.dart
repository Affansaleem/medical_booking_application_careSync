import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/error/exceptions.dart';
import '../../../../features/auth/domain/entities/user_role.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  });

  Future<UserModel> signIn({required String email, required String password});

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<void> resetPassword({required String email});

  Future<void> verifyOtp({
    required String email,
    required String token,
    required supabase.OtpType type,
  });

  Future<void> updatePassword({required String newPassword});

  Future<UserModel> completeOnboarding({
    required Map<String, dynamic> onboardingData,
  });

  Stream<supabase.AuthState> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabase.SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  Future<Map<String, dynamic>?> _getDbProfile(String userId) async {
    try {
      final data = await _supabaseClient
          .schema('caresync')
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> _fetchUserWithProfile(supabase.User authUser) async {
    final dbProfile = await _getDbProfile(authUser.id);
    if (dbProfile != null) {
      return UserModel.fromJson(dbProfile);
    }
    return UserModel.fromSupabase(authUser);
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name, 'role': role.value},
      );
      if (response.user == null) {
        throw const supabase.AuthException(
          'Sign up failed: User response is null',
        );
      }
      return await _fetchUserWithProfile(response.user!);
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const supabase.AuthException(
          'Sign in failed: User response is null',
        );
      }
      return await _fetchUserWithProfile(response.user!);
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;
      return await _fetchUserWithProfile(user);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String token,
    required supabase.OtpType type,
  }) async {
    try {
      await _supabaseClient.auth.verifyOTP(
        email: email,
        token: token,
        type: type,
      );
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _supabaseClient.auth.updateUser(
        supabase.UserAttributes(password: newPassword),
      );
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> completeOnboarding({
    required Map<String, dynamic> onboardingData,
  }) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw const supabase.AuthException('No authenticated user found');
      }

      final avatarFilePath =
          onboardingData.remove('_avatarFilePath') as String?;
      String? uploadedAvatarUrl;

      if (avatarFilePath != null) {
        final file = File(avatarFilePath);
        final ext = avatarFilePath.split('.').last.toLowerCase();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final storagePath = '${user.id}/$timestamp.$ext';
        await _supabaseClient.storage
            .from('caresync-user-avatar')
            .upload(
              storagePath,
              file,
              fileOptions: const supabase.FileOptions(
                cacheControl: '3600',
                upsert: true,
              ),
            );
        uploadedAvatarUrl = _supabaseClient.storage
            .from('caresync-user-avatar')
            .getPublicUrl(storagePath);
      }

      final updatePayload = <String, dynamic>{
        ...onboardingData,
        'is_onboarding_completed': true,
        'onboarding_completed_at': DateTime.now().toUtc().toIso8601String(),
      };
      if (uploadedAvatarUrl != null) {
        updatePayload['avatar_url'] = uploadedAvatarUrl;
      }

      await _supabaseClient
          .schema('caresync')
          .from('profiles')
          .update(updatePayload)
          .eq('id', user.id);

      return await _fetchUserWithProfile(user);
    } on supabase.StorageException catch (e) {
      throw ServerException(message: 'Avatar upload failed: ${e.message}');
    } on supabase.PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } on supabase.AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<supabase.AuthState> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange;
}
