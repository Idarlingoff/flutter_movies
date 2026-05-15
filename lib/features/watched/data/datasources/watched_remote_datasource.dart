import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/watched_model.dart';

abstract class WatchedRemoteDataSource {
  Future<List<WatchedModel>> getWatched();
  Future<WatchedModel> addToWatched({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
  });
  Future<void> removeFromWatched({
    required int mediaId,
    required String mediaType,
  });
  Future<bool> isWatched({
    required int mediaId,
    required String mediaType,
  });
}

class WatchedRemoteDataSourceImpl implements WatchedRemoteDataSource {
  final SupabaseClient supabaseClient;

  WatchedRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<WatchedModel>> getWatched() async {
    try {
      final response = await supabaseClient
          .from('watched')
          .select()
          .order('watched_at', ascending: false);

      return (response as List)
          .map((json) => WatchedModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get watched list: $e');
    }
  }

  @override
  Future<WatchedModel> addToWatched({
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

      final response = await supabaseClient.from('watched').insert({
        'user_id': userId,
        'media_id': mediaId,
        'media_type': mediaType,
        'title': title,
        'poster_path': posterPath,
      }).select().single();

      return WatchedModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add to watched: $e');
    }
  }

  @override
  Future<void> removeFromWatched({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await supabaseClient
          .from('watched')
          .delete()
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType);
    } catch (e) {
      throw Exception('Failed to remove from watched: $e');
    }
  }

  @override
  Future<bool> isWatched({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      final response = await supabaseClient
          .from('watched')
          .select('id')
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check watched: $e');
    }
  }
}

