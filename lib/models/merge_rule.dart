import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MergeRule {
  final String firstImageId;
  final String secondImageId;
  final String resultImageId;

  MergeRule(this.firstImageId, this.secondImageId, this.resultImageId);
}
