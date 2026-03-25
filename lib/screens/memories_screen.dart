import 'dart:ui';
import 'package:flutter/material.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF7E9D), Color(0xFFFFB6C1), Color(0xFF9358F7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Our Story",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Memories",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    _glassCircleIcon(Icons.add_a_photo),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              /// Gallery
              Expanded(
                child: Stack(
                  children: [
                    /// Hearts in background
                    Positioned(
                      top: 40,
                      left: 50,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white.withOpacity(0.2),
                        size: 50,
                      ),
                    ),
                    const Positioned(
                      top: 200,
                      right: 30,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white10,
                        size: 60,
                      ),
                    ),
                    const Positioned(
                      bottom: 200,
                      left: 20,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white30,
                        size: 30,
                      ),
                    ),
                    const Positioned(
                      top: 400,
                      right: 50,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white10,
                        size: 100,
                      ),
                    ),

                    /// Scrollable Masonry Gallery
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _featuredMemory(
                              imageUrl:
                                  "https://lh3.googleusercontent.com/aida-public/AB6AXuB-5OlLD_K9dfLGY1WVGqF8ItqAuUp4tU0nA24hU9bcBofI73KhTEVPSuaFau0aJ34UszhsN-YRnqR5BwIiEMjcgA4C7-kPXZKqqK6DNmBD50fjwqmcBllhV08NLXPkdfO-DW5grqgKCQSuDuLCIZTtKk-b_ML8wI0pufcU-kZfU_BEcfnYi6TAtvMY9pWdEkeK_Oq06dYimGzeSAnrpehTOOsGKqtL2lzs3-aSAGCgKiRtu1bEOZxGOUPOgcMOGyrJJsz23rS-7A",
                              title: "Sunset Walk in Paris",
                              date: "October 14, 2023",
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      _memoryCard(
                                        imageUrl:
                                            "https://lh3.googleusercontent.com/aida-public/AB6AXuC3734W0GWf3DIZlGMJ6l4Xb0wgc8aovhuZ61wLRMx_BN4k3Yg4AdOfYOrLIbBdlcklN0LW6fvSghkStNiSXNN6a4RY1df6Z4P9XmbbPdK4o1AjAK_T58L-L_RNIzHZeFVmO61uxdnMXxQMi3OkzaqoIjW5LTenjEL3K4f3iX7FXLwCBVQaU6gqSkLY9ywyNne3jYXAViEFMDw_ezHEbbaaE_qEmcAR29ARMf69f2Y6Cvy8bP0v2Xw_acFUGz1KqD1HT3itY6P8iQ",
                                        title: "Morning Coffee",
                                        date: "2 days ago",
                                      ),
                                      const SizedBox(height: 12),
                                      _memoryCard(
                                        imageUrl:
                                            "https://lh3.googleusercontent.com/aida-public/AB6AXuB-ooO4CVaQuphdOkz8-X6KP6OtKCEj2WuzpTyQKvr8surEJsZHJrPBprUqml8fZIekvrMDogzAAqvIgOhGqSWPzedzTwllgfF2KT_TKuQ9UdiIWbCwr3AN96U_Fx7VQgbOkMJL-o618wIHH5ZJJj6bMzMnprqbHw_NSmwMan3jBZiI1cCZY9OoXetVZc1mCNrrIF0OojDOVn2JIb2ZgBT01F1ZXTfTBeqhX_jpNSRTmBzRVBrKGPklHHaH0PJ36FC6gshsGIjWew",
                                        title: "Weekend Getaway",
                                        date: "Last week",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _memoryCard(
                                        imageUrl:
                                            "https://lh3.googleusercontent.com/aida-public/AB6AXuAupl_u_ZCGVK7_lQK8Uyo5ZP9HDffk6H8Bt6vrkiFkpC2vf8o-Wi8UcGEINu6rDXgQQENFC2XtxNa5zofUR_wO6Y5PHDK1u5kquivfHBDniZ5d3_kN9iyM_R3dg8I1mIzMWxzH4dZMCQW9gq0lZFd2VbN0ozDfEtLwPDzL3qSu6Vx9WnXq2Hm6Gs669vE3LMoKGSo-vXg5uBpeeIBmv-yUHhHIska285zJmMSeq_d6InXndU9SPRB7VbL6SRE3heogD1GMoE2j5w",
                                        title: "Dinner Date",
                                        date: "Sep 28, 2023",
                                      ),
                                      const SizedBox(height: 12),
                                      _memoryCard(
                                        imageUrl:
                                            "https://lh3.googleusercontent.com/aida-public/AB6AXuDfBR2ieuBlxneRhKMYY2Pj8xkg0oEC_r3vyL8pW1nvfFm4iLiwMgQSnhBx0_N0Eh6ZgD-xf1QaQ0czU7zbGqJn88Zqz9KlcpmdiyDxC2y4LvH7NT_gK6XOkd9XteGbxItKx7-8gwfqNVza6pMSCV56oBtY8vRXw0947uMuGZvhTEMhS3Q1VcX4DdD1AtrmTGtVYrMh4GMZP0eKWfZo2kUznpx-1R1-tLlLeeYIRce72_rNPfrIRxJqusLraDaf72HMAfc9YvkP5A",
                                        title: "The First Hello",
                                        date: "June 2021",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _memoryCard({
    required String imageUrl,
    required String title,
    required String date,
  }) {
    return _glassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuredMemory({
    required String imageUrl,
    required String title,
    required String date,
  }) {
    return _glassContainer(
      borderRadius: 32,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Featured",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassContainer({
    required Widget child,
    EdgeInsets? padding,
    double borderRadius = 20,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _glassCircleIcon(IconData icon) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
