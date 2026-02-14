import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
            Consumer<AppSettingsProvider>(
              builder: (context, settings, _) => Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('English'),
                      trailing: settings.locale == null || settings.locale!.languageCode == 'en'
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () => settings.setLocale(const Locale('en')),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('العربية'),
                      trailing: settings.locale?.languageCode == 'ar'
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () => settings.setLocale(const Locale('ar')),
                    ),
                  ],
                ),
              ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.theme,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Consumer<AppSettingsProvider>(
                    builder: (context, settings, _) => Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(l10n.themeLight),
                      leading: const Icon(Icons.light_mode),
                      trailing: settings.themeMode == ThemeMode.light
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () => settings.setThemeMode(ThemeMode.light),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(l10n.themeDark),
                      leading: const Icon(Icons.dark_mode),
                      trailing: settings.themeMode == ThemeMode.dark
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () => settings.setThemeMode(ThemeMode.dark),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(l10n.themeSystem),
                      leading: const Icon(Icons.brightness_auto),
                      trailing: settings.themeMode == ThemeMode.system
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () => settings.setThemeMode(ThemeMode.system),
                    ),
                    ],
                  ),
                ),
              ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.version,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Card(
                          child: ListTile(
                            title: Text('…'),
                          ),
                        );
                      }
                      final info = snapshot.data!;
                      final versionText =
                          '${info.version} (${info.buildNumber})';
                      return Card(
                        child: ListTile(
                          title: Text(versionText),
                          leading: const Icon(Icons.info_outline),
                        ),
                      );
                    },
                  ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  l10n.developedBy,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
