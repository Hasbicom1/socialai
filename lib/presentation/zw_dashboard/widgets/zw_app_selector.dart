import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:device_apps/device_apps.dart';

class ZWAppSelector extends StatefulWidget {
  final List<Application> installedApps;
  final List<String> selectedApps;
  final Function(String, bool) onAppSelected;

  const ZWAppSelector({
    Key? key,
    required this.installedApps,
    required this.selectedApps,
    required this.onAppSelected,
  }) : super(key: key);

  @override
  State<ZWAppSelector> createState() => _ZWAppSelectorState();
}

class _ZWAppSelectorState extends State<ZWAppSelector> {
  String _searchQuery = '';
  String _selectedCategory = 'all';

  List<String> get _filteredApps {
    return widget.installedApps
        .where((app) {
          bool matchesSearch = app.appName.toLowerCase().contains(_searchQuery.toLowerCase());
          bool matchesCategory = _selectedCategory == 'all' || 
              _getAppCategory(app.appName) == _selectedCategory;
          return matchesSearch && matchesCategory;
        })
        .map((app) => app.packageName)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1A),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(
            child: _buildAppList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.apps,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Apps to Monitor',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${widget.selectedApps.length} apps selected',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: 'Search apps...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    List<String> categories = ['all', 'social', 'messaging', 'email', 'entertainment', 'browser', 'media'];
    List<String> categoryLabels = ['All', 'Social', 'Messages', 'Email', 'Entertainment', 'Browser', 'Media'];
    
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isActive = _selectedCategory == categories[index];
          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(
                categoryLabels[index],
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white.withOpacity(0.7),
                  fontSize: 12.sp,
                ),
              ),
              selected: isActive,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = categories[index];
                });
              },
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

  Widget _buildAppList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: _filteredApps.length,
      itemBuilder: (context, index) {
        String packageName = _filteredApps[index];
        Application app = widget.installedApps.firstWhere(
          (app) => app.packageName == packageName,
        );
        bool isSelected = widget.selectedApps.contains(packageName);
        
        return _buildAppItem(app, isSelected);
      },
    );
  }

  Widget _buildAppItem(Application app, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF667EEA).withOpacity(0.2)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF667EEA)
              : Colors.white.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(4.w),
        leading: _buildAppIcon(app),
        title: Text(
          app.appName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            Text(
              'Version: ${app.versionName ?? 'Unknown'}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(_getAppCategory(app.appName)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getCategoryLabel(_getAppCategory(app.appName)),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF667EEA)
                : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF667EEA)
                  : Colors.white.withOpacity(0.3),
            ),
          ),
          child: isSelected
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                )
              : null,
        ),
        onTap: () {
          widget.onAppSelected(app.packageName, !isSelected);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildAppIcon(Application app) {
    return Container(
      width: 16.w,
      height: 16.w,
      decoration: BoxDecoration(
        gradient: _getAppGradient(app.appName),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          _getAppEmoji(app.appName),
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
    );
  }

  String _getAppCategory(String appName) {
    appName = appName.toLowerCase();
    
    if (appName.contains('whatsapp') || appName.contains('telegram') || appName.contains('signal')) {
      return 'messaging';
    } else if (appName.contains('instagram') || appName.contains('facebook') || appName.contains('twitter')) {
      return 'social';
    } else if (appName.contains('youtube') || appName.contains('netflix') || appName.contains('spotify')) {
      return 'entertainment';
    } else if (appName.contains('gmail') || appName.contains('outlook') || appName.contains('email')) {
      return 'email';
    } else if (appName.contains('chrome') || appName.contains('firefox') || appName.contains('safari')) {
      return 'browser';
    } else if (appName.contains('camera') || appName.contains('gallery') || appName.contains('photo')) {
      return 'media';
    } else {
      return 'other';
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'messaging':
        return 'Messages';
      case 'social':
        return 'Social';
      case 'entertainment':
        return 'Entertainment';
      case 'email':
        return 'Email';
      case 'browser':
        return 'Browser';
      case 'media':
        return 'Media';
      default:
        return 'Other';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'messaging':
        return const Color(0xFF4FACFE);
      case 'social':
        return const Color(0xFFF093FB);
      case 'entertainment':
        return const Color(0xFF43E97B);
      case 'email':
        return const Color(0xFFFA709A);
      case 'browser':
        return const Color(0xFF667EEA);
      case 'media':
        return const Color(0xFFFFD93D);
      default:
        return Colors.grey;
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
} 