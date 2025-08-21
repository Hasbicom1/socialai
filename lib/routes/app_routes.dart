import 'package:flutter/material.dart';

import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/platform_connection_setup/platform_connection_setup.dart';
import '../presentation/social_feed_screen/social_feed_screen.dart';
import '../presentation/platform_management_screen/platform_management_screen.dart';
import '../presentation/content_detail_view/content_detail_view.dart';
import '../presentation/ai_assistant_panel/ai_assistant_panel.dart';
import '../presentation/settings_and_privacy/settings_and_privacy.dart';
import '../presentation/zw_dashboard/zw_dashboard_screen.dart';

class AppRoutes {
  static const String initial = splash;
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String platformSetup = '/platform-setup';
  static const String socialFeed = '/social-feed';
  static const String platformManagement = '/platform-management';
  static const String contentDetail = '/content-detail';
  static const String aiAssistant = '/ai-assistant';
  static const String settings = '/settings';
  static const String zwDashboard = '/zw-dashboard';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingFlow(),
        platformSetup: (context) => const PlatformConnectionSetup(),
        socialFeed: (context) => const SocialFeedScreen(),
        platformManagement: (context) => const PlatformManagementScreen(),
        contentDetail: (context) => const ContentDetailView(),
        aiAssistant: (context) => const AiAssistantPanel(),
        settings: (context) => const SettingsAndPrivacy(),
        zwDashboard: (context) => const ZWDashboardScreen(),
      };
}
