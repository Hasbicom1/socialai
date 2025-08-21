import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../widgets/custom_image_widget.dart';

class SocialPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLikePressed;
  final VoidCallback onSavePressed;
  final VoidCallback onSharePressed;
  final VoidCallback onViewOriginalPressed;

  const SocialPostCard({
    Key? key,
    required this.post,
    required this.isLiked,
    required this.isSaved,
    required this.onLikePressed,
    required this.onSavePressed,
    required this.onSharePressed,
    required this.onViewOriginalPressed,
  }) : super(key: key);

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'binance':
        return const Color(0xFFF0B90B);
      case 'news':
        return const Color(0xFF1DA1F2);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'youtube':
        return const Color(0xFFFF0000);
      default:
        return const Color(0xFF6366f1);
    }
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'tiktok':
        return Icons.music_video;
      case 'binance':
        return Icons.currency_bitcoin;
      case 'news':
        return Icons.article;
      case 'twitter':
        return Icons.alternate_email;
      case 'facebook':
        return Icons.facebook;
      case 'youtube':
        return Icons.play_circle_fill;
      default:
        return Icons.public;
    }
  }

  Widget _buildMediaContent() {
    final mediaUrls = post['media_urls'] as List<dynamic>?;
    final contentType = post['content_type'] as String?;
    final thumbnailUrl = post['thumbnail_url'] as String?;

    if (mediaUrls == null || mediaUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
        width: double.infinity,
        height: 45.h,
        margin: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w), color: Colors.grey[900]),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: contentType == 'video'
                ? Stack(children: [
                    CustomImageWidget(
                        imageUrl: thumbnailUrl ?? '',
                        width: double.infinity,
                        height: 45.h,
                        fit: BoxFit.cover),
                    Center(
                        child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                                color: Colors.black.withAlpha(179),
                                shape: BoxShape.circle),
                            child: Icon(Icons.play_arrow,
                                color: Colors.white, size: 8.w))),
                  ])
                : CustomImageWidget(
                    imageUrl: mediaUrls.isNotEmpty ? mediaUrls[0] : '',
                    width: double.infinity, height: 45.h, fit: BoxFit.cover)));
  }

  Widget _buildEngagementMetrics() {
    final metrics = post['engagement_metrics'] as Map<String, dynamic>?;
    if (metrics == null) return const SizedBox.shrink();

    return Container(
        margin: EdgeInsets.only(top: 1.h),
        child: Row(children: [
          if (metrics['likes'] != null)
            _buildMetric(
                Icons.favorite, metrics['likes'].toString(), Colors.red),
          if (metrics['comments'] != null)
            _buildMetric(
                Icons.comment, metrics['comments'].toString(), Colors.blue),
          if (metrics['shares'] != null)
            _buildMetric(
                Icons.share, metrics['shares'].toString(), Colors.green),
          if (metrics['views'] != null)
            _buildMetric(
                Icons.visibility, metrics['views'].toString(), Colors.grey),
        ]));
  }

  Widget _buildMetric(IconData icon, String count, Color color) {
    return Container(
        margin: EdgeInsets.only(right: 4.w),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 4.w, color: color),
          SizedBox(width: 1.w),
          Text(count,
              style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500)),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final platformColor = _getPlatformColor(post['platform'] ?? '');
    final platformIcon = _getPlatformIcon(post['platform'] ?? '');
    final postedAt = DateTime.tryParse(post['posted_at'] ?? '');
    final timeAgo = postedAt != null
        ? _formatTimeAgo(DateTime.now().difference(postedAt))
        : 'Unknown';

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(color: Colors.grey[800]!, width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header with platform info and author
          Row(children: [
            // Platform indicator
            Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                    color: platformColor,
                    borderRadius: BorderRadius.circular(2.w)),
                child: Icon(platformIcon, color: Colors.white, size: 5.w)),
            SizedBox(width: 3.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                      post['author_name'] ??
                          post['author_username'] ??
                          'Unknown',
                      style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  Row(children: [
                    Text(post['platform']?.toString().toUpperCase() ?? '',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: platformColor,
                            fontWeight: FontWeight.w700)),
                    SizedBox(width: 2.w),
                    Text('• $timeAgo',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp, color: Colors.grey[400])),
                  ]),
                ])),
            IconButton(
                onPressed: onViewOriginalPressed,
                icon: Icon(Icons.open_in_new,
                    color: Colors.grey[400], size: 5.w)),
          ]),

          SizedBox(height: 2.h),

          // Title
          if (post['title'] != null && post['title'].toString().isNotEmpty)
            Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Text(post['title'],
                    style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700))),

          // Description/Content
          if (post['description'] != null &&
              post['description'].toString().isNotEmpty)
            Text(post['description'],
                style: GoogleFonts.inter(
                    fontSize: 14.sp, color: Colors.grey[300], height: 1.4),
                maxLines: 3,
                overflow: TextOverflow.ellipsis),

          // Media content
          _buildMediaContent(),

          // Engagement metrics
          _buildEngagementMetrics(),

          SizedBox(height: 2.h),

          // Action buttons
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _buildActionButton(Icons.favorite,
                isLiked ? Colors.red : Colors.grey[400]!, onLikePressed,
                filled: isLiked),
            _buildActionButton(
                Icons.bookmark,
                isSaved ? const Color(0xFF6366f1) : Colors.grey[400]!,
                onSavePressed,
                filled: isSaved),
            _buildActionButton(Icons.share, Colors.grey[400]!, onSharePressed),
            _buildActionButton(
                Icons.visibility, Colors.grey[400]!, onViewOriginalPressed),
          ]),
        ]));
  }

  Widget _buildActionButton(
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool filled = false,
  }) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            decoration: BoxDecoration(
                color: filled ? color.withAlpha(26) : Colors.transparent,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(color: color.withAlpha(77), width: 1)),
            child: Icon(filled ? icon : icon, color: color, size: 5.w)));
  }

  String _formatTimeAgo(Duration difference) {
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}