class QuoteModel {
  final String text;
  final String author;

  // No 'const' here because we are handling dynamic API data
  QuoteModel({required this.text, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      text: json['q'] ?? '',
      author: json['a'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
        'q': text,
        'a': author,
      };
}
