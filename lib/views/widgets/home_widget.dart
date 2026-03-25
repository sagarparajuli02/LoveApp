import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:love_days/utils/app_colors.dart';

class LoveWidget extends StatefulWidget {
  const LoveWidget({super.key});

  @override
  State<LoveWidget> createState() => _LoveWidgetState();
}

class _LoveWidgetState extends State<LoveWidget> {
  String partner1 = "A";
  String partner2 = "S";
  int totalDays = 1234;
  String since = "June 2021";

  @override
  void initState() {
    super.initState();
    _loadWidgetData();

    // Listen for widget taps
    HomeWidget.widgetClicked.listen((uri) {
      // Just print for now, app opens automatically
      print("Widget clicked! Uri: $uri");
    });
  }

  Future<void> _loadWidgetData() async {
    final p1 = await HomeWidget.getWidgetData<String>('partner1') ?? 'A';
    final p2 = await HomeWidget.getWidgetData<String>('partner2') ?? 'S';
    final days = await HomeWidget.getWidgetData<int>('totalDays') ?? 1234;
    final sinceDate =
        await HomeWidget.getWidgetData<String>('since') ?? 'June 2021';

    setState(() {
      partner1 = p1;
      partner2 = p2;
      totalDays = days;
      since = sinceDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.widgetGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$partner1 & $partner2",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$totalDays Days Together",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Since $since",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
