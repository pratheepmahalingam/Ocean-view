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

    @SuppressWarnings("unchecked")
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
            /* ✅ MATCH RESERVATIONS PAGE THEME (ONLY COLORS CHANGED) */
            --bg1:#071a2b;
            --bg2:#081d33;

            --panel: rgba(255,255,255,0.10);
            --panel2: rgba(255,255,255,0.14);
            --border: rgba(255,255,255,0.18);

            --text:#eaf2ff;
            --muted: rgba(234,242,255,0.78);

            --shadow: 0 28px 70px rgba(0,0,0,0.45);
            --shadow2: 0 10px 25px rgba(0,0,0,0.28);

            --radius:18px;

            --accent:#26d0ce;
            --accent2:#6e58ff;
            --warn:#ff5a73;

            --sidebarW: 270px;
        }

        *{ box-sizing:border-box; font-family: "Segoe UI", Arial, Helvetica, sans-serif; }

        body{
            margin:0;
            color: var(--text);
            min-height:100vh;
            background:
                radial-gradient(900px 500px at 15% 10%, rgba(38,208,206,0.25), transparent 60%),
                radial-gradient(900px 500px at 85% 90%, rgba(110,88,255,0.22), transparent 60%),
                linear-gradient(180deg, var(--bg1), var(--bg2));
        }

        /* Floating glow blobs */
        .blob{
            position: fixed;
            width: 560px; height: 560px;
            filter: blur(80px);
            opacity: 0.42;
            border-radius: 50%;
            z-index: 0;
            pointer-events:none;
            animation: float 10s ease-in-out infinite;
        }
        .b1{ left:-190px; top:-180px; background: rgba(38,208,206,0.90); }
        .b2{ right:-190px; bottom:-220px; background: rgba(110,88,255,0.90); animation-delay:-2.5s; }
        .b3{ right: 18%; top:-200px; width: 460px; height: 460px; background: rgba(255,90,115,0.55); animation-delay:-4.5s; }

        @keyframes float{
            0%,100%{ transform: translate(0,0) scale(1); }
            50%{ transform: translate(18px,-14px) scale(1.06); }
        }

        .layout{
            position: relative;
            z-index: 1;
            display:flex;
            min-height:100vh;
        }

        /* Sidebar (same layout, only colors match reservations page) */
        .sidebar{
            width: var(--sidebarW);
            padding: 18px 14px;
            position: sticky;
            top: 0;
            height: 100vh;

            background: linear-gradient(180deg, rgba(255,255,255,0.10), rgba(255,255,255,0.05));
            border-right: 1px solid rgba(255,255,255,0.10);
            backdrop-filter: blur(18px);
        }

        .brand{
            display:flex;
            align-items:center;
            gap:12px;
            padding: 10px 10px 16px;
        }
        .brand .logo{
            width: 44px; height: 44px;
            border-radius: 16px;
            display:flex; align-items:center; justify-content:center;
            background: linear-gradient(135deg, rgba(38,208,206,0.95), rgba(110,88,255,0.75));
            box-shadow: 0 16px 40px rgba(0,0,0,0.35);
        }

        .brand i{ color:#061018; font-size:18px; }
        .brandText{ display:flex; flex-direction:column; line-height:1.1; }
        .brandText .name{ font-weight: 1000; font-size: 18px; }
        .brandText .tag{
            margin-top:4px;
            font-size: 12px;
            color: var(--muted);
            font-weight: 800;
        }

        .nav{ margin-top: 10px; }

        .nav a{
            display:flex;
            align-items:center;
            gap:12px;
            padding: 12px 12px;
            border-radius: 14px;
            color: rgba(234,242,255,0.85);
            text-decoration:none;
            margin: 6px 6px;
            font-weight: 900;
            border: 1px solid transparent;
            transition: 0.18s ease;
        }

        .nav a:hover{
            background: rgba(255,255,255,0.08);
            border-color: rgba(255,255,255,0.10);
            transform: translateY(-1px);
        }

        .nav a.active{
            background: linear-gradient(90deg, rgba(38,208,206,0.20), rgba(110,88,255,0.18));
            border: 1px solid rgba(255,255,255,0.12);
            box-shadow: 0 14px 30px rgba(0,0,0,0.28);
        }

        .nav i{ width:18px; text-align:center; color: rgba(234,242,255,0.94); }
        .sidebar-footer{
            position:absolute;
            left:14px; right:14px;
            bottom:16px;
            padding: 12px 12px;

            display:flex;
            align-items:center;
            justify-content:space-between;
            gap: 10px;

            border-radius: 18px;
            background: rgba(255,255,255,0.09);
            border: 1px solid rgba(255,255,255,0.12);
            color: rgba(234,242,255,0.78);
            font-size: 13px;
            backdrop-filter: blur(14px);
        }

        .userMini{ display:flex; gap:10px; align-items:center; min-width:0; }
        .avatar{
            width:38px; height:38px;
            border-radius: 14px;
            background: linear-gradient(135deg, rgba(38,208,206,0.92), rgba(110,88,255,0.70));
            display:flex; align-items:center; justify-content:center;
            color:#061018;
            font-weight: 1000;
            box-shadow: 0 14px 30px rgba(0,0,0,0.25);
            flex: 0 0 auto;
        }
        .userMini .meta{ display:flex; flex-direction:column; gap:2px; min-width:0; }
        .userMini .meta .small{ color: var(--muted); font-weight:800; font-size: 12px; }
        .userMini .meta b{
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
            display:block;
            max-width: 150px;
        }

        .logout{
            color: rgba(234,242,255,0.88);
            text-decoration:none;
            padding: 10px 12px;
            border-radius: 16px;
            border: 1px solid rgba(255,255,255,0.14);
            background: rgba(0,0,0,0.14);
            transition: 0.18s ease;
        }
        .logout:hover{
            background: rgba(255,255,255,0.10);
            transform: translateY(-1px);
        }

        /* Main */
        .main{ flex: 1; padding: 26px 26px 44px; }

        .topbar{
            display:flex;
            align-items:flex-end;
            justify-content:space-between;
            gap: 14px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }

        .title{
            font-size: 40px;
            font-weight: 1000;
            margin: 0;
            letter-spacing: 0.2px;
        }
        .subtitle{
            margin-top: 8px;
            color: var(--muted);
            font-size: 15px;
            font-weight: 850;
        }

        .rightTools{
            display:flex;
            gap: 10px;
            align-items:center;
            flex-wrap: wrap;
            justify-content:flex-end;
        }

        .chip{
            display:flex;
            align-items:center;
            gap: 10px;
            padding: 10px 12px;
            border-radius: 999px;
            background: var(--panel);
            border: 1px solid var(--border);
            color: rgba(234,242,255,0.86);
            font-size: 13px;
            font-weight: 900;
            backdrop-filter: blur(12px);
            box-shadow: var(--shadow2);
        }

        .btn{
            display:inline-flex;
            align-items:center;
            gap:10px;
            padding: 10px 14px;
            border-radius: 999px;
            border: 1px solid rgba(255,255,255,0.14);
            background: linear-gradient(90deg, rgba(38,208,206,0.20), rgba(110,88,255,0.18));
            color: rgba(234,242,255,0.92);
            text-decoration:none;
            font-weight: 1000;
            transition: 0.18s ease;
        }
        .btn:hover{
            transform: translateY(-1px);
            filter: brightness(1.06);
        }

        /* KPI Cards */
        .cards{
            margin-top: 18px;
            display:grid;
            grid-template-columns: repeat(4, minmax(190px, 1fr));
            gap: 18px;
        }

        .card{
            border-radius: var(--radius);
            padding: 18px 18px;
            min-height: 105px;

            background: var(--panel);
            border: 1px solid var(--border);
            box-shadow: var(--shadow2);
            backdrop-filter: blur(18px);

            display:flex;
            justify-content:space-between;
            align-items:center;
            overflow:hidden;
            position: relative;
            transition: 0.18s ease;
        }

        .card:hover{
            transform: translateY(-2px);
            border-color: rgba(255,255,255,0.22);
        }

        .card .label{
            color: rgba(234,242,255,0.74);
            font-weight: 900;
            font-size: 12px;
            letter-spacing: 0.2px;
            text-transform: uppercase;
        }
        .card .value{
            margin-top: 10px;
            font-weight: 1000;
            font-size: 26px;
            letter-spacing: 0.2px;
        }

        .trend{
            margin-top: 8px;
            font-size: 12px;
            font-weight: 900;
            color: rgba(234,242,255,0.78);
            display:flex;
            align-items:center;
            gap:8px;
        }
        .dot{
            width: 8px; height: 8px;
            border-radius: 999px;
            background: rgba(38,208,206,0.95);
            box-shadow: 0 0 0 6px rgba(38,208,206,0.12);
        }

        .iconBox{
            width: 52px; height: 52px;
            border-radius: 18px;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size: 18px;
            color:#061018;
            box-shadow: 0 14px 32px rgba(0,0,0,0.30);
        }
        .c1{ background: linear-gradient(135deg, rgba(38,208,206,0.98), rgba(38,208,206,0.55)); }
        .c2{ background: linear-gradient(135deg, rgba(110,88,255,0.94), rgba(110,88,255,0.55)); }
        .c3{ background: linear-gradient(135deg, rgba(38,208,206,0.70), rgba(110,88,255,0.55)); }
        .c4{ background: linear-gradient(135deg, rgba(255,211,106,0.98), rgba(255,211,106,0.55)); }

        /* Table card */
        .bigCard{
            margin-top: 22px;
            border-radius: var(--radius);
            padding: 18px;

            background: var(--panel);
            border: 1px solid var(--border);
            box-shadow: var(--shadow2);
            backdrop-filter: blur(18px);
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
            font-weight: 1000;
            margin: 0;
        }

        .tableWrap{
            border-radius: 16px;
            overflow:hidden;
            border: 1px solid rgba(255,255,255,0.12);
            background: rgba(0,0,0,0.10);
        }

        table{ width:100%; border-collapse:collapse; }

        th, td{ padding: 12px 12px; text-align:left; }

        th{
            color: rgba(234,242,255,0.74);
            font-size: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.12);
            letter-spacing: 0.35px;
            text-transform: uppercase;
            background: rgba(255,255,255,0.04);
        }
        td{
            border-bottom: 1px solid rgba(255,255,255,0.08);
            font-weight: 850;
            color: rgba(234,242,255,0.92);
        }
        tbody tr{ transition: 0.16s ease; }
        tbody tr:hover{ background: rgba(255,255,255,0.06); }

        .rescode{ font-weight: 1000; color: rgba(234,242,255,0.98); }
        .room, .date{ color: rgba(234,242,255,0.78); font-weight: 900; }

        .mutedRow{
            color: rgba(234,242,255,0.72);
            font-weight: 900;
            padding: 18px 10px;
        }

        /* Responsive */
        @media (max-width: 1100px){
            .cards{ grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 720px){
            .sidebar{ display:none; }
            .cards{ grid-template-columns: 1fr; }
            .main{ padding: 18px; }
            .title{ font-size: 30px; }
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
            <div class="brandText">
                <div class="name">Ocean View</div>
                <div class="tag">Resort Management</div>
            </div>
        </div>

        <nav class="nav">
            <a class="active" href="DashboardServlet"><i class="fa-solid fa-table-columns"></i><span>Dashboard</span></a>
            <a href="addReservation.jsp"><i class="fa-solid fa-user-plus"></i><span>Add Reservation</span></a>
            <a href="ReservationsServlet"><i class="fa-solid fa-list"></i><span>Reservations</span></a>
            <a href="billCalculator.jsp"><i class="fa-solid fa-receipt"></i><span>Bill Calculator</span></a>
            <a href="help.jsp"><i class="fa-regular fa-circle-question"></i><span>Help</span></a>
        </nav>

        <div class="sidebar-footer">
            <div class="userMini">
                <div class="avatar"><i class="fa-solid fa-user"></i></div>
                <div class="meta">
                    <div class="small">Signed in as</div>
                    <b><%= username %></b>
                </div>
            </div>
            <a class="logout" href="LogoutServlet" title="Logout">
                <i class="fa-solid fa-right-from-bracket"></i>
            </a>
        </div>
    </aside>

    <!-- Main -->
    <main class="main">

        <div class="topbar">
            <div>
                <h1 class="title">Welcome back, <%= username %></h1>
                <div class="subtitle">Ocean View Resort — Reservation Dashboard</div>
            </div>

            <div class="rightTools">
                <div class="chip">
                    <i class="fa-solid fa-sparkles"></i>
                    Live Overview
                </div>
                <a class="btn" href="addReservation.jsp">
                    <i class="fa-solid fa-plus"></i>
                    New Reservation
                </a>
            </div>
        </div>

        <section class="cards">
            <div class="card">
                <div>
                    <div class="label">Total Reservations</div>
                    <div class="value"><%= totalReservations %></div>
                    <div class="trend"><span class="dot"></span> Updated from server</div>
                </div>
                <div class="iconBox c1"><i class="fa-regular fa-calendar"></i></div>
            </div>

            <div class="card">
                <div>
                    <div class="label">Active Today</div>
                    <div class="value"><%= activeToday %></div>
                    <div class="trend"><span class="dot"></span> Today’s activity</div>
                </div>
                <div class="iconBox c2"><i class="fa-solid fa-users"></i></div>
            </div>

            <div class="card">
                <div>
                    <div class="label">Room Types Available</div>
                    <div class="value"><%= roomTypes %></div>
                    <div class="trend"><span class="dot"></span> Live inventory</div>
                </div>
                <div class="iconBox c3"><i class="fa-solid fa-building"></i></div>
            </div>

            <div class="card">
                <div>
                    <div class="label">Est. Revenue</div>
                    <div class="value">$<%= String.format("%,.0f", estRevenue) %></div>
                    <div class="trend"><span class="dot"></span> This period</div>
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

            <div class="tableWrap">
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
                            <td colspan="5" class="mutedRow">No reservations found.</td>
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
            </div>
        </section>

    </main>
</div>
</body>
</html>