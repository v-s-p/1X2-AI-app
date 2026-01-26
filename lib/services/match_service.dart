import '../models/match_model.dart';

class MatchService {
  static List<MatchModel> getWeeklyMatches() {
    return [
      MatchModel(
        id: 1,
        home: "Galatasaray",
        away: "Beşiktaş",
        prediction: "1",
        confidence: 85,
        isLocked: false,
        explanation: "Derbi heyecanı! Galatasaray iç saha avantajıyla favori. Icardi'nin formu belirleyici olacak.",
        risk: "Low",
      ),
      MatchModel(
        id: 2,
        home: "Fenerbahçe",
        away: "Trabzonspor",
        prediction: "1",
        confidence: 78,
        isLocked: false,
        explanation: "Fenerbahçe şampiyonluk yolunda hata yapmak istemiyor. Trabzonspor ise sürpriz peşinde.",
        risk: "Medium",
      ),
      MatchModel.mock(3, "Başakşehir", "Kasımpaşa"),
      MatchModel.mock(4, "Adana Demir", "Samsunspor"),
      MatchModel.mock(5, "Alanyaspor", "Antalyaspor"),
      MatchModel.mock(6, "Göztepe", "Eyüpspor"),
      MatchModel.mock(7, "Rizespor", "Bodrum FK"),
      MatchModel.mock(8, "Konyaspor", "Sivasspor"),
      MatchModel.mock(9, "Gaziantep FK", "Kayseripsor"),
      MatchModel.mock(10, "Hatayspor", "Iğdır FK"),
      MatchModel.mock(11, "Real Madrid", "Barcelona"),
      MatchModel.mock(12, "Man City", "Liverpool"),
      MatchModel.mock(13, "Bayern Münih", "Dortmund"),
      MatchModel.mock(14, "Inter", "Milan"),
      MatchModel.mock(15, "PSG", "Marsilya"),
    ];
  }
}
