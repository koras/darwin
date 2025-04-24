import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'mergeGame.dart';
import 'statisticsPage.dart';
import 'rulesPage.dart';

class StartPage extends StatelessWidget {
  final Color textColor = const Color.fromARGB(255, 122, 80, 0);
  final String appVersion = "1.0.0"; // Замените на вашу версию

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
                    'Merge game',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),

                  // Кнопка "Играть"
                  _buildRoundedButton('Играть', () {
                    // Действие при нажатии
                    print('Действие при нажатии Играть');

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MergeGame()),
                    );
                  }),
                  SizedBox(height: 20),

                  // Кнопка "Находки"
                  _buildRoundedButton('Находки', () {
                    // Действие при нажатии
                    print('Действие при нажатии Находки');
                  }),
                  // SizedBox(height: 20),

                  // // Кнопка "Статистика"
                  // _buildRoundedButton('Статистика', () {
                  //   // Действие при нажатии

                  //   print('Действие при нажатии Статистика');
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => StatisticsPage()),
                  //   );
                  // }),
                  // SizedBox(height: 20),

                  // // Кнопка "Правила"
                  // _buildRoundedButton('Правила', () {
                  //   print('Правила');
                  //   // Действие при нажатии StartPage
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => RulesPage()),
                  //   );
                  // }),
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

  Widget _buildRoundedButton(String text, VoidCallback onPressed) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: textColor, width: 2),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent, // заменили primary на backgroundColor
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
