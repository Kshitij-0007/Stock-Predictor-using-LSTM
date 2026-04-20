from fastapi import HTTPException
from app.db.session import get_database

async def get_user_portfolio(user_id: str):
    db = get_database()
    portfolio = await db["portfolios"].find_one({"user_id": user_id})
    if not portfolio:
        raise HTTPException(status_code=404, detail="Portfolio not found")
        
    portfolio["_id"] = str(portfolio["_id"])
    
    # In a real app, current_price is dynamically updated via the market service. 
    # We leave that mapping for the frontend or a periodic cron.
    total_holdings_value = sum([h["quantity"] * h["current_price"] for h in portfolio.get("holdings", [])])
    
    portfolio["total_value"] = portfolio["balance"] + total_holdings_value
    portfolio["pnl"] = portfolio["total_value"] - 100000.0 # initial balance
    
    return portfolio
