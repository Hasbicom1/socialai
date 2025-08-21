import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectedPlatformWidget extends StatelessWidget {
  final String platformName;
  final String platformIcon;
  final String username;
  final bool isConnected;
  final VoidCallback onToggle;
  final bool showDivider;

  const ConnectedPlatformWidget({
    Key? key,
    required this.platformName,
    required this.platformIcon,
    required this.username,
    required this.isConnected,
    required this.onToggle,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: platformIcon,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platformName,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isConnected ? '@$username' : 'Not connected',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: isConnected
                            ? AppTheme.successGreen
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isConnected
                        ? AppTheme.errorRed.withValues(alpha: 0.1)
                        : AppTheme.primaryAIBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isConnected
                          ? AppTheme.errorRed
                          : AppTheme.primaryAIBlue,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isConnected ? 'Disconnect' : 'Connect',
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: isConnected
                          ? AppTheme.errorRed
                          : AppTheme.primaryAIBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(
            margin: EdgeInsets.only(left: 19.w),
            height: 1,
            color: AppTheme.borderSubtle,
          ),
      ],
    );
  }
}
