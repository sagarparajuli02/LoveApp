class EventModel {
  final String id;
  final String title;
  final DateTime date;
  final String icon;
  final bool notify;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    this.icon = 'celebration',
    this.notify = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'icon': icon,
      'notify': notify,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: DateTime.parse(map['date']),
      icon: map['icon'] ?? 'celebration',
      notify: map['notify'] ?? true,
    );
  }
}
