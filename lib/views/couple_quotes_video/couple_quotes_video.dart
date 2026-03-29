import 'package:flutter/material.dart';
import 'package:love_days/utils/app_colors.dart';
import 'package:love_days/theme/app_text.dart';
import 'quotes_tab.dart';
import 'videos_tab.dart';

class CoupleQuotesVideo extends StatelessWidget {
  const CoupleQuotesVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            /// 🎨 Tab Bar Header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: TabBar(
                  indicatorColor: AppColors.accentOrange,
                  labelColor: AppColors.accentOrange,
                  unselectedLabelColor: Colors.white38,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  labelStyle: context.appText.subheading.copyWith(
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: context.appText.subheading.copyWith(
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.format_quote_rounded),
                          SizedBox(width: 8),
                          Text("Quotes"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_fill_rounded),
                          SizedBox(width: 8),
                          Text("Videos"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 📑 Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  const QuotesTab(),
                  const VideosTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
