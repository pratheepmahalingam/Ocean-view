<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    // ✅ Session protection
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ✅ Values from servlet
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    Integer activeToday = (Integer) request.getAttribute("activeToday");
    Integer roomTypes = (Integer) request.getAttribute("roomTypes");
    Double estRevenue = (Double) request.getAttribute("estRevenue");

    List<Map<String, String>> recent = (List<Map<String, String>>) request.getAttribute("recentReservations");

    if (totalReservations == null) totalReservations = 0;
    if (activeToday == null) activeToday = 0;
    if (roomTypes == null) roomTypes = 0;
    if (estRevenue == null) estRevenue = 0.0;
    if (recent == null) recent = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View - Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        :root{
            --bg1:#061722;
            --bg2:#0a2a3a;
            --glass: rgba(255,255,255,0.10);
            --glass2: rgba(255,255,255,0.06);
            --stroke: rgba(255,255,255,0.16);

            --text:#eaf6ff;
            --muted: rgba(234,246,255,0.72);

            --shadow: 0 24px 70px rgba(0,0,0,0.45);
            --shadow2: 0 10px 25px rgba(0,0,0,0.28);
            --radius:18px;

            --a1:#1fd1f9;
            --a2:#b621fe;
            --a3:#2ad3a0;
            --a4:#ffd36a;

            --sidebarW: 270px;
        }

        *{ box-sizing:border-box; font-family: Arial, Helvetica, sans-serif; }
        body{
            margin:0;
            color: var(--text);
            min-height:100vh;

            /* Resort background image + gradients */
            background:
                radial-gradient(900px 520px at 10% 10%, rgba(31,209,249,0.25), transparent 60%),
                radial-gradient(900px 520px at 90% 85%, rgba(182,33,254,0.22), transparent 60%),
                linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.55)),
                url("images/resort-bg.jpg") center/cover no-repeat fixed;
        }

        /* floating glow blobs */
        .blob{
            position: fixed;
            width: 520px; height: 520px;
            filter: blur(70px);
            opacity: 0.42;
            border-radius: 50%;
            z-index: 0;
            pointer-events:none;
            animation: float 10s ease-in-out infinite;
        }
        .b1{ left:-180px; top:-160px; background: rgba(31,209,249,0.9); }
        .b2{ right:-170px; bottom:-200px; background: rgba(182,33,254,0.9); animation-delay:-2.5s; }
        .b3{ right: 12%; top:-170px; width: 420px; height: 420px; background: rgba(255,211,106,0.75); animation-delay:-4.5s; }

        @keyframes float{
            0%,100%{ transform: translate(0,0) scale(1); }
            50%{ transform: translate(18px,-14px) scale(1.05); }
        }

        .layout{
            position: relative;
            z-index: 1;
            display:flex;
            min-height:100vh;
        }

        /* Sidebar */
        .sidebar{
            width: var(--sidebarW);
            padding: 18px 14px;
            position: sticky;
            top: 0;
            height: 100vh;

            background: linear-gradient(180deg, rgba(6,23,34,0.72), rgba(10,42,58,0.55));
            border-right: 1px solid rgba(255,255,255,0.10);
            backdrop-filter: blur(14px);
        }

        .brand{
            display:flex;
            align-items:center;
            gap:10px;
            padding: 10px 10px 18px;
            font-weight: 900;
            font-size: 20px;
            letter-spacing: 0.2px;
        }
        .brand .logo{
            width: 40px; height: 40px;
            border-radius: 14px;
            display:flex; align-items:center; justify-content:center;
            background: linear-gradient(135deg, rgba(31,209,249,0.85), rgba(182,33,254,0.75));
            box-shadow: var(--shadow2);
        }
        .brand i{ color: #07131b; font-size: 18px; }

        .nav{ margin-top: 6px; }
        .nav a{
            display:flex;
            align-items:center;
            gap:12px;
            padding: 12px 12px;
            border-radius: 14px;
            color: rgba(234,246,255,0.84);
            text-decoration:none;
            margin: 8px 6px;
            font-weight: 800;
            border: 1px solid transparent;
            transition: 0.18s ease;
        }
        .nav a:hover{
            background: rgba(255,255,255,0.08);
            border-color: rgba(255,255,255,0.10);
            transform: translateY(-1px);
        }
        .nav a.active{
            background: linear-gradient(90deg, rgba(31,209,249,0.22), rgba(182,33,254,0.16));
            border: 1px solid rgba(255,255,255,0.14);
        }
        .nav i{ width:18px; text-align:center; color: rgba(234,246,255,0.92); }

        .sidebar-footer{
            position:absolute;
            left:14px; right:14px;
            bottom:16px;
            padding: 12px 12px;

            display:flex;
            align-items:center;
            justify-content:space-between;
            gap: 10px;

            border-radius: 16px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.12);
            color: rgba(234,246,255,0.78);
            font-size: 13px;
        }
        .logout{
            color: rgba(234,246,255,0.82);
            text-decoration:none;
            padding: 10px 12px;
            border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.12);
            background: rgba(0,0,0,0.12);
            transition: 0.18s ease;
        }
        .logout:hover{
            background: rgba(255,255,255,0.10);
            transform: translateY(-1px);
        }

        /* Main */
        .main{
            flex: 1;
            padding: 26px 26px 44px;
        }

        .topbar{
            display:flex;
            align-items:flex-end;
            justify-content:space-between;
            gap: 14px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }
        .title{
            font-size: 38px;
            font-weight: 950;
            margin: 0;
            letter-spacing: 0.2px;
        }
        .subtitle{
            margin-top: 8px;
            color: var(--muted);
            font-size: 15px;
        }

        .chip{
            display:flex;
            align-items:center;
            gap: 10px;
            padding: 10px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,0.10);
            border: 1px solid rgba(255,255,255,0.14);
            color: rgba(234,246,255,0.86);
            font-size: 13px;
            font-weight: 800;
        }

        /* KPI Cards */
        .cards{
            margin-top: 18px;
            display:grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 18px;
        }

        .card{
            border-radius: var(--radius);
            padding: 18px 18px;
            min-height: 98px;

            background: linear-gradient(180deg, var(--glass), var(--glass2));
            border: 1px solid rgba(255,255,255,0.14);
            box-shadow: var(--shadow2);
            backdrop-filter: blur(14px);

            display:flex;
            justify-content:space-between;
            align-items:center;
            overflow:hidden;
            position: relative;
        }

        .card::before{
            content:"";
            position:absolute;
            inset:-2px;
            background:
                radial-gradient(260px 160px at 20% 25%, rgba(31,209,249,0.18), transparent 60%),
                radial-gradient(260px 160px at 85% 80%, rgba(182,33,254,0.16), transparent 60%);
            z-index:0;
        }
        .card > *{ position:relative; z-index:1; }

        .card .label{ color: rgba(234,246,255,0.72); font-weight: 800; font-size: 13px; }
        .card .value{ margin-top: 10px; font-weight: 950; font-size: 24px; letter-spacing: 0.2px; }

        .iconBox{
            width: 46px; height: 46px;
            border-radius: 16px;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size: 18px;
            color:#07131b;
            box-shadow: 0 12px 28px rgba(0,0,0,0.25);
        }
        .c1{ background: linear-gradient(135deg, rgba(31,209,249,0.95), rgba(31,209,249,0.55)); }
        .c2{ background: linear-gradient(135deg, rgba(182,33,254,0.92), rgba(182,33,254,0.55)); }
        .c3{ background: linear-gradient(135deg, rgba(42,211,160,0.92), rgba(42,211,160,0.55)); }
        .c4{ background: linear-gradient(135deg, rgba(255,211,106,0.95), rgba(255,211,106,0.55)); }

        /* Table card */
        .bigCard{
            margin-top: 22px;
            border-radius: var(--radius);
            padding: 18px;

            background: linear-gradient(180deg, var(--glass), var(--glass2));
            border: 1px solid rgba(255,255,255,0.14);
            box-shadow: var(--shadow2);
            backdrop-filter: blur(14px);
        }

        .bigTop{
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }

        .bigTitle{
            font-size: 22px;
            font-weight: 950;
            margin: 0;
        }

        table{ width:100%; border-collapse:collapse; overflow:hidden; border-radius: 14px; }
        th, td{ padding: 12px 10px; text-align:left; }
        th{
            color: rgba(234,246,255,0.72);
            font-size: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.12);
            letter-spacing: 0.3px;
            text-transform: uppercase;
        }
        td{
            border-bottom: 1px solid rgba(255,255,255,0.10);
            font-weight: 700;
            color: rgba(234,246,255,0.90);
        }
        tbody tr:hover{
            background: rgba(255,255,255,0.06);
        }

        .rescode{ font-weight: 950; color: rgba(234,246,255,0.98); }
        .room, .date{ color: rgba(234,246,255,0.78); font-weight: 800; }

        /* Responsive */
        @media (max-width: 1100px){
            .cards{ grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 720px){
            .sidebar{ display:none; }
            .cards{ grid-template-columns: 1fr; }
            .main{ padding: 18px; }
        }
    </style>
</head>

<body>
<div class="blob b1"></div>
<div class="blob b2"></div>
<div class="blob b3"></div>

<div class="layout">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand">
            <div class="logo"><i class="fa-solid fa-water"></i></div>
            <span>Ocean View</span>
        </div>

        <nav class="nav">
            <a class="active" href="DashboardServlet"><i class="fa-solid fa-table-columns"></i>Dashboard</a>
            <a href="addReservation.jsp"><i class="fa-solid fa-user-plus"></i>Add Reservation</a>
            <a href="reservations.jsp"><i class="fa-solid fa-list"></i>Reservations</a>
            <a href="billCalculator.jsp"><i class="fa-solid fa-receipt"></i>Bill Calculator</a>
            <a href="help.jsp"><i class="fa-regular fa-circle-question"></i>Help</a>
        </nav>

        <div class="sidebar-footer">
            <div>Signed in as <b><%= username %></b></div>
            <a class="logout" href="LogoutServlet" title="Logout"><i class="fa-solid fa-right-from-bracket"></i></a>
        </div>
    </aside>

    <!-- Main -->
    <main class="main">

        <div class="topbar">
            <div>
                <h1 class="title">Welcome back, <%= username %></h1>
                <div class="subtitle">Ocean View Resort — Reservation Dashboard</div>
            </div>

            <div class="chip">
                <i class="fa-solid fa-sparkles"></i>
                Live Overview
            </div>
        </div>

        <section class="cards">
            <div class="card">
                <div>
                    <div class="label">Total Reservations</div>
                    <div class="value"><%= totalReservations %></div>
                </div>
                <div class="iconBox c1"><i class="fa-regular fa-calendar"></i></div>
            </div>

            <div class="card">
                <div>
                    <div class="label">Active Today</div>
                    <div class="value"><%= activeToday %></div>
                </div>
                <div class="iconBox c2"><i class="fa-solid fa-users"></i></div>
            </div>

            <div class="card">
                <div>
                    <div class="label">Room Types Available</div>
                    <div class="value"><%= roomTypes %></div>
                </div>
                <div class="iconBox c3"><i class="fa-solid fa-building"></i></div>
            </div>

            <div class="card">
                <div>
                    <div class="label">Est. Revenue</div>
                    <div class="value">$<%= String.format("%,.0f", estRevenue) %></div>
                </div>
                <div class="iconBox c4"><i class="fa-solid fa-dollar-sign"></i></div>
            </div>
        </section>

        <section class="bigCard">
            <div class="bigTop">
                <h2 class="bigTitle">Recent Reservations</h2>
                <div class="chip" style="padding:8px 12px;">
                    <i class="fa-regular fa-clock"></i>
                    Updated from server
                </div>
            </div>

            <table>
                <thead>
                <tr>
                    <th>Res. #</th>
                    <th>Guest</th>
                    <th>Room</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (recent.isEmpty()) {
                %>
                    <tr>
                        <td colspan="5" style="color: rgba(234,246,255,0.72); font-weight: 800;">No reservations found.</td>
                    </tr>
                <%
                    } else {
                        for (Map<String, String> r : recent) {
                %>
                    <tr>
                        <td class="rescode"><%= r.get("res_code") %></td>
                        <td><%= r.get("guest_name") %></td>
                        <td class="room"><%= r.get("room_name") %></td>
                        <td class="date"><%= r.get("check_in") %></td>
                        <td class="date"><%= r.get("check_out") %></td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </section>

    </main>
</div>
</body>
</html>
