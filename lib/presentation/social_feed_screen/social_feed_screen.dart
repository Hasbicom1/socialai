import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/social_media_service.dart';
import '../../services/supabase_service.dart';
import './widgets/connection_status_banner.dart';
import './widgets/platform_filter_chips.dart';
import './widgets/social_feed_app_bar.dart';
import './widgets/social_post_card.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _userInteractions = [];
  Map<String, dynamic>? _feedPreferences;
  List<String> _selectedPlatforms = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentOffset = 0;
  final int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeFeed();
    _scrollController.addListener(_onScroll);
  }

  void _initializeFeed() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load feed preferences
      final preferences = await SocialMediaService.getFeedPreferences();
      setState(() {
        _feedPreferences = preferences;
        _selectedPlatforms =
            preferences?['preferred_platforms']?.cast<String>() ?? [];
      });

      // Load initial posts
      await _loadPosts(refresh: true);
    } catch (error) {
      debugPrint('Feed initialization error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPosts({bool refresh = false}) async {
    if (refresh) {
      _currentOffset = 0;
      _posts.clear();
    }

    try {
      final newPosts = await SocialMediaService.getMixedFeed(
        limit: _pageSize,
        offset: _currentOffset,
        platforms: _selectedPlatforms.isNotEmpty ? _selectedPlatforms : null,
      );

      final postIds = newPosts.map((post) => post['id'] as String).toList();
      final interactions = postIds.isNotEmpty
          ? await SocialMediaService.getUserInteractions(postIds)
          : <Map<String, dynamic>>[];

      setState(() {
        if (refresh) {
          _posts = newPosts;
          _userInteractions = interactions;
        } else {
          _posts.addAll(newPosts);
          _userInteractions.addAll(interactions);
        }
        _currentOffset += newPosts.length;
      });
    } catch (error) {
      debugPrint('Error loading posts: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load posts: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await _loadPosts();

    setState(() {
      _isLoadingMore = false;
    });
  }

  void _onPlatformFilterChanged(List<String> platforms) {
    setState(() {
      _selectedPlatforms = platforms;
    });
    _loadPosts(refresh: true);
  }

  void _onPostInteraction(String postId, String interactionType) async {
    try {
      // Check if interaction already exists
      final existingInteraction = _userInteractions.firstWhere(
        (interaction) =>
            interaction['post_id'] == postId &&
            interaction['interaction_type'] == interactionType,
        orElse: () => {},
      );

      if (existingInteraction.isNotEmpty) {
        // Remove interaction
        await SocialMediaService.removeUserInteraction(
          postId: postId,
          interactionType: interactionType,
        );
        setState(() {
          _userInteractions.removeWhere((interaction) =>
              interaction['post_id'] == postId &&
              interaction['interaction_type'] == interactionType);
        });
      } else {
        // Add interaction
        await SocialMediaService.addUserInteraction(
          postId: postId,
          interactionType: interactionType,
          data: {'timestamp': DateTime.now().toIso8601String()},
        );
        setState(() {
          _userInteractions.add({
            'post_id': postId,
            'interaction_type': interactionType,
            'user_id': SupabaseService.instance.client.auth.currentUser?.id,
          });
        });
      }
    } catch (error) {
      debugPrint('Interaction error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToOriginalPost(String? externalUrl) async {
    if (externalUrl == null || externalUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Original post link not available')),
      );
      return;
    }

    try {
      final uri = Uri.parse(externalUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $externalUrl';
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open link: $error')),
      );
    }
  }

  bool _hasUserInteraction(String postId, String interactionType) {
    return _userInteractions.any((interaction) =>
        interaction['post_id'] == postId &&
        interaction['interaction_type'] == interactionType);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: SocialFeedAppBar(
        onSettingsPressed: () {
          // Navigate to settings
        },
        onSearchPressed: () {
          // Navigate to search
        },
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366f1)),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _loadPosts(refresh: true),
              color: const Color(0xFF6366f1),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Connection Status Banner
                  SliverToBoxAdapter(
                    child: ConnectionStatusBanner(),
                  ),

                  // Platform Filter Chips
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: PlatformFilterChips(
                        selectedPlatforms: _selectedPlatforms,
                        onChanged: _onPlatformFilterChanged,
                      ),
                    ),
                  ),

                  // Posts List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _posts.length) {
                          return _isLoadingMore
                              ? Container(
                                  padding: EdgeInsets.all(4.w),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF6366f1)),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }

                        final post = _posts[index];
                        final isLiked = _hasUserInteraction(post['id'], 'like');
                        final isSaved = _hasUserInteraction(post['id'], 'save');

                        return Padding(
                          padding: EdgeInsets.only(
                            left: 4.w,
                            right: 4.w,
                            bottom: 3.h,
                          ),
                          child: SocialPostCard(
                            post: post,
                            isLiked: isLiked,
                            isSaved: isSaved,
                            onLikePressed: () =>
                                _onPostInteraction(post['id'], 'like'),
                            onSavePressed: () =>
                                _onPostInteraction(post['id'], 'save'),
                            onSharePressed: () =>
                                _onPostInteraction(post['id'], 'share'),
                            onViewOriginalPressed: () =>
                                _navigateToOriginalPost(post['external_url']),
                          ),
                        );
                      },
                      childCount: _posts.length + (_isLoadingMore ? 1 : 0),
                    ),
                  ),

                  // Empty State
                  if (_posts.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.rss_feed,
                              size: 15.w,
                              color: Colors.grey[600],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No posts available',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Connect your social platforms to see posts',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
