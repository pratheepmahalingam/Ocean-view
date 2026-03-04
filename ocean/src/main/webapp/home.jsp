<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort - Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        *{ box-sizing:border-box; font-family:"Segoe UI", Arial, sans-serif; }

        body{
            margin:0;
            min-height:100vh;
            color:#fff;
            background:
                linear-gradient(rgba(0,0,0,0.45), rgba(0,0,0,0.70)),
                url("images/one.jpg") center/cover no-repeat fixed;
        }

        /* Glow */
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

        /* Navbar */
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

        /* ✅ Logo image in navbar */
        .logo{
            width:38px; height:38px;
            border-radius:12px;
            object-fit:cover;
            border:1px solid rgba(255,255,255,0.25);
            box-shadow:0 10px 24px rgba(0,0,0,0.25);
        }

        .brand span{ white-space:nowrap; }
        .brand i{ color:#1fd1f9; }

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
            border:none; cursor:pointer;
            font-size:14px; font-weight:1000;
            color:#041018;
            background: linear-gradient(90deg,#1fd1f9,#b621fe);
            box-shadow:0 12px 35px rgba(0,0,0,0.30);
            text-decoration:none;
            transition:0.2s;
            white-space:nowrap;
        }
        .primaryBtn:hover{ transform: translateY(-2px); filter:brightness(1.08); }

        /* Page wrap */
        .wrap{
            position:relative; z-index:1;
            padding: 28px 18px 60px;
            display:flex; justify-content:center;
        }
        .container{ width:min(1100px, 96vw); }

        /* Hero */
        .hero{
            background: rgba(255,255,255,0.15);
            border:1px solid rgba(255,255,255,0.25);
            backdrop-filter: blur(18px);
            border-radius:24px;
            box-shadow:0 25px 70px rgba(0,0,0,0.45);
            padding: 30px 26px;
        }

        .heroTop{
            display:flex; gap:18px;
            align-items:flex-start; justify-content:space-between;
            flex-wrap:wrap;
        }

        .title{
            margin:0; font-size:46px;
            font-weight:1000; letter-spacing:0.6px; line-height:1.1;
        }
        .sub{
            margin-top:10px;
            color:rgba(255,255,255,0.85);
            font-size:14px;
            font-weight:800;
            line-height:1.6;
        }

        /* Sections */
        .sectionTitle{
            margin: 28px 0 12px;
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
            line-height:1.5;
        }

        /* About preview */
        .aboutBox{
            margin-top:14px;
            display:grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap:14px;
        }

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
            margin-bottom:10px;
        }

        .miniList{
            margin:10px 0 0;
            padding:0;
            list-style:none;
            display:grid;
            gap:8px;
        }
        .miniList li{
            display:flex;
            gap:10px;
            align-items:flex-start;
            color: rgba(255,255,255,0.84);
            font-weight:900;
            font-size:13px;
        }
        .miniList i{ color:#b621fe; margin-top:2px; }

        /* Footer */
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

        .footer a{
            color: rgba(255,255,255,0.90);
            text-decoration:none;
            font-weight:1000;
        }
        .footer a:hover{ text-decoration:underline; }

        @media(max-width: 900px){
            .grid{ grid-template-columns: 1fr; }
            .aboutBox{ grid-template-columns:1fr; }
            .title{ font-size:34px; }
        }
        @media(max-width: 520px){
            .navbtn{ display:none; }
            .title{ font-size:30px; }
        }
    </style>
</head>

<body>

<div class="glow1"></div>
<div class="glow2"></div>

<!-- ✅ Navbar with logo -->
<header class="topbar">
    <div class="brand">
        <!-- ✅ If you have a logo image, put it here -->
        <img class="logo" src="images/logo.png" alt="Ocean View Logo"
             onerror="this.style.display='none';" />
        <i class="fa-solid fa-water"></i>
        <span>Ocean View Resort</span>
    </div>

    <div class="navlinks">
        <a class="navbtn" href="#features"><i class="fa-solid fa-star"></i> Features</a>
        <a class="navbtn" href="#services"><i class="fa-solid fa-bell-concierge"></i> Services</a>
        <a class="navbtn" href="#contact"><i class="fa-solid fa-phone"></i> Contact</a>
        <a class="navbtn" href="about.jsp"><i class="fa-solid fa-circle-info"></i> About</a>

        <a class="primaryBtn" href="login.jsp">
            <i class="fa-solid fa-right-to-bracket"></i> Login
        </a>
    </div>
</header>

<div class="wrap">
    <div class="container">

        <!-- HERO -->
        <section class="hero">
            <div class="heroTop">
                <div>
                    <h1 class="title">Ocean View Resort</h1>
                    <div class="sub">Galle, Sri Lanka — Reservation System</div>
                </div>
            </div>

            <div class="sub" style="margin-top:14px;">
                Manage bookings, view reservations, and calculate bills easily with a modern, secure system designed for
                Ocean View Resort operations.
            </div>
        </section>

        <!-- FEATURES -->
        <h2 id="features" class="sectionTitle">Front Page Features</h2>
        <div class="grid">
            <div class="card">
                <div class="icon"><i class="fa-solid fa-shield-halved"></i></div>
                <h3>Secure Login</h3>
                <p>Session protected access for staff/admin to manage reservations safely.</p>
            </div>

            <div class="card">
                <div class="icon"><i class="fa-solid fa-list-check"></i></div>
                <h3>Reservation Management</h3>
                <p>Create, search, edit, and delete reservations with clean UI and fast access.</p>
            </div>

            <div class="card">
                <div class="icon"><i class="fa-solid fa-calculator"></i></div>
                <h3>Bill Calculator</h3>
                <p>Automatically calculates total bill from updated dates and room prices per night.</p>
            </div>
        </div>

        <!-- ABOUT PREVIEW -->
        <h2 class="sectionTitle">About Ocean View</h2>
        <div class="aboutBox">
            <div class="card">
                <div class="badge"><i class="fa-solid fa-location-dot"></i> Galle, Sri Lanka</div>
                <h3 style="margin:0 0 8px;font-weight:1000;">A calm seaside stay with modern comfort</h3>
                <p style="margin:0;color:rgba(255,255,255,0.82);font-weight:800;line-height:1.6;">
                    Ocean View Resort offers relaxing oceanfront rooms, warm hospitality, and smooth reservation handling.
                    This system helps the resort manage guests and billing professionally.
                </p>
                <div style="margin-top:12px;">
                    <a class="navbtn" href="about.jsp">
                        <i class="fa-solid fa-circle-info"></i> Read More
                    </a>
                </div>
            </div>

            <div class="card">
                <h3 style="margin:0 0 8px;font-weight:1000;">Quick Highlights</h3>
                <ul class="miniList">
                    <li><i class="fa-solid fa-check"></i> Room types with price per night</li>
                    <li><i class="fa-solid fa-check"></i> Search by reservation code</li>
                    <li><i class="fa-solid fa-check"></i> Edit check-out date and bill updates</li>
                    <li><i class="fa-solid fa-check"></i> Clean dashboard-friendly layout</li>
                </ul>
            </div>
        </div>

        <!-- SERVICES (Removed Hospitality Support) -->
        <h2 id="services" class="sectionTitle">Services</h2>
        <div class="grid">
            <div class="card">
                <div class="icon"><i class="fa-solid fa-bed"></i></div>
                <h3>Comfort Rooms</h3>
                <p>Room categories with clear pricing for accurate billing.</p>
            </div>

            <div class="card">
                <div class="icon"><i class="fa-solid fa-umbrella-beach"></i></div>
                <h3>Ocean View Experience</h3>
                <p>Beautiful coastal atmosphere for a relaxing stay in Galle.</p>
            </div>

            <div class="card">
                <div class="icon"><i class="fa-solid fa-mug-hot"></i></div>
                <h3>Dining & Refreshments</h3>
                <p>Simple meals and refreshments designed for a peaceful vacation.</p>
            </div>
        </div>

        <!-- FOOTER / CONTACT -->
        <div id="contact" class="footer">
            <div>
                <i class="fa-solid fa-phone"></i> +94 0123456789 &nbsp; | &nbsp;
                <i class="fa-solid fa-envelope"></i> support@oceanviewresort.lk
            </div>
            <div>
                <a href="about.jsp"><i class="fa-solid fa-circle-info"></i> About</a>
                &nbsp; • &nbsp;
                <a href="help.jsp"><i class="fa-regular fa-circle-question"></i> Help</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>