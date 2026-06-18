from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from question_bank import QUESTION_BANK
from ai_service import get_next_question, analyze_assessment

app = FastAPI()

# Enable CORS configuration for browser routing
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

GENERAL_QUESTIONS_SEQUENCE = ["mood_1", "sleep_1", "anxiety_1", "mood_2"]

@app.get("/")
def home():
    return {"status": "running"}

@app.post("/next-question")
def next_question(payload: dict):
    answers = payload.get("answers", {})
    answered_ids = list(answers.keys())
    total_answered = len(answered_ids)

    if total_answered < 4:
        for q_id in GENERAL_QUESTIONS_SEQUENCE:
            if q_id not in answered_ids:
                for category, questions in QUESTION_BANK.items():
                    for q in questions:
                        if q["id"] == q_id:
                            return q

    category_result = get_next_question(answers, QUESTION_BANK)
    category = category_result.get("category", "mood")

    available_questions = [
        q for q in QUESTION_BANK.get(category, []) 
        if q["id"] not in answered_ids
    ]

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