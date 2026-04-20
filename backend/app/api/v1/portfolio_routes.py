from fastapi import APIRouter, Depends
from app.schemas.portfolio_schema import PortfolioResponse
from app.services.portfolio_service import get_user_portfolio
from app.api.v1.dependencies import get_current_user

router = APIRouter()

@router.get("/", response_model=PortfolioResponse)
async def get_portfolio(current_user: dict = Depends(get_current_user)):
    return await get_user_portfolio(current_user["_id"])
