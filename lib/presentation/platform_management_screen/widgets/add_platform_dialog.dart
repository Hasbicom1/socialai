import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AddPlatformDialog extends StatefulWidget {
  const AddPlatformDialog({Key? key}) : super(key: key);

  @override
  State<AddPlatformDialog> createState() => _AddPlatformDialogState();
}

class _AddPlatformDialogState extends State<AddPlatformDialog> {
  String? _selectedPlatform;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  static const List<Map<String, dynamic>> _availablePlatforms = [
    {
      'key': 'instagram',
      'label': 'Instagram',
      'color': Color(0xFFE4405F),
      'icon': Icons.camera_alt,
      'description': 'Connect your Instagram account to see photos and videos',
    },
    {
      'key': 'tiktok',
      'label': 'TikTok',
      'color': Color(0xFF000000),
      'icon': Icons.music_video,
      'description': 'Connect your TikTok account to see short videos',
    },
    {
      'key': 'binance',
      'label': 'Binance',
      'color': Color(0xFFF0B90B),
      'icon': Icons.currency_bitcoin,
      'description': 'Connect to see cryptocurrency news and updates',
    },
    {
      'key': 'news',
      'label': 'News Feeds',
      'color': Color(0xFF1DA1F2),
      'icon': Icons.article,
      'description': 'Connect to various news sources',
    },
    {
      'key': 'twitter',
      'label': 'Twitter',
      'color': Color(0xFF1DA1F2),
      'icon': Icons.alternate_email,
      'description': 'Connect your Twitter account to see tweets',
    },
    {
      'key': 'facebook',
      'label': 'Facebook',
      'color': Color(0xFF1877F2),
      'icon': Icons.facebook,
      'description': 'Connect your Facebook account',
    },
    {
      'key': 'youtube',
      'label': 'YouTube',
      'color': Color(0xFFFF0000),
      'icon': Icons.play_circle_fill,
      'description': 'Connect your YouTube account to see videos',
    },
  ];

  void _connectPlatform() {
    if (_selectedPlatform == null || _usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a platform and enter your username'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = {
      'platform': _selectedPlatform!,
      'username': _usernameController.text.trim(),
      'metadata': {
        'additional_info': _additionalInfoController.text.trim(),
        'connected_at': DateTime.now().toIso8601String(),
      },
    };

    Navigator.pop(context, result);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(
            color: Colors.grey[700]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.add_link,
                  color: const Color(0xFF6366f1),
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Connect Platform',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Platform selection
            Text(
              'Choose Platform',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2.h),

            // Platform options
            Container(
              height: 30.h,
              child: ListView.builder(
                itemCount: _availablePlatforms.length,
                itemBuilder: (context, index) {
                  final platform = _availablePlatforms[index];
                  final isSelected = _selectedPlatform == platform['key'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPlatform = platform['key'];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? platform['color'].withAlpha(26)
                            : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(
                          color: isSelected
                              ? platform['color']
                              : Colors.grey[700]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: platform['color'],
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Icon(
                              platform['icon'],
                              color: Colors.white,
                              size: 5.w,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  platform['label'],
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  platform['description'],
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: platform['color'],
                              size: 5.w,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 2.h),

            // Username field
            Text(
              'Username/Handle',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _usernameController,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: _selectedPlatform != null
                    ? 'Enter your ${_availablePlatforms.firstWhere((p) => p['key'] == _selectedPlatform)['label']} username'
                    : 'Enter your username',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey[500],
                  fontSize: 14.sp,
                ),
                prefixText: '@',
                prefixStyle: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide(
                    color: const Color(0xFF6366f1),
                    width: 2,
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 3.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                        side: BorderSide(
                          color: Colors.grey[600]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _connectPlatform,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366f1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 3.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                    child: Text(
                      'Connect',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
