import yfinance as yf
import pandas as pd
import os

def load_stock_data(ticker: str, start_date: str, end_date: str) -> pd.DataFrame:
    """Fetches NSE/BSE data from Yahoo Finance."""
    print(f"Downloading data for {ticker} from {start_date} to {end_date}...")
    df = yf.download(ticker, start=start_date, end=end_date)
    return df

def save_raw_data(data: pd.DataFrame, ticker: str, output_dir: str = "LSTM_Model/data/raw") -> str:
    """Saves the downloaded dataframe to a CSV file."""
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    file_path = os.path.join(output_dir, f"{ticker}_raw.csv")
    data.to_csv(file_path)
    return file_path
