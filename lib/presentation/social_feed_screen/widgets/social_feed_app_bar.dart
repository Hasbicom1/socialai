import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SocialFeedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSettingsPressed;
  final VoidCallback onSearchPressed;

  const SocialFeedAppBar({
    Key? key,
    required this.onSettingsPressed,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0A0A0A),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // App logo/icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Icon(
              Icons.rss_feed,
              color: Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'SocialAI',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        // Search button
        IconButton(
          onPressed: onSearchPressed,
          icon: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: 6.w,
          ),
        ),
        // Settings button
        IconButton(
          onPressed: onSettingsPressed,
          icon: Icon(
            Icons.settings,
            color: Colors.grey[400],
            size: 6.w,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }
}
