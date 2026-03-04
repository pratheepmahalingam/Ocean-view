<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort - About Us</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        *{ box-sizing:border-box; font-family:"Segoe UI", Arial, sans-serif; }

        body{
            margin:0;
            min-height:100vh;
            color:#fff;
            background:
                linear-gradient(rgba(0,0,0,0.50), rgba(0,0,0,0.78)),
                url("images/one.jpg") center/cover no-repeat fixed;
        }

        .glow1{
            position:fixed; width:520px;height:520px;
            background: radial-gradient(circle, rgba(31,209,249,0.55), transparent 70%);
            top:-160px;left:-160px; filter:blur(90px); z-index:0;
        }
        .glow2{
            position:fixed; width:520px;height:520px;
            background: radial-gradient(circle, rgba(182,33,254,0.55), transparent 70%);
            bottom:-160px;right:-160px; filter:blur(90px); z-index:0;
        }

        .topbar{
            position:sticky; top:0; z-index:5;
            padding:14px 18px;
            display:flex; align-items:center; justify-content:space-between;
            background: rgba(255,255,255,0.10);
            border-bottom: 1px solid rgba(255,255,255,0.16);
            backdrop-filter: blur(18px);
        }

        .brand{
            display:flex; align-items:center; gap:10px;
            font-weight:1000; letter-spacing:0.5px; font-size:18px;
        }
        .logo{
            width:38px; height:38px;
            border-radius:12px;
            object-fit:cover;
            border:1px solid rgba(255,255,255,0.25);
            box-shadow:0 10px 24px rgba(0,0,0,0.25);
        }
        .brand i{ color:#1fd1f9; }
        .brand span{ white-space:nowrap; }

        .navlinks{
            display:flex; align-items:center; gap:10px;
            flex-wrap:wrap; justify-content:flex-end;
        }
        .navbtn{
            display:inline-flex; align-items:center; gap:8px;
            padding:10px 14px; border-radius:14px;
            text-decoration:none; font-weight:900;
            color: rgba(255,255,255,0.92);
            background: rgba(255,255,255,0.10);
            border:1px solid rgba(255,255,255,0.18);
            transition:0.2s;
        }
        .navbtn:hover{ background: rgba(255,255,255,0.16); transform: translateY(-1px); }

        .primaryBtn{
            display:inline-flex; align-items:center; gap:10px;
            padding:10px 14px; border-radius:14px;
            font-size:14px; font-weight:1000;
            color:#041018;
            background: linear-gradient(90deg,#1fd1f9,#b621fe);
            box-shadow:0 12px 35px rgba(0,0,0,0.30);
            text-decoration:none;
            transition:0.2s;
            white-space:nowrap;
        }
        .primaryBtn:hover{ transform: translateY(-2px); filter:brightness(1.08); }

        .wrap{
            position:relative; z-index:1;
            padding: 26px 18px 60px;
            display:flex; justify-content:center;
        }
        .container{ width:min(1100px, 96vw); }

        .hero{
            background: rgba(255,255,255,0.15);
            border:1px solid rgba(255,255,255,0.25);
            backdrop-filter: blur(18px);
            border-radius:24px;
            box-shadow:0 25px 70px rgba(0,0,0,0.45);
            padding: 28px 24px;
        }

        .title{
            margin:0;
            font-size:40px;
            font-weight:1000;
            letter-spacing:0.4px;
        }
        .sub{
            margin-top:10px;
            color:rgba(255,255,255,0.85);
            font-size:14px;
            font-weight:800;
            line-height:1.7;
        }

        .badgeRow{ margin-top:14px; display:flex; gap:10px; flex-wrap:wrap; }
        .badge{
            display:inline-flex;
            gap:8px;
            align-items:center;
            padding:8px 12px;
            border-radius:999px;
            background: rgba(0,0,0,0.22);
            border:1px solid rgba(255,255,255,0.16);
            font-weight:1000;
            color: rgba(255,255,255,0.92);
            font-size:13px;
        }

        .sectionTitle{
            margin: 22px 0 12px;
            font-size:20px;
            font-weight:1000;
            letter-spacing:0.2px;
        }

        .grid{
            display:grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap:14px;
        }

        .card{
            background: rgba(255,255,255,0.13);
            border:1px solid rgba(255,255,255,0.20);
            border-radius:18px;
            backdrop-filter: blur(16px);
            padding: 16px 16px;
        }

        .icon{
            width:46px;height:46px;
            border-radius:16px;
            display:flex; align-items:center; justify-content:center;
            background: rgba(0,0,0,0.22);
            border:1px solid rgba(255,255,255,0.18);
            margin-bottom:10px;
            color:#1fd1f9;
            font-size:18px;
        }

        .card h3{ margin:0 0 6px; font-size:16px; font-weight:1000; }
        .card p{
            margin:0;
            color: rgba(255,255,255,0.82);
            font-size:13px;
            font-weight:800;
            line-height:1.6;
        }

        .twoCol{
            margin-top:14px;
            display:grid;
            grid-template-columns: 1.3fr 0.7fr;
            gap:14px;
        }

        .list{
            margin:10px 0 0;
            padding:0;
            list-style:none;
            display:grid;
            gap:8px;
        }
        .list li{
            display:flex;
            gap:10px;
            align-items:flex-start;
            color: rgba(255,255,255,0.84);
            font-weight:900;
            font-size:13px;
        }
        .list i{ color:#b621fe; margin-top:2px; }

        .footer{
            margin-top:22px;
            padding:14px 16px;
            border-radius:18px;
            background: rgba(255,255,255,0.10);
            border:1px solid rgba(255,255,255,0.16);
            backdrop-filter: blur(14px);
            color: rgba(255,255,255,0.80);
            font-weight:900;
            font-size:13px;
            display:flex;
            justify-content:space-between;
            gap:12px;
            flex-wrap:wrap;
        }
        .footer a{ color: rgba(255,255,255,0.92); text-decoration:none; font-weight:1000; }
        .footer a:hover{ text-decoration:underline; }

        @media(max-width: 900px){
            .grid{ grid-template-columns:1fr; }
            .twoCol{ grid-template-columns:1fr; }
            .title{ font-size:32px; }
        }
        @media(max-width: 520px){
            .navbtn{ display:none; }
            .title{ font-size:28px; }
        }
    </style>
</head>

<body>

<div class="glow1"></div>
<div class="glow2"></div>

<header class="topbar">
    <div class="brand">
        <img class="logo" src="images/logo.png" alt="Ocean View Logo"
             onerror="this.style.display='none';" />
        <i class="fa-solid fa-water"></i>
        <span>Ocean View Resort</span>
    </div>

    <div class="navlinks">
        <a class="navbtn" href="home.jsp"><i class="fa-solid fa-house"></i> Home</a>
        <a class="navbtn" href="#story"><i class="fa-solid fa-book-open"></i> Story</a>
        <a class="navbtn" href="#vision"><i class="fa-solid fa-bullseye"></i> Vision</a>
        <a class="navbtn" href="#contact"><i class="fa-solid fa-phone"></i> Contact</a>

        <a class="primaryBtn" href="login.jsp">
            <i class="fa-solid fa-right-to-bracket"></i> Login
        </a>
    </div>
</header>

<div class="wrap">
    <div class="container">

        <section class="hero" id="story">
            <h1 class="title">About Ocean View Resort</h1>
            <div class="sub">
                Located in <b>Galle, Sri Lanka</b>, Ocean View Resort is designed for guests who love calm ocean views,
                comfortable rooms, and a peaceful environment. Our reservation system supports staff in managing bookings
                and generating accurate bills based on room price per night and stay duration.
            </div>

            <div class="badgeRow">
                <div class="badge"><i class="fa-solid fa-location-dot"></i> Galle, Sri Lanka</div>
                <div class="badge"><i class="fa-solid fa-umbrella-beach"></i> Oceanfront Resort</div>
                <div class="badge"><i class="fa-solid fa-star"></i> Guest Satisfaction</div>
            </div>
        </section>

        <h2 id="vision" class="sectionTitle">Vision • Mission • Values</h2>
        <div class="grid">
            <div class="card">
                <div class="icon"><i class="fa-solid fa-eye"></i></div>
                <h3>Vision</h3>
                <p>To be a trusted seaside resort in Galle, known for comfort, quality, and memorable stays.</p>
            </div>

            <div class="card">
                <div class="icon"><i class="fa-solid fa-bullseye"></i></div>
                <h3>Mission</h3>
                <p>To provide warm service and a smooth reservation experience supported by a modern system.</p>
            </div>

            <div class="card">
                <div class="icon"><i class="fa-solid fa-handshake"></i></div>
                <h3>Values</h3>
                <p>Respect, honesty, safety, cleanliness, and continuous improvement for every guest.</p>
            </div>
        </div>

        <h2 class="sectionTitle">Why This System?</h2>
        <div class="twoCol">
            <div class="card">
                <h3 style="margin:0 0 8px;font-weight:1000;">Better Reservation Handling</h3>
                <p style="margin:0;color:rgba(255,255,255,0.82);font-weight:800;line-height:1.7;">
                    The Ocean View Reservation System helps staff add and manage reservations efficiently.
                    When check-out dates change, bill calculations update correctly using nights × price per night.
                    This reduces mistakes and improves guest trust.
                </p>
            </div>

            <div class="card">
                <h3 style="margin:0 0 8px;font-weight:1000;">Key Benefits</h3>
                <ul class="list">
                    <li><i class="fa-solid fa-check"></i> Accurate night calculation</li>
                    <li><i class="fa-solid fa-check"></i> Fast reservation searching</li>
                    <li><i class="fa-solid fa-check"></i> Easy edit and update</li>
                    <li><i class="fa-solid fa-check"></i> Professional UI experience</li>
                </ul>
            </div>
        </div>

        <div id="contact" class="footer">
            <div>
                <i class="fa-solid fa-phone"></i> +94 0123456789 &nbsp; | &nbsp;
                <i class="fa-solid fa-envelope"></i> support@oceanviewresort.lk
            </div>
            <div>
                <a href="home.jsp"><i class="fa-solid fa-house"></i> Home</a>
                &nbsp; • &nbsp;
                <a href="help.jsp"><i class="fa-regular fa-circle-question"></i> Help</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>