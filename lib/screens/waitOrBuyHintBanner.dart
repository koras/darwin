import 'package:flutter/material.dart';
import 'package:darwin/models/game_item.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darwin/gen_l10n/app_localizations.dart';
import 'package:darwin/bloc/level_bloc.dart';

class WaitOrBuyHintBanner extends StatelessWidget {
  final Duration remainingTime;
  final VoidCallback onClose;

  final Function(int) onBuyHints;

  const WaitOrBuyHintBanner({
    super.key,

    required this.remainingTime,
    required this.onClose,
    required this.onBuyHints,
  });

  @override
  Widget build(BuildContext context) {
    final purchaseOptions = [
      _PurchaseOption(3, const Color.fromARGB(255, 214, 228, 253)),
      _PurchaseOption(5, const Color.fromARGB(255, 220, 240, 221)),
      _PurchaseOption(10, const Color.fromARGB(255, 255, 250, 201)),
      _PurchaseOption(20, const Color.fromARGB(255, 202, 201, 255)),
    ];

    return _buildContent(context, purchaseOptions);
  }

  Widget _buildContent(BuildContext context, List<_PurchaseOption> options) {
    // Получаем данные элементов
    // Форматируем оставшееся время
    final timeText = context.read<LevelBloc>().state.timeStr ?? '';
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                AppLocalizations.of(context)!.hint_until_next_free,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Таймер
              Text(
                timeText,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 20),
              // Комбинация элементов (как в оригинальном баннере)
              // Текст предложения купить
              Text(
                AppLocalizations.of(context)!.or_buy_a_hint,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 15),

              // Кнопки покупки подсказок
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildPurchaseOption(
                    context,
                    option.count,
                    _getCost(context, option.count),
                    option.color,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Кнопка закрытия
              TextButton(
                onPressed: onClose,
                child: Text(
                  AppLocalizations.of(context)!.continueWithoutHints,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 25, 82, 32),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseOption(
    BuildContext context,
    int count,
    String price,
    //VoidCallback onPressed,
    Color color,
  ) {
    final textInfo = AppLocalizations.of(context)!.hints_left(count);

    return SizedBox(
      width:
          MediaQuery.of(context).size.width * 0.8, // Задаем ширину 80% экрана
      child: ElevatedButton(
        onPressed:
            () => {
              print('попытка купить $count'),

              context.read<LevelBloc>().add(BuyHintsEvent(count)),
            },
        //        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16, // Увеличили вертикальный padding
            horizontal: 24, // Добавили горизонтальный padding
          ),
          elevation: 3, // Добавили тень для кнопки
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              MainAxisSize.min, // Чтобы Row не растягивался на всю ширину
          children: [
            Text(
              '$textInfo - $price',
              style: const TextStyle(
                fontSize: 18, // Увеличили размер текста
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(
                  255,
                  53,
                  53,
                  53,
                ), // Белый текст для лучшей читаемости
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCost(BuildContext context, int count) {
    final String price = AppLocalizations.of(context)!.hints_cost;
    switch (count) {
      case 3:
        return '100 $price';
      case 5:
        return '200 $price';
      case 10:
        return '300 $price';
      case 20:
        return '500 $price';
      default:
        return '$count --';
    }
  }
}

// Вспомогательный класс для хранения данных о вариантах покупки
class _PurchaseOption {
  final int count;
  final Color color;

  const _PurchaseOption(this.count, this.color);
}
