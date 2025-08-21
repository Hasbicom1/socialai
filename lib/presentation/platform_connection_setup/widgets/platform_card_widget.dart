import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlatformCardWidget extends StatelessWidget {
  final Map<String, dynamic> platform;
  final bool isConnected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onToggle;

  const PlatformCardWidget({
    Key? key,
    required this.platform,
    required this.isConnected,
    required this.onTap,
    this.onLongPress,
    this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.darkTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isConnected
                    ? AppTheme.successGreen.withValues(alpha: 0.3)
                    : AppTheme.borderSubtle,
                width: isConnected ? 2 : 1,
              ),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                // Platform Logo
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: Color(platform['brandColor'] as int),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomImageWidget(
                      imageUrl: platform['logo'] as String,
                      width: 8.w,
                      height: 8.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Platform Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              platform['name'] as String,
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isConnected) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: AppTheme.successGreen,
                                    size: 3.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Connected',
                                    style: AppTheme
                                        .darkTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme.successGreen,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: 1.h),

                      Text(
                        platform['description'] as String,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.5.h),

                      // Content Types
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 0.5.h,
                        children: (platform['contentTypes'] as List<String>)
                            .take(3)
                            .map((type) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.borderSubtle.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              type,
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 10.sp,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 3.w),

                // Action Button
                isConnected
                    ? ElevatedButton(
                        onPressed: onToggle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.backgroundElevated,
                          foregroundColor: AppTheme.primaryAIBlue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          minimumSize: Size(0, 4.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: AppTheme.primaryAIBlue, width: 1),
                          ),
                        ),
                        child: Text(
                          'Manage',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.primaryAIBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Switch(
                        value: false,
                        onChanged: (_) => onTap(),
                        activeColor: AppTheme.primaryAIBlue,
                        inactiveThumbColor: AppTheme.textSecondary,
                        inactiveTrackColor: AppTheme.borderSubtle,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
