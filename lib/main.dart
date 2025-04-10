import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'GameItem.dart';
import 'ImageItem.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MaterialApp(home: MergeGame()),
    );
  }
}

// ImageItem? findImageById(String id) {
//   return allImages.firstWhere((image) => image.id == id);
// }

String? getMergeResult(String firstId, String secondId) {
  // Проверяем правила в обоих направлениях (A+B и B+A)
  final rule = mergeRules.firstWhereOrNull(
    (rule) =>
        (rule.firstImageId == firstId && rule.secondImageId == secondId) ||
        (rule.firstImageId == secondId && rule.secondImageId == firstId),
  );
  return rule?.resultImageId;
}

class MergeGame extends StatefulWidget {
  @override
  _MergeGameState createState() => _MergeGameState();
}

class _MergeGameState extends State<MergeGame> {
  double _toolboxHeightPercentage = 0.3; // Начальная высота панели (30% экрана)

  // Геттер для вычисления высоты игрового поля
  double get _gameAreaHeight =>
      MediaQuery.of(context).size.height * _gameAreaPercentage;

  // Геттер для высоты панели инструментов
  double get _toolboxHeight =>
      MediaQuery.of(context).size.height * (1 - _gameAreaPercentage);

  final List<GameItem> _gameItems = [];

  final int maxItems = 20;
  final int maxSameType = 3;

  // Параметры сетки
  final int gridColumns = 5;
  final int gridRows = 5;
  late double cellSize;
  GameItem? _draggedItem;

  double _gameAreaPercentage = 0.7; // Начальная высота (70%)
  final List<ImageItem> _selectedImages = [];
  final List<ImageItem> _toolboxImages = allImages.take(5).toList();

  // Выбранные картинки для игры (например, 3 из всех)
  late List<ImageItem> gameImages;

  // Позиции и видимость
  final Map<String, Offset> positions = {};
  final Map<String, bool> isVisible = {};
  String? resultImageId;

