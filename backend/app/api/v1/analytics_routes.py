from fastapi import APIRouter

router = APIRouter()

@router.get("/")
def get_analytics():
    return {"message": "Endpoint for analytics"}
