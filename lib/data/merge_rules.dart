import '../models/merge_rule.dart';

final List<MergeRule> mergeRules = [
  MergeRule('water', 'water', 'cloud'),
  MergeRule('cloud', 'cloud', 'sky'),

  MergeRule('sky', 'sky', 'wind'),

  MergeRule('wind', 'water', 'morning'),

  MergeRule('morning', 'morning', 'man'),
];
