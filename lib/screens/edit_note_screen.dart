import 'package:drive_notes/models/note_file.dart';
import 'package:drive_notes/providers/file_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  final NoteFile noteFile;

  const EditNoteScreen({super.key, required this.noteFile});

  @override
  ConsumerState<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final initialTitle = widget.noteFile.name.replaceAll(RegExp(r'\.txt$'), '') ?? 'Untitled';
    _titleController.text = initialTitle;
    _loadNoteContent();
  }

  void _loadNoteContent() async {
    final driveService = ref.read(driveFilesProvider.notifier).driveService;
    final content = await driveService.downloadNoteContent(widget.noteFile.id);
    _contentController.text = content;
    setState(() => _isLoading = false);
  }

  void _saveNote() async {
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final driveService = ref.read(driveFilesProvider.notifier).driveService;
    final newTitle = _titleController.text.trim().isEmpty ? 'Untitled' : _titleController.text.trim();

    await driveService.updateNote(
      widget.noteFile.id,
      _contentController.text,
      newTitle: newTitle,
    );

    await ref.read(driveFilesProvider.notifier).refreshFiles();

    setState(() => _isSaving = false);
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note updated')),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timestamp = '${_formatWeekday(now)}, ${_formatDate(now)} at ${_formatTime(now)}';

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
            icon: const Icon(Icons.check_rounded),
            onPressed: _isSaving ? null : _saveNote,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                  // Timestamp + char count
                  Text(
                    '$timestamp  •  ${_contentController.text.length} characters',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  TextField(
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
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      decoration: const InputDecoration(
                        hintText: 'Keep writing...',
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
    return days[dt.weekday % 7];
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
