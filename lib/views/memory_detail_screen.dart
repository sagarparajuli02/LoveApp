import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:love_days/models/memory_model.dart';

class MemoryDetailScreen extends StatefulWidget {
  final MemoryModel memory;
  const MemoryDetailScreen({super.key, required this.memory});

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

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
      backgroundColor: Colors.black,
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
                            return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(images[index]),
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
                              const BoxDecoration(color: Colors.black),
                        ),

                        /// Page Indicator
                        if (images.length > 1)
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.black45,
                            child: Text(
                              "${_currentIndex + 1} / ${images.length}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
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
