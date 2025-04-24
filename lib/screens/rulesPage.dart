import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Правила игры'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                _buildRuleSection(
                  'Основная цель',
                  'Создавайте артефакты, соеденяя одни эелементы с другими.'
                      'Откройте все возможные артефакты в игре',
                ),
                _buildRuleSection(
                  'Как играть',
                  'На игровой панели отображается набор артефактов\n'
                      'Комбинируйте элементы, чтобы создать новые\n. Для этого переносите их по одному на игровое поле.\n'
                      'Соеденяя элементы вы можете создавать новые артефакты\n',
                ),
                _buildRuleSection(
                  'Баллы',
                  '• В начале каждой игры даётся 300 баллов\n'
                      '• Каждый предмет(артефакт) дает разное количество очков\n'
                      '• Каждая подсказка отнимает 15 баллов\n'
                      '• Каждая минута игры отнимает 1 балл, но не более 20 баллов\n',
                ),
                _buildRuleSection(
                  'Советы для новичков',
                  '⏱️ Сначала собирайте легкодоступные предметы\n'
                      '🧠 Запоминайте связь ценных артефактов\n'
                      '🔄 Не зацикливайтесь на одном сложном предмете',
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Удачи в игре! 🎮',
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color.fromARGB(255, 15, 13, 13),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleSection(String title, String content) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
