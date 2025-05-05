// level_event.dart
part of 'level_bloc.dart';

abstract class LevelEvent {}

class LoadLevelEvent extends LevelEvent {
  final int levelId;
  LoadLevelEvent(this.levelId);
}

/// Событие обнаружения нового предмета
class ItemDiscoveredEvent extends LevelEvent {
  final String itemId;
  ItemDiscoveredEvent({required this.itemId});
}

class LevelCompletedEvent extends LevelEvent {}

class LevelFailedEvent extends LevelEvent {}

class ResetDiscoveryBannerEvent extends LevelEvent {}

/// Событие очистки последнего обнаруженного предмета
class ClearDiscoveryEvent extends LevelEvent {}

/// Событие добавления игровых предметов на поле
class AddGameItemsEvent extends LevelEvent {
  final List<GameItem> items;

  AddGameItemsEvent({required this.items});
}

class RemoveGameItemsEvent extends LevelEvent {
  final List<GameItem> items;

  RemoveGameItemsEvent({required this.items});
}

// events.dart
class MergeItemsEvent extends LevelEvent {
  final List<GameItem> itemsToRemove;
  final GameItem itemToAdd;

  MergeItemsEvent({required this.itemsToRemove, required this.itemToAdd});
}
