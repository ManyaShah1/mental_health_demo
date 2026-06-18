import random
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from question_bank import QUESTION_BANK
from ai_service import get_next_question, analyze_assessment

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Broad baseline sequence covering different areas first
GENERAL_QUESTIONS_SEQUENCE = ["mood_1", "sleep_1", "anxiety_1", "stress_1"]

@app.get("/")
def home():
    return {"status": "running"}

@app.post("/next-question")
def next_question(payload: dict):
    answers = payload.get("answers", {})
    answered_ids = list(answers.keys())
    total_answered = len(answered_ids)

    # 1. Force stop at exactly 15 questions and trigger results view
    if total_answered >= 15:
        return {"status": "completed", "message": "Assessment completed."}

    # 2. Enforce the first 4 generalized baseline questions sequentially
    if total_answered < 4:
        for q_id in GENERAL_QUESTIONS_SEQUENCE:
            if q_id not in answered_ids:
                for category, questions in QUESTION_BANK.items():
                    for q in questions:
                        if q["id"] == q_id:
                            return q

    # 3. After baseline, fetch category recommendations safely with type checking
    category = "mood"  # Secure default fallback
    try:
        category_result = get_next_question(answers, QUESTION_BANK)
        
        # Bulletproof validation: Handle both dictionary and raw string responses from Gemini
        if isinstance(category_result, dict):
            category = category_result.get("category", "mood").lower()
        elif isinstance(category_result, str):
            category = category_result.lower()
            
    except Exception as e:
        print(f"Error resolving category recommendations: {e}")

    # Ensure the category exists in our question bank dictionary
    if category not in QUESTION_BANK:
        category = "mood"

    # Filter out already answered questions in that targeted category
    available_questions = [
        q for q in QUESTION_BANK[category] 
        if q["id"] not in answered_ids
    ]

    # Fallback: If recommended category is completely exhausted, grab remaining questions from any area
    if not available_questions:
        for cat, questions in QUESTION_BANK.items():
            available_questions = [q for q in questions if q["id"] not in answered_ids]
            if available_questions:
                break

    # 4. Randomize selection inside the remaining target pool
    if available_questions:
        return random.choice(available_questions)
    else:
        # Final fallback if the pool runs entirely dry
        return {"status": "completed", "message": "All assessment questions completed."}

@app.post("/analyze")
def analyze(payload: dict):
    answers = payload.get("answers", {})
    return analyze_assessment(answers)