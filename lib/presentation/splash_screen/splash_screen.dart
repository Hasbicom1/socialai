import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_loading_indicator_widget.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/glassmorphism_background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _loadingProgress = 0.0;
  String _loadingText = 'Initializing AI Services...';
  bool _isLogoAnimationComplete = false;
  bool _hasNetworkConnection = true;
  bool _showRetryOption = false;

  // Mock initialization steps
  final List<Map<String, dynamic>> _initializationSteps = [
    {'text': 'Initializing AI Services...', 'duration': 800},
    {'text': 'Checking OAuth Tokens...', 'duration': 600},
    {'text': 'Loading User Preferences...', 'duration': 500},
    {'text': 'Preparing Social Feeds...', 'duration': 700},
    {'text': 'Finalizing Setup...', 'duration': 400},
  ];

  @override
  void initState() {
    super.initState();
    _hideStatusBar();
    _checkConnectivityAndInitialize();
  }

  void _hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  void _restoreStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  Future<void> _checkConnectivityAndInitialize() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      _hasNetworkConnection = connectivityResult != ConnectivityResult.none;

      if (_hasNetworkConnection) {
        await _performInitialization();
      } else {
        _showNetworkError();
      }
    } catch (e) {
      _showNetworkError();
    }
  }

  void _showNetworkError() {
    setState(() {
      _loadingText = 'No internet connection';
      _showRetryOption = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showRetryOption) {
        _showRetryDialog();
      }
    });
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Connection Error',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          content: Text(
            'Unable to connect to SocialAI services. Please check your internet connection and try again.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryInitialization();
              },
              child: Text(
                'Retry',
                style: TextStyle(color: AppTheme.primaryAIBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _retryInitialization() {
    setState(() {
      _loadingProgress = 0.0;
      _loadingText = 'Retrying connection...';
      _showRetryOption = false;
    });
    _checkConnectivityAndInitialize();
  }

  Future<void> _performInitialization() async {
    for (int i = 0; i < _initializationSteps.length; i++) {
      if (!mounted) return;

      final step = _initializationSteps[i];
      setState(() {
        _loadingText = step['text'] as String;
        _loadingProgress = (i + 1) / _initializationSteps.length;
      });

      await Future.delayed(Duration(milliseconds: step['duration'] as int));
    }

    if (mounted) {
      await _checkAuthenticationAndNavigate();
    }
  }

  Future<void> _checkAuthenticationAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
      final hasValidTokens = prefs.getBool('has_valid_oauth_tokens') ?? false;
      final isAuthenticated = prefs.getBool('is_authenticated') ?? false;

      // Add haptic feedback for successful initialization
      HapticFeedback.lightImpact();

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        _restoreStatusBar();

        // Navigation logic based on app state
        if (isFirstLaunch) {
          Navigator.pushReplacementNamed(context, '/onboarding-flow');
        } else if (!hasValidTokens || !isAuthenticated) {
          Navigator.pushReplacementNamed(context, '/platform-connection-setup');
        } else {
          // Navigate to main app (using settings as placeholder for main feed)
          Navigator.pushReplacementNamed(context, '/settings-and-privacy');
        }
      }
    } catch (e) {
      if (mounted) {
        _restoreStatusBar();
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      }
    }
  }

  void _onLogoAnimationComplete() {
    setState(() {
      _isLogoAnimationComplete = true;
    });
  }

  @override
  void dispose() {
    _restoreStatusBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      body: GlassmorphismBackgroundWidget(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer to push content to center
                const Spacer(flex: 2),

                // Animated Logo
                AnimatedLogoWidget(
                  onAnimationComplete: _onLogoAnimationComplete,
                ),

                SizedBox(height: 8.h),

                // AI Loading Indicator
                AnimatedOpacity(
                  opacity: _isLogoAnimationComplete ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: AILoadingIndicatorWidget(
                    loadingText: _loadingText,
                    progress: _loadingProgress,
                  ),
                ),

                // Retry button (shown only on network error)
                if (_showRetryOption && _isLogoAnimationComplete)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: ElevatedButton.icon(
                      onPressed: _retryInitialization,
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.textPrimary,
                        size: 4.w,
                      ),
                      label: Text(
                        'Retry Connection',
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryAIBlue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 1.5.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                // Spacer to maintain center alignment
                const Spacer(flex: 3),

                // Bottom branding
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Column(
                    children: [
                      Text(
                        'Powered by Advanced AI',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary.withValues(alpha: 0.7),
                          fontSize: 9.sp,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 1.w,
                            height: 1.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  AppTheme.primaryAIBlue.withValues(alpha: 0.6),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Unified Social Experience',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color:
                                  AppTheme.textSecondary.withValues(alpha: 0.7),
                              fontSize: 9.sp,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            width: 1.w,
                            height: 1.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  AppTheme.primaryAIBlue.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
