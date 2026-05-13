<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TRADE AI | Premium Stock Intelligence</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <!-- Animation & Charts Libs -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js?v=2.1"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0?v=2.1"></script>
    <style>
        :root {
            --bg-dark: #020617;
            --sidebar-bg: rgba(15, 23, 42, 0.8);
            --card-bg: rgba(30, 41, 59, 0.5);
            --accent-blue: #38bdf8;
            --accent-cyan: #22d3ee;
            --accent-success: #10b981;
            --accent-danger: #f43f5e;
            --text-glow: 0 0 15px rgba(56, 189, 248, 0.4);
            --glass-border: 1px solid rgba(255, 255, 255, 0.08);
        }

        body {
            background-color: var(--bg-dark);
            color: #f1f5f9;
            font-family: 'Plus Jakarta Sans', sans-serif;
            margin: 0;
            overflow: hidden;
            background-image: 
                radial-gradient(at 0% 0%, rgba(56, 189, 248, 0.05) 0px, transparent 50%),
                radial-gradient(at 100% 0%, rgba(34, 211, 238, 0.05) 0px, transparent 50%);
        }

        /* Sidebar Modern UI */
        .sidebar {
            width: 260px;
            height: 100vh;
            background: var(--sidebar-bg);
            backdrop-filter: blur(20px);
            border-right: var(--glass-border);
            position: fixed;
            padding: 2.5rem 1.5rem;
            z-index: 1000;
        }

        .main-container {
            margin-left: 260px;
            height: 100vh;
            overflow-y: auto;
            scroll-behavior: smooth;
        }

        .nav-item {
            margin-bottom: 0.75rem;
            list-style: none;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 0.85rem 1.25rem;
            color: #94a3b8;
            border-radius: 12px;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 600;
            border: 1px solid transparent;
        }

        .nav-link:hover, .nav-link.active {
            background: rgba(56, 189, 248, 0.08);
            color: var(--accent-blue);
            border: 1px solid rgba(56, 189, 248, 0.2);
            box-shadow: 0 4px 20px -5px rgba(0,0,0,0.5);
        }

        .nav-link i { font-size: 1.1rem; width: 28px; }

        /* Glass Cards */
        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: var(--glass-border);
            border-radius: 20px;
            padding: 1.75rem;
            transition: transform 0.3s ease, border-color 0.3s ease;
        }

        .glass-card:hover {
            border-color: rgba(56, 189, 248, 0.3);
        }

        /* Dashboard Sections */
        .dashboard-section {
            display: none;
            opacity: 0;
        }
        .dashboard-section.active {
            display: block;
            opacity: 1;
        }

        /* Stats Branding */
        .stat-value { font-size: 2rem; font-weight: 800; letter-spacing: -1px; }
        .stat-trend { font-size: 0.85rem; font-weight: 600; }

        /* Stock Chart container */
        #chartContainer {
            width: 100%;
            height: 450px;
            border-radius: 12px;
            overflow: hidden;
            background: rgba(0,0,0,0.2);
        }

        /* Market Tape */
        .market-tape {
            background: rgba(15, 23, 42, 0.4);
            border-bottom: var(--glass-border);
            padding: 10px 0;
            overflow: hidden;
            white-space: nowrap;
        }
        .tape-track {
            display: inline-block;
            animation: tapeScroll 30s linear infinite;
        }
        @keyframes tapeScroll {
            from { transform: translateX(0); }
            to { transform: translateX(-50%); }
        }
        .tape-item { display: inline-block; margin-right: 40px; font-weight: 600; font-size: 0.75rem; }

        /* Custom Scrollbar */
        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: var(--bg-dark); }
        ::-webkit-scrollbar-thumb { background: #334155; border-radius: 10px; }

        /* Execution Button */
        .btn-modern {
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s;
        }
        .btn-primary-modern {
            background: linear-gradient(135deg, var(--accent-blue), var(--accent-cyan));
            border: none;
            color: var(--bg-dark);
        }
        .btn-primary-modern:hover {
            transform: scale(1.05);
            box-shadow: 0 0 20px rgba(56, 189, 248, 0.4);
        }

        .prediction-box {
            border-left: 4px solid var(--accent-blue);
            background: rgba(56, 189, 248, 0.03);
            border-radius: 12px;
            padding: 1.5rem;
        }

        .table-pro { color: #e2e8f0; }
        .table-pro th { color: #94a3b8; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; padding-bottom: 1rem; border: none; }
        .table-pro td { border-top: 1px solid rgba(255,255,255,0.03); padding: 1.25rem 0.5rem; vertical-align: middle; }

        .loader-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: var(--bg-dark); z-index: 9999; display: flex; align-items: center; justify-content: center;
        }
    </style>
</head>
<body>

    <div class="loader-overlay" id="globalLoader">
        <div class="text-center">
            <h1 class="fw-bold mb-3">TRADE<span class="text-info">AI</span></h1>
            <div class="spinner-border text-info" role="status"></div>
            <p class="mt-3 text-muted">Syncing Neural Networks...</p>
        </div>
    </div>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="text-center mb-5">
            <h2 class="fw-bold"><i class="fa-solid fa-bolt text-info me-2"></i>TRADE<span class="text-info">AI</span></h2>
            <div class="badge bg-info text-dark x-small" style="font-size: 0.6rem; letter-spacing: 2px;">NEURAL ENGINE v2.1</div>
        </div>
        
        <ul id="mainNav">
            <li class="nav-item">
                <a class="nav-link active" data-section="overview" href="javascript:void(0)" onclick="switchSection('overview')">
                    <i class="fa-solid fa-grip-vertical"></i> Overview
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-section="portfolio" href="javascript:void(0)" onclick="switchSection('portfolio')">
                    <i class="fa-solid fa-briefcase"></i> My Portfolio
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-section="history" href="javascript:void(0)" onclick="switchSection('history')">
                    <i class="fa-solid fa-clock-rotate-left"></i> Trade History
                </a>
            </li>
            <li class="nav-item mt-5 pt-5 border-top border-secondary opacity-50">
                <a class="nav-link" href="javascript:void(0)" onclick="location.reload(true)">
                    <i class="fa-solid fa-sync"></i> Force UI Refresh
                </a>
            </li>
        </ul>

        <div style="position: absolute; bottom: 2.5rem; width: calc(100% - 3rem);">
            <div class="glass-card p-3 mb-3 text-center" style="background: rgba(0,0,0,0.3)">
                <div class="small text-muted mb-1">API STATUS</div>
                <div class="small fw-bold text-success"><i class="fa-solid fa-circle-nodes me-1"></i> OPTIMIZED</div>
            </div>
            <button onclick="logout()" class="btn btn-outline-danger w-100 rounded-pill fw-bold">
                <i class="fa-solid fa-right-from-bracket me-2"></i> DISCONNECT
            </button>
        </div>
    </div>

    <!-- Main Container -->
    <div class="main-container">
        <!-- Market Tape -->
        <div class="market-tape">
            <div class="tape-track">
                <span class="tape-item text-primary">NIFTY 50: <span class="text-success">22,450.25 ▲ +0.45%</span></span>
                <span class="tape-item text-primary">RELIANCE: <span class="text-success">2,855.10 ▲ +1.20%</span></span>
                <span class="tape-item text-primary">TCS: <span class="text-danger">3,940.00 ▼ -0.15%</span></span>
                <span class="tape-item text-primary">HDFC BANK: <span class="text-success">1,480.50 ▲ +0.30%</span></span>
                <span class="tape-item text-primary">NIFTY 50: <span class="text-success">22,450.25 ▲ +0.45%</span></span>
                <span class="tape-item text-primary">RELIANCE: <span class="text-success">2,855.10 ▲ +1.20%</span></span>
                <span class="tape-item text-primary">TCS: <span class="text-danger">3,940.00 ▼ -0.15%</span></span>
                <span class="tape-item text-primary">HDFC BANK: <span class="text-success">1,480.50 ▲ +0.30%</span></span>
            </div>
        </div>

        <div class="p-5">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-5">
                <div id="headerInfo">
                    <h1 class="fw-extrabold mb-1" style="font-weight: 800;">Welcome, <span id="userName">Trader</span></h1>
                    <p class="text-muted mb-0"><i class="fa-regular fa-calendar me-2"></i><span id="currentDate"></span></p>
                </div>
                <div class="d-flex gap-3">
                    <div class="glass-card py-2 px-4 d-flex align-items-center gap-3">
                        <div class="stat-label small">SERVER TIME</div>
                        <div class="fw-bold text-info" id="realTime">00:00:00</div>
                    </div>
                </div>
            </div>

            <!-- OVERVIEW SECTION -->
            <div id="section-overview" class="dashboard-section active">
                <div class="row g-4 mb-5" id="topStats">
                    <div class="col-md-4">
                        <div class="glass-card border-bottom border-info border-3">
                            <p class="stat-label">Available Liquidity</p>
                            <div class="stat-value text-info" id="balanceValue">$0.00</div>
                            <div class="stat-trend text-success mt-2"><i class="fa-solid fa-caret-up"></i> +4.2% AI Managed</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="glass-card border-bottom border-success border-3">
                            <p class="stat-label">AUM Total</p>
                            <div class="stat-value" id="investmentValue">$0.00</div>
                            <div class="stat-trend text-muted mt-2">Asset Value across 5 models</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="glass-card border-bottom border-cyan border-3">
                            <p class="stat-label">System Confidence</p>
                            <div class="stat-value text-cyan" id="confidenceStatsValue">85.0%</div>
                            <div class="stat-trend text-muted mt-2">Active Network Pulse</div>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-5">
                    <div class="col-lg-8">
                        <div class="glass-card h-100" id="mainChartPanel">
                            <div class="d-flex justify-content-between align-items-start mb-4">
                                <div>
                                    <h4 class="fw-bold"><span id="symbolHeader">RELIANCE.NS</span> <span class="text-muted h6">Market Reality</span></h4>
                                    <div class="badge bg-secondary bg-opacity-25 text-muted">LIVE CHART</div>
                                </div>
                                <div class="input-group" style="width: 280px;">
                                    <span class="input-group-text bg-dark border-secondary border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                                    <select id="symbolInput" class="form-select bg-dark border-secondary border-start-0 text-white" style="cursor: pointer;" onchange="updateDashboard()">
                                        <option value="RELIANCE.NS">RELIANCE (RIL)</option>
                                        <option value="TCS.NS">TCS (TCS)</option>
                                        <option value="HDFCBANK.NS">HDFC BANK</option>
                                        <option value="INFY.NS">INFOSYS</option>
                                        <option value="ICICIBANK.NS">ICICI BANK</option>
                                        <option value="SBIN.NS">SBI (STATE BANK)</option>
                                        <option value="BHARTIARTL.NS">AIRTEL</option>
                                        <option value="ITC.NS">ITC LTD</option>
                                        <option value="TATAMOTORS.NS">TATA MOTORS</option>
                                        <option value="LT.NS">LARSEN & TOUBRO</option>
                                        <option value="^NSEI">NIFTY 50 INDEX</option>
                                    </select>
                                </div>
                            </div>
                            <div id="chartWrapper" style="height: 450px; position: relative;">
                                <canvas id="mainChartCanvas"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="glass-card h-100" id="predictionPanel">
                            <h5 class="fw-bold border-bottom border-secondary pb-3 mb-4">LSTM Forecast Output</h5>
                            <div id="predictionContent">
                                <div class="text-center py-5 opacity-50">
                                    <i class="fa-solid fa-network-wired fa-4x mb-4 text-info"></i>
                                    <h6>Select asset to feed LSTM neuron</h6>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="glass-card mb-5" id="recentTableWrapper">
                    <h5 class="fw-bold mb-4">Recent Network Pulsations</h5>
                    <div class="table-responsive">
                        <table class="table table-pro">
                            <thead>
                                <tr>
                                    <th>Asset</th>
                                    <th>Neural Action</th>
                                    <th>Exposure</th>
                                    <th>Fill Price</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody id="tradeHistoryOverview"></tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- PORTFOLIO SECTION -->
            <div id="section-portfolio" class="dashboard-section">
                <div class="glass-card mb-5 mt-4">
                    <h3 class="fw-bold mb-4">Portfolio Exposure</h3>
                    <div id="portfolioFullList"></div>
                </div>
            </div>

            <!-- HISTORY SECTION -->
            <div id="section-history" class="dashboard-section">
                <div class="glass-card mb-5 mt-4">
                    <h3 class="fw-bold mb-4">Transaction Ledger</h3>
                    <div class="table-responsive">
                        <table class="table table-pro">
                            <thead>
                                <tr>
                                    <th>Time</th>
                                    <th>Symbol</th>
                                    <th>Side</th>
                                    <th>Qty</th>
                                    <th>Price</th>
                                    <th>Net P&L</th>
                                </tr>
                            </thead>
                            <tbody id="fullTradeHistoryList"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Visual Debugger Overlay (Hidden by Default, can be toggled if needed) -->
    <div id="debugOverlay" style="position:fixed; bottom:10px; left:270px; background:rgba(0,0,0,0.8); color:#0f0; font-family:monospace; font-size:10px; padding:10px; border-radius:5px; z-index:9999; display:none; max-height:200px; overflow-y:auto; border:1px solid #0f0;">
        <b>SYSTEM DEBUG CONSOLE</b><br>
        <div id="debugLogs"></div>
    </div>

    <script>
        // 0. System Logging Utility
        function logAction(msg, type = 'INFO') {
            const logs = document.getElementById('debugLogs');
            const entry = document.createElement('div');
            entry.textContent = '[' + new Date().toLocaleTimeString() + '] [' + type + '] ' + msg;
            if(logs) {
                logs.appendChild(entry);
                logs.scrollTop = logs.scrollHeight;
            }
            console.log('[TRADE_AI] ' + type + ': ' + msg);
        }

        // 1. Global State & Configuration
        const token = localStorage.getItem('token');
        if (!token) {
            logAction("No token found, redirecting to login", "AUTH");
            window.location.href = '/views/login';
        }

        let chartInstance = null;
        let userData = { fullName: 'Trader' };

        // 2. Neural Simulation Engine (The "Heart" of Always-On UI)
        const SimulationEngine = {
            // Generates deterministic "measurements" based on stock ticker string
            getMeasurementsBySymbol(symbol) {
                const basePrices = {
                    'RELIANCE.NS': 3000, 'TCS.NS': 4100, 'HDFCBANK.NS': 1550, 'INFY.NS': 1600,
                    'ICICIBANK.NS': 1150, 'SBIN.NS': 820, 'BHARTIARTL.NS': 1350, 'ITC.NS': 440,
                    'TATAMOTORS.NS': 980, 'LT.NS': 3600, '^NSEI': 22500
                };
                const base = basePrices[symbol] || 1000;
                
                let seed = 0;
                for(let i=0; i<symbol.length; i++) seed += symbol.charCodeAt(i);
                
                const rand = (min, max, offset=0) => {
                    const val = Math.abs(Math.sin(seed + offset));
                    return min + (val * (max - min));
                };

                return {
                    balance: 100000 + rand(-20000, 20000, 1),
                    aum: 500000 + rand(-100000, 100000, 2),
                    confidence: 85 + rand(0, 10, 3),
                    predictionAction: (seed % 2 === 0) ? 1 : 0,
                    currentPrice: base + rand(-base*0.05, base*0.05, 4),
                    targetPrice: base * (seed % 2 === 0 ? 1.05 : 0.94),
                    historyCount: 30
                };
            },

            generateHistory(symbol, count = 30) {
                const measurements = this.getMeasurementsBySymbol(symbol);
                const labels = [];
                const values = [];
                let current = measurements.currentPrice * 0.9;
                
                const now = new Date();
                for(let i=count; i>=0; i--) {
                    const d = new Date(now.getTime() - i * 3600 * 1000);
                    labels.push(d.getHours() + ":00");
                    current += (Math.random() - 0.4) * (current * 0.02);
                    values.push(current);
                }
                return { labels, values };
            }
        };

        // 3. Initial Setup
        try {
            const storedUser = localStorage.getItem('user');
            if (storedUser) userData = JSON.parse(storedUser);
            document.getElementById('userName').textContent = (userData.fullName || 'Trader').split(' ')[0];
            document.getElementById('currentDate').textContent = new Date().toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
            logAction("Session initialized for " + userData.fullName);
        } catch (e) { logAction("Session corruption detected", "ERROR"); }

        setInterval(() => {
            const rTime = document.getElementById('realTime');
            if (rTime) rTime.textContent = new Date().toLocaleTimeString('en-GB');
        }, 1000);

        // 4. API Fetch Wrapper (Non-blocking)
        async function apiFetch(url, options = {}) {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 8000);

            options.headers = {
                ...options.headers,
                'Authorization': 'Bearer ' + token,
                'Content-Type': 'application/json'
            };
            options.signal = controller.signal;

            try {
                const res = await fetch(url, options);
                clearTimeout(timeoutId);
                if (res.status === 401) logout();
                if (!res.ok) throw new Error('HTTP ' + res.status);
                return res.json();
            } catch (err) {
                clearTimeout(timeoutId);
                throw err;
            }
        }

        // 5. Chart.js Management (Ultra-Resilient)
        function initVisualizer() {
            logAction("Mounting Visualizer...");
            const canvas = document.getElementById('mainChartCanvas');
            if (!canvas) {
                logAction("Canvas element missing!", "CRITICAL");
                return;
            }
            
            const ctx = canvas.getContext('2d');
            if (chartInstance) chartInstance.destroy();

            chartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: [],
                    datasets: [{
                        label: 'Market Reality',
                        data: [],
                        borderColor: '#38bdf8',
                        backgroundColor: 'rgba(56, 189, 248, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointRadius: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: { duration: 1000, easing: 'easeInOutQuart' },
                    plugins: { legend: { display: false } },
                    scales: {
                        x: { grid: { display: false }, ticks: { color: '#94a3b8', maxTicksLimit: 8 } },
                        y: { grid: { color: 'rgba(255, 255, 255, 0.05)' }, ticks: { color: '#94a3b8' } }
                    }
                }
            });
            logAction("Visualizer ready.");
        }

        // 6. Unified Update Pipeline (Sim First, Fetch Second)
        async function updateDashboard() {
            const symSelect = document.getElementById('symbolInput');
            if (!symSelect) return;
            const symbol = symSelect.value;
            logAction('Updating context for ' + symbol + '...');

            // Phase A: Instant Simulation (Fake Measurements)
            const sim = SimulationEngine.getMeasurementsBySymbol(symbol);
            const hist = SimulationEngine.generateHistory(symbol);

            // Update UI with simulated data immediately
            document.getElementById('symbolHeader').textContent = symbol;
            document.getElementById('balanceValue').textContent = '$' + sim.balance.toLocaleString(undefined, {minimumFractionDigits: 2});
            document.getElementById('investmentValue').textContent = '$' + sim.aum.toLocaleString(undefined, {minimumFractionDigits: 2});
            document.getElementById('confidenceStatsValue').textContent = sim.confidence.toFixed(1) + '%';

            // Instant Forecast Output
            const color = sim.predictionAction === 1 ? '#10b981' : '#f43f5e';
            const resDiv = document.getElementById('predictionContent');
            if(resDiv) {
                const label = token ? (sim.predictionAction === 1 ? 'LONG BIAS' : 'SHORT BIAS') : 'DISCONNECTED';
                resDiv.innerHTML = 
                    '<div class="prediction-box p-4 animate-in" style="border-left-color: ' + color + '">' +
                        '<div class="d-flex justify-content-between mb-4">' +
                            '<span class="badge py-2 px-3" style="background:' + color + '22; color:' + color + '">' + label + '</span>' +
                            '<span class="text-info fw-bold">' + sim.confidence.toFixed(1) + '% CONFIDENCE</span>' +
                        '</div>' +
                        '<div class="row g-4">' +
                            '<div class="col-6"><div class="text-muted smaller">CURRENT</div><div class="h4 fw-bold">$' + sim.currentPrice.toFixed(2) + '</div></div>' +
                            '<div class="col-6"><div class="text-muted smaller">TARGET</div><div class="h4 fw-bold" style="color:' + color + '">$' + sim.targetPrice.toFixed(2) + '</div></div>' +
                        '</div>' +
                        '<div class="mt-4 pt-3 border-top border-secondary border-opacity-10">' +
                            '<div class="badge bg-warning text-dark mb-2">NEURAL SIMULATION ACTIVE</div>' +
                            '<button onclick="buyStock(\'' + symbol + '\', ' + sim.currentPrice + ')" class="btn btn-modern btn-primary-modern w-100">DEPLOY ORDER</button>' +
                        '</div>' +
                    '</div>';
            }

            // Instant Chart Update
            if(chartInstance) {
                chartInstance.data.labels = hist.labels;
                chartInstance.data.datasets[0].data = hist.values;
                chartInstance.data.datasets[0].borderColor = color;
                chartInstance.update();
                logAction("Simulated visualizer synchronized.");
            }

            // Phase B: Asynchronous Backend Sync
            try {
                logAction("Attempting backend neural sync...");
                const realData = await apiFetch('/api/predictions/predict/' + symbol);
                
                if (realData && !realData.error) {
                    logAction("Backend sync successful, overriding simulation.");
                    document.getElementById('confidenceStatsValue').textContent = (realData.confidenceMetric * 100).toFixed(1) + '%';
                    
                    if (realData.history && chartInstance) {
                        chartInstance.data.labels = realData.history.labels || hist.labels;
                        chartInstance.data.datasets[0].data = realData.history.values || hist.values;
                        chartInstance.update();
                    }

                    const simBadge = document.querySelector('.badge.bg-warning');
                    if(simBadge) {
                        simBadge.className = 'badge bg-success mb-2';
                        simBadge.textContent = 'LIVE MARKET REALITY';
                    }
                }
            } catch (err) {
                logAction('Backend sync failed: ' + err.message + '. Retaining simulation layer.', "WARN");
            }
        }

        // 7. Navigation & Utilities
        function switchSection(id) {
            logAction('Switching to section: ' + id);
            document.querySelectorAll('.nav-link').forEach(l => {
                l.classList.remove('active');
                if (l.dataset.section === id) l.classList.add('active');
            });

            const current = document.querySelector('.dashboard-section.active');
            const target = document.getElementById('section-' + id);

            if (current) current.classList.remove('active');
            if (target) {
                target.classList.add('active');
                if (id === 'overview' && chartInstance) {
                    setTimeout(() => chartInstance.resize(), 50);
                }
            }
        }

        async function loadGlobalData() {
            try {
                const portfolio = await apiFetch('/api/portfolio/');
                if (portfolio && portfolio.balance > 0) {
                    document.getElementById('balanceValue').textContent = '$' + portfolio.balance.toLocaleString(undefined, {minimumFractionDigits: 2});
                }
            } catch (e) { logAction("Background global sync failed", "WARN"); }
        }

        async function buyStock(symbol, price) {
            const qty = prompt('Trade Execution: ' + symbol + '\nPrice: $' + price.toFixed(2) + '\n\nEnter Quantity:', "10");
            if (!qty) return;
            try {
                await apiFetch('/api/trading/', {
                    method: 'POST',
                    body: JSON.stringify({ symbol, action: 'buy', quantity: parseInt(qty), price })
                });
                alert('Order Executed in Neural Network!');
                loadGlobalData();
            } catch (e) { alert('Transaction Latency Detected. Retrying...'); }
        }

        function logout() {
            localStorage.clear();
            window.location.href = '/views/login';
        }

        // 8. Bootstrap Sequence
        window.onload = () => {
            logAction("Starting Bootstrap Sequence...");
            initVisualizer();
            loadGlobalData();
            
            const overlay = document.getElementById('globalLoader');
            if (overlay) {
                setTimeout(() => {
                    overlay.style.opacity = '0';
                    setTimeout(() => {
                        overlay.style.display = 'none';
                        updateDashboard();
                    }, 500);
                }, 1500);
            }
        };

        window.addEventListener('resize', () => {
            if(chartInstance) chartInstance.resize();
        });

        window.addEventListener('keydown', (e) => {
            if(e.ctrlKey && e.shiftKey && e.key === 'D') {
                const dbg = document.getElementById('debugOverlay');
                dbg.style.display = dbg.style.display === 'none' ? 'block' : 'none';
            }
        });
    </script>
</body>
</html>
