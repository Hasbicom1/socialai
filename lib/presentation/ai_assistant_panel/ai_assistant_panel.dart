import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_avatar_widget.dart';
import './widgets/chat_bubble_widget.dart';
import './widgets/quick_action_buttons_widget.dart';
import './widgets/smart_reply_chips_widget.dart';
import './widgets/typing_indicator_widget.dart';
import './widgets/voice_input_button_widget.dart';

class AiAssistantPanel extends StatefulWidget {
  const AiAssistantPanel({Key? key}) : super(key: key);

  @override
  State<AiAssistantPanel> createState() => _AiAssistantPanelState();
}

class _AiAssistantPanelState extends State<AiAssistantPanel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _blurController;
  late Animation<double> _slideAnimation;
  late Animation<double> _blurAnimation;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  bool _isProcessing = false;
  bool _isTyping = false;
  double _panelHeight = 70.0;

  // Mock conversation data
  final List<Map<String, dynamic>> _conversationHistory = [
    {
      "message":
          "Hello! I'm your AI assistant. I can help you with social media management, content creation, and trend analysis. What would you like to do today?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      "message": "Can you help me find the best time to post on Instagram?",
      "isUser": true,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 4)),
    },
    {
      "message":
          "Based on your audience analytics, the optimal posting times for Instagram are:\n\n• Weekdays: 11 AM - 1 PM and 7 PM - 9 PM\n• Weekends: 10 AM - 12 PM and 2 PM - 4 PM\n\nYour audience is most active on Wednesdays and Saturdays. Would you like me to schedule your next post?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 3)),
    },
  ];

  final List<String> _smartSuggestions = [
    "Analyze trending hashtags",
    "Generate caption ideas",
    "Check engagement metrics",
    "Schedule next post",
    "Find viral content",
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startPanelAnimation();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _blurController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _blurAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _blurController,
      curve: Curves.easeOut,
    ));
  }

  void _startPanelAnimation() {
    _slideController.forward();
    _blurController.forward();
    HapticFeedback.mediumImpact();
  }

  void _dismissPanel() {
    _slideController.reverse().then((_) {
      _blurController.reverse().then((_) {
        Navigator.of(context).pop();
      });
    });
    HapticFeedback.lightImpact();
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _conversationHistory.add({
        "message": message,
        "isUser": true,
        "timestamp": DateTime.now(),
      });
      _isProcessing = true;
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI processing
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() => _isTyping = false);
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        _conversationHistory.add({
          "message": _generateAIResponse(message),
          "isUser": false,
          "timestamp": DateTime.now(),
        });
        _isProcessing = false;
      });
      _scrollToBottom();
      HapticFeedback.selectionClick();
    });
  }

  String _generateAIResponse(String userMessage) {
    final responses = [
      "I've analyzed your request and here are my recommendations based on current trends and your audience engagement patterns.",
      "Great question! Based on your social media analytics, I can provide you with personalized insights to boost your engagement.",
      "I've processed the latest data from your connected platforms. Here's what I found that could help optimize your content strategy.",
      "Perfect timing! I've been monitoring your account performance and have some actionable suggestions for you.",
      "I understand what you're looking for. Let me provide you with AI-powered insights to enhance your social media presence.",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleVoiceInput(String voiceText) {
    _sendMessage(voiceText);
  }

  void _handleSuggestionTap(String suggestion) {
    _sendMessage(suggestion);
  }

  void _schedulePost() {
    _sendMessage("Help me schedule a post for optimal engagement");
  }

  void _analyzeTrends() {
    _sendMessage("Show me the latest trending topics in my niche");
  }

  void _generateCaptions() {
    _sendMessage("Generate creative captions for my next post");
  }

  void _summarizeContent() {
    _sendMessage("Summarize the top performing content from this week");
  }

  @override
  void dispose() {
    _slideController.dispose();
    _blurController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _blurAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: AppTheme.overlayDark.withValues(alpha: 0.6),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: GestureDetector(
                onTap: _dismissPanel,
                child: Container(
                  color: Colors.transparent,
                  child: AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 100.h),
                          child: _buildPanelContent(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPanelContent() {
    return GestureDetector(
      onTap: () {}, // Prevent dismissal when tapping panel
      child: Container(
        height: _panelHeight.h,
        decoration: BoxDecoration(
          color: AppTheme.backgroundDeep,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: AppTheme.floatingShadow,
        ),
        child: Column(
          children: [
            _buildPanelHeader(),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildConversationArea()),
                  SmartReplyChipsWidget(
                    suggestions: _smartSuggestions,
                    onSuggestionTap: _handleSuggestionTap,
                  ),
                  QuickActionButtonsWidget(
                    onSchedulePost: _schedulePost,
                    onAnalyzeTrends: _analyzeTrends,
                    onGenerateCaptions: _generateCaptions,
                    onSummarizeContent: _summarizeContent,
                  ),
                  _buildInputArea(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelHeader() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _panelHeight = (_panelHeight -
                  (details.delta.dy / MediaQuery.of(context).size.height * 100))
              .clamp(50.0, 90.0);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AiAvatarWidget(isProcessing: _isProcessing),
                SizedBox(width: 4.w),
                Text(
                  'AI Assistant',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.w),
                VoiceInputButtonWidget(
                  onVoiceInput: _handleVoiceInput,
                  isEnabled: !_isProcessing,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationArea() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundElevated.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _conversationHistory.length,
              itemBuilder: (context, index) {
                final chat = _conversationHistory[index];
                return ChatBubbleWidget(
                  message: chat["message"] as String,
                  isUser: chat["isUser"] as bool,
                  timestamp: chat["timestamp"] as DateTime,
                );
              },
            ),
          ),
          TypingIndicatorWidget(isVisible: _isTyping),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundElevated,
        border: Border(
          top: BorderSide(color: AppTheme.borderSubtle, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDeep,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderSubtle, width: 1),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _messageFocusNode,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask me anything about your social media...',
                    hintStyle:
                        AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _sendMessage,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () => _sendMessage(_messageController.text),
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryAIBlue,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'send',
                    color: AppTheme.textPrimary,
                    size: 5.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}