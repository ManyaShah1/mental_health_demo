import random
from typing import Dict, List, Optional
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from question_bank import QUESTION_BANK
from ai_service import analyze_assessment

app = FastAPI(
    title="Mental Health Assessment API",
    description="A validated API to serve dynamic questionnaires and analyze wellness trends.",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- API SCHEMA DEFINITIONS ---

class AssessmentPayload(BaseModel):
    answers: Dict[str, str] = Field(
        default_factory=dict,
        description="A map of question IDs to the user's selected option text."
    )

class MetricBreakdown(BaseModel):
    Mood_Balance: int = Field(..., alias="Mood Balance")
    Sleep_Architecture: int = Field(..., alias="Sleep Architecture")
    Stress_Resilience: int = Field(..., alias="Stress Resilience")
    Cognitive_Focus: int = Field(..., alias="Cognitive Focus")
    Anxiety_Management: int = Field(..., alias="Anxiety Management")

    class Config:
        populate_by_name = True

class AnalysisResultResponse(BaseModel):
    total_score: int
    severity: str
    summary: str
    metrics: MetricBreakdown
    recommendations: List[str]


# --- API ENDPOINTS ---

GENERAL_QUESTIONS_SEQUENCE = ["mood_1", "sleep_1", "anxiety_1", "stress_1"]

@app.get("/", tags=["Health Check"])
def home():
    return {"status": "running"}

@app.post(
    "/next-question",
    response_model=dict,
    tags=["Questionnaire Flow"]
)
def next_question(payload: AssessmentPayload):
    answers = payload.answers
    answered_ids = list(answers.keys())
    total_answered = len(answered_ids)

    # 1. Enforce assessment cap at exactly 15 questions
    if total_answered >= 15:
        return {"status": "completed", "message": "Assessment completed."}

    # 2. Sequential Baseline Check (First 4 baseline questions)
    if total_answered < 4:
        for q_id in GENERAL_QUESTIONS_SEQUENCE:
            if q_id not in answered_ids:
                for category, questions in QUESTION_BANK.items():
                    for q in questions:
                        if q["id"] == q_id:
                            return q  # Returns the raw question dict cleanly

    # 3. Local Quota Optimization Routing (Questions 5-15)
    incomplete_categories = []
    for category, questions in QUESTION_BANK.items():
        available = [q for q in questions if q["id"] not in answered_ids]
        if available:
            incomplete_categories.append(available)

    # 4. Return Random Question from Remaining Pools
    if incomplete_categories:
        target_pool = random.choice(incomplete_categories)
        return random.choice(target_pool)
    else:
        return {"status": "completed", "message": "All assessment questions completed."}

@app.post(
    "/analyze",
    response_model=AnalysisResultResponse,
    tags=["Assessment Insights"]
)
def analyze(payload: AssessmentPayload):
    raw_analysis_data = analyze_assessment(payload.answers)
    return AnalysisResultResponse(**raw_analysis_data)