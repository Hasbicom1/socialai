import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AiAvatarWidget extends StatefulWidget {
  final bool isProcessing;

  const AiAvatarWidget({
    Key? key,
    required this.isProcessing,
  }) : super(key: key);

  @override
  State<AiAvatarWidget> createState() => _AiAvatarWidgetState();
}

class _AiAvatarWidgetState extends State<AiAvatarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isProcessing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AiAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isProcessing != oldWidget.isProcessing) {
      if (widget.isProcessing) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isProcessing ? _pulseAnimation.value : 1.0,
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.aiGradient,
              boxShadow: widget.isProcessing
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryAIBlue.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : AppTheme.cardShadow,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.textPrimary,
                size: 6.w,
              ),
            ),
          ),
        );
      },
    );
  }
}
