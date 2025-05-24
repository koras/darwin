import 'package:flutter/material.dart'; // Для использования firstWhereOrNull

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darwin/data/merge_rule.dart';
import 'package:darwin/bloc/level_bloc.dart';

class HintManager {
  final BuildContext context;
  final List<MergeRule> mergeRules;

  HintManager(this.context, this.mergeRules);

  // Находит элемент, которого нет в открытых подсказках
  String? findUnusedHint() {
    print('--------------findUnusedHint--------------------------------------');
    print('Находит элемент, которого нет в открытых подсказках  ');
    final state = context.read<LevelBloc>().state;
    final discoveredItemsLevel = state.discoveredItemsLevel;
    // Элементы которые
    // final availableItems = state.availableItems;

    discoveredItemsLevel.forEach((item) {
      print('Item: $item');
    });

    for (final hint in state.hints) {
      if (!discoveredItemsLevel.contains(hint)) {
        print('hint  = $hint');

        return hint;
      }
    }
    return null;
  }

  // Находит правила слияния для указанного элемента
  List<MergeRule> findMergeRulesForItem(String targetItemId) {
    return mergeRules
        .where((rule) => rule.resultImageId == targetItemId)
        .toList();
  }

  /// Находит компоненты для создания указанного элемента
  List<String>? findComponentsForItem(String targetItemId) {
    final rules = findMergeRulesForItem(targetItemId);
    if (rules.isEmpty) return null;

    final rule = rules.first;
    return [rule.firstImageId, rule.secondImageId, rule.resultImageId];
  }

  /// Возвращает все возможные комбинации для создания элемента
  List<List<String>> findAllComponentOptions(String targetItemId) {
    return findMergeRulesForItem(targetItemId)
        .map(
          (rule) => [rule.firstImageId, rule.secondImageId, rule.resultImageId],
        )
        .toList();
  }

  /// Обрабатывает логику показа подсказки
  /// Здесь надо найти элемент который покажем
  ///
  Future<Map<String, String>?> showHint() async {
    final element = findUnusedHint();
    if (element == null) return null;

    context.read<LevelBloc>().add(SetHintItem(element));
    final components = findComponentsForItem(element);

    if (components != null) {
      return {
        'item1': components[0],
        'item2': components[1],
        'result': components[2],
      };
    }
    return null;
  }
}
