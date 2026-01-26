import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  GenerativeModel? _model;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    
    // Load environment variables
    // Note: main.dart loads this, but if we need to reload or ensure it's loaded:
    try {
      await dotenv.load(fileName: "assets/.env");
    } catch (e) {
      // Ignore if already loaded or file issue, assuming main.dart handled it
    }
    
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env');
    }

    _model = GenerativeModel(
      model: 'gemini-pro-latest',
      apiKey: apiKey,
    );
    _isInitialized = true;
  }

  /// Basic prediction for the card
  Future<String> getPrediction(String matchDetails) async {
    if (!_isInitialized) await init();

    final content = [Content.text('''
    Sen uzman bir futbol analistisin. 2026 yılı güncel verilerini (google search) kullanarak analiz yap.
    Maç: $matchDetails
    
    Çıktı JSON formatında olmalı:
    {
      "prediction": "1, X veya 2",
      "confidence": 0-100 (sayı),
      "reasoning": "Tek cümlelik özet sebep."
    }
    ''')];

    try {
      final response = await _model!.generateContent(content);
      return response.text ?? "{}";
    } catch (e) {
      print('AI Error: $e');
      return "{}";
    }
  }

  /// Deep analysis for the detail page
  Future<Map<String, dynamic>> getDeepAnalysis(String matchDetails) async {
    if (!_isInitialized) await init();

    final content = [Content.text('''
    Bu maç için DERİNLEMESİNE analiz yap: $matchDetails
    
    Lütfen şu perspektifle analiz yap: "2025-2026 Sezonu" başlangıcından bugüne kadarki performans, form durumu ve haberleri baz al.
    Eğer 2026 yılına ait spesifik veri yoksa, devam eden sezonun (2025 sonu) verilerini kullan. Asla "Veri yok" deme, mevcut en son veriyi yorumla.

    Şu başlıkları incele:
    1. Finansal Durum: Kulüp maaşları, borçlar.
    2. Psikolojik Durum: Oyuncu motivasyonu, hoca ilişkileri.
    3. Yabancı Basın: Global medya yansımaları (Varsa).

    YANIT FORMATI (KESİNLİKLE JSON):
    {
      "financial": ["Maksimum 3 madde", "Kısa ve öz"],
      "psychology": ["Maksimum 3 madde", "Kısa ve öz"],
      "press": ["Maksimum 3 madde", "Kısa ve öz"],
      "verdict": "BANKO | GÜÇLÜ FAVORİ | RİSKLİ | SÜRPRİZ",
      "verdict_score": 0-100 (güven puanı, sayı)
    }
    ''')];

    try {
      final response = await _model!.generateContent(content);
      print('DEBUG: AI Raw Response: ${response.text}');
      String text = response.text ?? "{}";

      
      // Temizleme: Markdown ve ekstra metinlerden kurtul
      final startIndex = text.indexOf('{');
      final endIndex = text.lastIndexOf('}');
      if (startIndex != -1 && endIndex != -1) {
        text = text.substring(startIndex, endIndex + 1);
      } else {
        // JSON bulunamadıysa boş obje dön
        return {};
      }
      
      return json.decode(text);
    } catch (e) {
      print('Deep AI Error: $e');
      return {};
    }
  }
}
