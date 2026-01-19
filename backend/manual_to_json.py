import json
import re

# BURAYA KOPYALADIĞIN O KARMAŞIK METNİ YAPIŞTIR
raw_data = """
1

Trabzonspor - Kasımpaşa

23.01.2026
-
Cuma
20:00
-
-
2

Zecorner Kayserispor - Rams Başakşehir

24.01.2026
-
Cumartesi
14:30
-
-
3

Samsunspor - Kocaelispor

24.01.2026
-
Cumartesi
17:00
-
-
4

Mısırlı.com.tr Fatih Karagümrük - Galatasaray

24.01.2026
-
Cumartesi
20:00
-
-
5

Gaziantep FK - Tümosan Konyaspor

25.01.2026
-
Pazar
14:30
-
-
6

Hesap.com Antalyaspor - Gençlerbirliği

25.01.2026
-
Pazar
17:00
-
-
7

Çaykur Rizespor - Corendon Alanyaspor

25.01.2026
-
Pazar
17:00
-
-
8

Fenerbahçe - Göztepe

25.01.2026
-
Pazar
20:00
-
-
9

ikas Eyüpspor - Beşiktaş

26.01.2026
-
Pazartesi
20:00
-
-
10

Union Berlin - Borussia Dortmund

24.01.2026
-
Cumartesi
20:30
-
-
11

Marsilya - Lens

24.01.2026
-
Cumartesi
23:05
-
-
12

Arsenal - Manchester United

25.01.2026
-
Pazar
19:30
-
-
13

Villarreal - Real Madrid

24.01.2026
-
Cumartesi
23:00
-
-
14

Juventus - Napoli

25.01.2026
-
Pazar
20:00
-
-
15

Roma - Milan

25.01.2026
-
Pazar
22:45
-
-

"""

def yapay_zeka_tahmin(home, away):
    h, a = home.upper(), away.upper()
    # Veri odaklı basit ağırlıklandırma
    big_teams = ["GALATASARAY", "FENERBAHÇE", "BEŞİKTAŞ", "CITY", "REAL", "BARCELONA", "INTER", "PSG", "DORTMUND", "MILAN", "ARSENAL"]
    
    if any(t in h for t in big_teams): return "1", 0.90
    if any(t in a for t in big_teams): return "2", 0.82
    if "TRABZON" in h or "ANTALYA" in h: return "1", 0.75
    return "X", 0.45

def isle_ve_temizle():
    print("🧹 Akıllı temizleme ve analiz başlatıldı...")
    
    # Satır satır bölelim
    lines = raw_data.split('\n')
    matches_found = []
    
    # Yasaklı kelimeler (Bunları içeren satırlar maç olamaz)
    blacklist = ["CUMA", "CUMARTESİ", "PAZAR", "PAZARTESİ", "2026", "2025", "SAAT", "SKOR"]
    
    for line in lines:
        line = line.strip()
        # Eğer satırda "-" varsa ve yasaklı kelimelerden hiçbirini içermiyorsa
        if "-" in line and not any(word in line.upper() for word in blacklist):
            parts = line.split("-")
            if len(parts) >= 2:
                home = parts[0].strip()
                away = parts[1].strip()
                
                # Takım isimleri çok kısa olmamalı (En az 3 harf)
                if len(home) > 2 and len(away) > 2:
                    matches_found.append((home, away))

    final_list = []
    # Sadece ilk 15 gerçek maçı alalım
    for i, (home, away) in enumerate(matches_found[:15], 1):
        prediction, confidence = yapay_zeka_tahmin(home, away)
        
        final_list.append({
            "id": i,
            "home": home,
            "away": away,
            "prediction": prediction,
            "confidence": confidence,
            "isLocked": i > 2
        })

    if final_list:
        with open('matches_data.json', 'w', encoding='utf-8') as f:
            json.dump(final_list, f, ensure_ascii=False, indent=4)
        print(f"✅ BAŞARILI! Toplam {len(final_list)} gerçek maç tertemiz şekilde kaydedildi.")
    else:
        print("❌ Hata: Gerçek maçlar ayıklanamadı. Lütfen metni kontrol edin.")

if __name__ == "__main__":
    isle_ve_temizle()