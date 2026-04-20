import React, { useState } from 'react';
import { predictionService } from '../services/api';
import { Brain, TrendingUp, TrendingDown, RefreshCw } from 'lucide-react';

const PredictionWidget = ({ symbol }) => {
  const [prediction, setPrediction] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handlePredict = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await predictionService.getPrediction(symbol);
      if (response.data.error) {
        setError(response.data.error);
      } else {
        setPrediction(response.data);
      }
    } catch (err) {
      setError("Failed to fetch prediction");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="glass-card" style={{ marginTop: '24px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h3 style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Brain size={20} color="var(--primary)" /> AI Oracle
        </h3>
        <button 
          className="btn-primary" 
          onClick={handlePredict} 
          disabled={loading}
          style={{ padding: '6px 12px', fontSize: '14px', display: 'flex', alignItems: 'center', gap: '6px' }}
        >
          {loading ? <RefreshCw size={14} className="animate-spin" /> : "Predict Horizon"}
        </button>
      </div>

      <div style={{ marginTop: '16px' }}>
        {error && <p style={{ color: 'var(--accent-red)' }}>{error}</p>}
        
        {!prediction && !error && !loading && (
           <p style={{ color: 'var(--text-muted)' }}>Click predict to infer tomorrow's closing trajectory for {symbol}.</p>
        )}

        {prediction && !error && (
          <div style={{ background: 'rgba(0,0,0,0.2)', padding: '16px', borderRadius: '8px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <p style={{ color: 'var(--text-muted)', fontSize: '14px', marginBottom: '4px' }}>Target Action</p>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  {prediction.prediction_action === 1 ? (
                    <span className="badge badge-success" style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '14px' }}>
                      <TrendingUp size={16} /> BULLISH
                    </span>
                  ) : (
                    <span className="badge badge-danger" style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '14px' }}>
                      <TrendingDown size={16} /> BEARISH
                    </span>
                  )}
                </div>
              </div>
              
              <div style={{ textAlign: 'right' }}>
                <p style={{ color: 'var(--text-muted)', fontSize: '14px', marginBottom: '4px' }}>Predicted Price</p>
                <p style={{ fontSize: '18px', fontWeight: 'bold' }}>
                  {prediction.predicted_price.toFixed(2)} 
                  <span style={{ fontSize: '12px', color: prediction.prediction_action === 1 ? 'var(--accent)' : 'var(--accent-red)', marginLeft: '6px' }}>
                    ({prediction.projected_change_pct > 0 ? '+' : ''}{prediction.projected_change_pct.toFixed(2)}%)
                  </span>
                </p>
              </div>
            </div>
            
            <div style={{ marginTop: '16px' }}>
               <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '4px', fontSize: '12px', color: 'var(--text-muted)' }}>
                 <span>LSTM Confidence Level</span>
                 <span>{(prediction.confidence_metric * 100).toFixed(1)}%</span>
               </div>
               <div style={{ width: '100%', height: '6px', background: 'rgba(255,255,255,0.1)', borderRadius: '3px', overflow: 'hidden' }}>
                 <div style={{ 
                   height: '100%', 
                   width: `${prediction.confidence_metric * 100}%`,
                   background: prediction.prediction_action === 1 ? 'var(--accent)' : 'var(--accent-red)',
                   transition: 'width 1s ease-in-out'
                 }} />
               </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default PredictionWidget;
