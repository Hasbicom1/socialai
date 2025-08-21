import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AIInsightsPanel extends StatefulWidget {
  final double sentimentScore;
  final int engagementPrediction;
  final List<String> trendingTopics;
  final Map<String, double> engagementMetrics;

  const AIInsightsPanel({
    Key? key,
    required this.sentimentScore,
    required this.engagementPrediction,
    required this.trendingTopics,
    required this.engagementMetrics,
  }) : super(key: key);

  @override
  State<AIInsightsPanel> createState() => _AIInsightsPanelState();
}

class _AIInsightsPanelState extends State<AIInsightsPanel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -10 && !_isExpanded) {
          _expandPanel();
        } else if (details.delta.dy > 10 && _isExpanded) {
          _collapsePanel();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isExpanded ? 70.h : 12.h,
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildPanelHandle(),
            if (_isExpanded)
              _buildExpandedContent()
            else
              _buildCollapsedContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelHandle() {
    return GestureDetector(
      onTap: () {
        if (_isExpanded) {
          _collapsePanel();
        } else {
          _expandPanel();
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    gradient: AppTheme.aiGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'psychology',
                        color: Colors.white,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'AI Insights',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName:
                      _isExpanded ? 'keyboard_arrow_down' : 'keyboard_arrow_up',
                  color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickMetric(
            'Sentiment',
            '${(widget.sentimentScore * 100).toInt()}%',
            _getSentimentColor(),
            'sentiment_satisfied',
          ),
          _buildQuickMetric(
            'Engagement',
            '${widget.engagementPrediction}%',
            AppTheme.darkTheme.colorScheme.primary,
            'trending_up',
          ),
          _buildQuickMetric(
            'Trending',
            '${widget.trendingTopics.length}',
            AppTheme.accentPink,
            'local_fire_department',
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSentimentAnalysis(),
            SizedBox(height: 3.h),
            _buildEngagementChart(),
            SizedBox(height: 3.h),
            _buildTrendingTopics(),
            SizedBox(height: 3.h),
            _buildAIRecommendations(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMetric(
      String label, String value, Color color, String iconName) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 5.w,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSentimentAnalysis() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'sentiment_satisfied',
                color: _getSentimentColor(),
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Sentiment Analysis',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: widget.sentimentScore,
            backgroundColor: AppTheme.darkTheme.colorScheme.outline,
            valueColor: AlwaysStoppedAnimation<Color>(_getSentimentColor()),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getSentimentLabel(),
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: _getSentimentColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(widget.sentimentScore * 100).toInt()}% Positive',
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementChart() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'trending_up',
                color: AppTheme.darkTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Engagement Prediction',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 20.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final titles = ['Likes', 'Comments', 'Shares', 'Saves'];
                        return Text(
                          titles[value.toInt()],
                          style: AppTheme.darkTheme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingTopics() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_fire_department',
                color: AppTheme.accentPink,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Related Trending Topics',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: widget.trendingTopics.map((topic) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.accentPink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accentPink.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  topic,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.accentPink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendations() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: AppTheme.aiGradient.scale(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb',
                color: AppTheme.darkTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'AI Recommendations',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildRecommendationItem(
            'Best time to post similar content: 7-9 PM',
            'schedule',
          ),
          _buildRecommendationItem(
            'Add 2-3 more hashtags for better reach',
            'tag',
          ),
          _buildRecommendationItem(
            'Engage with comments within first hour',
            'chat',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.darkTheme.colorScheme.primary,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final metrics = ['likes', 'comments', 'shares', 'saves'];
    return metrics.asMap().entries.map((entry) {
      final index = entry.key;
      final key = entry.value;
      final value = (widget.engagementMetrics[key] ?? 0.0) * 100;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: AppTheme.darkTheme.colorScheme.primary,
            width: 6.w,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Color _getSentimentColor() {
    if (widget.sentimentScore >= 0.7) {
      return AppTheme.successGreen;
    } else if (widget.sentimentScore >= 0.4) {
      return AppTheme.warningAmber;
    } else {
      return AppTheme.errorRed;
    }
  }

  String _getSentimentLabel() {
    if (widget.sentimentScore >= 0.7) {
      return 'Very Positive';
    } else if (widget.sentimentScore >= 0.4) {
      return 'Neutral';
    } else {
      return 'Negative';
    }
  }

  void _expandPanel() {
    setState(() {
      _isExpanded = true;
    });
    _slideController.forward();
  }

  void _collapsePanel() {
    setState(() {
      _isExpanded = false;
    });
    _slideController.reverse();
  }
}
