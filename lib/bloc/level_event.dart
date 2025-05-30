// level_event.dart
part of 'level_bloc.dart';

abstract class LevelEvent {}

class LoadLevelEvent extends LevelEvent {
  final int levelId;
  final String title;
  final String result;
  final List<String> hints;
  final List<String> imageItems;
  final String background;
  final int freeHints;
  final int timeHintWait;

  LoadLevelEvent(
    this.levelId,
    this.title,
    this.result,
    this.hints,
    this.imageItems,
    this.background,
    this.freeHints,
    this.timeHintWait,
  );
}

/// Событие обнаружения нового предмета
class ItemDiscoveredEvent extends LevelEvent {
  final String itemId;
  ItemDiscoveredEvent({required this.itemId});
}

class LevelCompletedEvent extends LevelEvent {
  final BuildContext context;
  LevelCompletedEvent({required this.context});
}

class LevelFailedEvent extends LevelEvent {}

/// ожидание подсказки
class WaitingHint extends LevelEvent {}

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

// Добавляем новое событие
class ShowLevelCompleteEvent extends LevelEvent {
  final String itemId;
  ShowLevelCompleteEvent({required this.itemId});
}

class ClearGameFieldEvent extends LevelEvent {}

// убираем подсказку
class DecrementHint extends LevelEvent {}

// Событие покупки подсказок
// Событие отметки подсказки как использованной
class MarkHintUsedEvent extends LevelEvent {
  final String itemId;
  MarkHintUsedEvent(this.itemId);
}

// Событие отметки подсказки как использованной
class ClearActiveHintEvent extends LevelEvent {}

// Событие отметки подсказки как использованной
class UseHintEvent extends LevelEvent {}

// Событие отметки подсказки
class SetHintEvent extends LevelEvent {}

// какой элемент надо найти чтобы диактивировать подсказку
class SetHintItem extends LevelEvent {
  final String currentHint;

  SetHintItem(this.currentHint);
}

// Таймер обновления оставшегося времени
class HintTimerTicked extends LevelEvent {}

class BuyHintsEvent extends LevelEvent {
  final int count;
  BuyHintsEvent(this.count);
}

class RestorePurchasesEvent extends LevelEvent {}

class IAPInitializedEvent extends LevelEvent {}

class LocalChange extends LevelEvent {
  final Locale locale;
  LocalChange(this.locale);
}

class MusicChange extends LevelEvent {
  final bool soundsEnabled;
  MusicChange(this.soundsEnabled);
}
