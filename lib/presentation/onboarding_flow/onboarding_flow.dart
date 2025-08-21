import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/gesture_demo_widget.dart';
import './widgets/onboarding_button_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Welcome to SocialAI",
      "description":
          "Your intelligent social media companion that brings all your platforms together in one beautiful, AI-powered experience.",
      "imageUrl":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "gestures": [],
    },
    {
      "title": "AI-Powered Feed Curation",
      "description":
          "Our advanced AI learns your preferences and curates personalized content from Instagram, TikTok, Twitter, LinkedIn, and more.",
      "imageUrl":
          "https://images.pexels.com/photos/8386440/pexels-photo-8386440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "gestures": [
        {
          "type": "Swipe to Refresh",
          "description": "Pull down to refresh your personalized feed"
        },
        {
          "type": "AI Assistant",
          "description": "Tap the AI button for smart recommendations"
        },
      ],
    },
    {
      "title": "Unified Messaging Hub",
      "description":
          "Access all your conversations from WhatsApp, Instagram DMs, Twitter messages, and LinkedIn in one intelligent inbox.",
      "imageUrl":
          "https://images.pixabay.com/photo/2020/05/18/16/17/social-media-5187243_1280.png",
      "gestures": [
        {
          "type": "Long Press Menu",
          "description": "Long press messages for quick actions"
        },
        {
          "type": "Quick Actions",
          "description": "Swipe left for instant reply options"
        },
      ],
    },
    {
      "title": "Cross-Platform Magic",
      "description":
          "Post to multiple platforms simultaneously, get AI-generated captions, and track engagement across all your social accounts.",
      "imageUrl":
          "https://images.unsplash.com/photo-1611162617474-5b21e879e113?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "gestures": [],
      "isLastPage": true,
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
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/platform-connection-setup');
  }

  void _getStarted() async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    // Simulate brief loading for smooth transition
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/platform-connection-setup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.backgroundDeep,
                    AppTheme.backgroundElevated.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                // Skip button
                SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _skipOnboarding,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundElevated
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.borderSubtle
                                    .withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: AppTheme.darkTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        // Page indicator
                        PageIndicatorWidget(
                          currentPage: _currentPage,
                          totalPages: _onboardingData.length,
                        ),

                        // Placeholder for symmetry
                        SizedBox(width: 16.w),
                      ],
                    ),
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      HapticFeedback.selectionClick();
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final pageData = _onboardingData[index];
                      return Column(
                        children: [
                          // Main onboarding page
                          Expanded(
                            child: OnboardingPageWidget(
                              title: pageData["title"] as String,
                              description: pageData["description"] as String,
                              imageUrl: pageData["imageUrl"] as String,
                              isLastPage: pageData["isLastPage"] == true,
                            ),
                          ),

                          // Gesture demos (if available)
                          if ((pageData["gestures"] as List).isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Try These Gestures:',
                                    style: AppTheme
                                        .darkTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  ...(pageData["gestures"] as List).map(
                                    (gesture) => GestureDemoWidget(
                                      gestureType: gesture["type"] as String,
                                      description:
                                          gesture["description"] as String,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ],
                      );
                    },
                  ),
                ),

                // Bottom navigation
                SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    child: Row(
                      children: [
                        // Previous button (only show if not first page)
                        _currentPage > 0
                            ? Expanded(
                                child: OnboardingButtonWidget(
                                  text: 'Previous',
                                  onPressed: _previousPage,
                                  isPrimary: false,
                                ),
                              )
                            : const Spacer(),

                        if (_currentPage > 0) SizedBox(width: 4.w),

                        // Next/Get Started button
                        Expanded(
                          flex: _currentPage == 0 ? 1 : 1,
                          child: OnboardingButtonWidget(
                            text: _currentPage == _onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                            onPressed: _nextPage,
                            isPrimary: true,
                            isLoading: _isLoading &&
                                _currentPage == _onboardingData.length - 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Swipe gesture indicators
            if (_currentPage < _onboardingData.length - 1)
              Positioned(
                right: 4.w,
                top: 50.h,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundElevated.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.borderSubtle.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'swipe_left',
                    color: AppTheme.textSecondary,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
