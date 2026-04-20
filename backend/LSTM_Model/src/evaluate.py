from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import numpy as np

def evaluate_model(model, X_test, y_test, scaler_y):
    """Evaluates the regression model and prints exact value metrics."""
    # Predict output
    predictions_scaled = model.predict(X_test)
    
    # Inverse transform to get actual price values back
    predictions_real = scaler_y.inverse_transform(predictions_scaled)
    y_test_real = scaler_y.inverse_transform(y_test.reshape(-1, 1))
    
    mse = mean_squared_error(y_test_real, predictions_real)
    mae = mean_absolute_error(y_test_real, predictions_real)
    r2 = r2_score(y_test_real, predictions_real)
    
    print("="*40)
    print("      REGRESSION EVALUATION RESULTS")
    print("="*40)
    print(f"R-Squared (R2) Score : {r2:.4f} (Target > 0.85)")
    print(f"Mean Absolute Error  : ±{mae:.2f}")
    print(f"Mean Squared Error   :  {mse:.2f}")
    print("="*40)
    
    # Quick sanity check on the first 5 records vs predictions
    print("\nVisual Sanity Check (First 5 Predictions vs Actuals):")
    for i in range(5):
        print(f"Predicted: {predictions_real[i][0]:.2f} | Actual: {y_test_real[i][0]:.2f}")
    print("="*40)
    
    return mse, mae, r2, predictions_real, y_test_real
