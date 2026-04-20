from fastapi import HTTPException
from datetime import datetime
from app.db.session import get_database
from app.schemas.trade_schema import TradeCreate

async def execute_trade(user_id: str, trade_in: TradeCreate):
    db = get_database()
    portfolios_collection = db["portfolios"]
    trades_collection = db["trades"]
    
    portfolio = await portfolios_collection.find_one({"user_id": user_id})
    if not portfolio:
        raise HTTPException(status_code=404, detail="Portfolio not found")
        
    cost_or_revenue = trade_in.price * trade_in.quantity
    holdings = portfolio.get("holdings", [])
    
    if trade_in.action == "buy":
        if portfolio["balance"] < cost_or_revenue:
            raise HTTPException(status_code=400, detail="Insufficient funds")
        
        # update balance
        portfolio["balance"] -= cost_or_revenue
        
        # update holdings
        holding_found = False
        for h in holdings:
            if h["symbol"] == trade_in.symbol:
                total_cost = (h["quantity"] * h["average_price"]) + cost_or_revenue
                h["quantity"] += trade_in.quantity
                h["average_price"] = total_cost / h["quantity"]
                holding_found = True
                break
        
        if not holding_found:
            holdings.append({
                "symbol": trade_in.symbol,
                "quantity": trade_in.quantity,
                "average_price": trade_in.price,
                "current_price": trade_in.price
            })
            
    elif trade_in.action == "sell":
        holding_found = False
        for h in holdings:
            if h["symbol"] == trade_in.symbol:
                if h["quantity"] < trade_in.quantity:
                    raise HTTPException(status_code=400, detail="Insufficient shares")
                
                h["quantity"] -= trade_in.quantity
                portfolio["balance"] += cost_or_revenue
                holding_found = True
                break
                
        if not holding_found:
            raise HTTPException(status_code=400, detail="Do not hold this stock")
            
        # Clean up empty holdings
        holdings = [h for h in holdings if h["quantity"] > 0]
    
    # Save back to db
    await portfolios_collection.update_one(
        {"user_id": user_id},
        {"$set": {"balance": portfolio["balance"], "holdings": holdings}}
    )
    
    # Record trade
    trade_dict = trade_in.dict()
    trade_dict["user_id"] = user_id
    trade_dict["timestamp"] = datetime.utcnow()
    trade_dict["status"] = "executed"
    
    result = await trades_collection.insert_one(trade_dict)
    trade_dict["_id"] = str(result.inserted_id)
    
    return trade_dict
