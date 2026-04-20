from pydantic import BaseModel
from typing import List, Dict

class Holding(BaseModel):
    symbol: str
    quantity: float
    average_price: float
    current_price: float = 0.0
    
class PortfolioBase(BaseModel):
    user_id: str
    balance: float = 100000.0 # Initial $100k paper trading balance
    holdings: List[Holding] = []

class PortfolioResponse(PortfolioBase):
    total_value: float
    pnl: float
