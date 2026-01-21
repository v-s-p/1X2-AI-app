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
    // --- ELITE DARK RENK REHBERİ ---
    const brandNavy = Color(0xFF051125); // Tam istediğin Derin Lacivert
    const goldPrimary = Color(0xFFC69C2D); // amberAccent[700] dengi Elite Altın
    const mutedGrey = Color(0xFFB0BEC5); // Gümüş Gri

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: brandNavy,
        primaryColor: goldPrimary,
        cardColor: const Color(0xFF0F2035),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFC69C2D)),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: mutedGrey),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- 1. ADIM: ELITE SPLASH SCREEN (PULSE ANIMATION) ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse (Nefes Alma) Animasyonu Ayarı
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // React setTimeout Mantığı: 3 Saniye sonra Dashboard'a uçur
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulse Efektli Logo ve Başlık (Horizontal Row)
            ScaleTransition(
              scale: _pulseAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BrandLogo(size: 100, radius: 24), // Kare, Yuvarlak Köşe
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Predict",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "1X2 AI",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Futuristic Football Analysis",
              style: TextStyle(color: Color(0xFFB0BEC5), fontSize: 14, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

// --- LOGO BİLEŞENİ (Center Crop & No Distortion) ---
class BrandLogo extends StatelessWidget {
  final double size;
  final double radius;
  const BrandLogo({super.key, required this.size, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.cover, // Sündürmeden doldur
          alignment: Alignment.center, // Ortala
        ),
      ),
    );
  }
}

// --- GİRİŞ EKRANI ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BrandLogo(size: 120, radius: 25),
            const SizedBox(height: 60),
            TextField(decoration: InputDecoration(hintText: "E-posta", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
            const SizedBox(height: 15),
            TextField(obscureText: true, decoration: InputDecoration(hintText: "Şifre", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.black),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainShell())),
                child: const Text("ANALİZE BAŞLA"),
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
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_motion), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: 'Tahminler'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profil'),
        ],
      ),
      body: SafeArea(child: _pages[_currentIndex]),
    );
  }
}

// --- SAYFA BİLEŞENLERİ: ÜST LOGO ---
class _TopBarHeader extends StatelessWidget {
  const _TopBarHeader();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BrandLogo(size: 45, radius: 12),
          const Text("PREDICT 1X2", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, fontSize: 16)),
          CircleAvatar(radius: 20, backgroundColor: Colors.white.withOpacity(0.05), child: const Icon(Icons.person_outline, color: Color(0xFFC69C2D))),
        ],
      ),
    );
  }
}

// --- ANA SAYFA ---
class UpcomingMatchesPage extends StatelessWidget {
  const UpcomingMatchesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBarHeader(),
          const SizedBox(height: 30),
          const Text('Gelecek Maçlar', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          ...DemoData.upcomingMatches.map((match) => Padding(padding: const EdgeInsets.only(bottom: 20), child: MatchCard(match: match))),
        ],
      ),
    );
  }
}

// --- TAHMİNLER ---
class CouponPredictionsPage extends StatelessWidget {
  const CouponPredictionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBarHeader(),
          const SizedBox(height: 20),
          const Text('25. Hafta YZ Kuponu', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
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

// --- DİĞER SAYFALAR ---
class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});
  @override
  Widget build(BuildContext context) { return const Center(child: Text("Premium Panel")); }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) { return const Center(child: Text("Profil Panel")); }
}

// --- MAÇ KARTLARI ---
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
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(match.homeTeam, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            const Text('VS', style: TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.w900, fontSize: 18)),
            Expanded(child: Text(match.awayTeam, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          ]),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: match.confidence, backgroundColor: Colors.white.withOpacity(0.03), color: const Color(0xFFC69C2D), minHeight: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Text('${match.index}', style: const TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.bold)),
        const SizedBox(width: 15),
        Expanded(child: Text('${match.homeTeam} - ${match.awayTeam}', style: const TextStyle(fontSize: 14))),
        if (match.isLocked) const Icon(Icons.lock_outline, size: 16, color: Colors.white10) else Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFC69C2D), borderRadius: BorderRadius.circular(8)), child: Text(match.prediction, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
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
