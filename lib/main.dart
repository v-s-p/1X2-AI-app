import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PredictApp());
}

class PredictApp extends StatelessWidget {
  const PredictApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandNavy = Color(0xFF051125); // Elite Deep Navy
    const goldPrimary = Color(0xFFC69C2D); // Elite Gold

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: brandNavy,
        primaryColor: goldPrimary,
        cardColor: const Color(0xFF0F2035),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFFC69C2D), letterSpacing: 0.5),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFC69C2D)),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0BEC5)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- LOGO BİLEŞENİ ---
class BrandLogo extends StatelessWidget {
  final double size;
  final double radius;
  const BrandLogo({super.key, required this.size, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 25, spreadRadius: 5)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset('assets/logo.png', fit: BoxFit.cover, alignment: Alignment.center),
      ),
    );
  }
}

// --- 1. ADIM: ELITE SPLASH SCREEN (Sadece Pulse Logo) ---
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
    _pulse = Tween<double>(begin: 0.92, end: 1.08).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Timer(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _pulse,
          child: const BrandLogo(size: 180, radius: 40), // Yazısız, görkemli logo
        ),
      ),
    );
  }
}

// --- 2. ADIM: LOGIN EKRANI ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BrandLogo(size: 120, radius: 25),
            const SizedBox(height: 60),
            TextField(decoration: InputDecoration(hintText: "E-posta", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
            const SizedBox(height: 15),
            TextField(obscureText: true, decoration: InputDecoration(hintText: "Şifre", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC69C2D), foregroundColor: Colors.black),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainShell())),
                child: const Text("ANALİZE BAŞLA", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ANA YAPI ---
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [UpcomingMatchesPage(), CouponPredictionsPage(), PremiumPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF051125),
        selectedItemColor: const Color(0xFFC69C2D),
        unselectedItemColor: Colors.white24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_mosaic_rounded), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Tahminler'),
          BottomNavigationBarItem(icon: Icon(Icons.stars_rounded), label: 'Premium'),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin_rounded), label: 'Profil'),
        ],
      ),
      body: SafeArea(child: _pages[_currentIndex]),
    );
  }
}

// --- SAYFA BİLEŞENLERİ: ÜST BAR ---
class _TopBarHeader extends StatelessWidget {
  const _TopBarHeader();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BrandLogo(size: 45, radius: 10),
          Row(children: [
            Icon(Icons.notifications_none_rounded, color: Colors.grey[400]),
            const SizedBox(width: 15),
            const CircleAvatar(radius: 18, backgroundColor: Colors.white10, child: Icon(Icons.person, size: 20, color: Color(0xFFC69C2D))),
          ])
        ],
      ),
    );
  }
}

// --- ANA SAYFA (GÖRSEL 0 STİLİ) ---
class UpcomingMatchesPage extends StatelessWidget {
  const UpcomingMatchesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const _TopBarHeader(),
          const SizedBox(height: 10),
          // --- İSTEDİĞİN O CAFCALI BAŞLIK (Görsel 0) ---
          Center(
            child: Column(
              children: [
                const Text("Haftanın Maçları", 
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFFC69C2D), letterSpacing: -0.5)),
                const SizedBox(height: 5),
                Text("Futbolun büyüsü için yapay zeka destekli tahminler.", 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400], fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // --- TAB TASARIMI (Görsel 0) ---
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: const Color(0xFF0F2035), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(child: _buildTab("Hepsi", true)),
                Expanded(child: _buildTab("Canlı", false)),
                Expanded(child: _buildTab("Biten", false)),
              ],
            ),
          ),
          const SizedBox(height: 25),
          ...DemoData.upcomingMatches.map((match) => Padding(padding: const EdgeInsets.only(bottom: 20), child: MatchCard(match: match))),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: active ? const Color(0xFF051125) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: active ? const Color(0xFFC69C2D) : Colors.white24)),
    );
  }
}

// --- TAHMİNLER SAYFASI ---
class CouponPredictionsPage extends StatelessWidget {
  const CouponPredictionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBarHeader(),
          const Text('25. Hafta Analizleri', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFC69C2D))),
          const SizedBox(height: 20),
          FutureBuilder<List<CouponMatch>>(
            future: DemoData.loadMatchesFromJson(),
            builder: (context, snapshot) {
              final matches = snapshot.data ?? [];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF0F2035), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withOpacity(0.05))),
                child: Column(children: matches.map((m) => CouponMatchRow(match: m)).toList()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});
  @override
  Widget build(BuildContext context) { return const Center(child: Text("Premium Hazırlanıyor...")); }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) { return const Center(child: Text("Profil Paneli")); }
}

// --- MAÇ KARTLARI (Elite Style) ---
class MatchCard extends StatelessWidget {
  final MatchPrediction match;
  const MatchCard({super.key, required this.match});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2035),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(match.homeTeam, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
            const Text('VS', style: TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.w900, fontSize: 18)),
            Expanded(child: Text(match.awayTeam, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          ]),
          const SizedBox(height: 20),
          const Text("AI Confidence Score", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Home Win", style: TextStyle(fontSize: 12, color: Color(0xFFC69C2D), fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(value: match.confidence, backgroundColor: Colors.white.withOpacity(0.05), color: const Color(0xFFC69C2D), minHeight: 8),
              )),
              const SizedBox(width: 10),
              Text("%${(match.confidence * 100).round()}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC69C2D))),
            ],
          ),
        ],
      ),
    );
  }
}

class CouponMatchRow extends StatelessWidget {
  final CouponMatch match;
  const CouponMatchRow({super.key, required this.match});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Text('${match.index}', style: const TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.bold)),
        const SizedBox(width: 15),
        Expanded(child: Text('${match.homeTeam} - ${match.awayTeam}', style: const TextStyle(fontSize: 14))),
        if (match.isLocked) const Icon(Icons.lock_rounded, size: 16, color: Colors.white12) else Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFC69C2D), borderRadius: BorderRadius.circular(6)), child: Text(match.prediction, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      ]),
    );
  }
}

// --- VERİ MODELİ ---
class DemoData {
  static final List<MatchPrediction> upcomingMatches = [
    MatchPrediction(homeTeam: 'Trabzonspor', awayTeam: 'Kasımpaşa', confidence: 0.75),
    MatchPrediction(homeTeam: 'Fenerbahçe', awayTeam: 'Göztepe', confidence: 0.92),
  ];
  static Future<List<CouponMatch>> loadMatchesFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/matches_data.json');
      final List<dynamic> data = json.decode(response);
      return data.map((m) => CouponMatch(index: m['id'], homeTeam: m['home'], awayTeam: m['away'], prediction: m['prediction'], isLocked: m['isLocked'])).toList();
    } catch (e) { return []; }
  }
  static const List<String> premiumBenefits = ['VIP Tahminler', '%75 Başarı', 'xG Analizleri', '7/24 Destek'];
}

class MatchPrediction {
  final String homeTeam, awayTeam;
  final double confidence;
  MatchPrediction({required this.homeTeam, required this.awayTeam, required this.confidence});
}

class CouponMatch {
  final int index;
  final String homeTeam, awayTeam, prediction;
  final bool isLocked;
  CouponMatch({required this.index, required this.homeTeam, required this.awayTeam, required this.prediction, required this.isLocked});
}
