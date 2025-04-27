import 'package:flutter/material.dart';

class DiscoveryBanner extends StatefulWidget {
  final String itemName;
  final String imagePath;

  const DiscoveryBanner({
    Key? key,
    required this.itemName,
    required this.imagePath,
  }) : super(key: key);

  @override
  _DiscoveryBannerState createState() => _DiscoveryBannerState();
}

class _DiscoveryBannerState extends State<DiscoveryBanner> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    // Автоматически скрываем баннер через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _visible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(widget.imagePath, width: 40, height: 40),
            const SizedBox(width: 12),
            Text(
              'Новый предмет: ${widget.itemName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
