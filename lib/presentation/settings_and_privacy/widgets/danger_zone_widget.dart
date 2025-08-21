import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DangerZoneWidget extends StatelessWidget {
  final VoidCallback onDeleteAccount;
  final VoidCallback onExportData;

  const DangerZoneWidget({
    Key? key,
    required this.onDeleteAccount,
    required this.onExportData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Text(
              'DANGER ZONE',
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.errorRed,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.errorRed.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                _buildDangerItem(
                  title: 'Export My Data',
                  subtitle: 'Download all your data in JSON format',
                  iconName: 'download',
                  onTap: onExportData,
                  showDivider: true,
                ),
                _buildDangerItem(
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account and all data',
                  iconName: 'delete_forever',
                  onTap: onDeleteAccount,
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerItem({
    required String title,
    required String subtitle,
    required String iconName,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: AppTheme.errorRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: AppTheme.errorRed,
                      size: 5.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.errorRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.errorRed,
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            margin: EdgeInsets.only(left: 17.w),
            height: 1,
            color: AppTheme.errorRed.withValues(alpha: 0.2),
          ),
      ],
    );
  }
}
