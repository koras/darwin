import 'package:darwin/models/game_item.dart';
import 'package:flutter/material.dart';
import 'package:darwin/data/image_item.dart';
import 'package:darwin/gen_l10n/app_localizations.dart';
import 'package:darwin/data/app_localizations_extensions.dart';

class HintBanner extends StatelessWidget {
  // final BuildContext context;
  final String item1Id;
  final String item2Id;
  final String resultId;
  final int cointHint;
  final VoidCallback onClose;

  const HintBanner({
    Key? key,
    // required this.context,
    required this.item1Id,
    required this.item2Id,
    required this.resultId,
    required this.cointHint,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String textCountHint;
    // Получаем данные элементов из вашего репозитория
    final item1new = allImages.firstWhere((i) => i.id == item1Id);
    final item1 = GameItem.fromImageItem(imageItem: item1new);

    final item2new = allImages.firstWhere((i) => i.id == item2Id);
    final item2 = GameItem.fromImageItem(imageItem: item2new);

    final resultnew = allImages.firstWhere((i) => i.id == resultId);
    final result = GameItem.fromImageItem(imageItem: resultnew);

    if (cointHint > 0) {
      final text = AppLocalizations.of(context)!.hints_left;
      textCountHint = '$text: $cointHint';
    } else {
      textCountHint = AppLocalizations.of(context)!.run_out_of_hints;
      //  textCountHint = 'У вас закончились подсказки';
    }

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              Text(
                AppLocalizations.of(context)!.hints_hints,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),

              // Комбинация элементов
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Первый элемент
                  _buildItemWidget(context, item1),

                  // Плюс
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  // Второй элемент
                  _buildItemWidget(context, item2),

                  // Равно
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      '=',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  // Результат
                  _buildItemWidget(context, result),
                ],
              ),
              const SizedBox(height: 20),

              // Кнопка закрытия
              ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.hints_good,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  textCountHint,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(BuildContext context, GameItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _generateCalmColor(item.id), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(item.assetPath, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          AppLocalizations.of(context)!.getString(context, item.id),

          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _generateCalmColor(String input) {
    final hash = input.hashCode;
    return HSLColor.fromAHSL(1.0, (hash % 360).toDouble(), 0.4, 0.7).toColor();
  }
}
