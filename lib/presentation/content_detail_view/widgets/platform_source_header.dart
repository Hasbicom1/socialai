import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PlatformSourceHeader extends StatelessWidget {
  final String platform;
  final String username;
  final String timestamp;
  final VoidCallback onClose;
  final VoidCallback onShare;

  const PlatformSourceHeader({
    Key? key,
    required this.platform,
    required this.username,
    required this.timestamp,
    required this.onClose,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color:
            AppTheme.darkTheme.scaffoldBackgroundColor.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.darkTheme.colorScheme.outline,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.colorScheme.surface
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            _buildPlatformIcon(),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    username,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text(
                        platform,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: _getPlatformColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' • $timestamp',
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onShare,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.colorScheme.surface
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                  size: 5.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformIcon() {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: _getPlatformColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomIconWidget(
        iconName: _getPlatformIconName(),
        color: _getPlatformColor(),
        size: 5.w,
      ),
    );
  }

  String _getPlatformIconName() {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return 'camera_alt';
      case 'tiktok':
        return 'video_library';
      case 'twitter':
        return 'alternate_email';
      case 'linkedin':
        return 'business';
      case 'youtube':
        return 'play_circle_filled';
      case 'whatsapp':
        return 'chat';
      default:
        return 'public';
    }
  }

  Color _getPlatformColor() {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0077B5);
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'whatsapp':
        return const Color(0xFF25D366);
      default:
        return AppTheme.darkTheme.colorScheme.primary;
    }
  }
}
