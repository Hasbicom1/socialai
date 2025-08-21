import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ContentCaptionSection extends StatefulWidget {
  final String caption;
  final List<String> hashtags;
  final String location;
  final int likes;
  final int comments;
  final int shares;
  final bool isExpanded;

  const ContentCaptionSection({
    Key? key,
    required this.caption,
    required this.hashtags,
    required this.location,
    required this.likes,
    required this.comments,
    required this.shares,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  State<ContentCaptionSection> createState() => _ContentCaptionSectionState();
}

class _ContentCaptionSectionState extends State<ContentCaptionSection> {
  bool _isExpanded = false;
  bool _showTranslation = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEngagementMetrics(),
          SizedBox(height: 2.h),
          _buildCaptionContent(),
          if (widget.hashtags.isNotEmpty) ...[
            SizedBox(height: 1.h),
            _buildHashtags(),
          ],
          if (widget.location.isNotEmpty) ...[
            SizedBox(height: 1.h),
            _buildLocation(),
          ],
          SizedBox(height: 1.h),
          _buildCaptionActions(),
        ],
      ),
    );
  }

  Widget _buildEngagementMetrics() {
    return Row(
      children: [
        _buildMetricItem('favorite', widget.likes, 'likes'),
        SizedBox(width: 6.w),
        _buildMetricItem('comment', widget.comments, 'comments'),
        SizedBox(width: 6.w),
        _buildMetricItem('share', widget.shares, 'shares'),
        const Spacer(),
        Text(
          '2 hours ago',
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMetricItem(String iconName, int count, String label) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
        SizedBox(width: 1.w),
        Text(
          _formatCount(count),
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCaptionContent() {
    final maxLines = _isExpanded ? null : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onLongPress: () {
            _showSelectionDialog();
          },
          child: Text(
            _showTranslation ? _getTranslatedText() : widget.caption,
            style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
              height: 1.4,
            ),
            maxLines: maxLines,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
          ),
        ),
        if (widget.caption.length > 150) ...[
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Show less' : 'Show more',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHashtags() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: widget.hashtags.map((hashtag) {
        return GestureDetector(
          onTap: () {
            // Navigate to hashtag feed
          },
          child: Text(
            hashtag,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'location_on',
          color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: Text(
            widget.location,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCaptionActions() {
    return Row(
      children: [
        if (!_showTranslation)
          GestureDetector(
            onTap: () {
              setState(() {
                _showTranslation = true;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.darkTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'translate',
                    color: AppTheme.darkTheme.colorScheme.primary,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Translate',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_showTranslation) ...[
          GestureDetector(
            onTap: () {
              setState(() {
                _showTranslation = false;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.darkTheme.colorScheme.primary,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check',
                    color: AppTheme.darkTheme.colorScheme.primary,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Translated',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            'Show original',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ],
    );
  }

  void _showSelectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                  size: 5.w,
                ),
                title: Text(
                  'Copy text',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'translate',
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                  size: 5.w,
                ),
                title: Text(
                  'Translate',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _showTranslation = true;
                  });
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                  size: 5.w,
                ),
                title: Text(
                  'Search selected text',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _getTranslatedText() {
    return "Exploring the beautiful sunset at the beach today! The colors were absolutely stunning and reminded me of why I love photography so much. 📸✨";
  }
}
