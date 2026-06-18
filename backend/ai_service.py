import os
import json
from dotenv import load_dotenv
from pydantic import BaseModel
from google import genai
from google.genai import types

# Load environment variables
load_dotenv()

# Initialize the modern Google GenAI Client
# It will automatically pick up your GEMINI_API_KEY environment variable
client = genai.Client()

def get_next_question(answers, question_bank):
    """
    Asks Gemini to analyze response history and recommend the next category.
    """
    prompt = f"""
    You are a mental health assessment assistant.
    The user has answered the following questions so far: {answers}
    Available categories: {list(question_bank.keys())}
    Based on their answers, return the category most relevant to explore next.
    Do not select a category if its questions have already been fully explored.
    """
    try:
        response = client.models.generate_content(
            model='gemini-2.5-flash',
            contents=prompt,
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
            ),
        )
        return json.loads(response.text.strip())
    except Exception as e:
        print(f"Error in get_next_question SDK call: {e}")
        return {"category": "mood"}

def analyze_assessment(answers):
    """
    Compiles a deeply contextual, quantitative mental health dashboard report
    using structured content configurations.
    """
    prompt = f"""
    You are an expert clinical mental health analyst compiling an evaluation dashboard.
    Analyze these specific questionnaire responses provided by the user:
    {answers}

    CRITICAL DATA REQUISITES:
    1. Calculate an overall "total_score" out of 100 based on symptom severity trends.
    2. Break down the assessment into exactly these 5 specific structural sub-metrics scored out of 10:
       - Mood Balance
       - Sleep Architecture
       - Stress Resilience
       - Cognitive Focus
       - Anxiety Management
    3. Provide a deeply personal, customized 3-4 sentence "summary" cross-referencing their lowest metric scores.
    4. Provide 3 specific, non-generic recommendations. Do NOT use standard blanket statements.
    """
    try:
        response = client.models.generate_content(
            model='gemini-2.5-flash',
            contents=prompt,
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
            ),
        )
        return json.loads(response.text.strip())
    except Exception as e:
        print(f"Error in analyze_assessment SDK call: {e}")
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