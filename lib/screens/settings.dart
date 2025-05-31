import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darwin/gen_l10n/app_localizations.dart';
import 'package:darwin/bloc/level_bloc.dart';
import 'package:darwin/screens/main_menu.dart';
import 'package:darwin/widgets/bottom_app_bar_widget.dart';
import 'package:darwin/widgets/rounded_button.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:darwin/main.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  void _sendTestNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.testNotificationSent),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomAppBar(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0, // Убираем тень
      ),
      extendBodyBehindAppBar: true, // Чтобы фон был под AppBar
      body: Stack(
        children: [
          // Фоновая картинка
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background.png',
                ), // Укажите путь к вашему изображению
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Основное содержимое
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const Spacer(),

                // Основное содержимое настроек
                BlocBuilder<LevelBloc, LevelState>(
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.8,
                        ), // Полупрозрачный белый фон
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.settings,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildLanguageTile(context, state),
                          const Divider(height: 40),

                          _buildSoundTile(context, state),
                          const Divider(height: 40),

                          // _buildNotificationTile(context),
                          // const Divider(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildBackButton(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const Spacer(),
                const Spacer(),

                // Кнопка "Назад"
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20),
                //   child: _buildBackButton(context),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, LevelState state) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.language),
      trailing: DropdownButton<Locale>(
        value: state.locale,
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            // Просто отправляем событие в Bloc - он сам сохранит состояние
            context.read<LevelBloc>().add(LocalChange(newLocale));

            // Для немедленного обновления интерфейса
            // (MaterialApp уже слушает изменения через context.select)
          }
        },
        items:
            AppLocalizations.supportedLocales.map((Locale locale) {
              final languageName =
                  locale.languageCode == 'en' ? 'English' : 'Русский';
              return DropdownMenuItem(value: locale, child: Text(languageName));
            }).toList(),
      ),
    );
  }

  Widget _buildSoundTile(BuildContext context, LevelState state) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.volume_up, size: 28),
      title: Text(
        AppLocalizations.of(context)!.sound,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: Switch.adaptive(
        value: state.soundsEnabled,
        onChanged: (bool value) {
          context.read<LevelBloc>().add(MusicChange(value));
        },
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.notifications, size: 28),
      title: Text(
        AppLocalizations.of(context)!.testNotification,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.send),
        onPressed: () => _sendTestNotification(context),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white.withOpacity(0.8),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainMenu()),
          );
        },
        child: Text(
          AppLocalizations.of(context)!.backToMenu,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
