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
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          elevation: 0,
        ),
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

class UpcomingMatchesPage extends StatelessWidget {
  const UpcomingMatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final matches = DemoData.upcomingMatches;

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
          ...matches.map((match) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MatchCard(match: match),
              )),
        ],
      ),
    );
  }
}

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
                return const Center(child: CircularProgressIndicator(color: Color(0xFFF9D648)));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Veri yüklenirken hata oluştu!'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Maç bulunamadı.'));
              }

              final matches = snapshot.data!;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Color(0xFFF9D648), size: 24),
                        SizedBox(width: 10),
                        Text('Büyük İkramiye Kuponu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF9D648))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ...matches.map((match) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CouponMatchRow(match: match),
                        )),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9D648),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('TÜM 15 MAÇLIK KUPONU AÇ', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
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
    return const Center(child: Text('Premium Sayfası Hazırlanıyor...'));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profil Sayfası Hazırlanıyor...'));
  }
}

class _TopSearchBar extends StatelessWidget {
  const _TopSearchBar();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.sports_soccer, color: Color(0xFFF9D648), size: 24),
        ),
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
  const MatchCard({super.key, required this.match});
  final MatchPrediction match;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(match.homeTeam, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text('VS', style: TextStyle(color: Color(0xFFF9D648), fontWeight: FontWeight.w900)),
              Text(match.awayTeam, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: match.confidence, backgroundColor: Colors.white10, color: const Color(0xFFF9D648)),
        ],
      ),
    );
  }
}

class CouponMatchRow extends StatelessWidget {
  const CouponMatchRow({super.key, required this.match});
  final CouponMatch match;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('${match.index}.', style: const TextStyle(color: Color(0xFFF9D648))),
          const SizedBox(width: 10),
          Expanded(child: Text('${match.homeTeam} - ${match.awayTeam}', style: const TextStyle(fontSize: 13))),
          if (match.isLocked) const Icon(Icons.lock_outline, size: 16, color: Colors.white38) else Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFF9D648), borderRadius: BorderRadius.circular(4)),
            child: Text(match.prediction, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class DemoData {
  static final List<MatchPrediction> upcomingMatches = [
    MatchPrediction(homeTeam: 'Fenerbahçe', awayTeam: 'Göztepe', confidence: 0.92),
    MatchPrediction(homeTeam: 'Karagümrük', awayTeam: 'Galatasaray', confidence: 0.88),
  ];

  static Future<List<CouponMatch>> loadMatchesFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/matches_data.json');
      final List<dynamic> data = json.decode(response);
      return data.map((m) => CouponMatch(
        index: m['id'],
        homeTeam: m['home'],
        awayTeam: m['away'],
        prediction: m['prediction'],
        isLocked: m['isLocked'],
      )).toList();
    } catch (e) {
      return [];
    }
  }
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
