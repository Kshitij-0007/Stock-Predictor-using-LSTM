import React, { useState } from 'react';
import useWebSocket from '../hooks/useWebSocket';
import Chart from '../components/Chart/Chart';
import PredictionWidget from '../components/PredictionWidget';
import OrderPanel from '../components/OrderPanel';

const Dashboard = () => {
  const [selectedTicker, setSelectedTicker] = useState('^NSEI');
  const { data: wsData, isConnected } = useWebSocket('ws://localhost:8000/api/v1/market/ws/stream');

  // Extract live price from websocket if available, or fallback to realistic initial values
  const defaultPrices = { '^NSEI': 22000.00, 'RELIANCE.NS': 2800.00, 'TCS.NS': 3900.00 };
  const livePrice = wsData && wsData[selectedTicker] ? wsData[selectedTicker] : (defaultPrices[selectedTicker] || 100.00);
  
  const watchlist = [
    { symbol: '^NSEI', name: 'NIFTY 50' },
    { symbol: 'RELIANCE.NS', name: 'Reliance Ind.' },
    { symbol: 'TCS.NS', name: 'TCS' },
  ];

  return (
    <div style={{ padding: '40px', maxWidth: '1400px', margin: '0 auto' }}>
      <header style={{ marginBottom: '40px', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
        <div>
          <h1 style={{ fontSize: '2.5rem', marginBottom: '8px' }}>AI Trading Terminal</h1>
          <p style={{ color: 'var(--text-muted)' }}>Real-time Execution & LSTM Analytics</p>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <div style={{ width: '8px', height: '8px', borderRadius: '50%', background: isConnected ? 'var(--accent)' : 'var(--accent-red)', boxShadow: `0 0 10px ${isConnected ? 'var(--accent)' : 'var(--accent-red)'}` }} />
          <span style={{ fontSize: '14px', color: 'var(--text-muted)' }}>{isConnected ? 'LIVE FEED CONNECTED' : 'FEED DISCONNECTED'}</span>
        </div>
      </header>

      <div style={{ display: 'grid', gridTemplateColumns: 'minmax(0, 1fr) 350px', gap: '24px' }}>
        <main>
          {/* Main Chart Card */}
          <div className="glass-card">
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
              <div>
                <h2 style={{ fontSize: '24px' }}>{selectedTicker}</h2>
                <p style={{ fontSize: '32px', fontWeight: 'bold', color: 'white', marginTop: '4px' }}>
                  {livePrice.toLocaleString(undefined, {minimumFractionDigits: 2})}
                </p>
              </div>
              <div style={{ display: 'flex', gap: '8px' }}>
                <span className="badge badge-success">Live from Market</span>
              </div>
            </div>
            
            <Chart symbol={selectedTicker} />
          </div>

          {/* AI Prediction Injection */}
          <PredictionWidget symbol={selectedTicker} />
        </main>

        <aside>
          {/* Watchlist */}
          <div className="glass-card" style={{ padding: '0', overflow: 'hidden' }}>
            <h3 style={{ padding: '20px 24px 10px 24px' }}>Watchlist</h3>
            <ul style={{ listStyle: 'none' }}>
              {watchlist.map(item => {
                const itemPrice = wsData && wsData[item.symbol] ? wsData[item.symbol] : 0;
                return (
                  <li 
                    key={item.symbol}
                    onClick={() => setSelectedTicker(item.symbol)}
                    style={{ 
                      padding: '16px 24px', 
                      borderBottom: '1px solid var(--glass-border)', 
                      display: 'flex', 
                      justifyContent: 'space-between',
                      cursor: 'pointer',
                      background: selectedTicker === item.symbol ? 'rgba(255,255,255,0.05)' : 'transparent',
                      transition: 'background 0.2s',
                    }}
                  >
                    <div>
                      <div style={{ fontWeight: 'bold' }}>{item.symbol}</div>
                      <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>{item.name}</div>
                    </div>
                    {itemPrice > 0 ? (
                      <span style={{ color: 'var(--text-main)', fontWeight: 'bold' }}>{itemPrice.toFixed(2)}</span>
                    ) : (
                      <span style={{ color: 'var(--text-muted)' }}>Loading...</span>
                    )}
                  </li>
                );
              })}
            </ul>
          </div>

          {/* Execution Panel */}
          <OrderPanel symbol={selectedTicker} currentPrice={livePrice} />
        </aside>
      </div>
    </div>
  );
};

export default Dashboard;
