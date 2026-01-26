import google.generativeai as genai
import json
import os
import time
from datetime import datetime

# --- CONFIGURATION ---
API_KEY = "AIzaSyBENthP-YJpN6YHAgpxSeKuqHLIfL1gVgM"
MAX_BUDGET_TL = 350
COST_PER_COLUMN = 10
MAX_COLUMNS = MAX_BUDGET_TL // COST_PER_COLUMN

# Configure AI
genai.configure(api_key=API_KEY)
# Using Flash for speed and higher quotas
model = genai.GenerativeModel('gemini-2.0-flash')

# --- RAW DATA (As provided by User) ---
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

def parse_matches(raw_text):
    print("📋 Parsin inputs...")
    lines = raw_text.split('\n')
    matches = []
    
    blacklist = ["CUMA", "CUMARTESİ", "PAZAR", "PAZARTESİ", "2026", "2025", "SAAT", "SKOR"]
    
    for line in lines:
        line = line.strip()
        
        # Date parsing logic (Simple check for DD.MM.YYYY format)
        if len(line) == 10 and line[2] == '.' and line[5] == '.':
            # Format found, assign to the LAST match added if available
            if matches:
                matches[-1]['date'] = line
            continue # Skip processing this line as a match name
            
        if "-" in line and not any(word in line.upper() for word in blacklist):
            parts = line.split("-")
            if len(parts) >= 2:
                home = parts[0].strip()
                away = parts[1].strip()
                if len(home) > 2 and len(away) > 2:
                    matches.append({
                        "home": home, 
                        "away": away,
                        "date": "Tarih Bekleniyor..." # Placeholder
                    })
    
    return matches[:15]

def get_ai_prediction(home, away, date, retries=3):
    print(f"🤖 AI Analyzing ({date}): {home} vs {away}...")
    
    bugun = datetime.now().strftime("%d %B %Y")
    
    prompt = f"""
    REFERANS TARİH: {bugun}
    MAÇ TARİHİ: {date}
    GÖREV: Spor Toto için "İçeriden Bilgi" (Insider Info) odaklı maç analizi yap.

    ROLÜN:
    Sen sadece bir analist değil, kulüplerin mali yapılarını ve soyunma odası atmosferini bilen kıdemli bir SPOR MUHABİRİSİN.
    MAÇ: {home} vs {away}
    
    ARAŞTIRMA YAPARKEN ŞU "GÖRÜNMEYEN" FAKTÖRLERİ ARA (Google Search Kullanarak güncel verileri kontrol et):
    1. 💰 FİNANSAL KRİZLER:
       - Maaş krizleri, yönetim istifaları.
    2. 🧠 PSİKOLOJİK & SOSYAL DURUM:
       - Kadro dışı, kavga, özel hayat skandalları.
    3. ⚠️ MOTİVASYON:
       - Takımın ligdeki konumu ve hedefi.
    4. 🌍 GLOBAL İSTİHBARAT:
       - Yabancı takımlar için o ülkenin yerel basınını (BBC, Marca, L'Equipe, Bild vb.) tara.

    ANALİZ MANTIĞI:
    - Finansal kriz veya motivasyon düşüklüğü varsa sürpriz ara.
    - Favori takımda kaos varsa güven skorunu düşür.

    ÇIKTI FORMATI (Sadece Valid JSON):
    {{
        "prediction": "1", 
        "confidence": 85,
        "probabilities": {{"1": 60, "X": 25, "2": 15}},
        "risk_factor": "Net bir risk yok / VEYA / YÜKSEK RİSK: Maaş krizi var",
        "reasoning": "Takım A formda ancak yönetimsel kaos var. Bu yüzden X ihtimali arttı."
    }}
    """
    
    for attempt in range(retries):
        try:
            response = model.generate_content(prompt)
            text = response.text.strip()
            if text.startswith('```json'):
                text = text.split('```json')[1].split('```')[0].strip()
            elif text.startswith('```'):
                text = text.split('```')[1].strip()
                
            return json.loads(text)
        except Exception as e:
            if "429" in str(e):
                wait_time = (attempt + 1) * 10
                print(f"⚠️ Rate limit hit. Waiting {wait_time}s... (Attempt {attempt+1}/{retries})")
                time.sleep(wait_time)
            else:
                print(f"❌ Error for {home}-{away}: {e}")
                
    # Fallback
    return {"prediction": "1", "confidence": 50, "probabilities": {"1": 33, "X": 33, "2": 33}, "risk_factor": "Analiz Hatası", "reasoning": "Veri alınamadı."}

def budget_optimizer(matches_with_predictions):
    print("\n💰 Optimizing for budget (Max 350 TL)...")
    
    sorted_matches = sorted(matches_with_predictions, key=lambda x: x['confidence'], reverse=True)
    
    for i, match in enumerate(sorted_matches):
        if i < 10:
            match['play_type'] = 'Assumption (1-Only)'
            match['final_play'] = match['prediction']
        else:
            match['play_type'] = 'Double Chance'
            probs = match['probabilities']
            sorted_probs = sorted(probs.items(), key=lambda item: item[1], reverse=True)
            outcome1 = sorted_probs[0][0]
            outcome2 = sorted_probs[1][0]
            
            pair = sorted([outcome1, outcome2], key=lambda x: {'1':0, 'X':1, '2':2}.get(x, 9)) 
            match['final_play'] = f"{pair[0]}-{pair[1]}"

    num_doubles = len([m for m in sorted_matches if m['play_type'] == 'Double Chance'])
    total_columns = 2 ** num_doubles
    total_cost = total_columns * COST_PER_COLUMN
    
    print(f"   Strategy: {num_doubles} Doubles, {15-num_doubles} Singles.")
    print(f"   Calculated Cost: {total_cost} TL (Budget: {MAX_BUDGET_TL} TL)")
    
    return sorted_matches, total_cost

def main():
    matches = parse_matches(raw_data)
    
    if not matches:
        print("❌ No matches found!")
        return

    matches_with_data = []
    print(f"Start processing {len(matches)} matches...")
    
    for idx, m in enumerate(matches):
        pred_data = get_ai_prediction(m['home'], m['away'], m['date'])
        m.update(pred_data)
        m['id'] = idx + 1
        matches_with_data.append(m)
        print(f"   (Waiting 15s to manage API quota...)")
        time.sleep(15) # Increased pause to avoid rate limits
        
    optimized_matches, cost = budget_optimizer(matches_with_data)
    final_list = sorted(optimized_matches, key=lambda x: x['id'])
    
    output_data = {
        "generated_at": time.strftime("%Y-%m-%d %H:%M:%S"),
        "total_cost": cost,
        "matches": final_list
    }
    
    with open('matches_data.json', 'w', encoding='utf-8') as f:
        json.dump(output_data, f, ensure_ascii=False, indent=4)
        
    print(f"\n✅ DONE! Coupon generated. Cost: {cost} TL")

if __name__ == "__main__":
    main()