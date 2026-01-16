import 'package:flutter/material.dart';

void main() {
  runApp(const PredictApp());
}

class PredictApp extends StatelessWidget {
  const PredictApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryYellow = Color(0xFFF9D648);
    const background = Color(0xFF0B1433);
    const card = Color(0xFF111C3F);

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
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryYellow,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: primaryYellow,
          ),
          bodyLarge: TextStyle(fontSize: 16, height: 1.4),
          bodyMedium: TextStyle(fontSize: 14, height: 1.4),
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
        backgroundColor: const Color(0xFF0B1433),
        selectedItemColor: const Color(0xFFF9D648),
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Predictions'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Premium'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 22),
          Text('Upcoming Matches', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          const Text('AI-powered predictions for the beautiful game.'),
          const SizedBox(height: 18),
          const _MatchTabs(),
          const SizedBox(height: 18),
          ...matches.map((match) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
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
    final matches = DemoData.couponMatches;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 18),
          Text('Spor Toto AI Predictions', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          const Text('AI-powered 15-match coupon generator.'),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF111C3F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.confirmation_number_outlined, color: Color(0xFFF9D648)),
                    const SizedBox(width: 10),
                    Text('Jackpot Coupon - 15 Matches',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                const SizedBox(height: 16),
                ...matches.map((match) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CouponMatchRow(match: match),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9D648),
                foregroundColor: const Color(0xFF0B1433),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('UNLOCK FULL 15-MATCH COUPON',
                  style: TextStyle(fontWeight: FontWeight.w700)),
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
    final benefits = DemoData.premiumBenefits;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 20),
          Text('Join the Winners Club', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          const Text('Unlock the full power of Predict 1X2 AI and start winning.'),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF111C3F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Premium Benefits', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                ...benefits.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFFF9D648), size: 20),
                          const SizedBox(width: 10),
                          Expanded(child: Text(benefit)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PricePlanCard(
            title: 'Monthly',
            subtitle: 'Just \$4.99/week',
            price: '\$19.99',
            unit: '/month',
            highlight: 'Most Popular',
          ),
          const SizedBox(height: 14),
          PricePlanCard(
            title: 'Weekly',
            subtitle: 'Great for a short trial',
            price: '\$5.99',
            unit: '/week',
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9D648),
                foregroundColor: const Color(0xFF0B1433),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('SUBSCRIBE NOW', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        children: [
          const _TopSearchBar(),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF111C3F),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0B1433),
                    boxShadow: [
                      BoxShadow(color: Color(0x332D3A5C), blurRadius: 12, spreadRadius: 2),
                    ],
                  ),
                  child: const Icon(Icons.person_outline, size: 38, color: Color(0xFFF9D648)),
                ),
                const SizedBox(height: 12),
                Text('Mert Yilmaz', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF0B1433),
                    border: Border.all(color: const Color(0xFFF9D648)),
                  ),
                  child: const Text('FREE PLAN', style: TextStyle(color: Color(0xFFF9D648))),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2548),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.auto_awesome, color: Color(0xFFF9D648)),
                      const SizedBox(height: 8),
                      Text('Unlock Your Winning Potential',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 6),
                      const Text(
                        'Upgrade to Premium for detailed AI analysis and unlimited predictions.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9D648),
                            foregroundColor: const Color(0xFF0B1433),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Upgrade to Premium',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: StatCard(label: 'Predictions', value: '12')),
              SizedBox(width: 12),
              Expanded(child: StatCard(label: 'Won', value: '8')),
              SizedBox(width: 12),
              Expanded(child: StatCard(label: 'Success', value: '66%')),
            ],
          ),
          const SizedBox(height: 20),
          const _ProfileOption(title: 'Notification Settings'),
          const _ProfileOption(title: 'Contact Support'),
          const _ProfileOption(title: 'Logout', isDestructive: true),
        ],
      ),
    );
  }
}

