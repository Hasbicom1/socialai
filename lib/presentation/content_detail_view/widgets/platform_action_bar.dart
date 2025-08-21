import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PlatformActionBar extends StatefulWidget {
  final String platform;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onOpenInApp;

  const PlatformActionBar({
    Key? key,
    required this.platform,
    required this.isLiked,
    required this.isSaved,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
    required this.onOpenInApp,
  }) : super(key: key);

  @override
  State<PlatformActionBar> createState() => _PlatformActionBarState();
}

class _PlatformActionBarState extends State<PlatformActionBar>
    with TickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late AnimationController _saveAnimationController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _saveScaleAnimation;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _saveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _likeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));

    _saveScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _saveAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    _saveAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color:
            AppTheme.darkTheme.scaffoldBackgroundColor.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: AppTheme.darkTheme.colorScheme.outline,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  iconName: widget.isLiked ? 'favorite' : 'favorite_border',
                  label: 'Like',
                  isActive: widget.isLiked,
                  onTap: () {
                    _triggerHapticFeedback();
                    if (widget.isLiked) {
                      _likeAnimationController.reverse();
                    } else {
                      _likeAnimationController.forward().then((_) {
                        _likeAnimationController.reverse();
                      });
                    }
                    widget.onLike();
                  },
                  animation: _likeScaleAnimation,
                ),
                _buildActionButton(
                  iconName: 'comment',
                  label: 'Comment',
                  onTap: () {
                    _triggerHapticFeedback();
                    widget.onComment();
                  },
                ),
                _buildActionButton(
                  iconName: 'share',
                  label: 'Share',
                  onTap: () {
                    _triggerHapticFeedback();
                    widget.onShare();
                  },
                ),
                _buildActionButton(
                  iconName: widget.isSaved ? 'bookmark' : 'bookmark_border',
                  label: 'Save',
                  isActive: widget.isSaved,
                  onTap: () {
                    _triggerHapticFeedback();
                    if (widget.isSaved) {
                      _saveAnimationController.reverse();
                    } else {
                      _saveAnimationController.forward().then((_) {
                        _saveAnimationController.reverse();
                      });
                    }
                    widget.onSave();
                  },
                  animation: _saveScaleAnimation,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildOpenInAppButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String iconName,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    Animation<double>? animation,
  }) {
    Widget iconWidget = CustomIconWidget(
      iconName: iconName,
      color: isActive
          ? _getActiveColor()
          : AppTheme.darkTheme.colorScheme.onSurface,
      size: 6.w,
    );

    if (animation != null) {
      iconWidget = AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: animation.value,
            child: iconWidget,
          );
        },
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          children: [
            iconWidget,
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: isActive
                    ? _getActiveColor()
                    : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenInAppButton() {
    return GestureDetector(
      onTap: () {
        _triggerHapticFeedback();
        widget.onOpenInApp();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getPlatformColor(),
              _getPlatformColor().withValues(alpha: 0.8),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _getPlatformColor().withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'open_in_new',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Open in ${widget.platform}',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPlatformColor() {
    switch (widget.platform.toLowerCase()) {
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

  Color _getActiveColor() {
    switch (widget.platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'tiktok':
        return const Color(0xFFFF0050);
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

  void _triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }
}
