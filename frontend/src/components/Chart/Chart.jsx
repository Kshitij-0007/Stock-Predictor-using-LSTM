import React, { useEffect, useRef } from 'react';
import { createChart, ColorType, CandlestickSeries } from 'lightweight-charts';

const Chart = ({ data = [], symbol = "Stock" }) => {
  const chartContainerRef = useRef();
  const chartRef = useRef();
  const seriesRef = useRef();

  useEffect(() => {
    // 1. Setup Chart
    const handleResize = () => {
      chartRef.current.applyOptions({ width: chartContainerRef.current.clientWidth });
    };

    chartRef.current = createChart(chartContainerRef.current, {
      layout: {
        background: { type: ColorType.Solid, color: 'transparent' },
        textColor: '#d1d5db',
      },
      grid: {
        vertLines: { color: 'rgba(255, 255, 255, 0.1)' },
        horzLines: { color: 'rgba(255, 255, 255, 0.1)' },
      },
      width: chartContainerRef.current.clientWidth,
      height: 400,
      timeScale: {
        timeVisible: true,
        secondsVisible: false,
      },
    });

    seriesRef.current = chartRef.current.addSeries(CandlestickSeries, {
      upColor: '#10b981',
      downColor: '#ef4444',
      borderVisible: false,
      wickUpColor: '#10b981',
      wickDownColor: '#ef4444',
    });

    // 2. Mock historic chart data based on live ticker if array is empty
    if (data.length === 0) {
      const mockHistorical = [];
      let currentPrice = 18000;
      let time = Math.floor(Date.now() / 1000) - (86400 * 30); // 30 days ago
      
      for(let i=0; i<30; i++) {
        const volatility = (Math.random() - 0.5) * 500;
        const open = currentPrice;
        const close = currentPrice + volatility;
        const high = Math.max(open, close) + Math.random() * 100;
        const low = Math.min(open, close) - Math.random() * 100;
        
        mockHistorical.push({ time: time + (i * 86400), open, high, low, close });
        currentPrice = close;
      }
      seriesRef.current.setData(mockHistorical);
    }

    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
      chartRef.current.remove();
    };
  }, []);

  return (
    <div style={{ position: 'relative', width: '100%' }}>
      <h3 style={{ position: 'absolute', top: '10px', left: '10px', zIndex: 10 }}>{symbol} Live</h3>
      <div ref={chartContainerRef} style={{ width: '100%', height: '400px' }} />
    </div>
  );
};

export default Chart;
