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
            --nav:#0c2a3d;
            --nav2:#0a2232;
            --bg:#f4f7fb;
            --card:#ffffff;
            --muted:#708090;
            --text:#13202c;
            --shadow: 0 10px 20px rgba(12,42,61,0.10);
            --radius:14px;
            --accent1:#0b3f52;
            --accent2:#0f5f7a;
            --accent3:#1b9aaa;
            --accent4:#d28c2c;
        }
        *{box-sizing:border-box;font-family: Arial, Helvetica, sans-serif;}
        body{margin:0;background:var(--bg);color:var(--text);}

        .layout{display:flex;min-height:100vh;}

        /* Sidebar */
        .sidebar{
            width:260px;
            background: linear-gradient(180deg, var(--nav), var(--nav2));
            color:#fff;
            padding:18px 14px;
            position:sticky;
            top:0;
            height:100vh;
        }
        .brand{
            display:flex;
            align-items:center;
            gap:10px;
            padding:10px 10px 18px;
            font-weight:700;
            font-size:20px;
        }
        .brand i{color:#f3b04a;}
        .nav{margin-top:8px;}
        .nav a{
            display:flex;
            align-items:center;
            gap:12px;
            padding:12px 12px;
            border-radius:12px;
            color:#dbe7f1;
            text-decoration:none;
            margin:6px 6px;
            font-weight:600;
        }
        .nav a:hover{background:rgba(255,255,255,0.08);}
        .nav a.active{background:rgba(255,255,255,0.10);border:1px solid rgba(255,255,255,0.08);}
        .nav i{width:18px;text-align:center;}

        .sidebar-footer{
            position:absolute;
            left:14px; right:14px;
            bottom:16px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            color:#b7c9d9;
            font-size:13px;
            padding:10px 12px;
            border-top:1px solid rgba(255,255,255,0.10);
        }
        .logout{
            color:#b7c9d9;
            text-decoration:none;
            padding:8px 10px;
            border-radius:10px;
        }
        .logout:hover{background:rgba(255,255,255,0.08);}

        /* Main */
        .main{flex:1;padding:26px 26px 40px;}
        .title{
            font-size:38px;
            font-weight:800;
            margin:0;
            letter-spacing:0.2px;
        }
        .subtitle{
            margin-top:8px;
            color:var(--muted);
            font-size:16px;
        }

        /* Cards */
        .cards{
            margin-top:22px;
            display:grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap:18px;
        }
        .card{
            background:var(--card);
            border-radius:var(--radius);
            padding:18px 18px;
            box-shadow: var(--shadow);
            border:1px solid rgba(12,42,61,0.06);
            display:flex;
            justify-content:space-between;
            align-items:center;
            min-height:92px;
        }
        .card .label{color:var(--muted);font-weight:700;font-size:14px;}
        .card .value{margin-top:10px;font-weight:900;font-size:22px;}
        .iconBox{
            width:44px;height:44px;border-radius:12px;
            display:flex;align-items:center;justify-content:center;
            color:#fff;font-size:18px;
        }
        .b1{background:var(--accent1);}
        .b2{background:var(--accent2);}
        .b3{background:var(--accent3);}
        .b4{background:var(--accent4);}

        /* Table card */
        .bigCard{
            margin-top:22px;
            background:var(--card);
            border-radius:var(--radius);
            box-shadow: var(--shadow);
            border:1px solid rgba(12,42,61,0.06);
            padding:18px;
        }
        .bigTitle{font-size:22px;font-weight:900;margin:6px 0 14px;}
        table{width:100%;border-collapse:collapse;}
        th,td{padding:12px 10px;text-align:left;}
        th{color:var(--muted);font-size:13px;border-bottom:1px solid rgba(0,0,0,0.06);}
        td{border-bottom:1px solid rgba(0,0,0,0.06);font-weight:600;}
        .rescode{color:#13202c;font-weight:900;}
        .room{color:#586b7b;font-weight:700;}
        .date{color:#586b7b;font-weight:700;}

        @media (max-width: 1100px){
            .cards{grid-template-columns: repeat(2, 1fr);}
        }
        @media (max-width: 720px){
            .sidebar{display:none;}
            .cards{grid-template-columns: 1fr;}
            .main{padding:18px;}
        }
    </style>
</head>

<body>
<div class="layout">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand">
            <i class="fa-solid fa-water"></i>
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
        <h1 class="title">Welcome back, <%= username %></h1>
        <div class="subtitle">Ocean View Resort — Reservation Dashboard</div>

        <section class="cards">
            <div class="card">
                <div>
                    <div class="label">Total Reservations</div>
                    <div class="value"><%= totalReservations %></div>
                </div>
                <div class="iconBox b1"><i class="fa-regular fa-calendar"></i></div>
            </div>

            <div class="card">
                <div>
                    <div class="label">Active Today</div>
                    <div class="value"><%= activeToday %></div>
                </div>
                <div class="iconBox b2"><i class="fa-solid fa-users"></i></div>
            </div>

            <div class="card">
                <div>
                    <div class="label">Room Types Available</div>
                    <div class="value"><%= roomTypes %></div>
                </div>
                <div class="iconBox b3"><i class="fa-solid fa-building"></i></div>
            </div>

            <div class="card">
                <div>
                    <div class="label">Est. Revenue</div>
                    <div class="value">$<%= String.format("%,.0f", estRevenue) %></div>
                </div>
                <div class="iconBox b4"><i class="fa-solid fa-dollar-sign"></i></div>
            </div>
        </section>

        <section class="bigCard">
            <div class="bigTitle">Recent Reservations</div>

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
                        <td colspan="5" style="color:#708090;font-weight:700;">No reservations found.</td>
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
