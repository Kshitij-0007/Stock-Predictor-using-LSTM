from pydantic import BaseModel, Field
from typing import Optional, Literal
from datetime import datetime

class TradeBase(BaseModel):
    symbol: str
    action: Literal["buy", "sell"]
    quantity: float
    price: float

class TradeCreate(TradeBase):
    pass

class TradeInDB(TradeBase):
    id: str = Field(alias="_id")
    user_id: str
    status: Literal["executed", "pending", "failed"] = "executed"
    timestamp: datetime
    
class TradeResponse(TradeInDB):
    pass
