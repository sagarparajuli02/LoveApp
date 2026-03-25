import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:love_days/utils/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;

  const GlassCard({
    super.key,
    required this.child,
    this.radius = 25,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        // 🔥 Reduced blur (important)
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),

            // 🔥 Softer gradient (less white)
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.whiteA(0.18),
                AppColors.whiteA(0.05),
              ],
            ),

            border: Border.all(
              color: AppColors.whiteA(0.25),
              width: 1,
            ),

            boxShadow: [
              BoxShadow(
                color: AppColors.blackA(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
