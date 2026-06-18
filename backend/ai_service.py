import os
import json
from dotenv import load_dotenv
import google.generativeai as genai

# Load environment variables from a .env file
load_dotenv()

# Configure the Google Gemini API with your key
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# Initialize the Gemini Flash model
model = genai.GenerativeModel("gemini-2.5-flash")

def get_next_question(answers, question_bank):
    """
    Asks Gemini to look at the answers given so far and determine which category 
    of the questionnaire bank should be dug into next.
    """
    prompt = f"""
You are a mental health assessment assistant.
The user has answered the following questions so far:
{answers}

Available categories in our system:
{list(question_bank.keys())}

Based on their answers, determine which category is MOST relevant to dig deeper into next. 
Do not choose a category if its context has already been fully explored in the answers above.

Return JSON only matching this format:
{{
  "category": "sleep"
}}
"""
    try:
        response = model.generate_content(
            prompt,
            generation_config={"response_mime_type": "application/json"}
        )
        text = response.text.strip()
        result = json.loads(text)
        return result
    except Exception as e:
        print(f"Error in get_next_question API inference: {e}")
        return {"category": "mood"}

def analyze_assessment(answers):
    """
    Compiles a deeply contextual, quantitative mental health dashboard report
    based on the user's 15 responses.
    """
    prompt = f"""
You are an expert clinical mental health analyst compiling an evaluation dashboard.
Analyze these specific questionnaire responses provided by the user:
{answers}

CRITICAL DATA REQUISITES:
1. Calculate an overall "total_score" out of 100 based on symptom severity trends.
2. Break down the assessment into exactly 5 specific structural sub-metrics scored out of 10:
   - Mood Balance
   - Sleep Architecture
   - Stress Resilience
   - Cognitive Focus
   - Anxiety Management
3. Provide a deeply personal, customized 3-4 sentence "summary" cross-referencing their lowest metric scores.
4. Provide 3 specific, non-generic recommendations.

Return JSON matching this exact schema:
{{
  "total_score": 72,
  "severity": "Low/Moderate/High",
  "summary": "Your responses indicate standard mood stabilization with notable disruptions around deep sleep architecture...",
  "metrics": {{
    "Mood Balance": 8,
    "Sleep Architecture": 4,
    "Stress Resilience": 7,
    "Cognitive Focus": 5,
    "Anxiety Management": 6
  }},
  "recommendations": [
    "Prioritize a strict wind-down routine 45 minutes before sleep.",
    "Implement time-blocking techniques to protect cognitive bandwidth during drop-offs."
  ]
}}
"""
    try:
        response = model.generate_content(
            prompt,
            generation_config={"response_mime_type": "application/json"}
        )
        text = response.text.strip()
        return json.loads(text)
    except Exception as e:
        print(f"JSON Parsing/API Error in analyze_assessment: {e}")
        return {
            "total_score": 0,
            "severity": "Unknown",
            "summary": "Unable to safely process and compile evaluation parameters at this time.",
            "metrics": {
                "Mood Balance": 0,
                "Sleep Architecture": 0,
                "Stress Resilience": 0,
                "Cognitive Focus": 0,
                "Anxiety Management": 0
            },
            "recommendations": ["Please try reloading your assessment report panel shortly."]
        }