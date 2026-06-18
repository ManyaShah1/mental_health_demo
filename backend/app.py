from fastapi import FastAPI

from question_bank import (
    QUESTION_BANK
)

from ai_service import (
    get_next_question,
    analyze_assessment
)

app = FastAPI()


@app.get("/")
def home():
    return {
        "status": "running"
    }


@app.post("/next-question")
def next_question(
    payload: dict
):

    answers = payload.get(
        "answers",
        {}
    )

    category_result = (
        get_next_question(
            answers,
            QUESTION_BANK
        )
    )

    category = (
        category_result.get(
            "category",
            "mood"
        )
    )

    question = (
        QUESTION_BANK[category][0]
    )

    return question


@app.post("/analyze")
def analyze(
    payload: dict
):

    answers = payload.get(
        "answers",
        {}
    )

    return analyze_assessment(
        answers
    )