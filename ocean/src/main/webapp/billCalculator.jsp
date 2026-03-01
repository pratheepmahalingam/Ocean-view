<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String msg = (String) request.getAttribute("msg");
    String err = (String) request.getAttribute("err");

    String resCode = (String) request.getAttribute("resCode");
    String guest = (String) request.getAttribute("guest");
    String room = (String) request.getAttribute("room");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");
    Integer nights = (Integer) request.getAttribute("nights");
    Double total = (Double) request.getAttribute("total");

    if (resCode == null) resCode = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View - Bill Calculator</title>
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
            --border: rgba(12,42,61,0.10);
            --accent:#0f5f7a;
        }
        *{box-sizing:border-box;font-family: Arial, Helvetica, sans-serif;}
        body{margin:0;background:var(--bg);color:var(--text);}
        .layout{display:flex;min-height:100vh;}

        .sidebar{
            width:260px;
            background: linear-gradient(180deg, var(--nav), var(--nav2));
            color:#fff;
            padding:18px 14px;
            position:sticky; top:0; height:100vh;
        }
        .brand{
            display:flex; align-items:center; gap:10px;
            padding:10px 10px 18px;
            font-weight:700; font-size:20px;
        }
        .brand i{color:#f3b04a;}
        .nav{margin-top:8px;}
        .nav a{
            display:flex; align-items:center; gap:12px;
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
            position:absolute; left:14px; right:14px; bottom:16px;
            display:flex; align-items:center; justify-content:space-between;
            color:#b7c9d9; font-size:13px;
            padding:10px 12px;
            border-top:1px solid rgba(255,255,255,0.10);
        }
        .logout{color:#b7c9d9;text-decoration:none;padding:8px 10px;border-radius:10px;}
        .logout:hover{background:rgba(255,255,255,0.08);}

        .main{flex:1;padding:26px 26px 40px;}
        .pageTitle{font-size:40px;font-weight:900;margin:0;}
        .subtitle{margin-top:8px;color:var(--muted);font-weight:700;}

        .card{
            margin-top:18px;
            background:var(--card);
            border-radius:var(--radius);
            border:1px solid rgba(12,42,61,0.06);
            box-shadow: var(--shadow);
            padding:18px;
            width: min(860px, 100%);
        }

        label{display:block;font-weight:800;color:#203040;margin:10px 0 8px;}
        .input{
            background:#fff;
            border:1px solid var(--border);
            border-radius:10px;
            padding:12px 12px;
            width:100%;
            outline:none;
            font-size:15px;
        }

        .btn{
            margin-top:14px;
            border:none;
            border-radius:10px;
            padding:12px 14px;
            font-weight:900;
            font-size:15px;
            color:#fff;
            background: linear-gradient(90deg, #0b3f52, var(--accent));
            cursor:pointer;
        }

        .msg{
            margin-top:12px;
            padding:10px 12px;
            border-radius:10px;
            font-weight:800;
        }
        .ok{background:#e8fff2;border:1px solid #b8f3cf;color:#116b39;}
        .bad{background:#ffecec;border:1px solid #f4b4b4;color:#8f1d1d;}

        .resultGrid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap:14px;
            margin-top: 14px;
        }
        .box{
            border:1px solid rgba(12,42,61,0.08);
            border-radius:12px;
            padding:12px 14px;
            background:#fbfdff;
        }
        .box .k{color:var(--muted);font-weight:800;font-size:13px;}
        .box .v{margin-top:6px;font-weight:900;font-size:16px;}

        @media(max-width:920px){
            .resultGrid{grid-template-columns:1fr;}
        }
        @media(max-width:720px){
            .sidebar{display:none;}
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
            <a href="DashboardServlet"><i class="fa-solid fa-table-columns"></i>Dashboard</a>
            <a href="addReservation.jsp"><i class="fa-solid fa-user-plus"></i>Add Reservation</a>
            <a href="ReservationsServlet"><i class="fa-solid fa-list"></i>Reservations</a>
            <a class="active" href="billCalculator.jsp"><i class="fa-solid fa-receipt"></i>Bill Calculator</a>
            <a href="help.jsp"><i class="fa-regular fa-circle-question"></i>Help</a>
        </nav>

        <div class="sidebar-footer">
            <div>Signed in as <b><%= username %></b></div>
            <a class="logout" href="LogoutServlet" title="Logout">
                <i class="fa-solid fa-right-from-bracket"></i>
            </a>
        </div>
    </aside>

    <!-- Main -->
    <main class="main">
        <h1 class="pageTitle">Bill Calculator</h1>
        <div class="subtitle">Calculate total bill using Reservation Code</div>

        <div class="card">
            <% if (msg != null) { %>
            <div class="msg ok"><i class="fa-solid fa-circle-check"></i> <%= msg %></div>
            <% } %>
            <% if (err != null) { %>
            <div class="msg bad"><i class="fa-solid fa-triangle-exclamation"></i> <%= err %></div>
            <% } %>

            <form action="BillCalculatorServlet" method="get">
                <label>Reservation Code</label>
                <input class="input" type="text" name="res_code" value="<%= resCode %>" placeholder="RES-001" required>
                <button class="btn" type="submit"><i class="fa-solid fa-calculator"></i> Calculate</button>
            </form>

            <% if (total != null && nights != null) { %>
                <div class="resultGrid">
                    <div class="box"><div class="k">Guest</div><div class="v"><%= guest %></div></div>
                    <div class="box"><div class="k">Room</div><div class="v"><%= room %></div></div>
                    <div class="box"><div class="k">Check-in</div><div class="v"><%= checkIn %></div></div>
                    <div class="box"><div class="k">Check-out</div><div class="v"><%= checkOut %></div></div>
                    <div class="box"><div class="k">Nights</div><div class="v"><%= nights %></div></div>
                    <div class="box"><div class="k">Total Amount</div><div class="v">$<%= String.format("%,.2f", total) %></div></div>
                </div>
            <% } %>
        </div>
    </main>

</div>
</body>
</html>