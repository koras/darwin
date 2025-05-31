import 'package:flutter/material.dart';
import 'package:darwin/screens/main_menu.dart';
import 'package:darwin/screens/show_merge.dart';
import 'package:darwin/screens/settings.dart';
import 'package:darwin/constants/icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darwin/bloc/level_bloc.dart';
import 'package:darwin/screens/feedback_screen.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        height: 70, // Увеличиваем высоту панели
        padding: EdgeInsets.zero,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAppBarButton(
              icon: IconsGame.home,
              color: Colors.blue.shade700,

              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainMenu()),
                  ),
            ),
            _buildAppBarButton(
              icon: IconsGame.showMerge,
              color: Colors.green.shade700,

              onPressed: () {
                final currentState = context.read<LevelBloc>().state;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CombinationsPage()),
                );
              },
            ),
            _buildAppBarButton(
              icon: IconsGame.settings,
              color: Colors.green.shade700,

              onPressed: () {
                final currentState = context.read<LevelBloc>().state;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarButton({
    required String icon,
    required Color color,

    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2), // Бордюр
            ),
            child: ClipOval(
              // Обрезает изображение по кругу
              child: Image.asset(
                icon,
                fit: BoxFit.cover, // Заполняет круг, обрезая лишнее
              ),
            ),
          ),
        ),
      ],
    );
  }
}
