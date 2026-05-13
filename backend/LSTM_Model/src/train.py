import os
import datetime
import tensorflow as tf
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau

from LSTM_Model.src.data_loader import load_stock_data, save_raw_data
from LSTM_Model.src.preprocess import clean_and_compute_returns
from LSTM_Model.src.feature_engineering import add_indicators, create_sequences_and_scale
from LSTM_Model.src.model import build_lstm_classifier
from LSTM_Model.src.evaluate import evaluate_model

def train_pipeline(ticker="^NSEI", years=5, window_size=60, epochs=100, batch_size=64):
    """
    Orchestrates the Regression ML pipeline and trains using GPU if available.
    """
    # 1. Configuration & Data Fetching
    end_date = datetime.date.today()
    start_date = end_date - datetime.timedelta(days=years * 365)
    
    print(f"Fetching data for {ticker}...")
    df = load_stock_data(ticker, start_date.strftime("%Y-%m-%d"), end_date.strftime("%Y-%m-%d"))
    save_raw_data(df, ticker)
    
    # 2. Preprocessing & Feature Engineering
    df, price_col = clean_and_compute_returns(df)
    df = add_indicators(df, price_col)
    X, y, scaler_X, scaler_y = create_sequences_and_scale(df, ticker, price_col, window_size)
    
    # 3. Train/Test Split (Sequential for Time Series)
    split_idx = int(len(X) * 0.8)
    X_train, X_test = X[:split_idx], X[split_idx:]
    y_train, y_test = y[:split_idx], y[split_idx:]
    
    print(f"Training data shape: {X_train.shape}")
    print(f"Testing data shape: {X_test.shape}")
    
    # 4. Model Building
    model = build_lstm_classifier((X_train.shape[1], X_train.shape[2]))
    
    # 5. Training with Optimizations
    print("\nStarting model training...")
    model.fit(
        X_train, y_train,
        epochs=epochs,
        batch_size=32,
        validation_data=(X_test, y_test),
        verbose=1
    )
    
    # 6. Evaluation using Inverse Transformed Real Pricing
    print("\nEvaluating on Test Set...")
    evaluate_model(model, X_test, y_test, scaler_y)
    
    # 7. Save Model Artifacts
    model_dir = "LSTM_Model/models"
    if not os.path.exists(model_dir):
        os.makedirs(model_dir)
        
    model_path = os.path.join(model_dir, f"{ticker}_lstm_regression_model.h5")
    model.save(model_path)
    print(f"Model successfully saved to {model_path}")
    
    return model

if __name__ == "__main__":
    # Check GPU before running
    physical_devices = tf.config.list_physical_devices('GPU')
    if physical_devices:
        print(f"--- GPU Support Detected: {physical_devices} ---")
    else:
        print("--- Warning: Training on CPU ---")
        
    # Run the pipeline for Reliance Stock over the last 10 years
    train_pipeline(
        ticker="RELIANCE.NS", 
        years=10, 
        window_size=60, 
        epochs=50, 
        batch_size=32
    )
