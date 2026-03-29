import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:love_days/models/memory_model.dart';
import 'package:love_days/theme/app_text.dart';
import 'package:love_days/utils/app_colors.dart';

class MemoryDetailScreen extends StatefulWidget {
  final MemoryModel memory;
  const MemoryDetailScreen({super.key, required this.memory});

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  Map<String, String>? _headersForUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return null;

    // Some sites block direct image loads from apps ("hotlink protection").
    // Sending browser-like headers often fixes it on Android/iOS.
    final headers = <String, String>{
      'User-Agent': 'Mozilla/5.0',
      'Accept': 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8',
    };

    if (uri.host.endsWith('saraphotography.com.au')) {
      headers['Referer'] = 'https://saraphotography.com.au/';
    }

    return headers;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.memory.imageUrls;

    return Scaffold(
      backgroundColor: AppColors.appBlack,
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Text(
                    widget.memory.title,
                    style: context.appText.subheading,
                  ),
                  const SizedBox(width: 24), // placeholder
                ],
              ),
            ),

            /// Gallery
            Expanded(
              child: images.isNotEmpty
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PhotoViewGallery.builder(
                          itemCount: images.length,
                          builder: (context, index) {
                            final url = images[index];
                            return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(
                                url,
                                headers: _headersForUrl(url),
                              ),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.covered * 2,
                            );
                          },
                          pageController: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          scrollPhysics: const BouncingScrollPhysics(),
                          backgroundDecoration:
                              const BoxDecoration(color: AppColors.appBlack),
                        ),

                        /// Page Indicator
                        if (images.length > 1)
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.black45,
                            child: Text(
                              "${_currentIndex + 1} / ${images.length}",
                              style: context.appText.body,
                            ),
                          ),
                      ],
                    )
                  : const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 60,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
