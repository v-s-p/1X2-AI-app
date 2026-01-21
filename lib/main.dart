import 'dart:ui'; // Blur efekti için şart
import 'package:flutter/material.dart';

void main() {
  runApp(const PredictApp());
}

class PredictApp extends StatelessWidget {
  const PredictApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandNavy = Color(0xFF051125); // Derin Lacivert
    const goldPrimary = Color(0xFFC69C2D); // Altın

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict 1X2 AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: brandNavy,
        primaryColor: goldPrimary,
        fontFamily: 'Roboto', 
        useMaterial3: true,
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
  bool isPremium = false; // Test: FALSE (Kilitli maçları gör)

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // APP BAR TASARIMI
        appBar: AppBar(
          backgroundColor: const Color(0xFF051125),
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               // Logo yoksa hata vermesin diye Icon koydum, varsa Image.asset kullan
               const Icon(Icons.sports_soccer, color: Color(0xFFC69C2D), size: 28), 
               const SizedBox(width: 8),
               Text("PREDICT 1X2 AI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.2)),
            ],
          ),
          centerTitle: true,
          actions: const [
            Icon(Icons.notifications_none, color: Color(0xFFC69C2D)),
            SizedBox(width: 15),
          ],
          bottom: TabBar(
            indicatorColor: const Color(0xFFC69C2D),
            labelColor: const Color(0xFFC69C2D),
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "BÜLTEN"),
              Tab(text: "CANLI"),
              Tab(text: "BİTEN"),
            ],
          ),
        ),
        
        // GÖVDE
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF051125), Color(0xFF02060D)], // Hafif geçiş
            )
          ),
          child: TabBarView(
            children: [
              _buildHepsiTab(),
              _buildCanliTab(),
              _buildBitenTab(),
            ],
          ),
        ),

        // ALT MENÜ
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0F2035),
          selectedItemColor: const Color(0xFFC69C2D),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Ana Sayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Analiz'),
            BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  // --- HEPSİ SEKİMESİ (FREEMIUM LİSTE) ---
  Widget _buildHepsiTab() {
    final matches = DemoData.excelMatches;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        // İLK 2 MAÇ AÇIK, GERİSİ KİLİTLİ
        bool isLocked = index >= 2 && !isPremium; 
        
        return GestureDetector(
          onTap: () => isLocked ? _showPremiumSheet(context) : null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MatchCardElite(match: matches[index], isLocked: isLocked),
          ),
        );
      },
    );
  }

  // --- CANLI SEKİMESİ ---
  Widget _buildCanliTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.stadium, size: 80, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 20),
          const Text(
            "Sahalar Sessiz...",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFC69C2D)),
          ),
          const SizedBox(height: 8),
          const Text(
            "Şu an oynanan maç yok.\nFırtına birazdan kopacak!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildBitenTab() {
    return const Center(child: Text("Biten maç bulunamadı.", style: TextStyle(color: Colors.white54)));
  }

  // --- PREMIUM BOTTOM SHEET (AÇILIR PENCERE) ---
  void _showPremiumSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2035),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        height: 400,
        child: Column(
          children: [
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 30),
            const Icon(Icons.lock_open_rounded, color: Color(0xFFC69C2D), size: 60),
            const SizedBox(height: 20),
            const Text("Analizin Kilidini Aç", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            const Text(
              "Bu maçın yapay zeka tahminini, güven skorunu ve risk analizini görmek için Premium'a geç.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, height: 1.5),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC69C2D),
                  foregroundColor: Colors.black,
                  elevation: 10,
                  shadowColor: const Color(0xFFC69C2D).withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("HEMEN YÜKSELT", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- ELITE MAÇ KARTI (GÖRSEL DÜZELTİLDİ) ---
class MatchCardElite extends StatelessWidget {
  final Map<String, String> match;
  final bool isLocked;

  const MatchCardElite({super.key, required this.match, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. KARTIN KENDİSİ
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2035), // Kart Rengi
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
            ]
          ),
          child: Column(
            children: [
              // LİG / TARİH BİLGİSİ
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                child: Text(match['date']!, style: const TextStyle(fontSize: 11, color: Colors.white54, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),

              // TAKIMLAR VE SKOR ALANI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // EV SAHİBİ
                  Expanded(child: _buildTeamItem(match['home']!, true)),
                  
                  // VS / SKOR ALANI
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                         const Text("VS", style: TextStyle(color: Color(0xFFC69C2D), fontWeight: FontWeight.w900, fontSize: 18)),
                         if(!isLocked) // Sadece kilit açıkken oran gösterelim
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text("%76", style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                            )
                      ],
                    ),
                  ),

                  // DEPLASMAN
                  Expanded(child: _buildTeamItem(match['away']!, false)),
                ],
              ),
            ],
          ),
        ),
        
        // 2. KİLİT VE BLUR KATMANI (Buzlu Cam)
        if (isLocked)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0), // Bulanıklık şiddeti
                child: Container(
                  color: const Color(0xFF051125).withOpacity(0.5), // Yarı saydam lacivert perde
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.6),
                        border: Border.all(color: const Color(0xFFC69C2D), width: 2)
                      ),
                      child: const Icon(Icons.lock, color: Color(0xFFC69C2D), size: 24),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Takım İsim + Avatar Oluşturucu
  Widget _buildTeamItem(String name, bool isHome) {
    return Column(
      children: [
        // Daire içinde takımın baş harfi (Logo yerine geçici çözüm)
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isHome 
                ? [Colors.blueAccent.shade700, Colors.blue.shade900] 
                : [Colors.redAccent.shade700, Colors.red.shade900],
              begin: Alignment.topLeft, end: Alignment.bottomRight
            ),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 5, offset: Offset(0,2))]
          ),
          child: Center(child: Text(name[0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
        ),
        const SizedBox(height: 10),
        Text(
          name, 
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)
        ),
      ],
    );
  }
}

// --- DUMMY DATA (HATA VERMEMESİ İÇİN AYNI VERİ) ---
class DemoData {
  static const List<Map<String, String>> excelMatches = [
    {"home": "Trabzonspor", "away": "Kasımpaşa", "date": "23.01.2026 - 20:00"},
    {"home": "Kayserispor", "away": "Başakşehir", "date": "24.01.2026 - 14:30"},
    {"home": "Samsunspor", "away": "Kocaelispor", "date": "24.01.2026 - 17:00"},
    {"home": "Karagümrük", "away": "Galatasaray", "date": "24.01.2026 - 20:00"},
    {"home": "Gaziantep FK", "away": "Konyaspor", "date": "25.01.2026 - 14:30"},
    {"home": "Fenerbahçe", "away": "Göztepe", "date": "25.01.2026 - 20:00"},
    {"home": "Juventus", "away": "Napoli", "date": "25.01.2026 - 20:00"},
  ];
}
