<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        :root{
            --card-bg: rgba(255,255,255,0.88);
            --text: #1c2430;
            --muted: #6c7a89;
            --primary: #0f5f7a;
            --primary-dark: #0b3f52;
            --border: rgba(0,0,0,0.08);
        }
        *{ box-sizing: border-box; font-family: Arial, Helvetica, sans-serif; }
        body{
            margin:0;
            min-height:100vh;
            display:flex;
            align-items:center;
            justify-content:center;
            background:
                linear-gradient(rgba(0,0,0,0.25), rgba(0,0,0,0.25)),
                url("images/beach.jpg") center/cover no-repeat fixed;
            padding: 18px;
        }
        .card{
            width: min(520px, 92vw);
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 34px 34px 26px;
            box-shadow: 0 14px 40px rgba(0,0,0,0.25);
            backdrop-filter: blur(8px);
        }
        h1{ margin:0; text-align:center; color: var(--text); font-size: 34px; font-weight: 700; }
        .subtitle{ margin-top: 6px; text-align:center; color: var(--muted); font-size: 14px; }
        .group{ margin-top: 26px; }
        label{ display:block; font-size: 14px; color: var(--text); margin: 0 0 10px; font-weight: 600; }
        .input-wrap{
            display:flex; align-items:center; gap:10px;
            background:#fff; border: 1px solid var(--border);
            border-radius: 10px; padding: 10px 12px;
        }
        .input-wrap i{ color:#7d8a97; min-width: 18px; }
        input{ border:none; outline:none; width:100%; font-size: 15px; padding: 6px 2px; background: transparent; }
        .btn{
            margin-top: 18px; width: 100%;
            border: none; border-radius: 10px;
            padding: 14px 16px; font-size: 15px; font-weight: 700;
            color: #fff; background: linear-gradient(90deg, var(--primary-dark), var(--primary));
            cursor:pointer;
        }
        .error{
            margin-top: 14px; padding: 10px 12px; border-radius: 10px;
            background: rgba(220, 53, 69, 0.10);
            color: #b02a37; border: 1px solid rgba(220, 53, 69, 0.20);
            font-size: 14px;
        }
        .default{ margin-top: 10px; text-align:center; color: #7a8794; font-size: 13px; }
    </style>
</head>
<body>

<div class="card">
    <h1>Ocean View Resort</h1>
    <div class="subtitle">Galle, Sri Lanka — Reservation System</div>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div>
    <%
        }
    %>

    <form action="LoginServlet" method="post" class="group">
        <label>Username</label>
        <div class="input-wrap">
            <i class="fa-regular fa-user"></i>
            <input type="text" name="username" placeholder="Enter username" required />
        </div>

        <label style="margin-top:16px;">Password</label>
        <div class="input-wrap">
            <i class="fa-solid fa-lock"></i>
            <input type="password" name="password" placeholder="Enter password" required />
        </div>

        <button class="btn" type="submit">Sign In</button>
    </form>

    <div class="default">Default: <b>admin</b> / <b>admin123</b></div>
</div>

</body>
</html>
