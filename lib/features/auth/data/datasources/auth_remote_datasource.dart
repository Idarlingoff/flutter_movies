import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Stream<UserModel?> get authStateChanges;

  Future<UserModel> updateProfile({
    String? displayName,
    String? avatarUrl,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed');
      }

      return UserModel.fromSupabaseUser(
        response.user!,
        response.user!.userMetadata,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );

      if (response.user == null) {
        throw Exception('Sign up failed');
      }

      return UserModel.fromSupabaseUser(
        response.user!,
        response.user!.userMetadata,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return null;

      return UserModel.fromSupabaseUser(user, user.userMetadata);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return supabaseClient.auth.onAuthStateChange.map((state) {
      final user = state.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user, user.userMetadata);
    });
  }

  @override
  Future<UserModel> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['display_name'] = displayName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await supabaseClient.auth.updateUser(
        UserAttributes(
          data: updates,
        ),
      );

      if (response.user == null) {
        throw Exception('Update profile failed');
      }

      return UserModel.fromSupabaseUser(
        response.user!,
        response.user!.userMetadata,
      );
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}

