import os
import json
from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel("gemini-2.5-flash")

def get_next_question(answers, question_bank):
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
    response = model.generate_content(
        prompt,
        generation_config={"response_mime_type": "application/json"}
    )
    text = response.text.strip()
    try:
        return json.loads(text)
    except Exception as e:
        print(f"JSON Parsing Error: {e}")
        return {"category": "mood"}

def analyze_assessment(answers):
    prompt = f"""
Analyze these questionnaire responses:
{answers}

Return JSON only matching this format:
{{
  "severity": "Low/Moderate/High",
  "summary": "Full analysis summary...",
  "recommendations": [
      "Recommendation 1",
      "Recommendation 2"
  ]
}}
"""
    response = model.generate_content(
        prompt,
        generation_config={"response_mime_type": "application/json"}
    )
    text = response.text.strip()
    try:
        return json.loads(text)
    except Exception as e:
        print(f"JSON Parsing Error: {e}")
        return {
            "severity": "Unknown",
            "summary": "Unable to analyze",
            "recommendations": []
        }