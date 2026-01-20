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
    // --- ELITE DARK RENK PALETİ ---
    const deepNavy = Color(0xFF051125); // Arka plan
    const cardNavy = Color(0xFF0F2035); // Kartlar
    const goldAction = Color(0xFFFFD700); // Altın vurgular

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: deepNavy,
        primaryColor: goldAction,
        cardColor: cardNavy,
        // Genel Font ve Yazı Stilleri
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: goldAction),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0BEC5)), // Gümüş gri
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: goldAction,
            foregroundColor: deepNavy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            elevation: 5,
          ),
        ),
      ),
      home: const SplashScreen(),
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
    // 3 saniye logoyu göster ve login sayfasına geç
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF0A1E3D), Color(0xFF051125)],
            radius: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 150), // Logo tam ortada
            const SizedBox(height: 20),
            const Text(
              'PREDICT 1X2 AI',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 100), // Logo tepede
            const SizedBox(height: 40),
            const Text("Hoş Geldiniz", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Yapay zeka ile kazanmaya hazır mısınız?", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
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
  final List<Widget> _pages = const [
    UpcomingMatchesPage(),
    CouponPredictionsPage(),
    PremiumPage(),
    ProfilePage(),
  ];

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
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on_rounded), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph_rounded), label: 'Tahminler'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium_rounded), label: 'Premium'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
      body: SafeArea(child: _pages[_currentIndex]),
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
          const _TopAppBarLogo(), // AppBar'da Logo
          const SizedBox(height: 30),
          Text('Gelecek Maçlar', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text('Yapay zeka destekli profesyonel tahminler.', style: TextStyle(color: Colors.grey[400])),
          const SizedBox(height: 25),
          ...DemoData.upcomingMatches.map((match) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MatchCard(match: match),
              )),
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
          const _TopAppBarLogo(),
          const SizedBox(height: 20),
          Text('Spor Toto YZ Tahminleri', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 20),
          FutureBuilder<List<CouponMatch>>(
            future: DemoData.loadMatchesFromJson(),
            builder: (context, snapshot) {
              final matches = snapshot.data ?? [];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F2035),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    const Row(children: [Icon(Icons.auto_awesome, color: Color(0xFFFFD700), size: 20), SizedBox(width: 10), Text('JACKPOT KUPONU', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5))]),
                    const Divider(height: 30, color: Colors.white10),
                    ...matches.map((m) => CouponMatchRow(match: m)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- PREMIUM SAYFASI ---
class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const _TopAppBarLogo(),
          const SizedBox(height: 40),
          const Icon(Icons.stars_rounded, size: 80, color: Color(0xFFFFD700)),
          const SizedBox(height: 20),
          Text('Kazananlar Kulübü', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 30),
          ...DemoData.premiumBenefits.map((b) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [const Icon(Icons.verified_rounded, color: Color(0xFFFFD700), size: 20), const SizedBox(width: 12), Text(b, style: const TextStyle(fontSize: 15))]))),
          const SizedBox(height: 40),
          const PriceCard(title: 'Aylık Üyelik', price: '199₺', unit: '/ay', isPopular: true),
          const SizedBox(height: 40),
          SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: () {}, child: const Text("PREMIUM'A YÜKSELT"))),
        ],
      ),
    );
  }
}

// --- PROFİL SAYFASI ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const _TopAppBarLogo(),
          const SizedBox(height: 40),
          const CircleAvatar(radius: 50, backgroundColor: Color(0xFFFFD700), child: Icon(Icons.person, size: 60, color: Color(0xFF051125))),
          const SizedBox(height: 15),
          const Text('Mert Yılmaz', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const Text('ÜCRETSİZ PLAN', style: TextStyle(color: Color(0xFFFFD700), letterSpacing: 2, fontSize: 12)),
          const SizedBox(height: 40),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _StatItem(label: 'Tahmin', value: '12'),
            _StatItem(label: 'Kazanç', value: '8'),
            _StatItem(label: 'Başarı', value: '%66'),
          ]),
          const SizedBox(height: 40),
          const _ProfileListTile(title: 'Bildirimler', icon: Icons.notifications_none_rounded),
          const _ProfileListTile(title: 'Güvenlik', icon: Icons.security_rounded),
          const _ProfileListTile(title: 'Destek', icon: Icons.headset_mic_rounded),
          const _ProfileListTile(title: 'Çıkış', icon: Icons.logout_rounded, isExit: true),
        ],
      ),
    );
  }
}

// --- ÖZEL BİLEŞENLER ---

class _TopAppBarLogo extends StatelessWidget {
  const _TopAppBarLogo();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/logo.png', height: 40), // AppBar'daki Logo
        Row(children: [
          Icon(Icons.notifications_none_rounded, color: Colors.grey[400]),
          const SizedBox(width: 15),
          const CircleAvatar(radius: 18, backgroundColor: Color(0xFF0F2035), child: Icon(Icons.person, size: 20, color: Color(0xFFFFD700))),
        ])
      ],
    );
  }
}

class MatchCard extends StatelessWidget {
  final MatchPrediction match;
  const MatchCard({super.key, required this.match});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2035),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(match.homeTeam, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('VS', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w900))),
            Expanded(child: Text(match.awayTeam, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          ]),
          const SizedBox(height: 15),
          LinearProgressIndicator(value: match.confidence, backgroundColor: Colors.white.withOpacity(0.05), color: const Color(0xFFFFD700), minHeight: 6),
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerRight, child: Text("%${(match.confidence * 100).round()} AI Güven Skoru", style: const TextStyle(fontSize: 10, color: Colors.grey))),
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
      child: Row(
        children: [
          Text('${match.index}', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
          const SizedBox(width: 15),
          Expanded(child: Text('${match.homeTeam} - ${match.awayTeam}', style: const TextStyle(fontSize: 14))),
          if (match.isLocked) const Icon(Icons.lock_rounded, size: 16, color: Colors.white24) else Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(6)), child: Text(match.prediction, style: const TextStyle(color: Color(0xFF051125), fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  final String title, price, unit;
  final bool isPopular;
  const PriceCard({super.key, required this.title, required this.price, required this.unit, this.isPopular = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0F2035), borderRadius: BorderRadius.circular(15), border: Border.all(color: isPopular ? const Color(0xFFFFD700) : Colors.white10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text('$price$unit', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]);
  }
}

class _ProfileListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isExit;
  const _ProfileListTile({required this.title, required this.icon, this.isExit = false});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isExit ? Colors.redAccent : const Color(0xFFFFD700)),
      title: Text(title, style: TextStyle(color: isExit ? Colors.redAccent : Colors.white)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10),
    );
  }
}

// --- VERİ MODELİ (GÜNCEL) ---
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
