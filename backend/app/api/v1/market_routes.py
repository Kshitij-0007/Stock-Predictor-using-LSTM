import json
import asyncio
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from typing import List
import pandas as pd

router = APIRouter()

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)

manager = ConnectionManager()

# Global cache for market data to reduce API load
market_cache = {
    "data": {},
    "last_fetch": 0
}

async def stream_market_data():
    import yfinance as yf
    import time
    
    tickers = ["RELIANCE.NS", "TCS.NS", "^NSEI"]
    
    while True:
        if manager.active_connections:
            # Refresh cache every 60 seconds
            if time.time() - market_cache["last_fetch"] > 60:
                try:
                    # Use a 5-day period so we always get the last available price even on weekends
                    data = yf.download(tickers, period="5d", interval="1m", progress=False)
                    if not data.empty and 'Adj Close' in data:
                        # Convert the 'Adj Close' section to a dict
                        adj_close = data['Adj Close']
                        for ticker in tickers:
                            try:
                                # This handles both MultiIndex and single Series
                                if isinstance(adj_close, pd.DataFrame):
                                    series = adj_close[ticker].dropna()
                                else:
                                    series = adj_close.dropna()
                                
                                if not series.empty:
                                    market_cache["data"][ticker] = round(float(series.iloc[-1]), 2)
                            except:
                                pass
                    
                    market_cache["last_fetch"] = time.time()
                    print(f"BROADCASTING Market Data Refresh: {market_cache['data']}")
                except Exception as e:
                    print(f"Market Stream Error: {e}")

            # If we have any data (even cached), broadcast it
            if market_cache["data"]:
                await manager.broadcast(json.dumps(market_cache["data"]))
                
        await asyncio.sleep(5) # Broadcast to clients every 5 seconds

@router.websocket("/ws/stream")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            # Keep connection alive
            data = await websocket.receive_text()
    except WebSocketDisconnect:
        manager.disconnect(websocket)
