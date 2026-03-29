import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';

class QuotesController {
  final String _cacheKey = "cached_quotes";
  // Proxy is only needed for Flutter Web development
  final String _apiUrl =
      "https://api.allorigins.win/raw?url=https://zenquotes.io/api/quotes";

  Future<List<QuoteModel>> getQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString(_cacheKey);

    if (cachedData != null && cachedData.isNotEmpty) {
      return _parse(cachedData);
    }
    return await refreshQuotes();
  }

  Future<List<QuoteModel>> refreshQuotes() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_cacheKey, response.body);
        return _parse(response.body);
      }
    } catch (e) {
      print("Fetch error: $e");
    }

    // Safety Fallback
    return [
      QuoteModel(
          text: "The best thing to hold onto in life is each other.",
          author: "Audrey Hepburn"),
      QuoteModel(
          text: "Love is a friendship set to music.",
          author: "Joseph Campbell"),
    ];
  }

  List<QuoteModel> _parse(String jsonString) {
    try {
      List<dynamic> list = jsonDecode(jsonString);
      return list.map((item) => QuoteModel.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }
}
