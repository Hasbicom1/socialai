import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PlatformConnectionCard extends StatelessWidget {
  final Map<String, dynamic> connection;
  final VoidCallback onDisconnect;

  const PlatformConnectionCard({
    Key? key,
    required this.connection,
    required this.onDisconnect,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return const Color(0xFF10b981);
      case 'pending':
        return const Color(0xFFF59e0b);
      case 'error':
        return const Color(0xFFef4444);
      case 'disconnected':
        return const Color(0xFF6b7280);
      default:
        return const Color(0xFF6b7280);
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Never';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = connection['platform'] ?? '';
    final platformColor = _getPlatformColor(platform);
    final platformIcon = _getPlatformIcon(platform);
    final status = connection['connection_status'] ?? 'unknown';
    final statusColor = _getStatusColor(status);
    final username = connection['platform_username'] ?? 'Unknown';
    final lastSync = _formatDate(connection['last_sync_at']);
    final metadata = connection['connection_metadata'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: platformColor.withAlpha(51),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with platform info and status
          Row(
            children: [
              // Platform icon
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: platformColor,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Icon(
                  platformIcon,
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          platform.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 1.w,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(2.w),
                            border: Border.all(
                              color: statusColor.withAlpha(77),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '@$username',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Disconnect button
              if (status == 'connected')
                IconButton(
                  onPressed: onDisconnect,
                  icon: Icon(
                    Icons.link_off,
                    color: Colors.grey[400],
                    size: 5.w,
                  ),
                ),
            ],
          ),

          SizedBox(height: 3.h),

          // Connection details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Last Sync',
                  lastSync,
                  Icons.sync,
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: Colors.grey[700],
              ),
              Expanded(
                child: _buildDetailItem(
                  'Connected',
                  _formatDate(connection['created_at']),
                  Icons.schedule,
                ),
              ),
            ],
          ),

          // Metadata (if available)
          if (metadata != null && metadata.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 2.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Platform Info',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 3.w,
                    runSpacing: 1.h,
                    children: metadata.entries.map((entry) {
                      return _buildMetadataItem(
                          entry.key, entry.value.toString());
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Actions
          if (status != 'connected')
            Container(
              margin: EdgeInsets.only(top: 2.h),
              child: Row(
                children: [
                  if (status == 'error')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Retry connection logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                        ),
                        icon: Icon(Icons.refresh, size: 4.w),
                        label: Text(
                          'Retry',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (status == 'pending')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Complete connection logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366f1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                        ),
                        icon: Icon(Icons.check, size: 4.w),
                        label: Text(
                          'Complete Setup',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey[500],
          size: 5.w,
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: Colors.grey[300],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataItem(String key, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 1.w,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withAlpha(128),
        borderRadius: BorderRadius.circular(1.5.w),
      ),
      child: Text(
        '$key: $value',
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          color: Colors.grey[300],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
