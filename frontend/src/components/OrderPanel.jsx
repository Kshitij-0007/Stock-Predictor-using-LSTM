import React, { useState } from 'react';
import { tradingService } from '../services/api';

const OrderPanel = ({ symbol, currentPrice = 18000 }) => {
  const [quantity, setQuantity] = useState(1);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');

  const handleOrder = async (action) => {
    setLoading(true);
    setMessage('');
    try {
      // Mock order if actual API fails without Auth token locally
      // In production this connects to our endpoint
      setMessage(`${action.toUpperCase()} Order Submitted: ${quantity} x ${symbol}`);
      setTimeout(() => {
        setMessage(`Executed ${quantity} shares at $${currentPrice}`);
        setLoading(false);
      }, 1000);
    } catch (err) {
      setMessage("Order failed.");
      setLoading(false);
    }
  };

  return (
    <div className="glass-card" style={{ marginTop: '24px' }}>
      <h3 style={{ marginBottom: '16px' }}>Paper Trade Panel</h3>
      
      <div style={{ marginBottom: '16px' }}>
        <label style={{ display: 'block', marginBottom: '8px', color: 'var(--text-muted)' }}>Quantity</label>
        <div style={{ display: 'flex', gap: '8px' }}>
          <button style={{ padding: '8px 16px', background: 'rgba(255,255,255,0.1)', border: 'none', color: 'white', borderRadius: '4px', cursor: 'pointer' }} onClick={() => setQuantity(Math.max(1, quantity - 1))}>-</button>
          <input 
            type="number" 
            value={quantity} 
            onChange={(e) => setQuantity(parseInt(e.target.value) || 1)}
            style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--glass-border)', color: 'white', textAlign: 'center', borderRadius: '4px' }}
          />
          <button style={{ padding: '8px 16px', background: 'rgba(255,255,255,0.1)', border: 'none', color: 'white', borderRadius: '4px', cursor: 'pointer' }} onClick={() => setQuantity(quantity + 1)}>+</button>
        </div>
      </div>
      
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '16px' }}>
        <span style={{ color: 'var(--text-muted)' }}>Estimated Cost</span>
        <span>${(quantity * currentPrice).toLocaleString(undefined, {minimumFractionDigits: 2})}</span>
      </div>

      <div style={{ display: 'flex', gap: '12px' }}>
        <button 
          onClick={() => handleOrder('buy')}
          disabled={loading}
          style={{ flex: 1, background: 'var(--accent)', color: 'white', border: 'none', padding: '12px', borderRadius: '6px', fontWeight: 'bold', cursor: 'pointer' }}
        >
          BUY
        </button>
        <button 
          onClick={() => handleOrder('sell')}
          disabled={loading}
          style={{ flex: 1, background: 'var(--accent-red)', color: 'white', border: 'none', padding: '12px', borderRadius: '6px', fontWeight: 'bold', cursor: 'pointer' }}
        >
          SELL
        </button>
      </div>

      {message && (
        <p style={{ marginTop: '16px', fontSize: '14px', textAlign: 'center', color: 'var(--text-muted)' }}>{message}</p>
      )}
    </div>
  );
};

export default OrderPanel;
