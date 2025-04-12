import 'package:flutter/material.dart';
import '../models/image_item.dart';
import '../logic/game_field_manager.dart';

class ToolboxItemWidget extends StatelessWidget {
  final ImageItem imgItem;
  final double size;
  final FieldManager fieldManager;
  final BuildContext context;
  final void Function() onItemAdded;

  const ToolboxItemWidget({
    Key? key,
    required this.imgItem,
    required this.size,
    required this.fieldManager,
    required this.context,
    required this.onItemAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fieldManager.tryAddItem(
          context: this.context,
          item: imgItem,
          onAdd: (_) => onItemAdded(),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                imgItem.slug,
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
}
