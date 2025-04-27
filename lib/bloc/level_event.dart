// level_event.dart
part of 'level_bloc.dart';

abstract class LevelEvent {}

class LoadLevelEvent extends LevelEvent {
  final int levelId;
  LoadLevelEvent(this.levelId);
}

class ItemDiscoveredEvent extends LevelEvent {
  final String itemId;
  ItemDiscoveredEvent({required this.itemId});
}

class LevelCompletedEvent extends LevelEvent {}

class LevelFailedEvent extends LevelEvent {}

class ResetDiscoveryBannerEvent extends LevelEvent {}
