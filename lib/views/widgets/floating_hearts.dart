import 'dart:math';
import 'package:flutter/material.dart';

class FloatingHearts extends StatefulWidget {
  const FloatingHearts({super.key});

  @override
  State<FloatingHearts> createState() => _FloatingHeartsState();
}

class _FloatingHeartsState extends State<FloatingHearts>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildHeart(double size, double leftOffset, double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animationValue =
            (_controller.value + delay) % 1.0; // offset animation

        return Positioned(
          bottom: animationValue * MediaQuery.of(context).size.height,
          left: leftOffset,
          child: Opacity(
            opacity: 0.05, // VERY subtle
            child: Icon(
              Icons.favorite,
              color: Colors.white,
              size: size,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(8, (index) {
          final size = 20.0 + _random.nextDouble() * 30;
          final left = _random.nextDouble() * MediaQuery.of(context).size.width;
          final delay = _random.nextDouble();

          return _buildHeart(size, left, delay);
        }),
      ),
    );
  }
}
