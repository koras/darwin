import 'package:flutter/material.dart';
import 'package:darwin/screens/merge_game.dart';
import 'package:darwin/screens/show_merge.dart';
import 'package:darwin/widgets/rounded_button.dart';
import 'package:darwin/gen_l10n/app_localizations.dart';

import 'package:darwin/screens/settings.dart';
import 'package:darwin/screens/feedback_screen.dart';

class MainMenu extends StatelessWidget {
  final Color textColor = const Color.fromARGB(255, 122, 80, 0);
  final String appVersion = "0.1.5"; // Замените на вашу версию

  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Название игры
                  Text(
                    'Darwin: The Beginning',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      shadows: [
                        Shadow(
                          blurRadius: 0.2,
                          color: const Color.fromARGB(255, 13, 67, 129),
                          offset: Offset(0.6, 0.2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),

                  // Кнопка "Играть"
                  buildRoundedButton(
                    AppLocalizations.of(context)!.startGame,
                    () {
                      // Действие при нажатии
                      print('Действие при нажатии Играть');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MergeGame()),
                      );
                    },
                  ),
                  SizedBox(height: 20),

                  // Кнопка "Находки"
                  buildRoundedButton(AppLocalizations.of(context)!.finds, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CombinationsPage(),
                      ),
                    );
                  }),

                  SizedBox(height: 20),
                  // Кнопка "Находки"
                  buildRoundedButton(
                    AppLocalizations.of(context)!.settings,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Settings()),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  // Кнопка "Находки"
                  buildRoundedButton(
                    AppLocalizations.of(context)!.writeToUs,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackScreen(),
                        ),
                      );
                    },
                  ),
                  // SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Версия приложения в правом нижнем углу
          Positioned(
            right: 16,
            bottom: 16,
            child: Text(
              'v$appVersion',
              style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
