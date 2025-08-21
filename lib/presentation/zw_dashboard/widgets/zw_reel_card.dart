import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class ZWReelCard extends StatefulWidget {
  final Map<String, dynamic> update;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onAISummary;

  const ZWReelCard({
    Key? key,
    required this.update,
    required this.onTap,
    required this.onShare,
    required this.onAISummary,
  }) : super(key: key);

  @override
  State<ZWReelCard> createState() => _ZWReelCardState();
}

class _ZWReelCardState extends State<ZWReelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _getPriorityBorderColor(),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getPriorityShadowColor(),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildContent(),
                  _buildMediaPreview(),
                  _buildActions(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          _buildAppAvatar(),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.update['appName'] ?? 'Unknown App',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      _getTypeIcon(),
                      size: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _getTypeLabel(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      timeago.format(
                        DateTime.fromMillisecondsSinceEpoch(
                          widget.update['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildPriorityBadge(),
        ],
      ),
    );
  }

  Widget _buildAppAvatar() {
    String appName = widget.update['appName'] ?? 'App';
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        gradient: _getAppGradient(appName),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          _getAppEmoji(appName),
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge() {
    String priority = widget.update['priority'] ?? 'medium';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: _getPriorityColors(priority),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPriorityIcon(priority),
            size: 12,
            color: Colors.white,
          ),
          SizedBox(width: 1.w),
          Text(
            _getPriorityLabel(priority),
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.update['title'] ?? 'Update',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            widget.update['content'] ?? 'No content available',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    // Placeholder for media preview
    return Container(
      margin: EdgeInsets.all(4.w),
      height: 20.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 32,
              color: Colors.white.withOpacity(0.3),
            ),
            SizedBox(height: 1.h),
            Text(
              'Media Preview',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.favorite_border,
              label: 'Like',
              onTap: () {},
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: _buildActionButton(
              icon: Icons.share,
              label: 'Share',
              onTap: widget.onShare,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: _buildActionButton(
              icon: Icons.bookmark_border,
              label: 'Save',
              onTap: () {},
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: _buildActionButton(
              icon: Icons.psychology,
              label: 'AI',
              onTap: widget.onAISummary,
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFF667EEA)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary
                ? const Color(0xFF667EEA)
                : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isPrimary ? Colors.white : Colors.white.withOpacity(0.7),
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: isPrimary ? Colors.white : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityBorderColor() {
    String priority = widget.update['priority'] ?? 'medium';
    switch (priority) {
      case 'high':
        return const Color(0xFF667EEA);
      case 'medium':
        return Colors.orange;
      default:
        return Colors.white.withOpacity(0.2);
    }
  }

  Color _getPriorityShadowColor() {
    String priority = widget.update['priority'] ?? 'medium';
    switch (priority) {
      case 'high':
        return const Color(0xFF667EEA).withOpacity(0.3);
      case 'medium':
        return Colors.orange.withOpacity(0.2);
      default:
        return Colors.transparent;
    }
  }

  LinearGradient _getAppGradient(String appName) {
    List<List<Color>> gradients = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFFF093FB), const Color(0xFFF5576C)],
      [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
      [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      [const Color(0xFFFA709A), const Color(0xFFFEE140)],
    ];
    
    int index = appName.hashCode % gradients.length;
    return LinearGradient(
      colors: gradients[index],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  String _getAppEmoji(String appName) {
    appName = appName.toLowerCase();
    if (appName.contains('whatsapp')) return '💬';
    if (appName.contains('instagram')) return '📷';
    if (appName.contains('facebook')) return '📘';
    if (appName.contains('twitter')) return '🐦';
    if (appName.contains('youtube')) return '📺';
    if (appName.contains('gmail')) return '📧';
    if (appName.contains('chrome')) return '🌐';
    return '📱';
  }

  IconData _getTypeIcon() {
    String type = widget.update['type'] ?? 'notification';
    switch (type) {
      case 'message':
        return Icons.message;
      case 'update':
        return Icons.system_update;
      case 'alert':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  String _getTypeLabel() {
    String type = widget.update['type'] ?? 'notification';
    return type.substring(0, 1).toUpperCase() + type.substring(1);
  }

  LinearGradient _getPriorityColors(String priority) {
    switch (priority) {
      case 'high':
        return const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        );
      case 'medium':
        return const LinearGradient(
          colors: [Color(0xFFFFD93D), Color(0xFFFF6B6B)],
        );
      default:
        return LinearGradient(
          colors: [Colors.grey, Colors.grey.withOpacity(0.7)],
        );
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.remove;
      default:
        return Icons.low_priority;
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority) {
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      default:
        return 'Low';
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }
} 