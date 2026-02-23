<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        :root{
            --card-bg: rgba(255,255,255,0.18);
            --border: rgba(255,255,255,0.25);
            --text: #ffffff;
            --muted: rgba(255,255,255,0.8);
            --primaryA: #1fd1f9;
            --primaryB: #b621fe;
            --danger: #ff5a73;
            --shadow: 0 25px 70px rgba(0,0,0,0.45);
        }

        *{
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        /* ===== BACKGROUND IMAGE ===== */
        body{
            margin:0;
            min-height:100vh;
            display:flex;
            align-items:center;
            justify-content:center;
            padding: 20px;
            color: var(--text);

            background:
                linear-gradient(
                    rgba(0,0,0,0.55),
                    rgba(0,0,0,0.55)
                ),
                url("images/one.jpg") center/cover no-repeat fixed;
        }

        /* ===== GLOW EFFECT ===== */
        .glow{
            position: fixed;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(31,209,249,0.7), transparent 70%);
            top: -150px;
            left: -150px;
            filter: blur(80px);
            z-index: 0;
        }

        .glow2{
            position: fixed;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(182,33,254,0.7), transparent 70%);
            bottom: -150px;
            right: -150px;
            filter: blur(80px);
            z-index: 0;
        }

        /* ===== LOGIN CARD ===== */
        .card{
            position: relative;
            z-index: 1;
            width: min(420px, 92vw);
            padding: 34px 30px 28px;
            border-radius: 22px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            backdrop-filter: blur(18px);
            box-shadow: var(--shadow);
            text-align: center;
        }

        h1{
            margin: 0;
            font-size: 34px;
            font-weight: 900;
            letter-spacing: 0.5px;
        }

        .subtitle{
            margin-top: 6px;
            font-size: 14px;
            color: var(--muted);
        }

        /* ===== ERROR ===== */
        .error{
            margin-top: 16px;
            padding: 12px;
            border-radius: 14px;
            background: rgba(255, 90, 115, 0.15);
            border: 1px solid rgba(255, 90, 115, 0.35);
            font-size: 14px;
            display:flex;
            align-items:center;
            gap: 10px;
            text-align: left;
        }

        /* ===== FORM ===== */
        .group{
            margin-top: 26px;
            text-align: left;
        }

        label{
            display:block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 700;
            color: var(--muted);
        }

        .input-wrap{
            display:flex;
            align-items:center;
            gap: 10px;
            padding: 12px 14px;
            border-radius: 14px;
            background: rgba(0,0,0,0.35);
            border: 1px solid rgba(255,255,255,0.22);
            transition: 0.2s ease;
        }

        .input-wrap:focus-within{
            border-color: var(--primaryA);
            box-shadow: 0 0 0 4px rgba(31,209,249,0.18);
        }

        .input-wrap i{
            color: rgba(255,255,255,0.75);
        }

        input{
            width:100%;
            border:none;
            outline:none;
            background: transparent;
            font-size: 15px;
            color: #fff;
        }

        input::placeholder{
            color: rgba(255,255,255,0.6);
        }

        .toggle{
            background: none;
            border: none;
            cursor: pointer;
            color: rgba(255,255,255,0.75);
        }

        /* ===== BUTTON ===== */
        .btn{
            margin-top: 22px;
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 16px;
            font-size: 15px;
            font-weight: 900;
            color: #041018;
            background: linear-gradient(90deg, var(--primaryA), var(--primaryB));
            cursor: pointer;
            box-shadow: 0 12px 35px rgba(0,0,0,0.35);
            transition: transform 0.1s ease, filter 0.2s ease;
        }

        .btn:hover{
            filter: brightness(1.05);
        }

        .btn:active{
            transform: translateY(1px);
        }

        .default{
            margin-top: 14px;
            font-size: 13px;
            color: var(--muted);
            background: rgba(255,255,255,0.12);
            border-radius: 12px;
            padding: 10px;
            border: 1px dashed rgba(255,255,255,0.3);
        }

        @media(max-width:480px){
            h1{ font-size: 28px; }
        }
    </style>
</head>

<body>

<!-- Glow effects -->
<div class="glow"></div>
<div class="glow2"></div>

<div class="card">

    <h1>Ocean View Resort</h1>
    <div class="subtitle">Galle, Sri Lanka — Reservation System</div>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <div><%= error %></div>
        </div>
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
            <input id="pw" type="password" name="password" placeholder="Enter password" required />
            <button class="toggle" type="button" onclick="togglePw()">
                <i id="pwIcon" class="fa-regular fa-eye"></i>
            </button>
        </div>

        <button class="btn" type="submit">
            <i class="fa-solid fa-right-to-bracket"></i> Sign In
        </button>
    </form>



<script>
    function togglePw(){
        const pw = document.getElementById("pw");
        const icon = document.getElementById("pwIcon");
        if(pw.type === "password"){
            pw.type = "text";
            icon.className = "fa-regular fa-eye-slash";
        }else{
            pw.type = "password";
            icon.className = "fa-regular fa-eye";
        }
    }
</script>

</body>
</html>
