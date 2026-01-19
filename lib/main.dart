import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() => runApp(const PredictAIApp());

class PredictAIApp extends StatelessWidget {
  const PredictAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020817), // Görseldeki koyu lacivert
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 25. Hafta Maç Verileri
    final List<Map<String, dynamic>> matches = [
      {"home": "Göztepe", "away": "Fatih Karagümrük", "conf": 0.75, "pred": "1"},
      {"home": "Gençlerbirliği", "away": "Gaziantep FK", "conf": 0.68, "pred": "2"},
      {"home": "Kocaelispor", "away": "Fenerbahçe", "conf": 0.82, "pred": "2"},
      {"home": "Rams Başakşehir", "away": "Çaykur Rizespor", "conf": 0.70, "pred": "1"},
      {"home": "Galatasaray", "away": "Kayserispor", "conf": 0.90, "pred": "1"},
      {"home": "Kasımpaşa", "away": "Samsunspor", "conf": 0.65, "pred": "1"},
      {"home": "Alanyaspor", "away": "Eyüpspor", "conf": 0.55, "pred": "X"},
      {"home": "Beşiktaş", "away": "Konyaspor", "conf": 0.78, "pred": "1"},
      {"home": "Antalyaspor", "away": "Trabzonspor", "conf": 0.60, "pred": "X"},
      {"home": "Tottenham", "away": "Man. City", "conf": 0.72, "pred": "2"},
      {"home": "Real Madrid", "away": "Rayo Vallecano", "conf": 0.85, "pred": "1"},
      {"home": "Athletic Club", "away": "Real Sociedad", "conf": 0.58, "pred": "X"},
      {"home": "Cremonese", "away": "Inter Milan", "conf": 0.80, "pred": "2"},
      {"home": "Dortmund", "away": "Heidenheim", "conf": 0.75, "pred": "1"},
      {"home": "PSG", "away": "Strasbourg", "conf": 0.88, "pred": "1"},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png'), // Logo dosyanın adı doğru olmalı
        ),
        title: Text('Upcoming Matches', 
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 15),
          Icon(Icons.person_outline),
          SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text("AI-powered predictions for the beautiful game.",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                return MatchCard(
                  homeTeam: matches[index]['home'],
                  awayTeam: matches[index]['away'],
                  confidence: matches[index]['conf'],
                  prediction: matches[index]['pred'],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF020817),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Predictions'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: 'Profile'),
        ],
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final String homeTeam, awayTeam, prediction;
  final double confidence;
  const MatchCard({super.key, required this.homeTeam, required this.awayTeam, required this.confidence, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Kart rengi
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(homeTeam, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.yellow.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                child: Text("VS", style: GoogleFonts.poppins(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              Expanded(child: Text(awayTeam, textAlign: TextAlign.end, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("AI Confidence Score", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
              Text("Prediction: $prediction", style: GoogleFonts.poppins(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: confidence,
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white.withOpacity(0.1),
            progressColor: Colors.yellow,
            barRadius: const Radius.circular(10),
            trailing: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("${(confidence * 100).toInt()}%", style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
Önemli Notlar ve İpuçları:
Logo: assets/logo.png isminin deponda tam olarak aynı olduğundan emin ol (küçük/büyük harf duyarlıdır).
Yayınlama: Kodları yapıştırdıktan sonra terminalde flutter pub get komutunu çalıştırarak eklediğimiz paketleri projene dahil etmelisin.
Hata Kontrolü: Eğer main.dart içinde kırmızı hata çizgileri görürsen, muhtemelen paketlerin yüklenmesi gerekiyordur.
GitHub'a Gönderme: Bu değişiklikleri yaptıktan sonra şu komutlarla GitHub'a gönderebilirsin:
git add .
git commit -m "UI design and week 25 data integrated"
git push origin main
Bu temel yapı kurulduktan sonra, 2. Adım olarak maçları her hafta otomatik çekecek Python koduna ve premium kilit sistemine odaklanabiliriz. Başlamaya hazır mısın?
Model
ThinkingThoughts
Expand to view model thoughts

chevron_right
Mevcut kodunu, paylaştığın görsellere tam sadık kalarak, 25. Hafta Spor Toto verileriyle güncelledim ve tamamen Türkçe'ye çevirdim.
Bu kodu kopyalayıp main.dart dosyanın tamamıyla değiştirebilirsin. Tasarımı daha "premium" hale getirmek için google_fonts paketini de eklediğini varsayarak optimize ettim.
code
Dart
import 'package:flutter/material.dart';

void main() {
  runApp(const PredictApp());
}

class PredictApp extends StatelessWidget {
  const PredictApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryYellow = Color(0xFFF9D648);
    const background = Color(0xFF020817); // Daha koyu, modern arka plan
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
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: primaryYellow),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryYellow),
          bodyLarge: TextStyle(fontSize: 15, height: 1.4, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 13, color: Colors.white70),
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
        showUnselectedLabels: true,
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
    final matches = DemoData.upcomingMatches;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 24),
          Text('Gelecek Maçlar', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 4),
          const Text('Yapay zeka destekli profesyonel tahminler.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 20),
          const _MatchTabs(),
          const SizedBox(height: 16),
          ...matches.map((match) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MatchCard(match: match),
              )),
        ],
      ),
    );
  }
}

// --- TAHMİNLER (SPOR TOTO 15 MAÇ) ---
class CouponPredictionsPage extends StatelessWidget {
  const CouponPredictionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final matches = DemoData.couponMatches;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 20),
          Text('Spor Toto YZ Tahminleri', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 4),
          const Text('25. Hafta için 15 maçlık özel kupon.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Color(0xFFF9D648), size: 24),
                    const SizedBox(width: 10),
                    Text('Büyük İkramiye Kuponu', style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                const SizedBox(height: 20),
                ...matches.map((match) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CouponMatchRow(match: match),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9D648),
                foregroundColor: const Color(0xFF0B1433),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
              ),
              child: const Text('TÜM 15 MAÇLIK KUPONU AÇ', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            ),
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
    final benefits = DemoData.premiumBenefits;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 24),
          Text('Kazananlar Kulübüne Katıl', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          const Text('Predict 1X2 AI\'nın tüm gücünü açın ve kazanmaya başlayın.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Premium Avantajları', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                ...benefits.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFFF9D648), size: 22),
                          const SizedBox(width: 12),
                          Expanded(child: Text(benefit, style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const PricePlanCard(
            title: 'Aylık',
            subtitle: 'Sadece 149.99₺/hafta',
            price: '599.99₺',
            unit: '/ay',
            highlight: 'En Popüler',
          ),
          const SizedBox(height: 12),
          const PricePlanCard(
            title: 'Haftalık',
            subtitle: 'Kısa süreli deneme için ideal',
            price: '199.99₺',
            unit: '/hafta',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9D648),
                foregroundColor: const Color(0xFF0B1433),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('ŞİMDİ ABONE OL', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF020817),
                  child: Icon(Icons.person, size: 45, color: Color(0xFFF9D648)),
                ),
                const SizedBox(height: 16),
                Text('Mert Yılmaz', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF9D648)),
                  ),
                  child: const Text('ÜCRETSİZ PLAN', style: TextStyle(color: Color(0xFFF9D648), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF9D648), size: 30),
                      const SizedBox(height: 8),
                      const Text('Kazanma Potansiyelini Artır', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      const Text('Detaylı AI analizleri için Premium\'a geç.', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9D648),
                            foregroundColor: const Color(0xFF0B1433),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Premium\'a Yükselt', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(child: StatCard(label: 'Tahmin', value: '12')),
              SizedBox(width: 10),
              Expanded(child: StatCard(label: 'Kazanç', value: '8')),
              SizedBox(width: 10),
              Expanded(child: StatCard(label: 'Başarı', value: '%66')),
            ],
          ),
          const SizedBox(height: 24),
          const _ProfileOption(title: 'Bildirim Ayarları', icon: Icons.notifications_active_outlined),
          const _ProfileOption(title: 'Destek Ekibi', icon: Icons.support_agent),
          const _ProfileOption(title: 'Çıkış Yap', icon: Icons.logout, isDestructive: true),
        ],
      ),
    );
  }
}

