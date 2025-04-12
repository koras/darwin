import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../data/merge_rules.dart';

String? getMergeResult(String firstId, String secondId) {
  // Проверяем правила в обоих направлениях (A+B и B+A)
  final rule = mergeRules.firstWhereOrNull(
    (rule) =>
        (rule.firstImageId == firstId && rule.secondImageId == secondId) ||
        (rule.firstImageId == secondId && rule.secondImageId == firstId),
  );
  return rule?.resultImageId;
}
