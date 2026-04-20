import pandas as pd

def clean_and_compute_returns(df: pd.DataFrame):
    """Handles missing values and sets the target to exactly predict tomorrow's closing price."""
    df = df.copy()
    
    # Forward and backward fill for missing values
    df.ffill(inplace=True)
    df.bfill(inplace=True)
    
    price_col = 'Adj Close' if 'Adj Close' in df.columns else 'Close'

    # Clean multi-index columns from yfinance if exists
    if isinstance(df.columns, pd.MultiIndex):
       df.columns = [col[0] for col in df.columns]

    # Target variable: Next day's exact price
    df['Target'] = df[price_col].shift(-1)
    
    df.dropna(inplace=True)
    return df, price_col
