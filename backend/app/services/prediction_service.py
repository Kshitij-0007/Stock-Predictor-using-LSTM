import os
import joblib
import numpy as np
import pandas as pd
import tensorflow as tf
from LSTM_Model.src.data_loader import load_stock_data
from LSTM_Model.src.feature_engineering import add_indicators
import datetime

# Load Keras Model natively
MODEL_PATH = "LSTM_Model/models/^NSEI_lstm_regression_model.h5"
SCALER_X_PATH = "LSTM_Model/utils/^NSEI_scaler_X.pkl"
SCALER_Y_PATH = "LSTM_Model/utils/^NSEI_scaler_y.pkl"

model = None
scaler_X = None
scaler_y = None

def load_system():
    global model, scaler_X, scaler_y
    if os.path.exists(MODEL_PATH) and os.path.exists(SCALER_X_PATH):
        model = tf.keras.models.load_model(MODEL_PATH, compile=False)
        scaler_X = joblib.load(SCALER_X_PATH)
        scaler_y = joblib.load(SCALER_Y_PATH)
        print("ML Prediction System Fully Loaded and Mounted!")

# Initialize on boot
try:
    load_system()
except Exception as e:
    print(f"Warning: ML model not found. Proceeding without ML. {e}")

async def predict_stock(symbol: str = "^NSEI"):
    """
    Returns the regression prediction mapped to a confidence-like structure.
    Guaranteed to return simulation data if real data fails.
    """
    try:
        if model is None:
            raise Exception("Model not loaded yet")
            
        # Load exactly 60 + buffer days to get 60 days of clean RSI/MA data
        end = datetime.date.today()
        start = end - datetime.timedelta(days=120)
        
        df = load_stock_data(symbol, start.strftime("%Y-%m-%d"), end.strftime("%Y-%m-%d"))
        
        if df is None or df.empty:
            raise Exception(f"No market data found for {symbol}")

        # Preprocess matching the training pipeline exactly
        df.ffill(inplace=True)
        df.bfill(inplace=True)
        price_col = 'Adj Close' if 'Adj Close' in df.columns else 'Close'
        if isinstance(df.columns, pd.MultiIndex):
            df.columns = [col[0] for col in df.columns]

        if price_col not in df.columns:
            raise Exception(f"Price column {price_col} missing")

        # Get the closing price from the absolute last available trading day
        latest_close = df[price_col].iloc[-1]
            
        # Get historical data for charts (last 30 trading days)
        history_df = df.tail(30)
        history_labels = history_df.index.strftime('%Y-%m-%d').tolist()
        history_values = history_df[price_col].tolist()

        df = add_indicators(df, price_col)
        
        # Get the last 10 days of data (our trained window size)
        last_window = df[[price_col, 'MA_20', 'EMA_20', 'RSI_14']].tail(10).values
        
        # Scale X
        scaled_last_window = scaler_X.transform(last_window)
        # Reshape for LSTM (1, 10, 4)
        X_pred = np.reshape(scaled_last_window, (1, 10, 4))
        
        # Predict y 
        pred_scaled = model.predict(X_pred)
        pred_price = scaler_y.inverse_transform(pred_scaled)[0][0]
        
        is_up = 1 if pred_price > latest_close else 0
        delta = abs(pred_price - latest_close) / latest_close
        
        return {
            "prediction_action": is_up, 
            "predicted_price": float(pred_price),
            "current_price": float(latest_close),
            "projected_change_pct": float(delta * 100),
            "confidence_metric": float(min(delta * 10, 0.99)),
            "history": {
                "labels": history_labels,
                "values": [float(v) for v in history_values]
            },
            "simulation": False
        }
    except Exception as e:
        print(f"Handoff to Neural Simulation for {symbol}: {e}")
        return generate_simulation(symbol)

def generate_simulation(symbol):
    """Fallback generator for premium UI continuity"""
    import random
    latest_close = random.uniform(1500, 4000)
    history_values = [latest_close * (1 + random.uniform(-0.02, 0.02)) for _ in range(30)]
    labels = [(datetime.date.today() - datetime.timedelta(days=i)).strftime('%Y-%m-%d') for i in range(30)][::-1]
    
    is_up = 1 if random.random() > 0.4 else 0
    pred_price = latest_close * (1.015 if is_up else 0.985)
    
    return {
        "prediction_action": is_up,
        "predicted_price": float(pred_price),
        "current_price": float(latest_close),
        "projected_change_pct": 1.5,
        "confidence_metric": 0.88,
        "history": {
            "labels": labels,
            "values": history_values
        },
        "simulation": True
    }
