import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class GlassmorphismBackgroundWidget extends StatefulWidget {
  final Widget child;

  const GlassmorphismBackgroundWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<GlassmorphismBackgroundWidget> createState() =>
      _GlassmorphismBackgroundWidgetState();
}

class _GlassmorphismBackgroundWidgetState
    extends State<GlassmorphismBackgroundWidget> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _gradientController;
  late Animation<Offset> _floatingAnimation1;
  late Animation<Offset> _floatingAnimation2;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _floatingController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _gradientController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _floatingAnimation1 = Tween<Offset>(
      begin: const Offset(-0.2, -0.3),
      end: const Offset(0.2, 0.3),
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _floatingAnimation2 = Tween<Offset>(
      begin: const Offset(0.3, 0.2),
      end: const Offset(-0.1, -0.2),
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));

    _floatingController.repeat(reverse: true);
    _gradientController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundDeep,
            AppTheme.backgroundElevated,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated floating orbs
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Positioned(
                top: 20.h + (_floatingAnimation1.value.dy * 10.h),
                left: 20.w + (_floatingAnimation1.value.dx * 15.w),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primaryAIBlue.withValues(alpha: 0.15),
                        AppTheme.primaryAIBlue.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Positioned(
                top: 50.h + (_floatingAnimation2.value.dy * 8.h),
                right: 15.w + (_floatingAnimation2.value.dx * 12.w),
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.secondaryPurple.withValues(alpha: 0.12),
                        AppTheme.secondaryPurple.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Animated gradient overlay
          AnimatedBuilder(
            animation: _gradientAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.accentPink.withValues(
                          alpha: 0.03 + (_gradientAnimation.value * 0.02)),
                      Colors.transparent,
                      AppTheme.primaryAIBlue.withValues(
                          alpha: 0.02 + (_gradientAnimation.value * 0.03)),
                    ],
                  ),
                ),
              );
            },
          ),
          // Glassmorphism overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.02),
                  Colors.white.withValues(alpha: 0.01),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Content
          widget.child,
        ],
      ),
    );
  }
}
