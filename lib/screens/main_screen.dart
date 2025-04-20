import 'package:drive_notes/providers/entry_state_notifier.dart';
import 'package:drive_notes/screens/widgets/entry_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(driveFilesProvider);
    // final driveService = ref.watch(driveFilesProvider.notifier).driveService;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Notes"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: filesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (files) {
          if (files.isEmpty) {
            return const Center(
                child: Text("DriveNotes folder is currently empty."));
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ListView.builder(
              itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + (index * 40)),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 30),
                  child: child,
                ),
              );
            },
            child: NoteTile(
              file: file,
              onTap: () {
                context.pushNamed('editNote', extra: file);
              },
            ),
          );
        }


            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('createNote');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