  @override
  void initState() {
    super.initState();
    _toolboxImages.addAll(allImages.take(5));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // final screenHeight = MediaQuery.of(context).size.height;
    final toolboxHeight = screenSize.height * _toolboxHeightPercentage;

    cellSize = screenSize.width / gridColumns;

    final itemSize =
        MediaQuery.of(context).size.width / 4 -
        12; // 4 элемента в ряд с отступами

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Stack(
                children: [
                  // Сетка 5x7
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 1,
                        ),
                    itemCount: 25,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      );
                    },
                  ),

                  // Элементы на поле
                  ..._gameItems
                      .where((item) => item != _draggedItem)
                      .map((item) => _buildGameItem(item)),

                  if (_draggedItem != null) _buildDraggableItem(_draggedItem!),
                ],
              ),
            ),
          ),

          // Панель инструментов (статичные картинки)
          SizedBox(
            height: toolboxHeight,
            child: Column(
              children: [
                // Полоса для растягивания
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _toolboxHeightPercentage -=
                          details.delta.dy / screenSize.height;
                      _toolboxHeightPercentage = _toolboxHeightPercentage.clamp(
                        0.15,
                        0.4,
                      );
                    });
                  },
                  child: Container(
                    height: 24,
                    color: Colors.blueGrey[300],
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 4,
                        color: Colors.blueGrey[500],
                      ),
                    ),
                  ),
                ),

                // Скроллируемая область с фиксированными элементами
                Expanded(
                  child: Container(
                    color: Colors.blueGrey[100],
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 элемента в ряд
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1, // Квадратные элементы
                      ),
                      itemCount: _toolboxImages.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: itemSize,
                          height: itemSize,
                          child: _buildToolboxItem(
                            _toolboxImages[index],
                            itemSize,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameItem(GameItem item) {
    final posX = item.gridX * cellSize + cellSize * 0.1;
    final posY = item.gridY * cellSize + cellSize * 0.1;

    return Positioned(
      left: posX,
      top: posY,
      child: GestureDetector(
        onPanStart: (_) => _startDragging(item),
        child: Container(
          width: cellSize * 0.8,
          height: cellSize * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Image.asset(item.assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  void _startDragging(GameItem item) {
    setState(() {
      _draggedItem = item;
      item.isDragging = true;
    });
  }

  void _checkForMerge(GameItem movedItem) {
    // Проверяем соседние ячейки
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;

        final nx = movedItem.gridX + dx;
        final ny = movedItem.gridY + dy;

        if (nx >= 0 && nx < gridColumns && ny >= 0 && ny < gridRows) {
          final neighbor = _gameItems.firstWhereOrNull(
            (item) => item.gridX == nx && item.gridY == ny && !item.isDragging,
          );

          if (neighbor != null) {
            _tryMergeItems(movedItem, neighbor);
            return;
          }
        }
      }
    }
  }

  void _tryMergeItems(GameItem item1, GameItem item2) {
    final resultId = getMergeResult(item1.id, item2.id);

    if (resultId != null) {
      final resultItem = allImages.firstWhere((img) => img.id == resultId);
      final mergeX = item1.gridX;
      final mergeY = item1.gridY;

      setState(() {
        _gameItems.remove(item1);
        _gameItems.remove(item2);
        _gameItems.add(
          GameItem(
            id: resultItem.id,
            slug: resultItem.slug,
            assetPath: resultItem.assetPath,
            gridX: mergeX,
            gridY: mergeY,
          ),
        );
      });

      _showMessage('Получено: ${resultItem.slug}');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  Widget _buildDraggableItem(GameItem item) {
    final posX = item.gridX * cellSize + cellSize * 0.1;
    final posY = item.gridY * cellSize + cellSize * 0.1;

    return Positioned(
      left: posX + item.dragOffset.dx,
      top: posY + item.dragOffset.dy,
      child: GestureDetector(
        // onPanStart: (_) {
        //   setState(() {
        //     item.isDragging = true;
        //   });
        // },
        onPanUpdate: (details) {
          setState(() {
            item.dragOffset += details.delta;
          });
        },

        onPanEnd: (_) => _stopDragging(item),
        child: Container(
          width: cellSize * 0.8,
          height: cellSize * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(item.isDragging ? 0.4 : 0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Image.asset(item.assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  void _stopDragging(GameItem item) {
    setState(() {
      final posX = item.gridX * cellSize + cellSize * 0.1 + item.dragOffset.dx;
      final posY = item.gridY * cellSize + cellSize * 0.1 + item.dragOffset.dy;

      final newX = (posX / cellSize).round();
      final newY = (posY / cellSize).round();

      if (_isCellEmpty(newX, newY)) {
        item.gridX = newX;
        item.gridY = newY;
      }

      item.dragOffset = Offset.zero;
      item.isDragging = false;
      _draggedItem = null;
      _checkForMerge(item);
    });
  }

  // Сетка для визуального ориентира (необязательно)
  Widget _buildGrid(double cellSize) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
      ),
      itemCount: 25,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          final screenHeight = MediaQuery.of(context).size.height;
          _toolboxHeightPercentage -= details.delta.dy / screenHeight;
          _toolboxHeightPercentage = _toolboxHeightPercentage.clamp(0.15, 0.7);
        });
      },
      child: Container(
        height: 24,
        color: Colors.blueGrey[300],
        child: Center(
          child: Container(width: 60, height: 4, color: Colors.blueGrey[500]),
        ),
      ),
    );
  }

  //final List<ImageItem> _gameField = List.generate(35, (i) => GameCell.empty());

  void _addToGameField(ImageItem item) {
    print("Добавляем элемент ${item.id}");

    // Проверка ограничений
    if (_gameItems.length >= maxItems) {
      _showMessage('Максимум $maxItems элементов на поле');
      return;
    }

    final sameTypeCount = _gameItems.where((i) => i.id == item.id).length;
    if (sameTypeCount >= maxSameType) {
      _showMessage('Максимум $maxSameType элементов одного типа');
      return;
    }

    // Находим первую свободную ячейку
    for (int y = 0; y < gridRows; y++) {
      for (int x = 0; x < gridColumns; x++) {
        if (_isCellEmpty(x, y)) {
          setState(() {
            _gameItems.add(
              GameItem(
                id: item.id,
                slug: item.slug,
                assetPath: item.assetPath,
                gridX: x,
                gridY: y,
              ),
            );
          });
          return;
        }
      }
    }

    _showMessage('Нет свободных ячеек');
  }

  bool _isCellEmpty(int x, int y) {
    if (x < 0 || x >= gridColumns || y < 0 || y >= gridRows) return false;
    return !_gameItems.any(
      (item) => item.gridX == x && item.gridY == y && !item.isDragging,
    );
  }

  // Полоса для растягивания
  Widget _buildToolboxItem(ImageItem imgItem, double size) {
    return GestureDetector(
      // print("Добавлен ${imgItem.id}")
      onTap: () => {_addToGameField(imgItem)}, // Замените на вашу логику
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 1),
          ],
        ), // Добавлена закрывающая скобка

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Картинка (занимает большую часть пространства)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  imgItem.assetPath,
                  fit: BoxFit.contain,
                  width: size - 20,
                  height: size - 20,
                ),
              ),
            ),

            // Текстовая подпись
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                imgItem.slug, // Преобразуем item_1 в "item 1"
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addImageToGameField(ImageItem img) {
    setState(() {
      _selectedImages.add(
        ImageItem(
          img.id,
          img.id,
          img.assetPath,
          position: Offset(
            MediaQuery.of(context).size.width / 2 - 40,
            _gameAreaHeight / 2 - 40,
          ),
        ),
      );
    });
  }

  void _updateImagePosition(String id, Offset newPosition) {
    setState(() {
      final img = _selectedImages.firstWhere((img) => img.id == id);
      img.position = newPosition;
    });
  }

  void checkCollisions() {
    final visibleImages =
        gameImages.where((img) => isVisible[img.id]!).toList();

    // Проверяем все пары
    for (int i = 0; i < visibleImages.length; i++) {
      for (int j = i + 1; j < visibleImages.length; j++) {
        final img1 = visibleImages[i];
        final img2 = visibleImages[j];

        final distance = (positions[img1.id]! - positions[img2.id]!).distance;

        if (distance < 100) {
          // Дистанция для слияния
          final resultId = getMergeResult(img1.id, img2.id);
          if (resultId != null) {
            setState(() {
              isVisible[img1.id] = false;
              isVisible[img2.id] = false;
              resultImageId = resultId;
            });
            return;
          }
        }
      }
    }
  }

  double _getCenterX() {
    final visible = gameImages.where((img) => !isVisible[img.id]!);
    if (visible.length != 2) return 200;
    return (positions[visible.first.id]!.dx + positions[visible.last.id]!.dx) /
        2;
  }

  double _getCenterY() {
    final visible = gameImages.where((img) => !isVisible[img.id]!);
    if (visible.length != 2) return 300;
    return (positions[visible.first.id]!.dy + positions[visible.last.id]!.dy) /
        2;
  }
}

final List<MergeRule> mergeRules = [
  MergeRule('apple', 'banana', 'fruit_basket'),
  MergeRule('banana', 'orange', 'smoothie'),
];

class MergeRule {
  final String firstImageId;
  final String secondImageId;
  final String resultImageId;

  MergeRule(this.firstImageId, this.secondImageId, this.resultImageId);
}

class DraggableImage extends StatelessWidget {
  final ImageItem image;
  final Function(Offset) onDragEnd;

  const DraggableImage({required this.image, required this.onDragEnd});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: image.position.dx,
      top: image.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          onDragEnd(image.position + details.delta);
        },
        child: Image.asset(image.assetPath, width: 80, height: 80),
      ),
    );
  }
}

class GameCell {
  final ImageItem? item;
  GameCell.empty() : item = null;
  GameCell.withItem(this.item);
  bool get isEmpty => item == null;
}
