import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QuickActionButtonsWidget extends StatelessWidget {
  final Function() onSchedulePost;
  final Function() onAnalyzeTrends;
  final Function() onGenerateCaptions;
  final Function() onSummarizeContent;

  const QuickActionButtonsWidget({
    Key? key,
    required this.onSchedulePost,
    required this.onAnalyzeTrends,
    required this.onGenerateCaptions,
    required this.onSummarizeContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: 'schedule',
            label: 'Schedule',
            onTap: onSchedulePost,
          ),
          _buildActionButton(
            icon: 'trending_up',
            label: 'Trends',
            onTap: onAnalyzeTrends,
          ),
          _buildActionButton(
            icon: 'auto_awesome',
            label: 'Captions',
            onTap: onGenerateCaptions,
          ),
          _buildActionButton(
            icon: 'summarize',
            label: 'Summary',
            onTap: onSummarizeContent,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.borderSubtle,
                width: 1,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.primaryAIBlue,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 10.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
