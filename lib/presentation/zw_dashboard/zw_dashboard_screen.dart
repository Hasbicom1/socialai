import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../services/zw_app_aggregator_service.dart';
import 'widgets/zw_reel_card.dart';
import 'widgets/zw_ai_summary_panel.dart';
import 'widgets/zw_app_selector.dart';

class ZWDashboardScreen extends StatefulWidget {
  const ZWDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ZWDashboardScreen> createState() => _ZWDashboardScreenState();
}

class _ZWDashboardScreenState extends State<ZWDashboardScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _fadeController;

  List<Application> _installedApps = [];
  List<String> _selectedApps = [];
  List<Map<String, dynamic>> _aggregatedUpdates = [];
  bool _isLoading = true;
  bool _showAISummary = false;
  String _currentFilter = 'all';
  String _aiSummary = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeZW();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  Future<void> _initializeZW() async {
    await _requestPermissions();
    await _loadInstalledApps();
    await _loadUserPreferences();
    await _loadAggregatedUpdates();
    await _generateAISummary();
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _requestPermissions() async {
    bool hasPermission = await ZWAppAggregatorService().hasAccessibilityPermission();
    if (!hasPermission) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'ZW needs accessibility permission to monitor your apps and provide updates. '
          'Please enable it in Settings > Accessibility.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadInstalledApps() async {
    try {
      List<Application> apps = await ZWAppAggregatorService().getInstalledApps();
      setState(() {
        _installedApps = apps;
      });
    } catch (e) {
      print('Error loading installed apps: $e');
    }
  }

  Future<void> _loadUserPreferences() async {
    try {
      List<String> preferredApps = await ZWAppAggregatorService().getUserPreferredApps();
      setState(() {
        _selectedApps = preferredApps;
      });
    } catch (e) {
      print('Error loading user preferences: $e');
    }
  }

  Future<void> _loadAggregatedUpdates() async {
    try {
      List<Map<String, dynamic>> updates = await ZWAppAggregatorService().getAggregatedUpdates();
      setState(() {
        _aggregatedUpdates = updates;
      });
    } catch (e) {
      print('Error loading aggregated updates: $e');
    }
  }

  Future<void> _generateAISummary() async {
    try {
      String summary = await ZWAppAggregatorService().generateAISummary();
      setState(() {
        _aiSummary = summary;
      });
    } catch (e) {
      print('Error generating AI summary: $e');
    }
  }

  void _onAppSelected(String packageName, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (!_selectedApps.contains(packageName)) {
          _selectedApps.add(packageName);
        }
      } else {
        _selectedApps.remove(packageName);
      }
    });
    
    ZWAppAggregatorService().setUserPreferredApps(_selectedApps);
    _loadAggregatedUpdates();
    _generateAISummary();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _currentFilter = filter;
    });
  }

  void _onCardTap(Map<String, dynamic> update) async {
    try {
      bool opened = await DeviceApps.openApp(update['packageName']);
      if (!opened) {
        _showAppOpenError(update['appName']);
      }
    } catch (e) {
      _showAppOpenError(update['appName']);
    }
  }

  void _showAppOpenError(String appName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not open $appName'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _onShareUpdate(Map<String, dynamic> update) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }

  void _onAISummaryToggle() {
    setState(() {
      _showAISummary = !_showAISummary;
    });
    
    if (_showAISummary) {
      _slideController.forward();
      _fadeController.forward();
    } else {
      _slideController.reverse();
      _fadeController.reverse();
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    
    await _loadAggregatedUpdates();
    await _generateAISummary();
    
    setState(() {
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredUpdates {
    if (_currentFilter == 'all') {
      return _aggregatedUpdates;
    }
    return _aggregatedUpdates.where((update) {
      String appName = update['appName']?.toString().toLowerCase() ?? '';
      return appName.contains(_currentFilter.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
            _buildFilterBar(),
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildMainContent(),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '🧠 ZW',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              background: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFFF093FB)],
                ).createShader(const Rect.fromLTWH(0, 0, 100, 30)),
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),
                SizedBox(width: 1.w),
                Text(
                  'AI Active',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            'Syncing • Live',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    List<String> filters = ['all', 'social', 'messaging', 'email', 'entertainment'];
    List<String> filterLabels = ['All', 'Social', 'Messages', 'Email', 'Entertainment'];
    
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          bool isActive = _currentFilter == filters[index];
          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(
                filterLabels[index],
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white.withOpacity(0.7),
                  fontSize: 12.sp,
                ),
              ),
              selected: isActive,
              onSelected: (selected) => _onFilterChanged(filters[index]),
              backgroundColor: Colors.white.withOpacity(0.1),
              selectedColor: const Color(0xFF667EEA),
              side: BorderSide(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: _filteredUpdates.length,
          itemBuilder: (context, index) {
            return ZWReelCard(
              update: _filteredUpdates[index],
              onTap: () => _onCardTap(_filteredUpdates[index]),
              onShare: () => _onShareUpdate(_filteredUpdates[index]),
              onAISummary: _onAISummaryToggle,
            );
          },
        ),
        if (_showAISummary)
          ZWAISummaryPanel(
            summary: _aiSummary,
            onClose: _onAISummaryToggle,
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/ai_loading.json',
            width: 20.w,
            height: 20.w,
          ),
          SizedBox(height: 4.h),
          Text(
            'Initializing ZW...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Setting up AI-powered app aggregation',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Feed', true),
          _buildNavItem(Icons.search, 'Discover', false),
          _buildNavItem(Icons.psychology, 'AI', false),
          _buildNavItem(Icons.message, 'Messages', false),
          _buildNavItem(Icons.person, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF667EEA) : Colors.white.withOpacity(0.6),
          size: 24,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: isActive ? const Color(0xFF667EEA) : Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: _onRefresh,
          backgroundColor: const Color(0xFF667EEA),
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
        SizedBox(height: 2.h),
        FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => ZWAppSelector(
                installedApps: _installedApps,
                selectedApps: _selectedApps,
                onAppSelected: _onAppSelected,
              ),
            );
          },
          backgroundColor: const Color(0xFFF093FB),
          child: const Icon(Icons.settings, color: Colors.white),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
} 