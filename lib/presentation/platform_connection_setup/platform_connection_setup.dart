import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/connection_progress_widget.dart';
import './widgets/oauth_loading_widget.dart';
import './widgets/platform_card_widget.dart';
import './widgets/platform_options_sheet.dart';

class PlatformConnectionSetup extends StatefulWidget {
  const PlatformConnectionSetup({Key? key}) : super(key: key);

  @override
  State<PlatformConnectionSetup> createState() =>
      _PlatformConnectionSetupState();
}

class _PlatformConnectionSetupState extends State<PlatformConnectionSetup>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = false;
  String _loadingPlatform = '';
  Map<String, dynamic>? _loadingPlatformData;
  Set<String> _connectedPlatforms = {};

  final List<Map<String, dynamic>> _platforms = [
    {
      "id": "instagram",
      "name": "Instagram",
      "description": "Photos, Stories, Reels, and IGTV content from your feed",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/2048px-Instagram_icon.png",
      "brandColor": 0xFFE4405F,
      "contentTypes": ["Photos", "Stories", "Reels", "IGTV", "Shopping"],
      "isPopular": true,
    },
    {
      "id": "tiktok",
      "name": "TikTok",
      "description": "Short-form videos, trending sounds, and viral content",
      "logo":
          "https://sf16-website-login.neutral.ttwstatic.com/obj/tiktok_web_login_static/tiktok/webapp/main/webapp-desktop/8152caf0c8e8bc67ae0d.png",
      "brandColor": 0xFF000000,
      "contentTypes": ["Videos", "Sounds", "Effects", "Live Streams"],
      "isPopular": true,
    },
    {
      "id": "twitter",
      "name": "Twitter",
      "description": "Tweets, threads, spaces, and real-time conversations",
      "logo":
          "https://abs.twimg.com/responsive-web/client-web/icon-ios.b1fc7275.png",
      "brandColor": 0xFF1DA1F2,
      "contentTypes": ["Tweets", "Threads", "Spaces", "Fleets"],
      "isPopular": true,
    },
    {
      "id": "linkedin",
      "name": "LinkedIn",
      "description": "Professional updates, articles, and networking content",
      "logo":
          "https://content.linkedin.com/content/dam/me/business/en-us/amp/brand-site/v2/bg/LI-Bug.svg.original.svg",
      "brandColor": 0xFF0077B5,
      "contentTypes": ["Posts", "Articles", "Jobs", "Events"],
      "isPopular": false,
    },
    {
      "id": "youtube",
      "name": "YouTube",
      "description": "Videos, Shorts, live streams, and subscriptions",
      "logo":
          "https://www.youtube.com/s/desktop/f506bd45/img/favicon_32x32.png",
      "brandColor": 0xFFFF0000,
      "contentTypes": ["Videos", "Shorts", "Live Streams", "Playlists"],
      "isPopular": true,
    },
    {
      "id": "whatsapp",
      "name": "WhatsApp",
      "description": "Messages, status updates, and group conversations",
      "logo": "https://static.whatsapp.net/rsrc.php/v3/yz/r/ujTY9i_Jhs1.png",
      "brandColor": 0xFF25D366,
      "contentTypes": ["Messages", "Status", "Groups", "Calls"],
      "isPopular": false,
    },
    {
      "id": "news",
      "name": "News Sources",
      "description": "Breaking news, articles, and trending stories",
      "logo": "https://cdn-icons-png.flaticon.com/512/3208/3208799.png",
      "brandColor": 0xFF6366F1,
      "contentTypes": ["Articles", "Breaking News", "Trending", "Local"],
      "isPopular": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _connectPlatform(Map<String, dynamic> platform) async {
    setState(() {
      _isLoading = true;
      _loadingPlatform = platform['name'] as String;
      _loadingPlatformData = platform;
    });

    // Simulate OAuth flow
    await Future.delayed(const Duration(seconds: 3));

    // Mock successful connection
    if (mounted) {
      setState(() {
        _connectedPlatforms.add(platform['id'] as String);
        _isLoading = false;
        _loadingPlatform = '';
        _loadingPlatformData = null;
      });

      // Haptic feedback for successful connection
      HapticFeedback.lightImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully connected to ${platform['name']}!'),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _cancelConnection() {
    setState(() {
      _isLoading = false;
      _loadingPlatform = '';
      _loadingPlatformData = null;
    });
  }

  void _showPlatformOptions(Map<String, dynamic> platform) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlatformOptionsSheet(
        platform: platform,
        onSaveSettings: (settings) {
          // Handle settings save
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Settings saved for ${platform['name']}'),
              backgroundColor: AppTheme.primaryAIBlue,
            ),
          );
        },
      ),
    );
  }

  void _managePlatform(Map<String, dynamic> platform) {
    _showPlatformOptions(platform);
  }

  void _skipSetup() {
    Navigator.pushReplacementNamed(context, '/ai-assistant-panel');
  }

  void _continueSetup() {
    if (_connectedPlatforms.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/ai-assistant-panel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomIconWidget(
                              iconName: 'arrow_back',
                              color: AppTheme.textPrimary,
                              size: 6.w,
                            ),
                            TextButton(
                              onPressed: _skipSetup,
                              child: Text(
                                'Skip for Now',
                                style: AppTheme.darkTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Connect Your Platforms',
                          style: AppTheme.darkTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Link your social media accounts to create your personalized AI-powered feed. You can always add more platforms later.',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress Indicator
                  ConnectionProgressWidget(
                    connectedCount: _connectedPlatforms.length,
                    totalPlatforms: _platforms.length,
                  ),

                  // Platform List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 1.h, bottom: 12.h),
                      itemCount: _platforms.length,
                      itemBuilder: (context, index) {
                        final platform = _platforms[index];
                        final isConnected =
                            _connectedPlatforms.contains(platform['id']);

                        return PlatformCardWidget(
                          platform: platform,
                          isConnected: isConnected,
                          onTap: () => isConnected
                              ? _managePlatform(platform)
                              : _connectPlatform(platform),
                          onLongPress: () => _showPlatformOptions(platform),
                          onToggle: () => isConnected
                              ? _managePlatform(platform)
                              : _connectPlatform(platform),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundElevated,
                border: Border(
                  top: BorderSide(color: AppTheme.borderSubtle, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_connectedPlatforms.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.successGreen.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.successGreen,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                _connectedPlatforms.length == 1
                                    ? '1 platform connected - Ready to continue!'
                                    : '${_connectedPlatforms.length} platforms connected - Great job!',
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.successGreen,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: _connectedPlatforms.isNotEmpty
                            ? _continueSetup
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _connectedPlatforms.isNotEmpty
                              ? AppTheme.primaryAIBlue
                              : AppTheme.borderSubtle,
                          foregroundColor: _connectedPlatforms.isNotEmpty
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _connectedPlatforms.isEmpty
                              ? 'Connect at least one platform to continue'
                              : 'Continue to SocialAI',
                          style:
                              AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundElevated,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12.w,
                                  height: 0.5.h,
                                  decoration: BoxDecoration(
                                    color: AppTheme.borderSubtle,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                CustomIconWidget(
                                  iconName: 'security',
                                  color: AppTheme.primaryAIBlue,
                                  size: 12.w,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Advanced Settings',
                                  style: AppTheme
                                      .darkTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Configure granular permissions, data usage preferences, and privacy settings for each connected platform.',
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 3.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, '/settings-and-privacy');
                                    },
                                    child: Text('Open Advanced Settings'),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Maybe Later'),
                                ),
                                SizedBox(height: 2.h),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Advanced Settings',
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // OAuth Loading Overlay
          if (_isLoading && _loadingPlatformData != null)
            OAuthLoadingWidget(
              platformName: _loadingPlatformData!['name'] as String,
              platformLogo: _loadingPlatformData!['logo'] as String,
              brandColor: _loadingPlatformData!['brandColor'] as int,
              onCancel: _cancelConnection,
            ),
        ],
      ),
    );
  }
}
