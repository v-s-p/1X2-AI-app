import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const PredictApp());
}

class PredictApp extends StatelessWidget {
  const PredictApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF051125),
        primaryColor: const Color(0xFFC69C2D),
        cardColor: const Color(0xFF0F2035),
      ),
      home: const MainShell(),
    );
  }
}

// --- ANA NAVİGASYON MERKEZİ ---
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Sayfaları burada tanımlıyoruz
  final List<Widget> _pages = [
    const HomePage(),        // Maç Listesi ve Tablar
    const PredictionsPage(), // Banko ve Sihirli Kupon
    const PremiumPage(),     // Satış Ekranı
    const ProfilePage(),     // Kullanıcı Ayarları
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // Sayfa durumlarını korumak için IndexedStack
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF051125),
        selectedItemColor: const Color(0xFFC69C2D),
        unselectedItemColor: Colors.white24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Analiz'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// ==========================================
// 1. ANA SAYFA (MAÇ LİSTESİ VE TABLAR)
// ==========================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF051125),
          elevation: 0,
          title: Image.asset('assets/logo.png', height: 35),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Color(0xFFC69C2D),
            labelColor: Color(0xFFC69C2D),
            unselectedLabelColor: Colors.white24,
            tabs: [Tab(text: "Hepsi"), Tab(text: "Canlı"), Tab(text: "Biten")],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMatchList(context),
            _buildEmptyCanli(),
            const Center(child: Text("Biten maç kaydı yok.")),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: DemoData.excelMatches.length,
      itemBuilder: (context, index) {
        bool isLocked = index >= 2; // İlk 2 maç açık, kalanlar kilitli
        return GestureDetector(
          onTap: () => isLocked ? _showPremiumSheet(context) : null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MatchCardElite(match: DemoData.excelMatches[index], isLocked: isLocked),
          ),
        );
      },
    );
  }

  Widget _buildEmptyCanli() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.stadium_rounded, size: 80, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 15),
          const Text("Şu an çimler sessiz...", style: TextStyle(fontSize: 18, color: Color(0xFFC69C2D), fontWeight: FontWeight.bold)),
          const Text("Ama fırtına yaklaşıyor!", style: TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }

  void _showPremiumSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2035),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_open_rounded, color: Color(0xFFC69C2D), size: 50),
            const SizedBox(height: 20),
            const Text("Premium ile Tüm Kapıları Aç!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Haftalık 15 maçın tamamını ve AI güven skorlarını görmek için hemen yükselt.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC69C2D), foregroundColor: Colors.black),
                onPressed: () => Navigator.pop(context),
                child: const Text("PAKETLERİ GÖR"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. TAHMİN / ANALİZ SAYFASI
// ==========================================
class PredictionsPage extends StatelessWidget {
  const PredictionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("Analiz Merkezi", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          // HAFTANIN BANKOSU
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFC69C2D), Color(0xFF8E6E1A)]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              children: [
                Text("HAFTANIN BANKOSU", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2)),
                SizedBox(height: 15),
                Text("Fenerbahçe - Göztepe", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text("Tahmin: 1 (Güven: %94)", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // SİHİRLİ KUPON BUTONU
          SizedBox(
            width: double.infinity, height: 65,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFC69C2D), width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              icon: const Icon(Icons.auto_fix_high_rounded, color: Color(0xFFC69C2D)),
              label: const Text("YAPAY ZEKA KUPON OLUŞTUR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 40),
          // SON KAZANANLAR TICKER (Simüle edilmiş)
          const Text("SON KAZANANLAR", style: TextStyle(fontSize: 12, color: Colors.white38, letterSpacing: 1)),
          const SizedBox(height: 10),
          Container(
            height: 40,
            color: Colors.white.withOpacity(0.02),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                Center(child: Text("  🏆 Kullanıcı k***n 12.450₺ Kazandı!  •  🏆 Kullanıcı m***t 4.200₺ Kazandı!  •  🏆 AI Kuponu %100 Başarı!  ", style: TextStyle(color: Color(0xFFC69C2D)))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. PREMIUM SAYFASI (STOREFRONT)
// ==========================================
class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.stars_rounded, color: Color(0xFFC69C2D), size: 70),
            const SizedBox(height: 10),
            const Text("Elite Üyeliğe Geç", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            // HAFTALIK PAKET
            _buildPriceCard("Haftalık Paket", "59₺", "Hızlı Başlangıç", false),
            const SizedBox(height: 15),
            // AYLIK PAKET (EN POPÜLER)
            _buildPriceCard("Aylık Paket", "199₺", "En Popüler", true),
            const SizedBox(height: 40),
            // NEDEN PREMIUM?
            const Align(alignment: Alignment.centerLeft, child: Text("Neden Premium?", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 15),
            _buildBenefit("15 Maçın tamamına AI erişimi"),
            _buildBenefit("Yüksek güvenli 'Banko' maçlar"),
            _buildBenefit("Reklamsız tertemiz deneyim"),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(String title, String price, String badge, bool isPopular) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2035),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isPopular ? const Color(0xFFC69C2D) : Colors.white10, width: isPopular ? 2 : 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(badge, style: TextStyle(color: isPopular ? const Color(0xFFC69C2D) : Colors.white38, fontSize: 12)),
            ],
          ),
          Text(price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFC69C2D))),
        ],
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [const Icon(Icons.check_circle, color: Color(0xFFC69C2D), size: 18), const SizedBox(width: 10), Text(text)]),
    );
  }
}

