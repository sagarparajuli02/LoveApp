import 'package:cloud_firestore/cloud_firestore.dart';

class MemoryModel {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls; // <-- change from String to List<String>
  final DateTime date;
  final String createdBy;

  MemoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls, // updated
    required this.date,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrls': imageUrls, // updated
      'date': Timestamp.fromDate(date),
      'createdBy': createdBy,
    };
  }

  factory MemoryModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MemoryModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []), // <-- important
      date: (data['date'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
    );
  }
}
