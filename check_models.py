import os
import google.generativeai as genai
from dotenv import load_dotenv

# Base directory
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# Load env from specific path
load_dotenv(os.path.join(BASE_DIR, 'assets', '.env'))

api_key = os.environ.get('GEMINI_API_KEY')
if not api_key:
    print("❌ API Key not found!")
    exit()

genai.configure(api_key=api_key)

print("🔍 Listing available Flash and Pro models...")
try:
    for m in genai.list_models():
        if 'generateContent' in m.supported_generation_methods:
            name = m.name.replace('models/', '')
            print(f"- {name}")
except Exception as e:
    print(f"❌ Error listing models: {e}")
