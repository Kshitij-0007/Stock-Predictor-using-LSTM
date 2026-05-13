<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | TRADE AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <style>
        :root {
            --bg-dark: #020617;
            --card-bg: rgba(30, 41, 59, 0.4);
            --accent-blue: #38bdf8;
            --glass-border: 1px solid rgba(255, 255, 255, 0.08);
        }

        body {
            background-color: var(--bg-dark);
            color: #f8fafc;
            font-family: 'Plus Jakarta Sans', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            overflow: hidden;
            background-image: 
                radial-gradient(at 100% 100%, rgba(56, 189, 248, 0.08) 0px, transparent 50%),
                radial-gradient(at 0% 0%, rgba(34, 211, 238, 0.08) 0px, transparent 50%);
        }

        .login-card {
            background: var(--card-bg);
            backdrop-filter: blur(25px);
            border: var(--glass-border);
            border-radius: 32px;
            padding: 3.5rem;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 50px 100px -20px rgba(0, 0, 0, 0.7);
            position: relative;
            z-index: 10;
        }

        .logo { font-size: 2.25rem; font-weight: 800; text-align: center; margin-bottom: 2.5rem; letter-spacing: -1px; }
        .logo i { color: var(--accent-blue); text-shadow: 0 0 20px rgba(56, 189, 248, 0.6); }

        .form-control {
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
            padding: 1rem 1.25rem;
            border-radius: 16px;
            font-weight: 500;
        }

        .form-control:focus {
            background: rgba(15, 23, 42, 0.8);
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 4px rgba(56, 189, 248, 0.15);
            color: white;
        }

        .btn-modern {
            background: linear-gradient(135deg, var(--accent-blue), #22d3ee);
            border: none;
            padding: 1rem;
            border-radius: 16px;
            font-weight: 700;
            color: var(--bg-dark);
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s;
        }

        .btn-modern:hover {
            transform: scale(1.02);
            box-shadow: 0 0 30px rgba(56, 189, 248, 0.4);
        }

        .label-custom { color: #94a3b8; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }

        .social-btn {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 14px;
            padding: 0.75rem;
            color: white;
            transition: 0.3s;
            flex: 1;
        }
        .social-btn:hover { background: rgba(255,255,255,0.08); }

        .floating-blob {
            position: absolute; width: 300px; height: 300px;
            background: rgba(56, 189, 248, 0.1); filter: blur(80px);
            border-radius: 50%; z-index: 1;
        }
    </style>
</head>
<body>
    <div class="floating-blob" id="blob1"></div>
    <div class="floating-blob" id="blob2"></div>

    <div class="login-card" id="card">
        <div class="logo"><i class="fa-solid fa-bolt"></i> TRADE<span class="text-info">AI</span></div>
        
        <div class="text-center mb-5">
            <h3 class="fw-bold mb-1">Intelligence Portal</h3>
            <p class="text-muted">Enter the neural network to begin trading</p>
        </div>

        <div id="alertBox" class="alert d-none py-3 px-4 small border-0 mb-4" style="border-radius: 16px; background: rgba(244, 63, 94, 0.1); color: #f43f5e;"></div>

        <form id="loginForm">
            <div class="mb-4">
                <label class="label-custom mb-2">Neural Email Address</label>
                <input type="email" class="form-control" id="email" placeholder="identity@tradeai.io" required>
            </div>
            <div class="mb-5">
                <label class="label-custom mb-2">Access Key (Password)</label>
                <input type="password" class="form-control" id="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-modern w-100 mb-4">Connect Interface</button>
        </form>

        <p class="text-center text-muted small mb-0">First time syncing? <a href="/views/register" class="text-info fw-bold text-decoration-none">Create Neural ID</a></p>
    </div>

    <script>
        // Intro Animation
        gsap.from("#card", { y: 100, opacity: 0, duration: 1.2, ease: "power4.out" });
        gsap.to("#blob1", { x: 100, y: 50, duration: 10, repeat: -1, yoyo: true });
        gsap.to("#blob2", { x: -100, y: -50, duration: 12, repeat: -1, yoyo: true });

        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = e.target.querySelector('button');
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>SYNCING...';

            try {
                const response = await fetch('/api/auth/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ 
                        email: document.getElementById('email').value, 
                        password: document.getElementById('password').value 
                    })
                });

                const data = await response.json();
                if (response.ok) {
                    localStorage.setItem('token', data.accessToken);
                    localStorage.setItem('user', JSON.stringify(data));
                    gsap.to("#card", { scale: 0.95, opacity: 0, duration: 0.5, onComplete: () => {
                        window.location.href = '/views/dashboard';
                    }});
                } else {
                    const alertBox = document.getElementById('alertBox');
                    alertBox.textContent = "DECRYPT ERROR: Invalid credentials provided.";
                    alertBox.classList.remove('d-none');
                    btn.disabled = false;
                    btn.textContent = 'RECONNECT';
                }
            } catch (err) {
                const alertBox = document.getElementById('alertBox');
                alertBox.textContent = 'INTERFACE ERROR: Server connection failed.';
                alertBox.classList.remove('d-none');
                btn.disabled = false;
                btn.textContent = 'RECONNECT';
            }
        });
    </script>
</body>
</html>
