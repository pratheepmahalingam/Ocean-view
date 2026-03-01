<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View - Help</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        body{margin:0;font-family:Arial;background:#f4f7fb;}
        .layout{display:flex;min-height:100vh;}
        .sidebar{
            width:260px;background:#0c2a3d;color:#fff;
            padding:18px;position:sticky;height:100vh;
        }
        .brand{font-size:20px;font-weight:700;margin-bottom:20px;}
        .nav a{
            display:block;color:#dbe7f1;text-decoration:none;
            padding:10px;border-radius:10px;margin-bottom:6px;
        }
        .nav a:hover{background:rgba(255,255,255,0.08);}
        .main{flex:1;padding:30px;}
        .card{
            background:#fff;padding:20px;border-radius:14px;
            box-shadow:0 10px 20px rgba(0,0,0,0.08);
            max-width:800px;
        }
        h1{margin-top:0;}
        .section{margin-top:20px;}
        .section h3{margin-bottom:8px;}
        .section p{color:#607080;font-weight:600;}
    </style>
</head>
<body>
<div class="layout">

    <aside class="sidebar">
        <div class="brand">🌊 Ocean View</div>
        <div class="nav">
            <a href="DashboardServlet">Dashboard</a>
            <a href="addReservation.jsp">Add Reservation</a>
            <a href="ReservationsServlet">Reservations</a>
            <a href="billCalculator.jsp">Bill Calculator</a>
            <a href="help.jsp">Help</a>
        </div>
        <div style="margin-top:20px;font-size:13px;">
            Signed in as <b><%= username %></b>
        </div>
    </aside>

    <main class="main">
        <div class="card">
            <h1>Help & System Guide</h1>

            <div class="section">
                <h3>📌 Dashboard</h3>
                <p>View total reservations, active guests, revenue and recent bookings.</p>
            </div>

            <div class="section">
                <h3>➕ Add Reservation</h3>
                <p>Create new reservations with guest details, room type and dates.</p>
            </div>

            <div class="section">
                <h3>📋 Reservations</h3>
                <p>Search, edit or delete reservation records.</p>
            </div>

            <div class="section">
                <h3>💰 Bill Calculator</h3>
                <p>Calculate total bill using reservation code.</p>
            </div>

            <div class="section">
                <h3>🔐 Security</h3>
                <p>Your session automatically expires after logout.</p>
            </div>

        </div>
    </main>

</div>
</body>
</html>