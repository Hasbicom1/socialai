import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlatformOptionsSheet extends StatefulWidget {
  final Map<String, dynamic> platform;
  final Function(Map<String, dynamic>) onSaveSettings;

  const PlatformOptionsSheet({
    Key? key,
    required this.platform,
    required this.onSaveSettings,
  }) : super(key: key);

  @override
  State<PlatformOptionsSheet> createState() => _PlatformOptionsSheetState();
}

class _PlatformOptionsSheetState extends State<PlatformOptionsSheet> {
  late Map<String, bool> contentTypeSettings;
  late Map<String, bool> permissionSettings;
  late Map<String, bool> notificationSettings;

  @override
  void initState() {
    super.initState();
    contentTypeSettings = Map.fromIterable(
      widget.platform['contentTypes'] as List<String>,
      key: (item) => item as String,
      value: (item) => true,
    );

    permissionSettings = {
      'Read Posts': true,
      'Post Content': false,
      'Access Profile': true,
      'Manage Comments': false,
    };

    notificationSettings = {
      'New Posts': true,
      'Mentions': true,
      'Direct Messages': false,
      'Live Streams': false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.backgroundElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: Color(widget.platform['brandColor'] as int),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomImageWidget(
                      imageUrl: widget.platform['logo'] as String,
                      width: 8.w,
                      height: 8.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.platform['name']} Settings',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Customize your connection preferences',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: AppTheme.borderSubtle, height: 1),

          // Settings Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content Types Section
                  _buildSettingsSection(
                    'Content Types',
                    'Select which types of content to sync',
                    contentTypeSettings,
                    (key, value) =>
                        setState(() => contentTypeSettings[key] = value),
                  ),

                  SizedBox(height: 3.h),

                  // Permissions Section
                  _buildSettingsSection(
                    'Permissions',
                    'Control what SocialAI can do with your account',
                    permissionSettings,
                    (key, value) =>
                        setState(() => permissionSettings[key] = value),
                  ),

                  SizedBox(height: 3.h),

                  // Notifications Section
                  _buildSettingsSection(
                    'Notifications',
                    'Choose which notifications to receive',
                    notificationSettings,
                    (key, value) =>
                        setState(() => notificationSettings[key] = value),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Bottom Actions
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: AppTheme.borderSubtle, width: 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final settings = {
                        'contentTypes': contentTypeSettings,
                        'permissions': permissionSettings,
                        'notifications': notificationSettings,
                      };
                      widget.onSaveSettings(settings);
                      Navigator.pop(context);
                    },
                    child: Text('Save Settings'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    String title,
    String description,
    Map<String, bool> settings,
    Function(String, bool) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          description,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 2.h),
        ...settings.entries.map((entry) {
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                ),
                Switch(
                  value: entry.value,
                  onChanged: (value) => onChanged(entry.key, value),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
