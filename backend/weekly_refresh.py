import os
import json
import time
import re
from datetime import datetime
import google.generativeai as genai

# --- CONFIGURATION ---
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENV_PATH = os.path.join(BASE_DIR, 'assets', '.env')
OUTPUT_PATH = os.path.join(BASE_DIR, 'assets', 'matches_data.json')

MAX_BUDGET_TL = 350
COST_PER_COLUMN = 10

def load_api_key():
    """Reads GEMINI_API_KEY from assets/.env"""
    if not os.path.exists(ENV_PATH):
        raise FileNotFoundError(f".env file not found at {ENV_PATH}")
    
    with open(ENV_PATH, 'r') as f:
        for line in f:
            if line.startswith('GEMINI_API_KEY='):
                return line.split('=')[1].strip()
    return None

def fetch_latest_matches():
    """Parses the copy-pasted text from the user's prompt."""
    print("📋 Parsing match list from provided text...")
    raw_text = """
1
Trabzonspor - Kasımpaşa
23.01.2026
2
Zecorner Kayserispor - Rams Başakşehir
24.01.2026
3
Samsunspor - Kocaelispor
24.01.2026
4
Mısırlı.com.tr Fatih Karagümrük - Galatasaray
24.01.2026
5
Gaziantep FK - Tümosan Konyaspor
25.01.2026
6
Hesap.com Antalyaspor - Gençlerbirliği
25.01.2026
7
Çaykur Rizespor - Corendon Alanyaspor
25.01.2026
8
Fenerbahçe - Göztepe
25.01.2026
9
ikas Eyüpspor - Beşiktaş
26.01.2026
10
Union Berlin - Borussia Dortmund
24.01.2026
11
Marsilya - Lens
24.01.2026
12
Arsenal - Manchester United
25.01.2026
13
Villarreal - Real Madrid
24.01.2026
14
Juventus - Napoli
25.01.2026
15
Roma - Milan
25.01.2026
"""
    matches = []
    lines = [l.strip() for l in raw_text.strip().split('\n') if l.strip()]
    
    # Simple state machine to parse ID, Team, Date
    i = 0
    while i < len(lines):
        try:
            m_id = int(lines[i])
            teams = lines[i+1]
            date = lines[i+2]
            
            home_away = teams.split(' - ')
            home = home_away[0].strip()
            away = home_away[1].strip() if len(home_away) > 1 else "Unknown"
            
            matches.append({
                "id": m_id,
                "home": home,
                "away": away,
                "date": date
            })
            i += 3
        except:
            i += 1
            
    return matches

def get_ai_analysis(model, home, away, date):
    """Generates detailed analysis for a single match."""
    print(f"🤖 Analyzing: {home} vs {away} ({date})...")
    
    prompt = f"""
    GÖREV: Spor Toto analizi yap.
    MAÇ: {home} vs {away}
    TARİH: {date}
    BAĞLAM: 2025-2026 Sezonu güncel durumu.
    
    LÜTFEN ŞU FORMATTA JSON DÖN:
    {{
        "prediction": "1 | X | 2",
        "confidence": 0-100,
        "probabilities": {{"1": %, "X": %, "2": %}},
        "reasoning": "Burada kulüp finansları, sakatlıklar ve hoca durumuna dair kısa bir analiz yap."
    }}
    """
    
    try:
        response = model.generate_content(prompt)
        text = response.text.strip()
        # Extract JSON block
        json_match = re.search(r'\{.*\}', text, re.DOTALL)
        if json_match:
            return json.loads(json_match.group(0))
    except Exception as e:
        print(f"❌ API Error: {e}")
    
    return {"prediction": "1", "confidence": 50, "probabilities": {"1": 34, "X": 33, "2": 33}, "reasoning": "Veri alınamadı."}

