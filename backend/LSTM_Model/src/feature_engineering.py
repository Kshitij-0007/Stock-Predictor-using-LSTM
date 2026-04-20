import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
import joblib
import os

def add_indicators(df: pd.DataFrame, price_col: str) -> pd.DataFrame:
    """Adds moving averages and RSI for regression features."""
    df = df.copy()
    
    df['MA_20'] = df[price_col].rolling(window=20).mean()
    df['EMA_20'] = df[price_col].ewm(span=20, adjust=False).mean()
    
    delta = df[price_col].diff()
    gain = delta.clip(lower=0).rolling(window=14).mean()
    loss = (-delta.clip(upper=0)).rolling(window=14).mean()
    rs = gain / loss
    df['RSI_14'] = 100 - (100 / (1 + rs))
    
    df.dropna(inplace=True)
    return df

def create_sequences_and_scale(df: pd.DataFrame, ticker: str, price_col: str, window_size: int = 60, scaler_dir: str = "LSTM_Model/utils"):
    """Scales features and generates sliding window sequences for LSTM Regression using dual scalers."""
    feature_cols = [price_col, 'MA_20', 'EMA_20', 'RSI_14']
    target_col = 'Target'
    
    # We use dual-scalers so we can easily inverse-transform predictions back to real pricing amounts ($) later
    scaler_X = MinMaxScaler(feature_range=(0, 1))
    scaled_features = scaler_X.fit_transform(df[feature_cols].values)
    
    scaler_y = MinMaxScaler(feature_range=(0, 1))
    scaled_y = scaler_y.fit_transform(df[[target_col]].values)
    
    if not os.path.exists(scaler_dir):
        os.makedirs(scaler_dir)
        
    joblib.dump(scaler_X, os.path.join(scaler_dir, f"{ticker}_scaler_X.pkl"))
    joblib.dump(scaler_y, os.path.join(scaler_dir, f"{ticker}_scaler_y.pkl"))
    
    X, y = [], []
    
    for i in range(window_size, len(scaled_features)):
        X.append(scaled_features[i-window_size:i])
        y.append(scaled_y[i][0])
        
    return np.array(X), np.array(y), scaler_X, scaler_y
