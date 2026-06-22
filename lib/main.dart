import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/core/di/service_locator.dart';
import 'package:snapnotes/providers/collection_provider.dart';
import 'package:snapnotes/providers/dashboard_notifier.dart';
import 'package:snapnotes/providers/note_notifier.dart';
import 'package:snapnotes/providers/ocr_notifier.dart';
import 'package:snapnotes/providers/scan_notifier.dart';
import 'package:snapnotes/providers/search_notifier.dart';

import 'core/theme/app_theme.dart';
import 'database/isar/isar_service.dart';
import 'features/navigation/screens/main_navigation_screen.dart';
import 'providers/navigation_provider.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarService.instance;
  await setupDependencies();

  runApp(const SnapNotesApp());
}

class SnapNotesApp extends StatelessWidget {
  const SnapNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardNotifier = DashboardNotifier(getIt(), getIt(), getIt());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        ChangeNotifierProvider(create: (_) => NavigationProvider()),

        ChangeNotifierProvider(create: (_) => dashboardNotifier),

        ChangeNotifierProvider(
          create: (_) =>
              CollectionNotifier(getIt(), getIt(), getIt(), dashboardNotifier),
        ),

        ChangeNotifierProvider(
          create: (_) => NoteNotifier(
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            dashboardNotifier,
            getIt(),
            getIt(),
            getIt(),
          ),
        ),

        ChangeNotifierProvider(create: (_) => ScanNotifier()),

        ChangeNotifierProvider(create: (_) => OcrNotifier()),

        ChangeNotifierProvider(create: (_) => SearchNotifier(getIt())),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnapNotes',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeProvider.themeMode,
      home: const MainNavigationScreen(),
    );
  }
}