def optimize_budget(matches):
    """Ensures the total cost is around 350 TL by deciding play types."""
    # Simple logic: Top 11 confidence matches are single, bottom 4 are double.
    # Cost = 2^4 * 10 = 160 TL. If we do 5 doubles: 2^5 * 10 = 320 TL.
    # Let's do 5 doubles for the lowest confidence ones.
    sorted_m = sorted(matches, key=lambda x: x['confidence'])
    
    for i, m in enumerate(sorted_m):
        if i < 5: # 5 lowest confidence get double chance
            m['play_type'] = "Double Chance"
            # Get two most likely outcomes
            probs = m['probabilities']
            top_two = sorted(probs.items(), key=lambda x: x[1], reverse=True)[:2]
            outcome_str = "-".join(sorted([top_two[0][0], top_two[1][0]], key=lambda x: {'1':0, 'X':1, '2':2}.get(x, 3)))
            m['final_play'] = outcome_str
        else:
            m['play_type'] = "Single"
            m['final_play'] = m['prediction']
            
    return 320 # Fixed cost for this strategy (2^5 * 10)

def get_batch_analysis(model, matches, max_retries=3):
    """Generates analysis for a chunk of matches with retry logic."""
    print(f"🤖 Batch Analyzing {len(matches)} matches...")
    
    match_list_str = "\n".join([f"{m['id']}: {m['home']} vs {m['away']} ({m['date']})" for m in matches])
    
    prompt = f"""
    GÖREV: Aşağıdaki {len(matches)} Spor Toto maçını "2025-2026 Sezonu" bağlamında analiz et.
    Her maç için; kulüp finansları, sakatlıklar ve hoca durumuna dair kısa (1-2 cümle) bir analiz ve tahmin yap.
    
    MAÇLAR:
    {match_list_str}
    
    LÜTFEN KESİNLİKLE ŞU FORMATTA JSON LİSTESİ DÖN (BAŞKA METİN EKLEME):
    {{
        "analyses": [
            {{
                "id": Maçın ID'si,
                "prediction": "1 | X | 2",
                "confidence": 0-100,
                "probabilities": {{"1": %, "X": %, "2": %}},
                "reasoning": "Analiz metni..."
            }}
        ]
    }}
    """
    
    for attempt in range(max_retries):
        try:
            response = model.generate_content(prompt)
            text = response.text.strip()
            
            # Robust JSON extraction
            json_match = re.search(r'(\{[\s\S]*\})', text)
            if json_match:
                json_str = json_match.group(1)
                data = json.loads(json_str)
                return {a['id']: a for a in data['analyses']}
        except Exception as e:
            if "429" in str(e):
                wait_time = (attempt + 1) * 30
                print(f"⚠️ Quota hit (429). Retrying in {wait_time}s... (Attempt {attempt+1}/{max_retries})")
                time.sleep(wait_time)
            else:
                print(f"❌ Batch API Error: {e}")
                break
    
    return {}

def main():
    try:
        api_key = load_api_key()
        if not api_key:
            print("❌ No API Key found in assets/.env")
            return
        
        genai.configure(api_key=api_key)
        model = genai.GenerativeModel('gemini-2.5-flash')
        
        all_matches = fetch_latest_matches()
        processed_matches = []
        
        # Process in chunks of 5
        chunk_size = 5
        for i in range(0, len(all_matches), chunk_size):
            chunk = all_matches[i:i + chunk_size]
            batch_results = get_batch_analysis(model, chunk)
            
            for m in chunk:
                if m['id'] in batch_results:
                    m.update(batch_results[m['id']])
                else:
                    m.update({
                        "prediction": "1", 
                        "confidence": 50, 
                        "probabilities": {"1": 34, "X": 33, "2": 33}, 
                        "reasoning": "Analiz verisi alınamadı (Batch Hatası)."
                    })
                processed_matches.append(m)
            
            if i + chunk_size < len(all_matches):
                print("⏳ Mandatory cooldown (20s)...")
                time.sleep(20)
            
        total_cost = optimize_budget(processed_matches)
        
        output = {
            "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            "total_cost": total_cost,
            "matches": sorted(processed_matches, key=lambda x: x['id'])
        }
        
        with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
            json.dump(output, f, ensure_ascii=False, indent=4)
            
        print(f"\n✅ SUCCESS! {OUTPUT_PATH} updated. Total Cost: {total_cost} TL")
        
    except Exception as e:
        print(f"💥 Fatal Error: {e}")

if __name__ == "__main__":
    main()