// ==========================================
// 4. PROFİL SAYFASI
// ==========================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(radius: 50, backgroundColor: Color(0xFF0F2035), child: Icon(Icons.person, size: 60, color: Color(0xFFC69C2D))),
          const SizedBox(height: 15),
          const Text("Mert Yılmaz", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
            child: const Text("Üyelik Durumu: FREE", style: TextStyle(color: Colors.white54, fontSize: 12)),
          ),
          const SizedBox(height: 40),
          _buildProfileTile(Icons.notifications_outlined, "Bildirimler"),
          _buildProfileTile(Icons.support_agent_rounded, "Destek Al"),
          _buildProfileTile(Icons.logout_rounded, "Çıkış Yap", isRed: true),
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, {bool isRed = false}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.redAccent : const Color(0xFFC69C2D)),
      title: Text(title, style: TextStyle(color: isRed ? Colors.redAccent : Colors.white)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10),
      onTap: () {},
    );
  }
}

// --- YARDIMCI BİLEŞENLER (MAÇ KARTI) ---
class MatchCardElite extends StatelessWidget {
  final Map<String, String> match;
  final bool isLocked;
  const MatchCardElite({super.key, required this.match, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: const Color(0xFF0F2035), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(match['home']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  const Text("VS", style: TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.w900)),
                  Expanded(child: Text(match['away']!, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                ],
              ),
              const SizedBox(height: 10),
              Text(match['date']!, style: const TextStyle(fontSize: 11, color: Colors.white24)),
            ],
          ),
        ),
        if (isLocked)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(child: Icon(Icons.lock_rounded, color: Color(0xFFC69C2D), size: 30)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// --- VERİ ---
class DemoData {
  static const List<Map<String, String>> excelMatches = [
    {"home": "Trabzonspor", "away": "Kasımpaşa", "date": "23.01.2026 - 20:00"},
    {"home": "Kayserispor", "away": "Başakşehir", "date": "24.01.2026 - 14:30"},
    {"home": "Samsunspor", "away": "Kocaelispor", "date": "24.01.2026 - 17:00"},
    {"home": "Karagümrük", "away": "Galatasaray", "date": "24.01.2026 - 20:00"},
    {"home": "Gaziantep FK", "away": "Konyaspor", "date": "25.01.2026 - 14:30"},
    {"home": "Antalyaspor", "away": "Gençlerbirliği", "date": "25.01.2026 - 17:00"},
    {"home": "Rizespor", "away": "Alanyaspor", "date": "25.01.2026 - 17:00"},
    {"home": "Fenerbahçe", "away": "Göztepe", "date": "25.01.2026 - 20:00"},
    {"home": "Eyüpspor", "away": "Beşiktaş", "date": "26.01.2026 - 20:00"},
    {"home": "Union Berlin", "away": "Dortmund", "date": "24.01.2026 - 20:30"},
    {"home": "Marsilya", "away": "Lens", "date": "24.01.2026 - 23:05"},
    {"home": "Arsenal", "away": "Man. United", "date": "25.01.2026 - 19:30"},
    {"home": "Villarreal", "away": "Real Madrid", "date": "24.01.2026 - 23:00"},
    {"home": "Juventus", "away": "Napoli", "date": "25.01.2026 - 20:00"},
    {"home": "Roma", "away": "AC Milan", "date": "25.01.2026 - 22:45"},
  ];
}
