import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PageIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicatorWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: currentPage == index ? 8.w : 2.w,
          height: 1.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: currentPage == index
                ? LinearGradient(
                    colors: [
                      AppTheme.primaryAIBlue,
                      AppTheme.secondaryPurple,
                    ],
                  )
                : null,
            color: currentPage == index
                ? null
                : AppTheme.borderSubtle.withValues(alpha: 0.5),
            boxShadow: currentPage == index
                ? [
                    BoxShadow(
                      color: AppTheme.primaryAIBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