// --- YARDIMCI BİLEŞENLER ---

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
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.white54, size: 20),
                SizedBox(width: 10),
                Text('Maç ara...', style: TextStyle(color: Colors.white38)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.notifications_none, color: Color(0xFFF9D648)),
        const SizedBox(width: 12),
        const Icon(Icons.person_outline, color: Color(0xFFF9D648)),
      ],
    );
  }
}

class _MatchTabs extends StatelessWidget {
  const _MatchTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _TabChip(label: 'Hepsi', isActive: true)),
        SizedBox(width: 8),
        Expanded(child: _TabChip(label: 'Canlı')),
        SizedBox(width: 8),
        Expanded(child: _TabChip(label: 'Biten')),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({required this.label, this.isActive = false});
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF9D648) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: isActive ? Colors.black : Colors.white70, fontWeight: FontWeight.bold),
      ),
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
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(match.time, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.yellow.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(match.league, style: const TextStyle(color: Color(0xFFF9D648), fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TeamColumn(name: match.homeTeam),
              const Text('VS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.black, color: Color(0xFFF9D648))),
              _TeamColumn(name: match.awayTeam, alignEnd: true),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('YZ Güven Skoru', style: TextStyle(fontSize: 12, color: Colors.white70)),
              const Spacer(),
              Text('${(match.confidence * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF9D648))),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: match.confidence,
              minHeight: 8,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFF9D648)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  const _TeamColumn({required this.name, this.alignEnd = false});
  final String name;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Column(
        crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20, backgroundColor: const Color(0xFF020817), child: Text(name[0], style: const TextStyle(color: Color(0xFFF9D648)))),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFF020817), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Text('${match.index}.', style: const TextStyle(color: Color(0xFFF9D648), fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Text(match.homeTeam, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('vs', style: TextStyle(color: Colors.white38, fontSize: 11))),
                Expanded(child: Text(match.awayTeam, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis, textAlign: TextAlign.end)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (match.isLocked)
            const Icon(Icons.lock_outline, color: Color(0xFFF9D648), size: 18)
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFF9D648), borderRadius: BorderRadius.circular(8)),
              child: Text(match.prediction, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}

class PricePlanCard extends StatelessWidget {
  const PricePlanCard({super.key, required this.title, required this.subtitle, required this.price, required this.unit, this.highlight});
  final String title, subtitle, price, unit;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: highlight != null ? const Color(0xFFF9D648) : Colors.white12),
      ),
      child: Row(
        children: [
          Icon(Icons.radio_button_checked, color: highlight != null ? const Color(0xFFF9D648) : Colors.white38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(price, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF9D648))),
            Text(unit, style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ]),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFF9D648))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ]),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({required this.title, required this.icon, this.isDestructive = false});
  final String title;
  final IconData icon;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? Colors.redAccent : Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.white, fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.white24),
        ],
      ),
    );
  }
}

