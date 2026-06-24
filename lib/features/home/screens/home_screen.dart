import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/features/favorites/screens/favorites_screen.dart';
import 'package:snapnotes/features/notes/screens/create_note_screen.dart';
import 'package:snapnotes/features/notes/screens/note_detail_screen.dart';
import 'package:snapnotes/providers/dashboard_notifier.dart';
import 'package:snapnotes/providers/navigation_provider.dart';

import '../../../widgets/app_action_card.dart';
import '../../../widgets/app_empty_state.dart';
import '../../../widgets/app_section_header.dart';
import '../../../widgets/app_stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _messages = [
    'Capture ideas. Organize knowledge.',
    'Scan documents in seconds.',
    'Your second brain, offline.',
    'Never lose important notes again.',
    'Turn paper into searchable notes.',
  ];
  int _currentMessageIndex = 0;

  late final Timer _timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardNotifier>().loadDashboard();
    });
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      setState(() {
        _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
      });
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning ☀️';
    }

    if (hour < 17) {
      return 'Good Afternoon 🌤️';
    }

    return 'Good Evening 🌙';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardNotifier>();
    debugPrint('Recent Notes Count: ${dashboardProvider.recentNotes.length}');
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SnapNotes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Offline OCR Notes',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<DashboardNotifier>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors:
                                Theme.of(context).brightness == Brightness.dark
                                ? [
                                    const Color(0xFF134E4A),
                                    const Color(0xFF0F172A),
                                  ]
                                : [
                                    const Color(0xFF14B8A6),
                                    const Color(0xFF06B6D4),
                                  ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting(),
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                            const SizedBox(height: 12),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 900),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, .3),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                _messages[_currentMessageIndex],
                                key: ValueKey(_currentMessageIndex),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: .95,
                                      ),
                                      height: 1.4,
                                    ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0F766E),
                              ),
                              onPressed: () {
                                context.read<NavigationProvider>().changeIndex(
                                  2,
                                );
                              },
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: const Text('Scan Now'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Stats Section
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: 'Notes',
                          value: provider.totalNotes.toString(),
                          icon: Icons.note_alt_outlined,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: AppStatCard(
                          title: 'Collections',
                          value: provider.totalCollections.toString(),
                          icon: Icons.folder_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: 'Favorites',
                          value: provider.totalFavorites.toString(),
                          icon: Icons.star_outline,
                        ),
                      ),

                      const Spacer(),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Quick Actions Header
                  AppSectionHeader(title: 'Quick Actions'),

                  const SizedBox(height: 12),

                  /// Quick Actions
                  Row(
                    children: [
                      AppActionCard(
                        title: 'Scan',
                        icon: Icons.camera_alt_outlined,
                        onTap: () {
                          context.read<NavigationProvider>().changeIndex(2);
                        },
                      ),

                      const SizedBox(width: 12),

                      AppActionCard(
                        title: 'Favorites',
                        icon: Icons.star_outline,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FavoritesScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 12),

                      AppActionCard(
                        title: 'Create',
                        icon: Icons.edit_note_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateNoteScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Text(
                        'Recent Notes',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const Spacer(),

                      TextButton(
                        onPressed: () {
                          context.read<NavigationProvider>().changeIndex(1);
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (dashboardProvider.recentNotes.isEmpty)
                    const AppEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dashboardProvider.recentNotes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final note = dashboardProvider.recentNotes[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NoteDetailScreen(note: note),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: .08),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: .12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.note_alt_outlined,
                                        size: 20,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),

                                    const Spacer(),

                                    if (note.isFavorite)
                                      const Icon(Icons.star_rounded, size: 20),

                                    const SizedBox(width: 8),

                                    const Icon(Icons.chevron_right),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  note.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  note.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        height: 1.4,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),

                                const SizedBox(height: 14),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      '${note.updatedAt.day}/${note.updatedAt.month}/${note.updatedAt.year}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
