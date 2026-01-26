import 'package:flutter/material.dart';
import '../models/match_model.dart';

class MatchDetailsSheet extends StatelessWidget {
  final MatchModel match;

  const MatchDetailsSheet({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    const goldPrimary = Color(0xFFC69C2D);
    const darkBg = Color(0xFF0A0E17);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (match.isLocked) ...[
            _buildLockedState(context, goldPrimary)
          ] else ...[
            _buildUnlockedState(match, goldPrimary)
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildLockedState(BuildContext context, Color gold) {
    return Column(
      children: [
        const Icon(Icons.lock_outline, size: 60, color: Colors.white24),
        const SizedBox(height: 16),
        const Text(
          "Unlock Full Analysis",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        const Text(
          "Get detailed insights, confidence scores, and risk factors for all 15 matches.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              // TODO: Implement subscription logic
            },
            child: const Text("Subscribe ($3.99 / Week)", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockedState(MatchModel match, Color gold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${match.home} vs ${match.away}", 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text("Deep Analysis", style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: gold.withOpacity(0.5)),
              ),
              child: Text("Predict: ${match.prediction}", 
                style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("ANALYTICS", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 10),
        Row(
          children: [
            _statItem("Confidence", "${match.confidence}%", gold),
            const SizedBox(width: 20),
            _statItem("Risk Level", match.risk, _getRiskColor(match.risk)),
          ],
        ),
        const SizedBox(height: 20),
        const Text("INSIGHTS", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 10),
        Text(
          match.explanation,
          style: const TextStyle(color: Colors.white70, height: 1.5),
        ),
      ],
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 11)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'low': return Colors.greenAccent;
      case 'high': return Colors.redAccent;
      default: return Colors.orangeAccent;
    }
  }
}