// --- GÜNCEL VERİ MODELİ (25. HAFTA EXCEL LİSTESİ) ---

class DemoData {
  static final List<MatchPrediction> upcomingMatches = [
    MatchPrediction(time: '24 Oca, 20:00', league: 'Süper Lig', homeTeam: 'Karagümrük', awayTeam: 'Galatasaray', confidence: 0.88),
    MatchPrediction(time: '25 Oca, 20:00', league: 'Süper Lig', homeTeam: 'Fenerbahçe', awayTeam: 'Göztepe', confidence: 0.92),
    MatchPrediction(time: '25 Oca, 19:30', league: 'Premier Lig', homeTeam: 'Arsenal', awayTeam: 'Man. United', confidence: 0.70),
  ];

  static final List<CouponMatch> couponMatches = [
    CouponMatch(index: 1, homeTeam: 'Trabzonspor', awayTeam: 'Kasımpaşa', prediction: '1', isLocked: false),
    CouponMatch(index: 2, homeTeam: 'Kayserispor', awayTeam: 'Başakşehir', prediction: 'X', isLocked: false),
    CouponMatch(index: 3, homeTeam: 'Samsunspor', awayTeam: 'Kocaelispor', prediction: '1', isLocked: true),
    CouponMatch(index: 4, homeTeam: 'Karagümrük', awayTeam: 'Galatasaray', prediction: '2', isLocked: true),
    CouponMatch(index: 5, homeTeam: 'Gaziantep FK', awayTeam: 'Konyaspor', prediction: '1', isLocked: true),
    CouponMatch(index: 6, homeTeam: 'Antalyaspor', awayTeam: 'Gençlerbirliği', prediction: '1', isLocked: true),
    CouponMatch(index: 7, homeTeam: 'Rizespor', awayTeam: 'Alanyaspor', prediction: 'X', isLocked: true),
    CouponMatch(index: 8, homeTeam: 'Fenerbahçe', awayTeam: 'Göztepe', prediction: '1', isLocked: true),
    CouponMatch(index: 9, homeTeam: 'Eyüpspor', awayTeam: 'Beşiktaş', prediction: '2', isLocked: true),
    CouponMatch(index: 10, homeTeam: 'Union Berlin', awayTeam: 'Dortmund', prediction: '2', isLocked: true),
    CouponMatch(index: 11, homeTeam: 'Marsilya', awayTeam: 'Lens', prediction: '1', isLocked: true),
    CouponMatch(index: 12, homeTeam: 'Arsenal', awayTeam: 'Man. United', prediction: '1', isLocked: true),
    CouponMatch(index: 13, homeTeam: 'Villarreal', awayTeam: 'Real Madrid', prediction: '2', isLocked: true),
    CouponMatch(index: 14, homeTeam: 'Juventus', awayTeam: 'Napoli', prediction: 'X', isLocked: true),
    CouponMatch(index: 15, homeTeam: 'Roma', awayTeam: 'AC Milan', prediction: '2', isLocked: true),
  ];

  static const List<String> premiumBenefits = [
    'Günlük YZ Destekli VIP Tahminler',
    '%75 Üzeri Kanıtlanmış Başarı',
    'Detaylı xG ve Form Analizleri',
    'Tüm Dünya Liglerine Erişim',
    'Premium Üyelere Özel VIP Topluluk',
    '7/24 Teknik Destek',
  ];
}

class MatchPrediction {
  final String time, league, homeTeam, awayTeam;
  final double confidence;
  MatchPrediction({
    required this.time, 
    required this.league, 
    required this.homeTeam, 
    required this.awayTeam, 
    required this.confidence
  });
}

class CouponMatch {
  final int index;
  final String homeTeam, awayTeam, prediction;
  final bool isLocked;
  CouponMatch({
    required this.index, 
    required this.homeTeam, 
    required this.awayTeam, 
    required this.prediction, 
    required this.isLocked
  });
}
