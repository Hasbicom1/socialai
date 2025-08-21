import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PlatformFilterChips extends StatelessWidget {
  final List<String> selectedPlatforms;
  final Function(List<String>) onChanged;

  const PlatformFilterChips({
    Key? key,
    required this.selectedPlatforms,
    required this.onChanged,
  }) : super(key: key);

  static const List<Map<String, dynamic>> _platforms = [
    {'key': 'instagram', 'label': 'Instagram', 'color': Color(0xFFE4405F)},
    {'key': 'tiktok', 'label': 'TikTok', 'color': Color(0xFF000000)},
    {'key': 'binance', 'label': 'Binance', 'color': Color(0xFFF0B90B)},
    {'key': 'news', 'label': 'News', 'color': Color(0xFF1DA1F2)},
    {'key': 'twitter', 'label': 'Twitter', 'color': Color(0xFF1DA1F2)},
    {'key': 'facebook', 'label': 'Facebook', 'color': Color(0xFF1877F2)},
    {'key': 'youtube', 'label': 'YouTube', 'color': Color(0xFFFF0000)},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Platform',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            // All platforms chip
            _buildFilterChip(
              label: 'All',
              isSelected: selectedPlatforms.isEmpty,
              color: const Color(0xFF6366f1),
              onTap: () => onChanged([]),
            ),
            // Individual platform chips
            ..._platforms.map((platform) => _buildFilterChip(
                  label: platform['label'],
                  isSelected: selectedPlatforms.contains(platform['key']),
                  color: platform['color'],
                  onTap: () => _togglePlatform(platform['key']),
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 2.w,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(51) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: isSelected ? color : Colors.grey[600]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            if (isSelected) SizedBox(width: 2.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: isSelected ? Colors.white : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePlatform(String platform) {
    List<String> newSelection = List.from(selectedPlatforms);

    if (newSelection.contains(platform)) {
      newSelection.remove(platform);
    } else {
      newSelection.add(platform);
    }

    onChanged(newSelection);
  }
}
