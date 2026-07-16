import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../utils/app_colors.dart';
import '../data/dummy_data.dart'; // To get dummy profiles

class DiscussionSheet extends StatefulWidget {
  final TaskModel task;
  final String role; // Current user's role

  const DiscussionSheet({
    super.key,
    required this.task,
    required this.role,
  });

  @override
  State<DiscussionSheet> createState() => _DiscussionSheetState();
}

class _DiscussionSheetState extends State<DiscussionSheet> {
  final _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeString = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    
    // Determine author name based on role
    String authorName = '';
    if (widget.role == 'Siswa') {
      authorName = '${dummyStudentProfile.name} (Siswa)';
    } else {
      authorName = dummyTeacherProfile.fullName;
    }

    setState(() {
      widget.task.comments.add(
        CommentModel(
          author: authorName,
          role: widget.role,
          text: text,
          timestamp: timeString,
        ),
      );
      _commentController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ruang Diskusi',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Chat List
          Expanded(
            child: widget.task.comments.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada diskusi.\nMulai percakapan!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.textLight,
                        fontSize: 15,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    itemCount: widget.task.comments.length,
                    itemBuilder: (context, index) {
                      final comment = widget.task.comments[index];
                      final isMe = comment.role == widget.role;
                      final isTeacher = comment.role == 'Guru';

                      return _buildChatBubble(comment, isMe, isTeacher);
                    },
                  ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16).copyWith(
              bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: GoogleFonts.inter(fontSize: 15, color: AppColors.textPrimary),
                    maxLines: 3,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendComment(),
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar...',
                      hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 15),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendComment,
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(CommentModel comment, bool isMe, bool isTeacher) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                comment.author,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isTeacher ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              if (isTeacher) ...[
                const SizedBox(width: 4),
                Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              border: isMe ? null : Border.all(color: AppColors.border),
            ),
            child: Text(
              comment.text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isMe ? Colors.white : AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            comment.timestamp,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
