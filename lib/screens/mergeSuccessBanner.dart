import 'package:darwin/models/game_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:darwin/data/app_localizations_extensions.dart';
import 'package:darwin/logic/generate_calm_color.dart';

class MergeSuccessBanner extends StatelessWidget {
  final GameItem? resultItem;
  final VoidCallback onClose;
  final BuildContext context;

  final Animation<double> opacityAnimation;
  final Animation<double> scaleAnimation;

  const MergeSuccessBanner({
    required this.context,
    required this.resultItem,
    required this.onClose,
    required this.opacityAnimation,
    required this.scaleAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameItem = resultItem!.id;

    return AnimatedBuilder(
      animation: Listenable.merge([opacityAnimation, scaleAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.scale(scale: scaleAnimation.value, child: child),
        );
      },
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  //       'Поздравляем!',
                  AppLocalizations.of(context)!.new_level_element_title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.new_level_element_text,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 30),

                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      22,
                    ), // Закругление углов
                    border: Border.all(
                      color: generateCalmColor(
                        resultItem!.slug,
                      ), // Цвет бордюра
                      width: 4, // Толщина бордюра (2 пикселя)
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // Закругление внутри бордюра
                    child: Image.asset(
                      resultItem!.assetPath,
                      width: 100,
                      height: 100,
                      fit:
                          BoxFit
                              .cover, // Чтобы изображение заполняло пространство
                    ),
                  ),
                ),

                //   Image.asset(resultItem!.assetPath, width: 100, height: 100),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.getString(context, nameItem),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.new_level_element_button_text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
