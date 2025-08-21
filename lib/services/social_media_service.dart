import '../services/supabase_service.dart';

class SocialMediaService {
  static final _client = SupabaseService.instance.client;

  // Get mixed feed posts for user
  static Future<List<Map<String, dynamic>>> getMixedFeed({
    int limit = 20,
    int offset = 0,
    List<String>? platforms,
  }) async {
    try {
      var query = _client.from('social_posts').select('''
            *,
            user_profiles!social_posts_user_id_fkey (
              username,
              display_name,
              avatar_url
            ),
            post_categories (
              content_categories (
                name,
                color_hex
              )
            )
          ''').eq('is_visible', true);

      // Filter by platforms if specified
      if (platforms != null && platforms.isNotEmpty) {
        query = query.inFilter('platform', platforms);
      }

      final response = await query
          .order('posted_at', ascending: false)
          .range(offset, offset + limit - 1);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch mixed feed: $error');
    }
  }

  // Get user's connected platforms
  static Future<List<Map<String, dynamic>>> getUserPlatforms() async {
    try {
      final response = await _client
          .from('platform_connections')
          .select('*')
          .eq('user_id', _client.auth.currentUser!.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch user platforms: $error');
    }
  }

  // Connect a new platform
  static Future<Map<String, dynamic>> connectPlatform({
    required String platform,
    required String platformUsername,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _client
          .from('platform_connections')
          .insert({
            'user_id': _client.auth.currentUser?.id,
            'platform': platform,
            'platform_username': platformUsername,
            'connection_status': 'connected',
            'connection_metadata': metadata ?? {},
            'last_sync_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to connect platform: $error');
    }
  }

  // Disconnect a platform
  static Future<void> disconnectPlatform(String connectionId) async {
    try {
      await _client
          .from('platform_connections')
          .update({'connection_status': 'disconnected'})
          .eq('id', connectionId)
          .eq('user_id', _client.auth.currentUser!.id);
    } catch (error) {
      throw Exception('Failed to disconnect platform: $error');
    }
  }

  // Add user interaction (like, save, share, hide)
  static Future<void> addUserInteraction({
    required String postId,
    required String interactionType,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Remove existing interaction of same type for this post
      await _client
          .from('user_interactions')
          .delete()
          .eq('user_id', _client.auth.currentUser!.id)
          .eq('post_id', postId)
          .eq('interaction_type', interactionType);

      // Add new interaction
      await _client.from('user_interactions').insert({
        'user_id': _client.auth.currentUser?.id,
        'post_id': postId,
        'interaction_type': interactionType,
        'interaction_data': data ?? {},
      });
    } catch (error) {
      throw Exception('Failed to add interaction: $error');
    }
  }

  // Remove user interaction
  static Future<void> removeUserInteraction({
    required String postId,
    required String interactionType,
  }) async {
    try {
      await _client
          .from('user_interactions')
          .delete()
          .eq('user_id', _client.auth.currentUser!.id)
          .eq('post_id', postId)
          .eq('interaction_type', interactionType);
    } catch (error) {
      throw Exception('Failed to remove interaction: $error');
    }
  }

  // Get user's interactions for posts
  static Future<List<Map<String, dynamic>>> getUserInteractions(
      List<String> postIds) async {
    try {
      final response = await _client
          .from('user_interactions')
          .select('*')
          .eq('user_id', _client.auth.currentUser!.id)
          .inFilter('post_id', postIds);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch user interactions: $error');
    }
  }

  // Update feed preferences
  static Future<void> updateFeedPreferences({
    List<String>? preferredPlatforms,
    List<String>? preferredContentTypes,
    bool? showNsfw,
    bool? autoRefresh,
    int? postsPerPage,
    String? sortPreference,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (preferredPlatforms != null)
        updates['preferred_platforms'] = preferredPlatforms;
      if (preferredContentTypes != null)
        updates['preferred_content_types'] = preferredContentTypes;
      if (showNsfw != null) updates['show_nsfw'] = showNsfw;
      if (autoRefresh != null) updates['auto_refresh'] = autoRefresh;
      if (postsPerPage != null) updates['posts_per_page'] = postsPerPage;
      if (sortPreference != null) updates['sort_preference'] = sortPreference;

      await _client
          .from('feed_preferences')
          .update(updates)
          .eq('user_id', _client.auth.currentUser!.id);
    } catch (error) {
      throw Exception('Failed to update feed preferences: $error');
    }
  }

  // Get feed preferences
  static Future<Map<String, dynamic>?> getFeedPreferences() async {
    try {
      final response = await _client
          .from('feed_preferences')
          .select('*')
          .eq('user_id', _client.auth.currentUser!.id)
          .maybeSingle();

      return response;
    } catch (error) {
      throw Exception('Failed to fetch feed preferences: $error');
    }
  }

  // Get content categories
  static Future<List<Map<String, dynamic>>> getContentCategories() async {
    try {
      final response = await _client
          .from('content_categories')
          .select('*')
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch categories: $error');
    }
  }

  // Search posts
  static Future<List<Map<String, dynamic>>> searchPosts({
    required String query,
    List<String>? platforms,
    int limit = 20,
  }) async {
    try {
      var supabaseQuery = _client
          .from('social_posts')
          .select('''
            *,
            user_profiles!social_posts_user_id_fkey (
              username,
              display_name,
              avatar_url
            )
          ''')
          .eq('is_visible', true)
          .or('title.ilike.%$query%,description.ilike.%$query%,content_text.ilike.%$query%');

      if (platforms != null && platforms.isNotEmpty) {
        supabaseQuery = supabaseQuery.inFilter('platform', platforms);
      }

      final response =
          await supabaseQuery.order('posted_at', ascending: false).limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to search posts: $error');
    }
  }
}