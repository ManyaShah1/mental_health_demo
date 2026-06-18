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
    Compiles a deeply contextual and non-generic evaluation report strictly 
    tailored to the cumulative pattern of the user's answers.
    """
    prompt = f"""
You are an expert clinical mental health analyst compiling an evaluation report.
Analyze these specific questionnaire responses provided by the user:
{answers}

CRITICAL INSTRUCTIONS FOR UNIQUE RESULTS:
1. Do NOT reuse generic templates or standard blanket statements.
2. The "summary" must be custom-tailored to the intersections of their answers. For example, if they have poor sleep AND low focus, comment explicitly on how sleep deprivation is degrading cognitive clarity.
3. Recommendations MUST match the severity and explicitly mention details derived from their worst-scoring responses.
4. Output "severity" strictly based on cumulative patterns: High (constant severe symptoms), Moderate (frequent or intermittent struggles), Low (mostly stable/mild fluctuations).

Return JSON only matching this exact schema:
{{
  "severity": "Low/Moderate/High",
  "summary": "Write a deeply specific 3-4 sentence analysis explaining the exact interaction of their symptoms.",
  "recommendations": [
      "Custom actionable recommendation statement 1 based on their explicit options.",
      "Custom actionable recommendation statement 2 based on their explicit options."
  ]
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
        print(f"JSON Parsing/API Error in analyze_assessment: {e}")
        return {
            "severity": "Unknown",
            "summary": "Unable to safely process and analyze parameters at this time.",
            "recommendations": [
                "Please consider reaching out to a mental health professional for a personalized consultation.",
                "Ensure you are maintaining basic sleep hygiene and tracking any changes in routine daily."
            ]
        }