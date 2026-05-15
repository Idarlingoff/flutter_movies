import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/favorite_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteModel>> getFavorites();
  Future<FavoriteModel> addFavorite({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
  });
  Future<void> removeFavorite({
    required int mediaId,
    required String mediaType,
  });
  Future<bool> isFavorite({
    required int mediaId,
    required String mediaType,
  });
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final SupabaseClient supabaseClient;

  FavoritesRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final response = await supabaseClient
          .from('favorites')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => FavoriteModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  @override
  Future<FavoriteModel> addFavorite({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await supabaseClient.from('favorites').insert({
        'user_id': userId,
        'media_id': mediaId,
        'media_type': mediaType,
        'title': title,
        'poster_path': posterPath,
      }).select().single();

      return FavoriteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await supabaseClient
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  @override
  Future<bool> isFavorite({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      final response = await supabaseClient
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check favorite: $e');
    }
  }
}

