import 'package:drive_notes/providers/file_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateNoteScreen extends ConsumerStatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  ConsumerState<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends ConsumerState<CreateNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isSaving = false;

  void _saveNote() async {
    final title = _titleController.text.trim().isEmpty ? 'Untitled' : _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final driveService = ref.read(driveFilesProvider.notifier).driveService;
    await driveService.uploadNote(content, title);
    await ref.read(driveFilesProvider.notifier).refreshFiles();

    setState(() => _isSaving = false);
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved successfully')),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekday = _formatWeekday(now);
    final date = _formatDate(now);
    final time = _formatTime(now);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
        leading: const BackButton(),
        actions: [
          IconButton(
            key: const Key('saveButton'),
            icon: const Icon(Icons.check_rounded),
            onPressed: _isSaving ? null : _saveNote,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Time Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$date, $weekday',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            TextField(
              key: const Key('titleField'),
              controller: _titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),

            const Divider(),

            // Content
            Expanded(
              child: TextField(
                key: const Key('contentField'),
                controller: _contentController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatWeekday(DateTime dt) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[dt.weekday % 7].toUpperCase();
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')} ${_monthToString(dt.month)} ${dt.year}';
  }

  String _monthToString(int month) {
    const months = [
      '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return months[month];
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'pm' : 'am';
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min $ampm';
  }
}
