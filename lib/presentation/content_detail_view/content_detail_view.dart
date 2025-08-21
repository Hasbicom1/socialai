import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_insights_panel.dart';
import './widgets/comments_section.dart';
import './widgets/content_caption_section.dart';
import './widgets/content_media_viewer.dart';
import './widgets/platform_action_bar.dart';
import './widgets/platform_source_header.dart';

class ContentDetailView extends StatefulWidget {
  const ContentDetailView({Key? key}) : super(key: key);

  @override
  State<ContentDetailView> createState() => _ContentDetailViewState();
}

class _ContentDetailViewState extends State<ContentDetailView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isLiked = false;
  bool _isSaved = false;
  bool _showComments = false;
  bool _showAIInsights = false;
  int _currentContentIndex = 0;

  // Mock data for the content detail
  final List<Map<String, dynamic>> _contentData = [
    {
      "id": 1,
      "platform": "Instagram",
      "username": "@sarah_travels",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "timestamp": "2 hours ago",
      "mediaType": "image",
      "mediaUrl":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80",
      "aspectRatio": 1.0,
      "caption":
          "Exploring the beautiful sunset at the beach today! The colors were absolutely stunning and reminded me of why I love photography so much. There's something magical about golden hour that makes everything look perfect. Can't wait to share more from this amazing trip! 📸✨ #sunset #beach #photography #travel #goldenhour #nature #wanderlust",
      "hashtags": [
        "#sunset",
        "#beach",
        "#photography",
        "#travel",
        "#goldenhour",
        "#nature",
        "#wanderlust"
      ],
      "location": "Malibu Beach, California",
      "likes": 2847,
      "comments": 156,
      "shares": 89,
      "isVerified": true,
    },
    {
      "id": 2,
      "platform": "TikTok",
      "username": "@dance_moves_pro",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "timestamp": "4 hours ago",
      "mediaType": "video",
      "mediaUrl":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&q=80",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&q=80",
      "aspectRatio": 9 / 16,
      "caption":
          "New dance routine I've been working on! What do you think? 💃🕺 Drop your favorite move in the comments below! #dance #viral #fyp #trending",
      "hashtags": ["#dance", "#viral", "#fyp", "#trending"],
      "location": "Los Angeles, CA",
      "likes": 15420,
      "comments": 892,
      "shares": 1205,
      "isVerified": false,
    },
  ];

  final List<Map<String, dynamic>> _commentsData = [
    {
      "id": 1,
      "username": "alex_photographer",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "text":
          "Absolutely stunning shot! The composition and lighting are perfect. What camera settings did you use for this?",
      "timestamp": "1h",
      "likes": 24,
      "isVerified": true,
      "replies": [
        {
          "id": 11,
          "username": "sarah_travels",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "text":
              "Thank you! I used f/2.8, ISO 100, 1/250s. Golden hour magic! ✨",
          "timestamp": "45m",
          "likes": 12,
        },
        {
          "id": 12,
          "username": "photo_enthusiast",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "text": "Thanks for sharing the settings! Your work is inspiring 📸",
          "timestamp": "30m",
          "likes": 8,
        },
      ],
    },
    {
      "id": 2,
      "username": "beach_lover_99",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "text":
          "This makes me want to visit Malibu right now! 🏖️ Adding it to my travel list",
      "timestamp": "2h",
      "likes": 18,
      "isVerified": false,
      "replies": [],
    },
    {
      "id": 3,
      "username": "sunset_chaser",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "text":
          "The colors in this shot are incredible! Mother nature is the best artist 🎨",
      "timestamp": "3h",
      "likes": 31,
      "isVerified": false,
      "replies": [],
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            _buildMainContent(),
            if (_showComments) _buildCommentsOverlay(),
            if (_showAIInsights) _buildAIInsightsOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final currentContent = _contentData[_currentContentIndex];

    return Column(
      children: [
        PlatformSourceHeader(
          platform: currentContent['platform'] as String,
          username: currentContent['username'] as String,
          timestamp: currentContent['timestamp'] as String,
          onClose: () {
            Navigator.pop(context);
          },
          onShare: _handleShare,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ContentMediaViewer(
                  mediaType: currentContent['mediaType'] as String,
                  mediaUrl: currentContent['mediaUrl'] as String,
                  thumbnailUrl: currentContent['thumbnailUrl'] as String?,
                  aspectRatio:
                      (currentContent['aspectRatio'] as num?)?.toDouble() ??
                          1.0,
                  onFullscreen: _handleFullscreen,
                ),
                ContentCaptionSection(
                  caption: currentContent['caption'] as String,
                  hashtags: (currentContent['hashtags'] as List).cast<String>(),
                  location: currentContent['location'] as String,
                  likes: currentContent['likes'] as int,
                  comments: currentContent['comments'] as int,
                  shares: currentContent['shares'] as int,
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
        PlatformActionBar(
          platform: currentContent['platform'] as String,
          isLiked: _isLiked,
          isSaved: _isSaved,
          onLike: _handleLike,
          onComment: _handleComment,
          onShare: _handleShare,
          onSave: _handleSave,
          onOpenInApp: _handleOpenInApp,
        ),
      ],
    );
  }

  Widget _buildCommentsOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showComments = false;
          });
        },
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping on comments
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.3,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return CommentsSection(
                  platform:
                      _contentData[_currentContentIndex]['platform'] as String,
                  comments: _commentsData,
                  onAddComment: _handleAddComment,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIInsightsOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showAIInsights = false;
          });
        },
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping on panel
              child: AIInsightsPanel(
                sentimentScore: 0.85,
                engagementPrediction: 78,
                trendingTopics: const [
                  '#sunset',
                  '#photography',
                  '#beach',
                  '#goldenhour',
                  '#travel'
                ],
                engagementMetrics: const {
                  'likes': 0.85,
                  'comments': 0.65,
                  'shares': 0.45,
                  'saves': 0.72,
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLike() {
    HapticFeedback.lightImpact();
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _handleComment() {
    HapticFeedback.lightImpact();
    setState(() {
      _showComments = true;
    });
  }

  void _handleShare() {
    HapticFeedback.lightImpact();
    _showShareBottomSheet();
  }

  void _handleSave() {
    HapticFeedback.lightImpact();
    setState(() {
      _isSaved = !_isSaved;
    });
  }

  void _handleOpenInApp() {
    HapticFeedback.mediumImpact();
    final platform = _contentData[_currentContentIndex]['platform'] as String;
    _showOpenInAppDialog(platform);
  }

  void _handleFullscreen() {
    HapticFeedback.lightImpact();
    // Implement fullscreen media viewer
  }

  void _handleAddComment() {
    HapticFeedback.lightImpact();
    // Add comment logic
  }

  void _showShareBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Share Content',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption('copy', 'Copy Link', () {
                    Navigator.pop(context);
                  }),
                  _buildShareOption('message', 'Message', () {
                    Navigator.pop(context);
                  }),
                  _buildShareOption('share', 'More', () {
                    Navigator.pop(context);
                  }),
                ],
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'psychology',
                  color: AppTheme.darkTheme.colorScheme.primary,
                  size: 5.w,
                ),
                title: Text(
                  'View AI Insights',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _showAIInsights = true;
                  });
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption(String iconName, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color:
                  AppTheme.darkTheme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.darkTheme.colorScheme.primary,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showOpenInAppDialog(String platform) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'open_in_new',
                color: AppTheme.darkTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Open in $platform',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'This will open the content in the native $platform app for full interaction capabilities.',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement deep linking to native app
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkTheme.colorScheme.primary,
              ),
              child: Text(
                'Open App',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
