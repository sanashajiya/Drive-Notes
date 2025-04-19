
import 'package:drive_notes/models/note_model.dart';
import 'package:drive_notes/providers/auth_state_provider.dart';
import 'package:drive_notes/screens/add_new_entry.dart';
import 'package:drive_notes/screens/modify_entry_screen.dart';
import 'package:drive_notes/screens/main_screen.dart';
import 'package:drive_notes/screens/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteFileAdapter());
  await Hive.openBox<NoteFile>('notesBox');
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'root',
      builder: (context, state) => const _AuthGate(),
    ),
    GoRoute(
      path: '/create',
      name: 'createNote',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const CreateNoteScreen(),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/edit',
      name: 'editNote',
      pageBuilder: (context, state) {
        final noteFile = state.extra as NoteFile;
        return CustomTransitionPage(
          child: EditNoteScreen(noteFile: noteFile),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),
  ],
);

final kLightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurpleAccent,
  brightness: Brightness.light,
);

final kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 100, 193, 255),
  brightness: Brightness.dark,
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat',
        colorScheme: kLightColorScheme,
        scaffoldBackgroundColor: const Color(0xFFF7F6FB),
        appBarTheme: AppBarTheme(
          backgroundColor: kLightColorScheme.primary,
          foregroundColor: kLightColorScheme.onPrimary,
          elevation: 4,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: Colors.deepPurple.shade100,
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kLightColorScheme.primary,
          foregroundColor: kLightColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat',
        colorScheme: kDarkColorScheme,
        scaffoldBackgroundColor: const Color(0xFF101417),
        appBarTheme: AppBarTheme(
          backgroundColor: kDarkColorScheme.surfaceVariant,
          foregroundColor: kDarkColorScheme.onSurface,
          elevation: 4,
        ),
        cardTheme: CardTheme(
          color: kDarkColorScheme.surfaceVariant,
          shadowColor: Colors.black45,
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kDarkColorScheme.primary,
          foregroundColor: kDarkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      title: 'Drive Notes',
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) => user == null ? const WelcomeScreen() : const MainScreen(),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}