class _TopSearchBar extends StatelessWidget {
  const _TopSearchBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF111C3F),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
          ),
          child: const Icon(Icons.sports_soccer, color: Color(0xFFF9D648), size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF111C3F),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Color(0xFFF9D648)),
                SizedBox(width: 8),
                Expanded(child: Text('Search matches...', style: TextStyle(color: Colors.white70))),
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
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: const [
          Expanded(child: _TabChip(label: 'All', isActive: true)),
          Expanded(child: _TabChip(label: 'Live')),
          Expanded(child: _TabChip(label: 'Finished')),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0B1433) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isActive ? const Color(0xFFF9D648) : Colors.white70,
          fontWeight: FontWeight.w600,
        ),
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
        color: const Color(0xFF111C3F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(match.time, style: const TextStyle(color: Colors.white70)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B1433),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF9D648)),
                ),
                child: Text(match.league, style: const TextStyle(color: Color(0xFFF9D648))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _TeamColumn(name: match.homeTeam, city: match.homeShort),
              ),
              const Text('VS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF9D648))),
              Expanded(
                child: _TeamColumn(name: match.awayTeam, city: match.awayShort, alignEnd: true),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('AI Confidence Score', style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Home Win', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: match.confidence,
                    minHeight: 10,
                    backgroundColor: const Color(0xFF2B3358),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFF9D648)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('${(match.confidence * 100).round()}%',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFF9D648))),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  const _TeamColumn({required this.name, required this.city, this.alignEnd = false});

  final String name;
  final String city;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFF1C2548),
          child: Text(name.characters.first,
              style: const TextStyle(color: Color(0xFFF9D648), fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        Text(name, textAlign: alignEnd ? TextAlign.end : TextAlign.start),
        const SizedBox(height: 4),
        Text(city, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}

class CouponMatchRow extends StatelessWidget {
  const CouponMatchRow({super.key, required this.match});

  final CouponMatch match;

  @override
  Widget build(BuildContext context) {
    final locked = match.isLocked;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1433),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Text('${match.index}.', style: const TextStyle(color: Color(0xFFF9D648))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CompactTeam(name: match.homeTeam),
                    const Text('vs', style: TextStyle(color: Colors.white70)),
                    _CompactTeam(name: match.awayTeam, alignEnd: true),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2548),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(match.prediction,
                          style: const TextStyle(color: Color(0xFFF9D648), fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (locked)
            const Icon(Icons.lock, color: Color(0xFFF9D648))
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF9D648),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(match.prediction,
                  style: const TextStyle(color: Color(0xFF0B1433), fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}

class _CompactTeam extends StatelessWidget {
  const _CompactTeam({required this.name, this.alignEnd = false});

  final String name;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Row(
        mainAxisAlignment: alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF1C2548),
            child: Text(name.characters.first,
                style: const TextStyle(color: Color(0xFFF9D648), fontSize: 12)),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class PricePlanCard extends StatelessWidget {
  const PricePlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.unit,
    this.highlight,
  });

  final String title;
  final String subtitle;
  final String price;
  final String unit;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF111C3F),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF9D648).withOpacity(0.6)),
          ),
          child: Row(
            children: [
              const Icon(Icons.radio_button_checked, color: Color(0xFFF9D648)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF9D648),
                      )),
                  Text(unit, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
        if (highlight != null)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFF9D648),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
              child: Text(
                highlight!,
                style: const TextStyle(
                  color: Color(0xFF0B1433),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({required this.title, this.isDestructive = false});

  final String title;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.white),
            ),
          ),
          Icon(Icons.chevron_right, color: isDestructive ? Colors.redAccent : Colors.white54),
        ],
      ),
    );
  }
}

class DemoData {
  static final List<MatchPrediction> upcomingMatches = [
    MatchPrediction(
      time: '17 Jan, 20:00',
      league: 'Süper Lig',
      homeTeam: 'Rams Başakşehir',
      homeShort: 'Başakşehir',
      awayTeam: 'Mısırlı.com.tr Fatih Karagümrük',
      awayShort: 'Fatih Karagümrük',
      confidence: 0.75,
    ),
    MatchPrediction(
      time: '17 Jan, 23:00',
      league: 'Süper Lig',
      homeTeam: 'Galatasaray',
      homeShort: 'Galatasaray',
      awayTeam: 'Gaziantep FK',
      awayShort: 'Gaziantep',
      confidence: 0.64,
    ),
  ];

  static final List<CouponMatch> couponMatches = List.generate(15, (index) {
    final match = _couponMatchData[index];
    return CouponMatch(
      index: index + 1,
      homeTeam: match.homeTeam,
      awayTeam: match.awayTeam,
      prediction: match.prediction,
      isLocked: index >= 2,
    );
  });

  static const List<String> premiumBenefits = [
    'Daily AI-powered Tips',
    'Over 75% Success Rate',
    'Detailed Match Analysis',
    'Unlimited Access to All Leagues',
    'Exclusive Community Access',
    'Priority Customer Support',
  ];

  static const List<_BaseMatch> _couponMatchData = [
    _BaseMatch('Rams Başakşehir', 'Mısırlı.com.tr Fatih Karagümrük', '1'),
    _BaseMatch('Galatasaray', 'Gaziantep FK', '1'),
    _BaseMatch('Kasımpaşa', 'Hesap.com Antalyaspor', '1X'),
    _BaseMatch('Gençlerbirliği', 'Samsunspor', 'X'),
    _BaseMatch('Kocaelispor', 'Trabzonspor', '2'),
    _BaseMatch('Corendon Alanyaspor', 'Fenerbahçe', '2'),
    _BaseMatch('Tümosan Konyaspor', 'İkas Eyüpspor', '1X'),
    _BaseMatch('Beşiktaş', 'Zecorner Kayserispor', '1'),
    _BaseMatch('Göztepe', 'Çaykur Rizespor', '1X'),
    _BaseMatch('TSG Hoffenheim', 'Bayer Leverkusen', '2'),
    _BaseMatch('RB Leipzig', 'Bayern Münih', 'X2'),
    _BaseMatch('Paris St Germain', 'Lille', '1'),
    _BaseMatch('Manchester United', 'Manchester City', '2'),
    _BaseMatch('Aston Villa', 'Everton', '1'),
    _BaseMatch('Real Sociedad', 'Barcelona', 'X2'),
  ];
}

class MatchPrediction {
  MatchPrediction({
    required this.time,
    required this.league,
    required this.homeTeam,
    required this.homeShort,
    required this.awayTeam,
    required this.awayShort,
    required this.confidence,
  });

  final String time;
  final String league;
  final String homeTeam;
  final String homeShort;
  final String awayTeam;
  final String awayShort;
  final double confidence;
}

class CouponMatch {
  CouponMatch({
    required this.index,
    required this.homeTeam,
    required this.awayTeam,
    required this.prediction,
    required this.isLocked,
  });

  final int index;
  final String homeTeam;
  final String awayTeam;
  final String prediction;
  final bool isLocked;
}

class _BaseMatch {
  const _BaseMatch(this.homeTeam, this.awayTeam, this.prediction);

  final String homeTeam;
  final String awayTeam;
  final String prediction;
}
