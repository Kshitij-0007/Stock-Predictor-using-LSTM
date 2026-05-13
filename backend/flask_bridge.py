import sys
import os
from flask import Flask, jsonify

# Add the current directory to sys.path to allow importing from 'app'
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.services.prediction_service import predict_stock
import asyncio

app = Flask(__name__)

@app.route('/predict/<symbol>', methods=['GET'])
def predict(symbol):
    """
    Bridge endpoint to provide the LSTM prediction in the format expected by Spring Boot.
    Runs on port 5000.
    """
    try:
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        result = loop.run_until_complete(predict_stock(symbol))
        # Ensure result isn't an error dict
        if isinstance(result, dict) and "error" in result:
            from app.services.prediction_service import generate_simulation
            return jsonify(generate_simulation(symbol))
        return jsonify(result)
    except Exception as e:
        print(f"Bridge-level fallback triggered: {e}")
        from app.services.prediction_service import generate_simulation
        return jsonify(generate_simulation(symbol))
    finally:
        if 'loop' in locals():
            loop.close()

@app.route('/', methods=['GET'])
def index():
    return jsonify({"message": "LSTM Prediction Microservice is up and running on port 5000"})

if __name__ == '__main__':
    print("Starting LSTM Flask Bridge on port 5000...")
    app.run(host='0.0.0.0', port=5000)
