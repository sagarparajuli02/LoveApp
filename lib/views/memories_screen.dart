import 'dart:io' as io;
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Add this to pubspec.yaml

import 'package:love_days/controllers/memory_controller.dart';
import 'package:love_days/models/memory_model.dart';
import 'memory_detail_screen.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  final MemoryController _controller = MemoryController();
  final Color primaryColor = const Color(0xFFec5b13);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: Text("Please sign in")));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(user.uid),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<List<MemoryModel>>(
                    stream: _controller.getMemories(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Colors.white24));
                      }

                      final memories = snapshot.data ?? [];
                      if (memories.isEmpty) {
                        return const Center(
                            child: Text("No memories yet",
                                style: TextStyle(color: Colors.white54)));
                      }

                      return MasonryGridView.count(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        itemCount: memories.length,
                        itemBuilder: (context, index) {
                          return _memoryCard(memories[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.3,
                colors: [Color(0xFF3b0764), Colors.black],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomLeft,
                radius: 1.2,
                colors: [Color(0xFF831843), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String userId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Our Special Moments",
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2)),
              SizedBox(height: 4),
              Text("Our Memories",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1)),
            ],
          ),
          GestureDetector(
            onTap: () => _openAddMemoryModal(userId),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memoryCard(MemoryModel memory) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MemoryDetailScreen(memory: memory))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (memory.imageUrls.isNotEmpty)
                  AspectRatio(
                    aspectRatio:
                        1, // Masonry grid handles varying heights, but 1:1 looks clean for the preview
                    child: Image.network(
                      memory.imageUrls.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(memory.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(DateFormat('MMM dd, yyyy').format(memory.date),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Optimized Modal with Glassmorphism
  void _openAddMemoryModal(String userId) {
    String title = "";
    String description = "";
    DateTime selectedDate = DateTime.now();
    List<XFile> localImages = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A).withOpacity(0.9),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 20),
                  const Text("Capture a Memory",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("What's this memory called?"),
                    onChanged: (val) => title = val,
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    icon: Icons.calendar_today,
                    label: DateFormat('EEEE, MMM dd').format(selectedDate),
                    onTap: () async {
                      final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now());
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    icon: Icons.photo_library,
                    label: localImages.isEmpty
                        ? "Select Photos"
                        : "${localImages.length} Photos Selected",
                    onTap: () async {
                      final picked = await _controller.pickImages();
                      if (picked != null) {
                        setModalState(() => localImages = picked);
                      }
                    },
                  ),
                  if (localImages.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: localImages.length,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(io.File(localImages[i].path),
                                  width: 80, height: 80, fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (title.isEmpty || localImages.isEmpty) return;
                      await _controller.addMemory(
                          userId: userId,
                          title: title,
                          description: description,
                          images: localImages,
                          date: selectedDate);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text("Save Memory",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white)),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10)),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
