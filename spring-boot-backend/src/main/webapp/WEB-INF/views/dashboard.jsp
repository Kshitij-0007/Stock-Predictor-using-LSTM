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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                <a class="nav-link" href="https://example.com/settings">
                    <i class="fa-solid fa-sliders"></i> System Config
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
                                    <select id="symbolInput" class="form-select bg-dark border-secondary border-start-0 text-white" style="cursor: pointer;" onchange="getPrediction()">
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

    <script>
        // Safety checks for session
        const token = localStorage.getItem('token');
        if (!token) window.location.href = '/views/login';

        let userData = { fullName: 'Trader' };
        try {
            const storedUser = localStorage.getItem('user');
            if (storedUser) userData = JSON.parse(storedUser);
        } catch (e) { console.error("Session data corruption:", e); }

        document.getElementById('userName').textContent = (userData.fullName || 'Trader').split(' ')[0];
        document.getElementById('currentDate').textContent = new Date().toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

        setInterval(() => {
            const rTime = document.getElementById('realTime');
            if (rTime) rTime.textContent = new Date().toLocaleTimeString('en-GB');
        }, 1000);

        let chartInstance = null;

        function initMainChart() {
            const ctx = document.getElementById('mainChartCanvas');
            if (!ctx) return;

            if (chartInstance) {
                chartInstance.destroy();
            }

            const gradient = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, 'rgba(56, 189, 248, 0.4)');
            gradient.addColorStop(1, 'rgba(56, 189, 248, 0)');

            chartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: [],
                    datasets: [{
                        label: 'Market Price',
                        data: [],
                        borderColor: '#38bdf8',
                        backgroundColor: gradient,
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointRadius: 0,
                        pointHoverRadius: 6,
                        pointHoverBackgroundColor: '#38bdf8',
                        pointHoverBorderColor: '#020617',
                        pointHoverBorderWidth: 3
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                            backgroundColor: 'rgba(15, 23, 42, 0.9)',
                            titleFont: { size: 14, weight: 'bold' },
                            bodyFont: { size: 13 },
                            padding: 12,
                            borderColor: 'rgba(255, 255, 255, 0.1)',
                            borderWidth: 1
                        }
                    },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: { color: '#94a3b8', maxRotation: 0, autoSkip: true, maxTicksLimit: 10 }
                        },
                        y: {
                            grid: { color: 'rgba(255, 255, 255, 0.05)' },
                            ticks: { color: '#94a3b8', callback: v => '$' + v.toLocaleString() }
                        }
                    },
                    interaction: { mode: 'nearest', axis: 'x', intersect: false }
                }
            });
        }

        async function apiFetch(url, options = {}) {
            const controller = new AbortController();
            const id = setTimeout(() => controller.abort(), 10000); // 10s timeout

            options.headers = {
                ...options.headers,
                'Authorization': 'Bearer ' + token,
                'Content-Type': 'application/json'
            };
            options.signal = controller.signal;

            try {
                const res = await fetch(url, options);
                clearTimeout(id);
                if (res.status === 401) logout();
                if (!res.ok) throw new Error('Network response: ' + res.status);
                return res.json();
            } catch (err) {
                clearTimeout(id);
                throw err;
            }
        }

        function switchSection(id) {
            document.querySelectorAll('.nav-link').forEach(l => {
                l.classList.remove('active');
                if (l.dataset.section === id) l.classList.add('active');
            });

            const current = document.querySelector('.dashboard-section.active');
            const target = document.getElementById('section-' + id);

            if (typeof gsap !== 'undefined') {
                gsap.to(current, { opacity: 0, scale: 0.98, duration: 0.2, onComplete: () => {
                    current.classList.remove('active');
                    target.classList.add('active');
                    gsap.fromTo(target, { opacity: 0, scale: 1.02 }, { opacity: 1, scale: 1, duration: 0.3 });
                    if (id === 'overview' && activeChart) activeChart.applyOptions({ width: document.getElementById('chartContainer').clientWidth });
                }});
            } else {
                current.classList.remove('active');
                target.classList.add('active');
            }
        }

        async function loadGlobalData() {
            try {
                const portfolio = await apiFetch('/api/portfolio/');
                if (portfolio && document.getElementById('balanceValue')) {
                    document.getElementById('balanceValue').textContent = '$' + (portfolio.balance || 0).toLocaleString(undefined, {minimumFractionDigits: 2});
                    
                    let totalInvested = 0;
                    (portfolio.holdings || []).forEach(h => totalInvested += (h.quantity * (h.currentPrice || 0)));
                    document.getElementById('investmentValue').textContent = '$' + totalInvested.toLocaleString(undefined, {minimumFractionDigits: 2});
                    
                    if (portfolio.pnl !== undefined) {
                        const pnlEl = document.querySelector('#balanceValue + .stat-trend');
                        if (pnlEl) {
                            const isPos = portfolio.pnl >= 0;
                            pnlEl.className = 'stat-trend ' + (isPos ? 'text-success' : 'text-danger') + ' mt-2';
                            pnlEl.innerHTML = '<i class="fa-solid fa-caret-' + (isPos ? 'up' : 'down') + '"></i> ' + 
                                (isPos ? '+' : '') + portfolio.pnl.toLocaleString(undefined, {minimumFractionDigits: 2}) + ' P&L';
                        }
                    }

                    document.getElementById('portfolioFullList').innerHTML = (portfolio.holdings || []).map(h => 
                        '<div class="glass-card mb-3 d-flex justify-content-between align-items-center">' +
                            '<div class="d-flex align-items-center gap-4">' +
                                '<div class="p-3 bg-secondary bg-opacity-25 rounded-circle"><i class="fa-solid fa-chart-pie text-info"></i></div>' +
                                '<div>' +
                                    '<h5 class="mb-0 fw-bold">' + h.symbol + '</h5>' +
                                    '<small class="text-muted">' + h.quantity + ' CONTRACTS HELD</small>' +
                                '</div>' +
                            '</div>' +
                            '<div class="text-end">' +
                                '<div class="h5 mb-0 fw-bold">$' + (h.quantity * h.currentPrice).toFixed(2) + '</div>' +
                                '<div class="text-success small">+2.05%</div>' +
                            '</div>' +
                        '</div>'
                    ).join('') || '<div class="text-center py-5 text-muted">Awaiting network entry...</div>';
                }

                const trades = await apiFetch('/api/trading/history');
                if (Array.isArray(trades)) {
                    document.getElementById('tradeHistoryOverview').innerHTML = trades.slice(0, 8).map(t => 
                        '<tr>' +
                            '<td class="fw-bold">' + t.symbol + '</td>' +
                            '<td><span class="badge ' + (t.action === 'buy' ? 'bg-success' : 'bg-danger') + ' bg-opacity-10 text-' + (t.action === 'buy' ? 'success' : 'danger') + ' px-3">' + t.action.toUpperCase() + '</span></td>' +
                            '<td>' + t.quantity + ' Units</td>' +
                            '<td>$' + (t.price || 0).toFixed(2) + '</td>' +
                            '<td><span class="text-success"><i class="fa-solid fa-square-check me-1"></i> VERIFIED</span></td>' +
                        '</tr>'
                    ).join('');

                    document.getElementById('fullTradeHistoryList').innerHTML = trades.map(t => 
                        '<tr>' +
                            '<td class="text-muted smaller">Today</td>' +
                            '<td class="fw-bold">' + t.symbol + '</td>' +
                            '<td>' + t.action.toUpperCase() + '</td>' +
                            '<td>' + t.quantity + '</td>' +
                            '<td>$' + (t.price || 0).toFixed(2) + '</td>' +
                            '<td class="text-success">+$45.20</td>' +
                        '</tr>'
                    ).join('');
                }
            } catch (err) { console.warn("Background data fetch incomplete", err); }
        }

        async function getPrediction() {
            const symSelect = document.getElementById('stockSymbol');
            if (!symSelect) return;
            const symbol = symSelect.value;
            const resDiv = document.getElementById('predictionResult');
            
            resDiv.innerHTML = '<div class="text-center p-4">' +
                '<div class="spinner-border text-info mb-3" style="width: 3rem; height: 3rem;"></div>' +
                '<h5 class="text-info animate-pulse" id="loadingText">Syncing Neural Networks...</h5>' +
                '<p class="text-muted small">Decoding market patterns...</p></div>';

            const messages = ["Analyzing Volume Peaks...", "Mapping Resistance...", "Processing LSTM Layers...", "Fetching Market Reality..."];
            let msgIdx = 0;
            const msgInterval = setInterval(() => {
                const el = document.getElementById('loadingText');
                if (el) el.innerText = messages[msgIdx++ % messages.length];
            }, 2500);

            try {
                const data = await apiFetch('/api/predictions/predict/' + symbol);
                clearInterval(msgInterval);
                
                if (data.error && !data.simulation) {
                    resDiv.innerHTML = '<div class="alert alert-danger mx-2 mt-4"><i class="fas fa-exclamation-circle mr-2"></i> ' + data.error + '</div>';
                } else {
                    const color = data.predictionAction === 1 ? '#10b981' : '#ef4444';
                    const actionText = data.predictionAction === 1 ? 'BULLISH ASCENSION' : 'BEARISH CORRECTION';
                    const icon = data.predictionAction === 1 ? 'fa-arrow-trend-up' : 'fa-arrow-trend-down';
                    
                    resDiv.innerHTML = 
                        '<div class="p-4 animate-in">' +
                            '<div class="d-flex justify-content-between align-items-center mb-4">' +
                                    '<div class="text-muted smaller">CURRENT</div>' +
                                    '<div class="h4 fw-bold">$' + data.currentPrice.toFixed(2) + '</div>' +
                                '</div>' +
                                '<div class="col-6">' +
                                    '<div class="text-muted smaller">FORECAST</div>' +
                                    '<div class="h4 fw-bold" style="color: ' + color + '">$' + data.predictedPrice.toFixed(2) + '</div>' +
                                '</div>' +
                            '</div>' +
                            '<hr class="opacity-10">' +
                            '<div class="d-flex justify-content-between align-items-center mt-4">' +
                                '<div>' +
                                    '<div class="text-muted smaller">VOLATILITY SCORE</div>' +
                                    '<div class="fw-bold">LOW</div>' +
                                '</div>' +
                                '<button class="btn btn-modern btn-primary-modern" onclick="buyStock(\'' + symbol + '\', ' + data.currentPrice + ')">' +
                                    'DEPLOY ORDER' +
                                '</button>' +
                            '</div>' +
                        '</div>';

                    if (data.history && chartInstance) {
                        const labels = Array.isArray(data.history.labels) ? data.history.labels : [];
                        const values = Array.isArray(data.history.values) ? data.history.values : [];
                        
                        chartInstance.data.labels = labels;
                        chartInstance.data.datasets[0].data = values;
                        chartInstance.data.datasets[0].borderColor = color;
                        
                        // Status Badge
                        const statusBadge = document.querySelector('.badge.bg-secondary') || document.querySelector('.badge.bg-warning') || document.querySelector('.badge.bg-success');
                        if (statusBadge) {
                            const isSim = !!data.simulation;
                            statusBadge.className = isSim ? 'badge bg-warning text-dark' : 'badge bg-success';
                            statusBadge.textContent = isSim ? 'NEURAL SIMULATION ACTIVE' : 'LIVE MARKET REALITY';
                        }

                        const ctx = document.getElementById('mainChartCanvas').getContext('2d');
                        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
                        gradient.addColorStop(0, color + '66');
                        gradient.addColorStop(1, color + '00');
                        chartInstance.data.datasets[0].backgroundColor = gradient;
                        
                        chartInstance.update('none'); // Update without animation for instant visibility
                        chartInstance.resize();
                        
                        // Update Confidence Stat
                        const confVal = (data.confidenceMetric * 100).toFixed(1);
                        document.getElementById('confidenceStatsValue').textContent = confVal + '%';
                        console.log("Visualizer Synchronized for " + symbol + " (Sim: " + !!data.simulation + ")");
                    }
                }
            } catch (err) {
                const msg = err.name === 'AbortError' ? 'Neural Link Timed Out' : err.message;
                resDiv.innerHTML = '<div class="alert alert-danger mx-2 mt-4 text-center">' +
                    '<i class="fa-solid fa-triangle-exclamation fa-2x mb-3"></i><br><b>' + msg + '</b><br>' +
                    '<p class="small text-muted mt-2">Ensure the Python Neural Bridge is running on Port 5000.</p>' +
                    '<button class="btn btn-sm btn-info mt-2 rounded-pill px-4" onclick="getPrediction()">Retry Neural Sync</button></div>';
            }
        }

        // Auto-run on Startup
        document.addEventListener('DOMContentLoaded', () => {
            initChart();
            // Trigger first prediction after a short delay
            setTimeout(getPrediction, 500);
        });

        async function buyStock(symbol, price) {
            const qty = prompt('Trade Execution: ' + symbol + ' \nPrice: $' + price.toFixed(2) + ' \n\nEnter Exposure Units:', "10");
            if (!qty) return;

            try {
                const res = await apiFetch('/api/trading/', {
                    method: 'POST',
                    body: JSON.stringify({ symbol, action: 'buy', quantity: parseInt(qty), price })
                });
                if (res.error) alert("REJECTED: " + res.error);
                else {
                    alert('ORDER EXECUTED IN NEURAL NETWORK');
                    loadGlobalData();
                }
            } catch (err) { alert('NETWORK TIMEOUT'); }
        }

        function logout() {
            localStorage.removeItem('token');
            localStorage.removeItem('user');
            window.location.href = '/views/login';
        }

        // Boot
        window.addEventListener('DOMContentLoaded', () => {
            initMainChart();
            loadGlobalData();
            
            const hideOverlay = () => {
                const loader = document.getElementById('globalLoader');
                if (!loader) return;
                
                try {
                    if (typeof gsap !== 'undefined') {
                        gsap.to(loader, { opacity: 0, duration: 0.5, onComplete: () => {
                            loader.style.display = 'none';
                            // Ensure chart is ready once visible
                            if (chartInstance) {
                                chartInstance.resize();
                            }
                            getPrediction();
                            gsap.from('.nav-item', { x: -30, opacity: 0, stagger: 0.05, duration: 0.4 });
                        }});
                    } else {
                        loader.style.display = 'none';
                        getPrediction();
                    }
                } catch (e) {
                    console.warn("GSAP/Animation error, forcing visibility", e);
                    loader.style.display = 'none';
                    getPrediction();
                }
            };

            // Force hide loader after 1.5 seconds regardless of state
            setTimeout(hideOverlay, 1500);
            
            // Backup fail-safe for the user (after 5s)
            setTimeout(() => {
                const loader = document.getElementById('globalLoader');
                if (loader && loader.style.display !== 'none') {
                    loader.style.display = 'none';
                }
            }, 5000);
        });
    </script>
</body>
</html>
