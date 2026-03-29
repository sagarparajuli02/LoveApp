import 'package:flutter/material.dart';
import 'package:love_days/theme/app_text.dart';

class VideosTab extends StatelessWidget {
  const VideosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Couple video memories coming soon",
        style: context.appText.bodyMuted.copyWith(letterSpacing: 0.5),
      ),
    );
  }
}
