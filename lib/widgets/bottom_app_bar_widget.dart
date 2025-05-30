import 'package:flutter/material.dart';
import 'package:darwin/screens/mainMenu.dart';
import 'package:darwin/screens/showMerge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darwin/bloc/level_bloc.dart';
import 'package:darwin/screens/feedback_screen.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade400, width: 2)),
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCustomIconButton(
              icon: Icons.home,
              color: Colors.blue.shade700,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StartPage()),
                  ),
            ),

            _buildCustomIconButton(
              icon: Icons.list_alt,
              color: Colors.green.shade700,
              onPressed: () {
                final currentState = context.read<LevelBloc>().state;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CombinationsPage(
                          discoveredItems: currentState.discoveredItems,
                        ),
                  ),
                );
              },
            ),

            _buildCustomIconButton(
              icon: Icons.feedback,
              color: Colors.orange.shade700,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()),
                  ),
            ),

            _buildCustomIconButton(
              icon: Icons.volume_off,
              color: Colors.red.shade700,
              onPressed: () {}, // Пустой обработчик, но он обязателен
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed, // Параметр обязателен
  }) {
    return IconButton(
      onPressed: onPressed, // Передаем в IconButton
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.2),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
