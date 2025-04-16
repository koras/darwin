part of 'level_bloc.dart';

abstract class LevelEvent {}

class IncrementEvent extends LevelEvent {}

class DecrementEvent extends LevelEvent {}

class ResetEvent extends LevelEvent {}
