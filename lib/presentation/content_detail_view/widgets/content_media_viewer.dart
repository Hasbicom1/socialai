import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ContentMediaViewer extends StatefulWidget {
  final String mediaType;
  final String mediaUrl;
  final String? thumbnailUrl;
  final double aspectRatio;
  final VoidCallback? onFullscreen;

  const ContentMediaViewer({
    Key? key,
    required this.mediaType,
    required this.mediaUrl,
    this.thumbnailUrl,
    this.aspectRatio = 16 / 9,
    this.onFullscreen,
  }) : super(key: key);

  @override
  State<ContentMediaViewer> createState() => _ContentMediaViewerState();
}

class _ContentMediaViewerState extends State<ContentMediaViewer> {
  bool _isPlaying = false;
  bool _showControls = true;
  double _currentPosition = 0.0;
  double _totalDuration = 100.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: widget.mediaType == 'video' ? 70.h : 60.h,
      ),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Stack(
          children: [
            _buildMediaContent(),
            if (widget.mediaType == 'video') _buildVideoControls(),
            _buildMediaOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    switch (widget.mediaType) {
      case 'image':
        return _buildImageViewer();
      case 'video':
        return _buildVideoViewer();
      case 'carousel':
        return _buildCarouselViewer();
      default:
        return _buildImageViewer();
    }
  }

  Widget _buildImageViewer() {
    return GestureDetector(
      onTap: widget.onFullscreen,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.darkTheme.colorScheme.surface,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CustomImageWidget(
            imageUrl: widget.mediaUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoViewer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPlaying = !_isPlaying;
          _showControls = true;
        });
        _hideControlsAfterDelay();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.darkTheme.colorScheme.surface,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              CustomImageWidget(
                imageUrl: widget.thumbnailUrl ?? widget.mediaUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              if (!_isPlaying)
                Center(
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CustomIconWidget(
                      iconName: 'play_arrow',
                      color: Colors.white,
                      size: 10.w,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselViewer() {
    return PageView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.darkTheme.colorScheme.surface,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageWidget(
              imageUrl: widget.mediaUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoControls() {
    if (!_showControls || !_isPlaying) return const SizedBox.shrink();

    return Positioned(
      bottom: 2.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${(_currentPosition / 60).floor()}:${(_currentPosition % 60).floor().toString().padLeft(2, '0')}',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _currentPosition,
                    max: _totalDuration,
                    onChanged: (value) {
                      setState(() {
                        _currentPosition = value;
                      });
                    },
                    activeColor: AppTheme.darkTheme.colorScheme.primary,
                    inactiveColor: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                Text(
                  '${(_totalDuration / 60).floor()}:${(_totalDuration % 60).floor().toString().padLeft(2, '0')}',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentPosition =
                          (_currentPosition - 10).clamp(0, _totalDuration);
                    });
                  },
                  child: CustomIconWidget(
                    iconName: 'replay_10',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  child: CustomIconWidget(
                    iconName: _isPlaying ? 'pause' : 'play_arrow',
                    color: Colors.white,
                    size: 8.w,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentPosition =
                          (_currentPosition + 10).clamp(0, _totalDuration);
                    });
                  },
                  child: CustomIconWidget(
                    iconName: 'forward_10',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaOverlay() {
    return Positioned(
      top: 2.h,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: widget.mediaType == 'video' ? 'videocam' : 'photo',
              color: Colors.white,
              size: 3.w,
            ),
            if (widget.mediaType == 'carousel') ...[
              SizedBox(width: 1.w),
              Text(
                '1/3',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }
}
