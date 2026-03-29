import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../controllers/quotes_controller.dart';
import '../../models/quote_model.dart';

class QuotesTab extends StatefulWidget {
  const QuotesTab({super.key});

  @override
  State<QuotesTab> createState() => _QuotesTabState();
}

class _QuotesTabState extends State<QuotesTab> {
  final QuotesController _controller = QuotesController();
  late Future<List<QuoteModel>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _quotesFuture = _controller.getQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.redAccent,
      onRefresh: () async {
        setState(() {
          _quotesFuture = _controller.refreshQuotes();
        });
      },
      child: FutureBuilder<List<QuoteModel>>(
        future: _quotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.redAccent));
          }

          final quotes = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quotes.length,
            itemBuilder: (context, index) => _QuoteCard(quote: quotes[index]),
          );
        },
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${quote.text}"',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "— ${quote.author}",
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              GestureDetector(
                onTap: () => Share.share('"${quote.text}"\n— ${quote.author}'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.ios_share,
                      size: 18, color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
