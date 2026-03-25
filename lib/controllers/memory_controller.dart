import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:love_days/models/memory_model.dart';

class MemoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Get all memories for a user, ordered by date descending
  Stream<List<MemoryModel>> getMemories(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('memories')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MemoryModel.fromDocument(doc)).toList());
  }

  /// Pick multiple images from gallery
  Future<List<XFile>?> pickImages() async {
    return _picker.pickMultiImage(imageQuality: 85);
  }

  /// Upload multiple images to Firebase Storage and return URLs
  Future<List<String>> uploadImages(String userId, List<XFile> images) async {
    List<String> urls = [];
    for (var image in images) {
      final memoryId = _firestore.collection('tmp').doc().id;
      final ref = _storage.ref().child('users/$userId/memories/$memoryId.jpg');

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      } else {
        await ref.putFile(io.File(image.path));
      }

      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  /// Add a memory with multiple images
  Future<void> addMemory({
    required String userId,
    required String title,
    required String description,
    required List<XFile> images,
    required DateTime date,
  }) async {
    final imageUrls = await uploadImages(userId, images);

    final memory = MemoryModel(
      id: '', // Firestore will auto-generate
      title: title,
      description: description,
      imageUrls: imageUrls,
      date: date,
      createdBy: userId,
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('memories')
        .add(memory.toMap());
  }
}
