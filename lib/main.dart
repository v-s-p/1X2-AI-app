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
    const primaryYellow = Color(0xFFF9D648);
    const background = Color(0xFF020817);
    const card = Color(0xFF0F172A);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: primaryYellow,
          secondary: primaryYellow,
          surface: card,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: background, elevation: 0),
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
  final List<Widget> _pages = const [
    UpcomingMatchesPage(),
    CouponPredictionsPage(),
    PremiumPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF020817),
        selectedItemColor: const Color(0xFFF9D648),
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Tahminler'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: 'Profil'),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 24),
          const Text('Gelecek Maçlar', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFF9D648))),
          const SizedBox(height: 4),
          const Text('Yapay zeka destekli profesyonel tahminler.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 20),
          ...DemoData.upcomingMatches.map((match) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MatchCard(match: match),
              )),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 20),
          const Text('Spor Toto YZ Tahminleri', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFF9D648))),
          const SizedBox(height: 20),
          FutureBuilder<List<CouponMatch>>(
            future: DemoData.loadMatchesFromJson(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final matches = snapshot.data ?? [];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)),
                child: Column(
                  children: [
                    const Row(children: [Icon(Icons.auto_awesome, color: Color(0xFFF9D648)), SizedBox(width: 10), Text('Jackpot Kuponu - 15 Maç', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 20),
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

// --- PREMIUM SAYFASI (Görsel 4 & 5'e Sadık) ---
class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('Kazananlar Kulübüne Katıl', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFF9D648))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: DemoData.premiumBenefits.map((b) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [const Icon(Icons.check_circle, color: Color(0xFFF9D648), size: 20), const SizedBox(width: 10), Text(b)]))).toList(),
            ),
          ),
          const SizedBox(height: 20),
          const PriceCard(title: 'Aylık', subtitle: 'Haftalık sadece 49₺', price: '199₺', unit: '/ay', isPopular: true),
          const SizedBox(height: 12),
          const PriceCard(title: 'Haftalık', subtitle: 'Deneme için ideal', price: '59₺', unit: '/hafta'),
        ],
      ),
    );
  }
}

// --- PROFİL SAYFASI (Görsel 7'ye Sadık) ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Color(0xFFF9D648), child: Icon(Icons.person, size: 50, color: Colors.black)),
          const SizedBox(height: 10),
          const Text('Mert Yılmaz', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('ÜCRETSİZ PLAN', style: TextStyle(color: Color(0xFFF9D648), fontSize: 12)),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatBox(label: 'Tahmin', value: '12'),
              StatBox(label: 'Kazanç', value: '8'),
              StatBox(label: 'Başarı', value: '%66'),
            ],
          ),
          const SizedBox(height: 30),
          _ProfileMenu(title: 'Bildirim Ayarları', icon: Icons.notifications),
          _ProfileMenu(title: 'Destek', icon: Icons.support_agent),
          _ProfileMenu(title: 'Çıkış Yap', icon: Icons.logout, isRed: true),
        ],
      ),
    );
  }
}

// --- YARDIMCI BİLEŞENLER ---

class PriceCard extends StatelessWidget {
  final String title, subtitle, price, unit;
  final bool isPopular;
  const PriceCard({super.key, required this.title, required this.subtitle, required this.price, required this.unit, this.isPopular = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(15), border: Border.all(color: isPopular ? const Color(0xFFF9D648) : Colors.white10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12))]),
          Text('$price$unit', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFF9D648))),
        ],
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String label, value;
  const StatBox({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFF9D648))), Text(label, style: const TextStyle(color: Colors.white54))]);
  }
}

class _ProfileMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isRed;
  const _ProfileMenu({required this.title, required this.icon, this.isRed = false});
  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon, color: isRed ? Colors.red : const Color(0xFFF9D648)), title: Text(title, style: TextStyle(color: isRed ? Colors.red : Colors.white)), trailing: const Icon(Icons.chevron_right, color: Colors.white24));
  }
}

class _TopSearchBar extends StatelessWidget {
  const _TopSearchBar();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.sports_soccer, color: Color(0xFFF9D648))),
        const SizedBox(width: 12),
        const Expanded(child: Text("Predict 1X2 AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
        const Icon(Icons.notifications_none, color: Color(0xFFF9D648)),
        const SizedBox(width: 12),
        const Icon(Icons.person_outline, color: Color(0xFFF9D648)),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(match.homeTeam, style: const TextStyle(fontWeight: FontWeight.bold)), const Text('VS', style: TextStyle(color: Color(0xFFF9D648), fontWeight: FontWeight.w900)), Text(match.awayTeam, style: const TextStyle(fontWeight: FontWeight.bold))]),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: match.confidence, backgroundColor: Colors.white10, color: const Color(0xFFF9D648)),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('${match.index}.', style: const TextStyle(color: Color(0xFFF9D648))),
          const SizedBox(width: 10),
          Expanded(child: Text('${match.homeTeam} - ${match.awayTeam}', style: const TextStyle(fontSize: 14))),
          if (match.isLocked) const Icon(Icons.lock_outline, size: 18, color: Colors.white38) else Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFF9D648), borderRadius: BorderRadius.circular(6)), child: Text(match.prediction, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class DemoData {
  static final List<MatchPrediction> upcomingMatches = [
    MatchPrediction(homeTeam: 'Trabzonspor', awayTeam: 'Kasımpaşa', confidence: 0.75),
    MatchPrediction(homeTeam: 'Karagümrük', awayTeam: 'Galatasaray', confidence: 0.88),
  ];

  static Future<List<CouponMatch>> loadMatchesFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/matches_data.json');
      final List<dynamic> data = json.decode(response);
      return data.map((m) => CouponMatch(index: m['id'], homeTeam: m['home'], awayTeam: m['away'], prediction: m['prediction'], isLocked: m['isLocked'])).toList();
    } catch (e) { return []; }
  }

  static const List<String> premiumBenefits = ['Günlük VIP Tahminler', '%75 Başarı Oranı', 'Detaylı Analizler', 'Tüm Liglere Erişim', 'VIP Topluluk', '7/24 Destek'];
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
