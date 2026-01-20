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
    // --- LOGONUN KENDİ LACİVERTİ VE ALTIN RENGİ ---
    const brandNavy = Color(0xFF060B28); // Logo arka planındaki derin lacivert
    const brandCard = Color(0xFF101636); // Kartlar için bir tık açık ton
    const goldAction = Color(0xFFFFD700); // Parlak altın/sarı

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: brandNavy,
        primaryColor: goldAction,
        cardColor: brandCard,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: goldAction),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0BEC5)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: goldAction,
            foregroundColor: brandNavy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- LOGO BİLEŞENİ (Center Crop - Sündürmeden) ---
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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

// --- 1. ADIM: AÇILIŞ EKRANI (Metin Kaldırıldı) ---
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
            const BrandLogo(size: 180, radius: 20), // Sadece logo
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Color(0xFFFFD700), strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}

// --- 2. ADIM: GİRİŞ EKRANI (Predict Yazısı Kaldırıldı) ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const BrandLogo(size: 120, radius: 20), // Logo tek başına parlıyor
            const SizedBox(height: 60),
            TextField(decoration: InputDecoration(hintText: "E-posta", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 15),
            TextField(obscureText: true, decoration: InputDecoration(hintText: "Şifre", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainShell())),
                child: const Text("GİRİŞ YAP"),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Hesabınız yok mu? Kayıt Ol", style: TextStyle(color: Colors.grey, fontSize: 12)),
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
        backgroundColor: const Color(0xFF060B28),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Predictions'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(child: _pages[_currentIndex]),
    );
  }
}

// --- ÜST BAR (HER SAYFADA LOGO) ---
class _TopBarHeader extends StatelessWidget {
  const _TopBarHeader();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const BrandLogo(size: 45, radius: 8), // Şık AppBar Logosu
        Row(children: [
          Icon(Icons.notifications_none_rounded, color: Colors.grey[400]),
          const SizedBox(width: 15),
          const CircleAvatar(radius: 18, backgroundColor: Color(0xFF101636), child: Icon(Icons.person, size: 20, color: Color(0xFFFFD700))),
        ])
      ],
    );
  }
}

// --- SAYFA: ANA SAYFA ---
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

// --- SAYFA: TAHMİNLER ---
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
          Text('Spor Toto Tahminleri', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 20),
          FutureBuilder<List<CouponMatch>>(
            future: DemoData.loadMatchesFromJson(),
            builder: (context, snapshot) {
              final matches = snapshot.data ?? [];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF101636), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
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
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(16), child: Column(children: [_TopBarHeader(), Expanded(child: Center(child: Text("Premium Çok Yakında")))]));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(16), child: Column(children: [_TopBarHeader(), Expanded(child: Center(child: Text("Profil Sayfası")))]));
  }
}

// --- KARTLAR VE SATIRLAR ---
class MatchCard extends StatelessWidget {
  final MatchPrediction match;
  const MatchCard({super.key, required this.match});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF101636), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
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
  static const List<String> premiumBenefits = ['VIP Tahminler', '%75 Başarı', 'Detaylı Analizler', '7/24 Destek'];
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
