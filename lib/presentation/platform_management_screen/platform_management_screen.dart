import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../services/social_media_service.dart';
import './widgets/add_platform_dialog.dart';
import './widgets/platform_connection_card.dart';

class PlatformManagementScreen extends StatefulWidget {
  const PlatformManagementScreen({Key? key}) : super(key: key);

  @override
  State<PlatformManagementScreen> createState() =>
      _PlatformManagementScreenState();
}

class _PlatformManagementScreenState extends State<PlatformManagementScreen> {
  List<Map<String, dynamic>> _platformConnections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlatformConnections();
  }

  Future<void> _loadPlatformConnections() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final connections = await SocialMediaService.getUserPlatforms();
      setState(() {
        _platformConnections = connections;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load platforms: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addPlatform() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddPlatformDialog(),
    );

    if (result != null) {
      try {
        await SocialMediaService.connectPlatform(
          platform: result['platform'],
          platformUsername: result['username'],
          metadata: result['metadata'],
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully connected ${result['platform']}!'),
            backgroundColor: Colors.green,
          ),
        );

        _loadPlatformConnections(); // Refresh list
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect platform: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _disconnectPlatform(
      String connectionId, String platformName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          'Disconnect Platform',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to disconnect $platformName? You will no longer see posts from this platform in your feed.',
          style: GoogleFonts.inter(
            color: Colors.grey[300],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Colors.grey[400],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Disconnect',
              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await SocialMediaService.disconnectPlatform(connectionId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Disconnected $platformName'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadPlatformConnections(); // Refresh list
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to disconnect: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 6.w,
          ),
        ),
        title: Text(
          'Platform Management',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _addPlatform,
            icon: Icon(
              Icons.add,
              color: const Color(0xFF6366f1),
              size: 6.w,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366f1)),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadPlatformConnections,
              color: const Color(0xFF6366f1),
              child: _platformConnections.isEmpty
                  ? _buildEmptyState()
                  : _buildPlatformsList(),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_off,
            size: 15.w,
            color: Colors.grey[600],
          ),
          SizedBox(height: 3.h),
          Text(
            'No Connected Platforms',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Connect your social media accounts to\nsee personalized content in your feed',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: _addPlatform,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366f1),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 3.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
            icon: Icon(Icons.add, size: 5.w),
            label: Text(
              'Connect Platform',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformsList() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: _platformConnections.length,
      itemBuilder: (context, index) {
        final connection = _platformConnections[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 3.h),
          child: PlatformConnectionCard(
            connection: connection,
            onDisconnect: () => _disconnectPlatform(
              connection['id'],
              connection['platform'] ?? 'Unknown',
            ),
          ),
        );
      },
    );
  }
}
