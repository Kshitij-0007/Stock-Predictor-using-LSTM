from fastapi import APIRouter, Depends
from app.schemas.trade_schema import TradeCreate, TradeResponse
from app.services.trading_service import execute_trade
from app.api.v1.dependencies import get_current_user

router = APIRouter()

@router.post("/", response_model=TradeResponse)
async def place_order(trade_in: TradeCreate, current_user: dict = Depends(get_current_user)):
    return await execute_trade(current_user["_id"], trade_in)
