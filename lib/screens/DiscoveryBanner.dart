import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darwin/bloc/level_bloc.dart';

class DiscoveryBanner extends StatefulWidget {
  final String itemName;
  final String imagePath;
  final String messageType; // 'discovery' или 'clear'

  const DiscoveryBanner({
    Key? key,
    this.itemName = "",
    this.imagePath = "",
    this.messageType = 'discovery',
  }) : super(key: key);

  @override
  _DiscoveryBannerState createState() => _DiscoveryBannerState();
}

class _DiscoveryBannerState extends State<DiscoveryBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _offsetAnimation;
  late LevelBloc _levelBloc; // Добавляем BLoC

  @override
  void initState() {
    super.initState();
    _levelBloc = context.read<LevelBloc>(); // Получаем BLoC из контекста

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
      // Отслеживаем завершение анимации
      if (status == AnimationStatus.completed) {
        _levelBloc.add(ClearDiscoveryEvent()); // Отправляем событие
      }
    });

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _offsetAnimation = Tween<double>(
      begin: 0.0,
      end: -100.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Запускаем анимацию через 3 секунды
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offsetAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: widget.messageType == 'clear' ? _clear() : _newItem(),
              ),
            ),
          ),
        );
      },
    );
  }

  _clear() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 36),
        SizedBox(width: 15),
        Text(
          'Игровое поле очищено!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  _newItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(widget.imagePath, width: 36, height: 36),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            'Новый предмет: ${widget.itemName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Icon(Icons.celebration, color: Colors.amber[700], size: 24),
      ],
    );
  }
}
