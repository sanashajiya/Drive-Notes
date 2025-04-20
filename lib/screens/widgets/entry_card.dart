import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drive_notes/models/note_model.dart';
import 'package:drive_notes/providers/entry_state_notifier.dart';

class NoteTile extends ConsumerWidget {
  final NoteFile file;
  final VoidCallback onTap;

  const NoteTile({
    super.key,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final iconColor = colorScheme.primary;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        color: cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          onLongPress: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Note'),
                content: const Text('Do you really want to remove this note?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await ref.read(driveFilesProvider.notifier).deleteFile(file.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted successfully')),
              );
            }
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(
                Icons.sticky_note_2_outlined,
                color: iconColor,
                size: 22,
              ),
            ),
            title: Text(
              file.name.endsWith('.txt')
                  ? file.name.replaceAll(RegExp(r'\.txt$'), '')
                  : file.name,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: iconColor),
          ),
        ),
      ),
    );
  }
}
