import os
import json

from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()

genai.configure(
    api_key=os.getenv("GEMINI_API_KEY")
)

model = genai.GenerativeModel(
    "gemini-2.5-flash"
)

def get_next_question(
    answers,
    question_bank
):

    prompt = f"""
You are a mental health assessment assistant.

User answers:

{answers}

Available categories:

{list(question_bank.keys())}

Determine the MOST relevant category
to explore next.

Return JSON only:

{{
  "category":"sleep"
}}
"""

    response = model.generate_content(
        prompt
    )

    text = response.text.strip()

    try:
        return json.loads(text)
    except:
        return {
            "category": "mood"
        }


def analyze_assessment(
    answers
):

    prompt = f"""
Analyze these questionnaire responses:

{answers}

Return JSON only:

{{
  "severity":"Low/Moderate/High",
  "summary":"...",
  "recommendations":[
      "...",
      "..."
  ]
}}
"""

    response = model.generate_content(
        prompt
    )

    text = response.text.strip()

    try:
        return json.loads(text)
    except:
        return {
            "severity": "Unknown",
            "summary":
                "Unable to analyze",
            "recommendations": []
        }