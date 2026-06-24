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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardNotifier>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardNotifier>();
    debugPrint('Recent Notes Count: ${dashboardProvider.recentNotes.length}');
    return Scaffold(
      appBar: AppBar(title: const Text('SnapNotes')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<DashboardNotifier>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Greeting
                  Text(
                    'Good Evening 👋',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Welcome to SnapNotes',
                    style: Theme.of(context).textTheme.bodyLarge,
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

                  AppSectionHeader(title: 'Recent Notes', onViewAll: () {}),

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

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.note_alt_outlined),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NoteDetailScreen(note: note),
                                ),
                              );
                            },

                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    note.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                if (note.isFavorite)
                                  const Icon(Icons.star, size: 18),
                              ],
                            ),

                            subtitle: Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            trailing: const Icon(Icons.chevron_right),
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
