import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../services/match_service.dart';
import 'match_details_sheet.dart';

class WeeklyMatchesScreen extends StatelessWidget {
  const WeeklyMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matches = MatchService.getWeeklyMatches();
    const goldPrimary = Color(0xFFC69C2D);
    const darkBg = Color(0xFF0A0E17);
    const cardColor = Color(0xFF141A26);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        title: const Text("PREDICT AI", 
          style: TextStyle(color: goldPrimary, fontWeight: FontWeight.w900, letterSpacing: 2)),
        actions: const [
          Icon(Icons.workspace_premium, color: goldPrimary),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Spor Toto - Week 24", 
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text("15 Matches analyzed by AI", 
                  style: TextStyle(color: Colors.white38, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MatchCard(match: match, gold: goldPrimary, cardColor: cardColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final MatchModel match;
  final Color gold;
  final Color cardColor;

  const _MatchCard({required this.match, required this.gold, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => MatchDetailsSheet(match: match),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text("${match.id}", 
                  style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(match.home, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("vs", style: TextStyle(color: Colors.white24, fontSize: 11)),
                      ),
                      Expanded(child: Text(match.away, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                    ],
                  ),
                  if (!match.isLocked) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _tag("Predict: ${match.prediction}", gold.withOpacity(0.1), gold),
                        const SizedBox(width: 8),
                        _tag("${match.confidence}%", Colors.white.withOpacity(0.05), Colors.white70),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (match.isLocked) 
               const Icon(Icons.lock_outline, size: 20, color: Colors.white24)
            else
               const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color bg, Color textCo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(color: textCo, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
