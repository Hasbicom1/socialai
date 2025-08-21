import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CommentsSection extends StatefulWidget {
  final String platform;
  final List<Map<String, dynamic>> comments;
  final VoidCallback onAddComment;

  const CommentsSection({
    Key? key,
    required this.platform,
    required this.comments,
    required this.onAddComment,
  }) : super(key: key);

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _showReplies = false;
  int _selectedCommentIndex = -1;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildCommentsHeader(),
          Expanded(
            child: _buildCommentsList(),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.darkTheme.colorScheme.outline,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'comment',
            color: AppTheme.darkTheme.colorScheme.onSurface,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'Comments (${widget.comments.length})',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: _getPlatformColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.platform,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: _getPlatformColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    if (widget.comments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'comment',
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No comments yet',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Be the first to comment!',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        final comment = widget.comments[index];
        return _buildCommentItem(comment, index);
      },
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment, int index) {
    final hasReplies = (comment['replies'] as List?)?.isNotEmpty ?? false;
    final isExpanded = _selectedCommentIndex == index && _showReplies;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 5.w,
                backgroundImage: NetworkImage(comment['avatar'] as String),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment['username'] as String,
                          style:
                              AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        if (comment['isVerified'] == true)
                          CustomIconWidget(
                            iconName: 'verified',
                            color: _getPlatformColor(),
                            size: 3.w,
                          ),
                        const Spacer(),
                        Text(
                          comment['timestamp'] as String,
                          style: AppTheme.darkTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      comment['text'] as String,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        _buildCommentAction(
                          'favorite_border',
                          comment['likes'].toString(),
                          () {},
                        ),
                        SizedBox(width: 4.w),
                        _buildCommentAction(
                          'reply',
                          'Reply',
                          () {
                            _commentFocusNode.requestFocus();
                          },
                        ),
                        if (hasReplies) ...[
                          SizedBox(width: 4.w),
                          _buildCommentAction(
                            isExpanded
                                ? 'keyboard_arrow_up'
                                : 'keyboard_arrow_down',
                            '${(comment['replies'] as List).length} replies',
                            () {
                              setState(() {
                                if (_selectedCommentIndex == index) {
                                  _showReplies = !_showReplies;
                                } else {
                                  _selectedCommentIndex = index;
                                  _showReplies = true;
                                }
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isExpanded && hasReplies) ...[
            SizedBox(height: 2.h),
            _buildRepliesList(comment['replies'] as List),
          ],
        ],
      ),
    );
  }

  Widget _buildRepliesList(List replies) {
    return Container(
      margin: EdgeInsets.only(left: 12.w),
      child: Column(
        children: replies.map<Widget>((reply) {
          return Container(
            margin: EdgeInsets.only(bottom: 1.5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 4.w,
                  backgroundImage: NetworkImage(reply['avatar'] as String),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reply['username'] as String,
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            reply['timestamp'] as String,
                            style: AppTheme.darkTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        reply['text'] as String,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          _buildCommentAction(
                            'favorite_border',
                            reply['likes'].toString(),
                            () {},
                          ),
                          SizedBox(width: 4.w),
                          _buildCommentAction(
                            'reply',
                            'Reply',
                            () {
                              _commentFocusNode.requestFocus();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCommentAction(
      String iconName, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            size: 4.w,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.darkTheme.colorScheme.outline,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 4.w,
              backgroundImage: const NetworkImage(
                'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: TextField(
                controller: _commentController,
                focusNode: _commentFocusNode,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.darkTheme.colorScheme.surface,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                if (_commentController.text.trim().isNotEmpty) {
                  widget.onAddComment();
                  _commentController.clear();
                  _commentFocusNode.unfocus();
                }
              },
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _commentController.text.trim().isNotEmpty
                      ? _getPlatformColor()
                      : AppTheme.darkTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomIconWidget(
                  iconName: 'send',
                  color: Colors.white,
                  size: 5.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPlatformColor() {
    switch (widget.platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0077B5);
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'whatsapp':
        return const Color(0xFF25D366);
      default:
        return AppTheme.darkTheme.colorScheme.primary;
    }
  }
}
