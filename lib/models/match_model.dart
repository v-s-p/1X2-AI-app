class MatchModel {
  final int id;
  final String home;
  final String away;
  final String prediction; // '1', 'X', '2'
  final int confidence; // 0-100
  final bool isLocked;
  final String explanation;
  final String risk; // 'Low', 'Medium', 'High'

  MatchModel({
    required this.id,
    required this.home,
    required this.away,
    required this.prediction,
    required this.confidence,
    required this.isLocked,
    required this.explanation,
    this.risk = 'Medium',
  });

  // Factory constructor for mock data ease
  factory MatchModel.mock(int id, String home, String away, {bool isLocked = true}) {
    return MatchModel(
      id: id,
      home: home,
      away: away,
      prediction: (id % 3 == 0) ? 'X' : (id % 2 == 0 ? '1' : '2'),
      confidence: 65 + (id * 2) % 30,
      isLocked: isLocked,
      explanation: "This is a detailed analysis for $home vs $away. Based on recent form and historical data, we predict a ${id % 3 == 0 ? 'draw' : (id % 2 == 0 ? 'home win' : 'away win')}.",
      risk: id % 3 == 0 ? 'High' : (id % 2 == 0 ? 'Low' : 'Medium'),
    );
  }
}
