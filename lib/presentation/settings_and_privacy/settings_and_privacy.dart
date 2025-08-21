import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import './widgets/connected_platform_widget.dart';
import './widgets/danger_zone_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/toggle_settings_item_widget.dart';

class SettingsAndPrivacy extends StatefulWidget {
  const SettingsAndPrivacy({Key? key}) : super(key: key);

  @override
  State<SettingsAndPrivacy> createState() => _SettingsAndPrivacyState();
}

class _SettingsAndPrivacyState extends State<SettingsAndPrivacy> {
  // Mock user data
  final Map<String, dynamic> userData = {
    "userId": "user_12345",
    "email": "john.doe@example.com",
    "username": "johndoe_ai",
    "fullName": "John Doe",
    "profileImage":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "subscriptionType": "Premium",
    "joinDate": "2024-01-15",
    "lastActive": "2025-08-21T16:03:22.995689Z",
  };

  // Settings state
  bool _incognitoMode = false;
  bool _biometricAuth = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _aiContentCuration = true;
  bool _autoDownloadMedia = false;
  bool _backgroundSync = true;
  bool _hapticFeedback = true;
  String _selectedTheme = 'Dark';
  double _textSize = 1.0;

  // Connected platforms mock data
  final List<Map<String, dynamic>> connectedPlatforms = [
    {
      "name": "Instagram",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/150px-Instagram_icon.png",
      "username": "johndoe_insta",
      "isConnected": true,
    },
    {
      "name": "Twitter",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Logo_of_Twitter.svg/150px-Logo_of_Twitter.svg.png",
      "username": "johndoe_x",
      "isConnected": true,
    },
    {
      "name": "LinkedIn",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/150px-LinkedIn_logo_initials.png",
      "username": "john-doe-professional",
      "isConnected": false,
    },
    {
      "name": "TikTok",
      "icon":
          "https://upload.wikimedia.org/wikipedia/en/thumb/a/a9/TikTok_logo.svg/150px-TikTok_logo.svg.png",
      "username": "johndoe_tiktok",
      "isConnected": true,
    },
    {
      "name": "YouTube",
      "icon":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/150px-YouTube_full-color_icon_%282017%29.svg.png",
      "username": "JohnDoeChannel",
      "isConnected": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildAccountSection(),
            _buildConnectedPlatformsSection(),
            _buildAIPreferencesSection(),
            _buildNotificationSection(),
            _buildPrivacySection(),
            _buildSecuritySection(),
            _buildAppearanceSection(),
            _buildDataUsageSection(),
            _buildSupportSection(),
            _buildDangerZoneSection(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundDeep,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textPrimary,
          size: 6.w,
        ),
      ),
      title: Text(
        'Settings & Privacy',
        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundElevated,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryAIBlue,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomImageWidget(
                imageUrl: userData["profileImage"] as String,
                width: 16.w,
                height: 16.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData["fullName"] as String,
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '@${userData["username"]}',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryAIBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${userData["subscriptionType"]} Member',
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.primaryAIBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'edit',
            color: AppTheme.primaryAIBlue,
            size: 5.w,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return SettingsSectionWidget(
      title: 'ACCOUNT',
      children: [
        SettingsItemWidget(
          title: 'Profile Management',
          subtitle: 'Edit profile, bio, and display preferences',
          iconName: 'person',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'Subscription',
          subtitle: 'Manage your Premium subscription',
          iconName: 'star',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'Account Information',
          subtitle: 'Email, phone number, and verification',
          iconName: 'info',
          onTap: () => _showComingSoonToast(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildConnectedPlatformsSection() {
    return SettingsSectionWidget(
      title: 'CONNECTED PLATFORMS',
      children: connectedPlatforms.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> platform = entry.value;

        return ConnectedPlatformWidget(
          platformName: platform["name"] as String,
          platformIcon: platform["icon"] as String,
          username: platform["username"] as String,
          isConnected: platform["isConnected"] as bool,
          onToggle: () => _togglePlatformConnection(index),
          showDivider: index < connectedPlatforms.length - 1,
        );
      }).toList(),
    );
  }

  Widget _buildAIPreferencesSection() {
    return SettingsSectionWidget(
      title: 'AI PREFERENCES',
      children: [
        ToggleSettingsItemWidget(
          title: 'AI Content Curation',
          subtitle: 'Let AI personalize your feed based on interests',
          iconName: 'auto_awesome',
          value: _aiContentCuration,
          onChanged: (value) => setState(() => _aiContentCuration = value),
        ),
        SettingsItemWidget(
          title: 'Content Sensitivity',
          subtitle: 'Adjust content filtering and safety settings',
          iconName: 'shield',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'Topic Preferences',
          subtitle: 'Choose topics you want to see more of',
          iconName: 'tune',
          onTap: () => _showComingSoonToast(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return SettingsSectionWidget(
      title: 'NOTIFICATIONS',
      children: [
        ToggleSettingsItemWidget(
          title: 'Push Notifications',
          subtitle: 'Receive notifications on your device',
          iconName: 'notifications',
          value: _pushNotifications,
          onChanged: (value) => setState(() => _pushNotifications = value),
        ),
        ToggleSettingsItemWidget(
          title: 'Email Notifications',
          subtitle: 'Receive updates via email',
          iconName: 'email',
          value: _emailNotifications,
          onChanged: (value) => setState(() => _emailNotifications = value),
        ),
        SettingsItemWidget(
          title: 'Notification Preferences',
          subtitle: 'Customize what notifications you receive',
          iconName: 'settings',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'Quiet Hours',
          subtitle: 'Set times when notifications are muted',
          iconName: 'do_not_disturb',
          onTap: () => _showComingSoonToast(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return SettingsSectionWidget(
      title: 'PRIVACY',
      children: [
        ToggleSettingsItemWidget(
          title: 'Incognito Mode',
          subtitle: 'Browse without saving history or data',
          iconName: 'visibility_off',
          value: _incognitoMode,
          onChanged: (value) => setState(() => _incognitoMode = value),
        ),
        SettingsItemWidget(
          title: 'Data & Privacy',
          subtitle: 'Control how your data is used and shared',
          iconName: 'privacy_tip',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'Blocked Users',
          subtitle: 'Manage blocked accounts and content',
          iconName: 'block',
          onTap: () => _showComingSoonToast(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return SettingsSectionWidget(
      title: 'SECURITY',
      children: [
        ToggleSettingsItemWidget(
          title: 'Biometric Authentication',
          subtitle: 'Use Face ID or fingerprint to unlock app',
          iconName: 'fingerprint',
          value: _biometricAuth,
          onChanged: (value) => setState(() => _biometricAuth = value),
        ),
        SettingsItemWidget(
          title: 'Two-Factor Authentication',
          subtitle: 'Add an extra layer of security',
          iconName: 'security',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'Active Sessions',
          subtitle: 'Manage devices signed into your account',
          iconName: 'devices',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'Change Password',
          subtitle: 'Update your account password',
          iconName: 'lock',
          onTap: () => _showComingSoonToast(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return SettingsSectionWidget(
      title: 'APPEARANCE',
      children: [
        SettingsItemWidget(
          title: 'Theme',
          subtitle: 'Currently: $_selectedTheme',
          iconName: 'palette',
          onTap: () => _showThemeSelector(),
        ),
        SettingsItemWidget(
          title: 'Text Size',
          subtitle: 'Adjust text size for better readability',
          iconName: 'text_fields',
          onTap: () => _showTextSizeSelector(),
        ),
        SettingsItemWidget(
          title: 'Accessibility',
          subtitle: 'Screen reader and accessibility options',
          iconName: 'accessibility',
          onTap: () => _showComingSoonToast(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildDataUsageSection() {
    return SettingsSectionWidget(
      title: 'DATA USAGE',
      children: [
        ToggleSettingsItemWidget(
          title: 'Auto-Download Media',
          subtitle: 'Automatically download images and videos',
          iconName: 'download',
          value: _autoDownloadMedia,
          onChanged: (value) => setState(() => _autoDownloadMedia = value),
        ),
        ToggleSettingsItemWidget(
          title: 'Background Sync',
          subtitle: 'Keep content updated in the background',
          iconName: 'sync',
          value: _backgroundSync,
          onChanged: (value) => setState(() => _backgroundSync = value),
        ),
        SettingsItemWidget(
          title: 'Storage Management',
          subtitle: 'Manage cached data and storage usage',
          iconName: 'storage',
          onTap: () => _showComingSoonToast(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return SettingsSectionWidget(
      title: 'SUPPORT',
      children: [
        SettingsItemWidget(
          title: 'Help Center',
          subtitle: 'Get help and find answers to common questions',
          iconName: 'help',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'Contact Support',
          subtitle: 'Get in touch with our support team',
          iconName: 'support_agent',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy and terms',
          iconName: 'policy',
          onTap: () => _showComingSoonToast(),
        ),
        SettingsItemWidget(
          title: 'About SocialAI',
          subtitle: 'Version 1.0.0 (Build 2025.08.21)',
          iconName: 'info_outline',
          onTap: () => _showAboutDialog(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildDangerZoneSection() {
    return DangerZoneWidget(
      onExportData: _exportUserData,
      onDeleteAccount: _showDeleteAccountDialog,
    );
  }

  void _togglePlatformConnection(int index) {
    setState(() {
      connectedPlatforms[index]["isConnected"] =
          !connectedPlatforms[index]["isConnected"];
    });

    String platformName = connectedPlatforms[index]["name"] as String;
    bool isConnected = connectedPlatforms[index]["isConnected"] as bool;

    Fluttertoast.showToast(
      msg: isConnected
          ? '$platformName connected successfully'
          : '$platformName disconnected',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor:
          isConnected ? AppTheme.successGreen : AppTheme.warningAmber,
      textColor: AppTheme.textPrimary,
    );
  }

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Theme',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ...['Dark', 'Light', 'Auto'].map((theme) => ListTile(
                  title: Text(
                    theme,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  leading: Radio<String>(
                    value: theme,
                    groupValue: _selectedTheme,
                    onChanged: (value) {
                      setState(() => _selectedTheme = value!);
                      Navigator.pop(context);
                    },
                  ),
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showTextSizeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Text Size',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Slider(
              value: _textSize,
              min: 0.8,
              max: 1.4,
              divisions: 6,
              label: '${(_textSize * 100).round()}%',
              onChanged: (value) => setState(() => _textSize = value),
            ),
            Text(
              'Sample text at ${(_textSize * 100).round()}% size',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontSize: 14 * _textSize,
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _exportUserData() async {
    try {
      // Create comprehensive user data export
      final exportData = {
        "exportDate": DateTime.now().toIso8601String(),
        "userData": userData,
        "connectedPlatforms": connectedPlatforms,
        "settings": {
          "incognitoMode": _incognitoMode,
          "biometricAuth": _biometricAuth,
          "pushNotifications": _pushNotifications,
          "emailNotifications": _emailNotifications,
          "aiContentCuration": _aiContentCuration,
          "autoDownloadMedia": _autoDownloadMedia,
          "backgroundSync": _backgroundSync,
          "hapticFeedback": _hapticFeedback,
          "selectedTheme": _selectedTheme,
          "textSize": _textSize,
        },
        "metadata": {
          "appVersion": "1.0.0",
          "exportFormat": "JSON",
          "gdprCompliant": true,
        }
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      final fileName =
          'socialai_data_export_${DateTime.now().millisecondsSinceEpoch}.json';

      if (kIsWeb) {
        // Web implementation
        final bytes = utf8.encode(jsonString);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // Mobile implementation
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(jsonString);
      }

      Fluttertoast.showToast(
        msg: 'Data exported successfully',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        textColor: AppTheme.textPrimary,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Export failed. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        textColor: AppTheme.textPrimary,
      );
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundElevated,
        title: Text(
          'Delete Account',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.errorRed,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Type "DELETE" to confirm:',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Type DELETE here',
                hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              onChanged: (value) {
                // Handle confirmation text
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Account deletion cancelled',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppTheme.warningAmber,
                textColor: AppTheme.textPrimary,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: Text(
              'Delete',
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundElevated,
        title: Text(
          'About SocialAI',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SocialAI - AI-Powered Social Media Aggregation',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Version: 1.0.0',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Build: 2025.08.21',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Consolidate all your social media platforms into one intelligent app with AI-powered content curation.',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.primaryAIBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonToast() {
    Fluttertoast.showToast(
      msg: 'Coming soon in future updates',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.primaryAIBlue,
      textColor: AppTheme.textPrimary,
    );
  }
}
