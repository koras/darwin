import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:darwin/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _sendTestNotification() {
    // Здесь будет логика отправки тестового уведомления
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.testNotificationSent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text('settings')),
      body: ListView(
        children: [
          // Настройка языка
          ListTile(
            title: Text('Язык'),
            trailing: DropdownButton<Locale>(
              value: appState?._locale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  appState?.setLocale(newLocale);
                }
              },
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
              ],
            ),
          ),
          const Divider(),

          // Настройка звука
          ListTile(
            title: Text('Звук'),
            trailing: Switch(
              value: appState?._soundEnabled ?? true,
              onChanged: (bool value) {
                appState?.toggleSound();
              },
            ),
          ),
          const Divider(),

          // Кнопка тестового уведомления
          ListTile(
            title: Text('sendTestNotification'),
            trailing: IconButton(
              icon: const Icon(Icons.notification_add),
              onPressed: _sendTestNotification,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
