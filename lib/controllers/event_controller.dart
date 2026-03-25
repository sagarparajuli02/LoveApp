import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:love_days/models/event_model.dart';

class EventController {
  final String coupleId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EventController(this.coupleId) {
    if (coupleId.isEmpty) {
      throw Exception("coupleId cannot be empty!");
    }
  }

  Future<void> addEvent(EventModel event) async {
    await _firestore
        .collection('couples')
        .doc(coupleId)
        .collection('events')
        .doc(event.id)
        .set(event.toMap());
  }

  Stream<List<EventModel>> getEvents() {
    return _firestore
        .collection('couples')
        .doc(coupleId)
        .collection('events')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => EventModel.fromMap(doc.data())).toList());
  }
}
