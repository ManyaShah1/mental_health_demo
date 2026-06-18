from fastapi import FastAPI
from question_bank import QUESTION_BANK
from ai_service import get_next_question, analyze_assessment

app = FastAPI()

# Define the exact 4 baseline/generalized questions to ask first
GENERAL_QUESTIONS_SEQUENCE = [
    "mood_1",     # How often have you felt down recently?
    "sleep_1",    # How would you rate your sleep quality?
    "anxiety_1",  # How often do you feel overwhelmed?
    "mood_2"      # Have you lost interest in activities?
]

@app.get("/")
def home():
    return {"status": "running"}

@app.post("/next-question")
def next_question(payload: dict):
    answers = payload.get("answers", {})
    answered_ids = list(answers.keys())
    total_answered = len(answered_ids)

    # Rule: First 4 questions are generalized baseline questions
    if total_answered < 4:
        for q_id in GENERAL_QUESTIONS_SEQUENCE:
            if q_id not in answered_ids:
                for category, questions in QUESTION_BANK.items():
                    for q in questions:
                        if q["id"] == q_id:
                            return q

    # Rule: After 4 questions, use Gemini to pick the next relevant category
    category_result = get_next_question(answers, QUESTION_BANK)
    category = category_result.get("category", "mood")

    # Get unanswered questions from that category
    available_questions = [
        q for q in QUESTION_BANK.get(category, []) 
        if q["id"] not in answered_ids
    ]

    # Fallback: If recommended category is fully answered, grab any remaining question
    if not available_questions:
        for cat, questions in QUESTION_BANK.items():
            available_questions = [q for q in questions if q["id"] not in answered_ids]
            if available_questions:
                break

    if available_questions:
        return available_questions[0]
    else:
        return {"status": "completed", "message": "All assessment questions completed."}

@app.post("/analyze")
def analyze(payload: dict):
    answers = payload.get("answers", {})
    return analyze_assessment(answers)