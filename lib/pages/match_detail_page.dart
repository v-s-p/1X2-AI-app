import 'package:flutter/material.dart';
import '../main.dart'; // CouponMatch
import '../services/ai_service.dart';

class MatchDetailPage extends StatefulWidget {
  final CouponMatch match;
  const MatchDetailPage({super.key, required this.match});

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _analysisData;

  @override
  void initState() {
    super.initState();
    _loadAnalysis();
  }

  Future<void> _loadAnalysis() async {
    final matchInfo = "${widget.match.homeTeam} vs ${widget.match.awayTeam}";
    final data = await AIService().getDeepAnalysis(matchInfo);
    if (mounted) {
      debugPrint("DEBUG: MatchDetailPage received data: $data");
      setState(() {
        _analysisData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const navyBg = Color(0xFF051125);
    const goldAccent = Color(0xFFC69C2D);

    return Scaffold(
      backgroundColor: navyBg,
      appBar: AppBar(
        backgroundColor: navyBg,
        leading: const BackButton(color: Colors.white),
        title: Text("${widget.match.homeTeam} vs ${widget.match.awayTeam}", 
          style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: goldAccent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER SUMMARY ---
                  _buildHeaderSummary(),
                  const SizedBox(height: 20),
                  
                  // --- SECTIONS ---
                  _buildSection("Financial Status", Icons.attach_money, _analysisData?['financial']),
                  _buildSection("Player Psychology", Icons.psychology, _analysisData?['psychology']),
                  _buildSection("Global Press", Icons.public, _analysisData?['press']),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderSummary() {
    final verdict = _analysisData?['verdict'] as String? ?? "BELİRSİZ";
    final score = _analysisData?['verdict_score']?.toString() ?? "--";

    Color badgeColor;
    IconData badgeIcon;
    
    switch (verdict.toUpperCase()) {
      case 'BANKO':
        badgeColor = const Color(0xFF00E676); // Green
        badgeIcon = Icons.verified;
        break;
      case 'GÜÇLÜ FAVORİ':
        badgeColor = const Color(0xFF2979FF); // Blue
        badgeIcon = Icons.thumb_up;
        break;
      case 'SÜRPRİZ':
        badgeColor = const Color(0xFFE040FB); // Purple
        badgeIcon = Icons.bolt;
        break;
      case 'RİSKLİ':
        badgeColor = const Color(0xFFFF9100); // Orange
        badgeIcon = Icons.warning_amber_rounded;
        break;
      default:
        badgeColor = Colors.grey;
        badgeIcon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        border: Border.all(color: badgeColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(badgeIcon, color: badgeColor, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("YAPAY ZEKA KARARI", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(verdict.toUpperCase(), style: TextStyle(color: badgeColor, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("GÜVEN", style: TextStyle(color: Colors.white38, fontSize: 10)),
              Text("%$score", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  // _buildBadge removed as it is no longer used

  Widget _buildSection(String title, IconData icon, dynamic data) {
    if (data == null || (data is List && data.isEmpty)) return const SizedBox.shrink();

    final List<String> items = (data as List).map((e) => e.toString()).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2035),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFC69C2D), size: 22),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(color: Colors.white10, height: 20),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ", style: TextStyle(color: Colors.white54, fontSize: 16)),
                Expanded(child: Text(item, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
