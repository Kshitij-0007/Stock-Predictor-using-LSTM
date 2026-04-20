import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout, BatchNormalization
from tensorflow.keras.regularizers import l2

def build_lstm_classifier(input_shape):
    """
    Builds an optimized Regression LSTM model.
    """
    model = Sequential([
        LSTM(
            units=100, 
            return_sequences=True, 
            input_shape=input_shape
        ),
        
        LSTM(
            units=50
        ),
        
        Dense(units=25, activation='relu'),
        # Linear activation for exact price prediction
        Dense(units=1, activation='linear')
    ])
    
    optimizer = tf.keras.optimizers.Adam(learning_rate=0.001)
    
    # We use Mean Squared Error (MSE) loss for regression models
    model.compile(
        optimizer=optimizer,
        loss='mean_squared_error',
        metrics=['mean_absolute_error']
    )
    
    return model
