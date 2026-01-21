import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        cardColor: const Color(0xFF0F2035),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFC69C2D)),
          headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 13, color: Color(0xFFB0BEC5)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- LOGO BİLEŞENİ (Center Crop) ---
class BrandLogo extends StatelessWidget {
  final double size;
  final double radius;
  const BrandLogo({super.key, required this.size, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset('assets/logo.png', fit: BoxFit.cover, alignment: Alignment.center),
      ),
    );
  }
}

// --- SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Timer(const Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainShell())));
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(scale: _pulse, child: const BrandLogo(size: 160, radius: 35)),
      ),
    );
  }
}

// --- ANA NAVİGASYON ---
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [const HomePage(), const PredictionsPage(), const PremiumPage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _selectedIndex, children: _pages)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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
    );
  }
}

// --- ANA SAYFA (MAÇ KARTLARI) ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const _TopHeaderWidget(), // Arama barı ve logo
          const SizedBox(height: 20),
          const Text("Upcoming Matches", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFFC69C2D))),
          const Text("AI-powered predictions for the beautiful game.", style: TextStyle(color: Colors.white38, fontSize: 13)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: const Color(0xFF0F2035), borderRadius: BorderRadius.circular(10)),
              child: const TabBar(
                indicatorColor: Colors.transparent,
                indicator: BoxDecoration(color: Color(0xFF051125), borderRadius: BorderRadius.all(Radius.circular(8))),
                labelColor: Color(0xFFC69C2D),
                unselectedLabelColor: Colors.white24,
                tabs: [Tab(text: "All"), Tab(text: "Live"), Tab(text: "Finished")],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMatchList(),
                const Center(child: Text("No live matches")),
                const Center(child: Text("No finished matches")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchList() {
    // Sadece ilk 4 maçı alıyoruz
    final matches = DemoData.excelMatches.take(4).toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: MatchCardTechnical(match: matches[index]),
        );
      },
    );
  }
}

// --- ÜST HEADER WIDGET (Resimdeki gibi) ---
class _TopHeaderWidget extends StatelessWidget {
  const _TopHeaderWidget();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          const BrandLogo(size: 40, radius: 5),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: const Color(0xFF0F2035), borderRadius: BorderRadius.circular(8)),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 18, color: Colors.white38),
                  SizedBox(width: 10),
                  Text("Search matches...", style: TextStyle(color: Colors.white38, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Icon(Icons.notifications_none, color: Colors.white70),
          const SizedBox(width: 15),
          const Icon(Icons.person_outline, color: Colors.white70),
        ],
      ),
    );
  }
}

// --- YENİ TEKNİK MAÇ KARTI (Görseldeki Yapı) ---
class MatchCardTechnical extends StatelessWidget {
  final Map<String, String> match;
  const MatchCardTechnical({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F2035),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          // ÜST KISIM (Tarih ve Saat)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(match['date']!.split('-')[0].trim(), style: const TextStyle(fontSize: 11, color: Colors.white54)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(5)),
                  child: Text(match['date']!.split('-')[1].trim(), style: const TextStyle(fontSize: 11, color: Color(0xFFC69C2D), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // ORTA KISIM (Takımlar)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _teamUi(match['home']!, true)),
                const Text("VS", style: TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.w900, fontSize: 18)),
                Expanded(child: _teamUi(match['away']!, false)),
              ],
            ),
          ),
          // ALT KISIM (AI Bölmesi)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12))),
            child: Column(
              children: [
                const Text("AI Confidence Score", style: TextStyle(fontSize: 11, color: Colors.white38, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("1", style: TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(value: 0.75, backgroundColor: Colors.white10, color: Color(0xFFC69C2D), minHeight: 7),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("75%", style: TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamUi(String name, bool left) {
    return Column(
      crossAxisAlignment: left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        const CircleAvatar(radius: 18, backgroundColor: Colors.white10, child: Icon(Icons.sports_soccer, size: 20)),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

// --- DİĞER SAYFALAR ---
class PredictionsPage extends StatelessWidget {
  const PredictionsPage({super.key});
  @override
  Widget build(BuildContext context) { return const Center(child: Text("Analiz Sayfası")); }
}
class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});
  @override
  Widget build(BuildContext context) { return const Center(child: Text("Premium Sayfası")); }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) { return const Center(child: Text("Profil Sayfası")); }
}

// --- VERİ ---
class DemoData {
  static const List<Map<String, String>> excelMatches = [
    {"home": "Trabzonspor", "away": "Kasımpaşa", "date": "23.01.2026 - 20:00"},
    {"home": "Kayserispor", "away": "Başakşehir", "date": "24.01.2026 - 14:30"},
    {"home": "Samsunspor", "away": "Kocaelispor", "date": "24.01.2026 - 17:00"},
    {"home": "Karagümrük", "away": "Galatasaray", "date": "24.01.2026 - 20:00"},
  ];

  static Future<List<CouponMatch>> loadMatchesFromJson() async { return []; }
}

class CouponMatch {
  final int index;
  final String homeTeam, awayTeam, prediction;
  final bool isLocked;
  CouponMatch({required this.index, required this.homeTeam, required this.awayTeam, required this.prediction, required this.isLocked});
}
