import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/watchlist_model.dart';

abstract class WatchlistRemoteDataSource {
  Future<List<WatchlistModel>> getWatchlist();
  Future<WatchlistModel> addToWatchlist({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
    int priority,
    String? notes,
  });
  Future<WatchlistModel> updateWatchlistItem({
    required int mediaId,
    required String mediaType,
    int? priority,
    String? notes,
  });
  Future<void> removeFromWatchlist({
    required int mediaId,
    required String mediaType,
  });
  Future<bool> isInWatchlist({
    required int mediaId,
    required String mediaType,
  });
}

class WatchlistRemoteDataSourceImpl implements WatchlistRemoteDataSource {
  final SupabaseClient supabaseClient;

  WatchlistRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<WatchlistModel>> getWatchlist() async {
    try {
      final response = await supabaseClient
          .from('watchlist')
          .select()
          .order('priority', ascending: false)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => WatchlistModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get watchlist: $e');
    }
  }

  @override
  Future<WatchlistModel> addToWatchlist({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
    int priority = 0,
    String? notes,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await supabaseClient.from('watchlist').insert({
        'user_id': userId,
        'media_id': mediaId,
        'media_type': mediaType,
        'title': title,
        'poster_path': posterPath,
        'priority': priority,
        'notes': notes,
      }).select().single();

      return WatchlistModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add to watchlist: $e');
    }
  }

  @override
  Future<WatchlistModel> updateWatchlistItem({
    required int mediaId,
    required String mediaType,
    int? priority,
    String? notes,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updates = <String, dynamic>{};
      if (priority != null) updates['priority'] = priority;
      if (notes != null) updates['notes'] = notes;

      final response = await supabaseClient
          .from('watchlist')
          .update(updates)
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType)
          .select()
          .single();

      return WatchlistModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update watchlist item: $e');
    }
  }

  @override
  Future<void> removeFromWatchlist({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await supabaseClient
          .from('watchlist')
          .delete()
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType);
    } catch (e) {
      throw Exception('Failed to remove from watchlist: $e');
    }
  }

  @override
  Future<bool> isInWatchlist({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      final response = await supabaseClient
          .from('watchlist')
          .select('id')
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check watchlist: $e');
    }
  }
}

