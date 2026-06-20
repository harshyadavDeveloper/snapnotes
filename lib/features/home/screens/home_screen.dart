import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/providers/dashboard_notifier.dart';

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
                      AppStatCard(
                        title: 'Notes',
                        value: provider.totalNotes.toString(),
                        icon: Icons.note_alt_outlined,
                      ),

                      SizedBox(width: 12),

                      AppStatCard(
                        title: 'Collections',
                        value: provider.totalCollections.toString(),
                        icon: Icons.folder_outlined,
                      ),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Scan feature coming soon'),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 12),

                      AppActionCard(
                        title: 'Import',
                        icon: Icons.image_outlined,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Import feature coming soon'),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 12),

                      AppActionCard(
                        title: 'Create',
                        icon: Icons.edit_note_outlined,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Create Note feature coming soon'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// Recent Notes Header
                  AppSectionHeader(title: 'Recent Notes', onViewAll: () {}),

                  const SizedBox(height: 16),

                  /// Empty State
                  const AppEmptyState(),

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
