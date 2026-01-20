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
    const deepNavy = Color(0xFF051125);
    const goldAction = Color(0xFFFFD700);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: deepNavy,
        primaryColor: goldAction,
        cardColor: const Color(0xFF0F2035),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: goldAction),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0BEC5)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: goldAction,
            foregroundColor: deepNavy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- LOGO BİLEŞENİ (Center Crop Mantığı) ---
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
        border: Border.all(color: Colors.white10, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          'assets/logo.png', // Logo yolun
          fit: BoxFit.cover,    // Kutuyu sündürmeden doldur
          alignment: Alignment.center, // Ortaya odakla
        ),
      ),
    );
  }
}

// --- 1. ADIM: ELITE SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BrandLogo(size: 150, radius: 25), // Büyük Splash Logosu
            const SizedBox(height: 25),
            const Text('PREDICT 1X2 AI', style: TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 3)),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Color(0xFFFFD700), strokeWidth: 2),
          ],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const BrandLogo(size: 100, radius: 20), // Login Logosu
            const SizedBox(height: 40),
            const Text("Hoş Geldiniz", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(decoration: InputDecoration(hintText: "E-posta", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 15),
            TextField(obscureText: true, decoration: InputDecoration(hintText: "Şifre", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainShell())), child: const Text("GİRİŞ YAP"))),
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
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Tahminler'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      body: SafeArea(child: _pages[_currentIndex]),
    );
  }
}

// --- ÜST BAR LOGO BİLEŞENİ ---
class _TopBarHeader extends StatelessWidget {
  const _TopBarHeader();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const BrandLogo(size: 40, radius: 8), // AppBar Logosu
        Row(children: [
          Icon(Icons.notifications_none_rounded, color: Colors.grey[400]),
          const SizedBox(width: 15),
          const CircleAvatar(radius: 18, backgroundColor: Color(0xFF0F2035), child: Icon(Icons.person, size: 20, color: Color(0xFFFFD700))),
        ])
      ],
    );
  }
}

// --- ANA SAYFA ---
class UpcomingMatchesPage extends StatelessWidget {
  const UpcomingMatchesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBarHeader(),
          const SizedBox(height: 30),
          Text('Gelecek Maçlar', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 25),
          ...DemoData.upcomingMatches.map((match) => Padding(padding: const EdgeInsets.only(bottom: 16), child: MatchCard(match: match))),
        ],
      ),
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
          const SizedBox(height: 20),
          Text('Spor Toto YZ Tahminleri', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 20),
          FutureBuilder<List<CouponMatch>>(
            future: DemoData.loadMatchesFromJson(),
            builder: (context, snapshot) {
              final matches = snapshot.data ?? [];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF0F2035), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                child: Column(children: matches.map((m) => CouponMatchRow(match: m)).toList()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- DİĞER SAYFALAR (Premium & Profil) ---
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

// --- KARTLAR VE SATIRLAR ---
class MatchCard extends StatelessWidget {
  final MatchPrediction match;
  const MatchCard({super.key, required this.match});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0F2035), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(match.homeTeam, style: const TextStyle(fontWeight: FontWeight.bold))),
            const Text('VS', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w900)),
            Expanded(child: Text(match.awayTeam, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 15),
          LinearProgressIndicator(value: match.confidence, backgroundColor: Colors.white.withOpacity(0.05), color: const Color(0xFFFFD700), minHeight: 6),
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
        Text('${match.index}', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        const SizedBox(width: 15),
        Expanded(child: Text('${match.homeTeam} - ${match.awayTeam}', style: const TextStyle(fontSize: 14))),
        if (match.isLocked) const Icon(Icons.lock_rounded, size: 16, color: Colors.white24) else Text(match.prediction, style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
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
  static const List<String> premiumBenefits = ['Günlük VIP Tahminler', '%75 Başarı Oranı', 'Detaylı xG Analizleri', 'Tüm Dünya Ligleri', '7/24 Destek'];
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
