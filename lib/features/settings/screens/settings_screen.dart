import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapnotes/providers/app_info_provider.dart';
import 'package:snapnotes/providers/dashboard_notifier.dart';

import '../../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final appInfo = context.watch<AppInfoProvider>();
    final dashboard = context.watch<DashboardNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: .75),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: 32,
                ),

                const SizedBox(height: 16),

                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Customize your SnapNotes experience',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _SettingsCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark themes'),
              secondary: const Icon(Icons.dark_mode_outlined),
              value: themeProvider.isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
            ),
          ),

          const SizedBox(height: 16),

          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Version'),
              subtitle: Text(
                appInfo.version.isEmpty ? 'Loading...' : appInfo.version,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _SettingsCard(
            child: Column(
              children: [
                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(
                      Icons.storage_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      'Storage Statistics',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _buildStatRow(
                  context,
                  Icons.note_alt_outlined,
                  'Notes',
                  dashboard.totalNotes.toString(),
                ),

                const SizedBox(height: 12),

                _buildStatRow(
                  context,
                  Icons.folder_outlined,
                  'Collections',
                  dashboard.totalCollections.toString(),
                ),

                const SizedBox(height: 12),

                _buildStatRow(
                  context,
                  Icons.star_outline,
                  'Favorites',
                  dashboard.totalFavorites.toString(),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const _SettingsCard(
            child: ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy'),
              subtitle: Text('Everything stays on your device'),
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              'Made with Flutter ❤️',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: .08),
        ),
      ),
      child: child,
    );
  }
}

Widget _buildStatRow(
  BuildContext context,
  IconData icon,
  String title,
  String value,
) {
  return Row(
    children: [
      Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),

      const SizedBox(width: 12),

      Expanded(child: Text(title)),

      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    ],
  );
}
