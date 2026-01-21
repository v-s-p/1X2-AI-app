import 'dart:ui'; // Blur efekti için şart
import 'package:flutter/material.dart';

void main() {
  runApp(const PredictApp());
}

class PredictApp extends StatelessWidget {
  const PredictApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandNavy = Color(0xFF051125);
    const goldPrimary = Color(0xFFC69C2D);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: brandNavy,
        primaryColor: goldPrimary,
        fontFamily: 'Roboto', // Modern font
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool isPremium = false; // Test için FALSE bırakıyoruz (Kilitleri görmek için)

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF051125),
          elevation: 0,
          title: Image.asset('assets/logo.png', height: 40),
          centerTitle: true,
          actions: const [
            Icon(Icons.notifications_none, color: Color(0xFFC69C2D)),
            SizedBox(width: 15),
          ],
          bottom: TabBar(
            indicatorColor: const Color(0xFFC69C2D),
            labelColor: const Color(0xFFC69C2D),
            unselectedLabelColor: Colors.white24,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Hepsi"),
              Tab(text: "Canlı"),
              Tab(text: "Biten"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHepsiTab(),
            _buildCanliTab(),
            _buildBitenTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF051125),
          selectedItemColor: const Color(0xFFC69C2D),
          unselectedItemColor: Colors.white24,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Predictions'),
            BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // --- HEPSİ SEKİMESİ (FREEMIUM LİSTE) ---
  Widget _buildHepsiTab() {
    final matches = DemoData.excelMatches;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        bool isLocked = index >= 2 && !isPremium; // İlk 2 maç hariç kilitli
        return GestureDetector(
          onTap: () => isLocked ? _showPremiumSheet(context) : null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MatchCardElite(match: matches[index], isLocked: isLocked),
          ),
        );
      },
    );
  }

  // --- CANLI SEKİMESİ (ESPRİLİ BOŞ EKRAN) ---
  Widget _buildCanliTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.stadium_outlined, size: 100, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 20),
          const Text(
            "Şu an çimler sessiz...",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFC69C2D)),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ama fırtına yaklaşıyor!",
            style: TextStyle(color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildBitenTab() {
    return const Center(child: Text("Biten maç bulunamadı."));
  }

  // --- PREMIUM BOTTOM SHEET ---
  void _showPremiumSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2035),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        height: 350,
        child: Column(
          children: [
            const Icon(Icons.stars_rounded, color: Color(0xFFC69C2D), size: 60),
            const SizedBox(height: 20),
            const Text("Premium'a Geçin", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "Tüm 15 maçın detaylı AI analizlerini ve yüksek güven skorlarını görmek için paketini yükselt!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC69C2D),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("ŞİMDİ YÜKSELT", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- MAÇ KARTI (BLUR EFEKTLİ) ---
class MatchCardElite extends StatelessWidget {
  final Map<String, String> match;
  final bool isLocked;

  const MatchCardElite({super.key, required this.match, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ANA KART İÇERİĞİ
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2035),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _teamInfo(match['home']!, true)),
                  const Text("VS", style: TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.w900)),
                  Expanded(child: _teamInfo(match['away']!, false)),
                ],
              ),
              const SizedBox(height: 15),
              Text(match['date']!, style: const TextStyle(fontSize: 12, color: Colors.white24)),
            ],
          ),
        ),
        
        // KİLİT VE BLUR KATMANI (Eğer Kilitliyse)
        if (isLocked)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Icon(Icons.lock_outline_rounded, color: Color(0xFFC69C2D), size: 40),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _teamInfo(String name, bool isHome) {
    return Column(
      crossAxisAlignment: isHome ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        const CircleAvatar(radius: 18, backgroundColor: Colors.white10, child: Icon(Icons.sports_soccer, size: 18)),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

// --- DUMMY EXCEL LİSTESİ ---
class DemoData {
  static const List<Map<String, String>> excelMatches = [
    {"home": "Trabzonspor", "away": "Kasımpaşa", "date": "23.01.2026 - 20:00"},
    {"home": "Kayserispor", "away": "Rams Başakşehir", "date": "24.01.2026 - 14:30"},
    {"home": "Samsunspor", "away": "Kocaelispor", "date": "24.01.2026 - 17:00"},
    {"home": "Karagümrük", "away": "Galatasaray", "date": "24.01.2026 - 20:00"},
    {"home": "Gaziantep FK", "away": "Konyaspor", "date": "25.01.2026 - 14:30"},
    {"home": "Antalyaspor", "away": "Gençlerbirliği", "date": "25.01.2026 - 17:00"},
    {"home": "Rizespor", "away": "Alanyaspor", "date": "25.01.2026 - 17:00"},
    {"home": "Fenerbahçe", "away": "Göztepe", "date": "25.01.2026 - 20:00"},
    {"home": "Eyüpspor", "away": "Beşiktaş", "date": "26.01.2026 - 20:00"},
    {"home": "Union Berlin", "away": "Borussia Dortmund", "date": "24.01.2026 - 20:30"},
    {"home": "Marsilya", "away": "Lens", "date": "24.01.2026 - 23:05"},
    {"home": "Arsenal", "away": "Man. United", "date": "25.01.2026 - 19:30"},
    {"home": "Villarreal", "away": "Real Madrid", "date": "24.01.2026 - 23:00"},
    {"home": "Juventus", "away": "Napoli", "date": "25.01.2026 - 20:00"},
    {"home": "Roma", "away": "AC Milan", "date": "25.01.2026 - 22:45"},
  ];
}
