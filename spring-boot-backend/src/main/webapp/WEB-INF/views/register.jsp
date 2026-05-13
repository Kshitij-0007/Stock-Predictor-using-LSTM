<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | TRADE AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <style>
        :root {
            --bg-dark: #020617;
            --card-bg: rgba(15, 23, 42, 0.4);
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
                radial-gradient(at 0% 100%, rgba(56, 189, 248, 0.08) 0px, transparent 50%),
                radial-gradient(at 100% 0%, rgba(34, 211, 238, 0.08) 0px, transparent 50%);
        }

        .login-card {
            background: var(--card-bg);
            backdrop-filter: blur(25px);
            border: var(--glass-border);
            border-radius: 32px;
            padding: 3.5rem;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 50px 100px -20px rgba(0, 0, 0, 0.7);
            position: relative;
            z-index: 10;
        }

        .logo { font-size: 2.25rem; font-weight: 800; text-align: center; margin-bottom: 2.25rem; }
        .logo i { color: var(--accent-blue); text-shadow: 0 0 20px rgba(56, 189, 248, 0.5); }

        .form-control {
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
            padding: 0.85rem 1.25rem;
            border-radius: 14px;
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
            transition: 0.3s;
        }

        .btn-modern:hover { transform: scale(1.02); box-shadow: 0 0 30px rgba(56, 189, 248, 0.3); }

        .label-custom { color: #94a3b8; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }

        .floating-blob {
            position: absolute; width: 400px; height: 400px;
            background: rgba(34, 211, 238, 0.08); filter: blur(100px);
            border-radius: 50%; z-index: 1;
        }
    </style>
</head>
<body>
    <div class="floating-blob" id="blob1" style="bottom: -100px; right: -100px;"></div>
    <div class="floating-blob" id="blob2" style="top: -100px; left: -100px;"></div>

    <div class="login-card" id="card">
        <div class="logo"><i class="fa-solid fa-user-plus"></i> TRADE<span class="text-info">AI</span></div>
        
        <div class="text-center mb-5">
            <h3 class="fw-bold mb-1">Network Initiation</h3>
            <p class="text-muted small">Establish your credentials in the AI ecosystem</p>
        </div>

        <div id="alertBox" class="alert d-none py-3 px-4 small border-0 mb-4" style="border-radius: 16px;"></div>

        <form id="registerForm">
            <div class="mb-3">
                <label class="label-custom mb-1">Human Designation (Name)</label>
                <input type="text" class="form-control" id="fullName" placeholder="Full Name" required>
            </div>
            <div class="mb-3">
                <label class="label-custom mb-1">Network ID (Email)</label>
                <input type="email" class="form-control" id="email" placeholder="identity@tradeai.io" required>
            </div>
            <div class="mb-4">
                <label class="label-custom mb-1">Access Pass (Password)</label>
                <input type="password" class="form-control" id="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-modern w-100 mb-4">Initialize Account</button>
        </form>

        <p class="text-center text-muted small mb-0">Already registered? <a href="/views/login" class="text-info fw-bold text-decoration-none">Reconnect</a></p>
    </div>

    <script>
        gsap.from("#card", { y: 100, opacity: 0, duration: 1, ease: "power3.out" });

        document.getElementById('registerForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = e.target.querySelector('button');
            const alertBox = document.getElementById('alertBox');
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>ESTABLISHING...';

            try {
                const response = await fetch('/api/auth/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ 
                        fullName: document.getElementById('fullName').value,
                        email: document.getElementById('email').value, 
                        password: document.getElementById('password').value 
                    })
                });

                if (response.ok) {
                    alertBox.textContent = 'NEURAL ID CREATED. REDIRECTING...';
                    alertBox.style.background = 'rgba(16, 185, 129, 0.1)';
                    alertBox.style.color = '#10b981';
                    alertBox.classList.remove('d-none');
                    setTimeout(() => window.location.href = '/views/login', 1500);
                } else {
                    const data = await response.json();
                    alertBox.textContent = data.message || 'INITIATION FAILED.';
                    alertBox.style.background = 'rgba(244, 63, 94, 0.1)';
                    alertBox.style.color = '#f43f5e';
                    alertBox.classList.remove('d-none');
                    btn.disabled = false;
                    btn.textContent = 'RETRY INITIALIZATION';
                }
            } catch (err) {
                alertBox.textContent = 'INTERFACE ERROR: CONNECTIVITY LOST.';
                alertBox.style.background = 'rgba(244, 63, 94, 0.1)';
                alertBox.style.color = '#f43f5e';
                alertBox.classList.remove('d-none');
                btn.disabled = false;
                btn.textContent = 'RETRY INITIALIZATION';
            }
        });
    </script>
</body>
</html>
