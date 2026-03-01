<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Data from servlet
    Object idObj = request.getAttribute("id");
    String id = (idObj == null) ? "" : String.valueOf(idObj);

    String res_code = (String) request.getAttribute("res_code");
    String guest_name = (String) request.getAttribute("guest_name");
    String address = (String) request.getAttribute("address");
    String phone = (String) request.getAttribute("phone");
    String room_name = (String) request.getAttribute("room_name");
    String check_in = (String) request.getAttribute("check_in");
    String check_out = (String) request.getAttribute("check_out");
    Object totalObj = request.getAttribute("total_amount");
    String total_amount = (totalObj == null) ? "0" : String.valueOf(totalObj);

    if (res_code == null) res_code = "";
    if (guest_name == null) guest_name = "";
    if (address == null) address = "";
    if (phone == null) phone = "";
    if (room_name == null) room_name = "";
    if (check_in == null) check_in = "";
    if (check_out == null) check_out = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View - Edit Reservation</title>
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

        /* Sidebar */
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

        /* Main */
        .main{flex:1;padding:26px 26px 40px;}
        .pageTitle{font-size:40px;font-weight:900;margin:0;}
        .subtitle{margin-top:8px;color:var(--muted);font-weight:700;}

        .formCard{
            margin-top:18px;
            background:var(--card);
            border-radius:var(--radius);
            border:1px solid rgba(12,42,61,0.06);
            box-shadow: var(--shadow);
            padding:18px;
            width: min(860px, 100%);
        }

        .row{display:grid;grid-template-columns: 1fr 1fr;gap:14px;}
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

        .btnRow{display:flex;gap:10px;flex-wrap:wrap;margin-top:16px;}
        .btn{
            border:none;
            border-radius:10px;
            padding:12px 14px;
            font-weight:900;
            font-size:15px;
            color:#fff;
            background: linear-gradient(90deg, #0b3f52, var(--accent));
            cursor:pointer;
        }
        .btn2{
            border:1px solid rgba(12,42,61,0.16);
            border-radius:10px;
            padding:12px 14px;
            font-weight:900;
            font-size:15px;
            background:#fff;
            cursor:pointer;
            text-decoration:none;
            color:#203040;
            display:inline-flex;
            align-items:center;
            gap:8px;
        }
        .btn2:hover{background:#f7fafc;}

        @media(max-width:920px){
            .row{grid-template-columns:1fr;}
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
            <a class="active" href="ReservationsServlet"><i class="fa-solid fa-list"></i>Reservations</a>
            <a href="billCalculator.jsp"><i class="fa-solid fa-receipt"></i>Bill Calculator</a>
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
        <h1 class="pageTitle">Edit Reservation</h1>
        <div class="subtitle">Update reservation details</div>

        <div class="formCard">
            <form action="UpdateReservationServlet" method="post">
                <input type="hidden" name="id" value="<%= id %>">

                <div class="row">
                    <div>
                        <label>Reservation Code</label>
                        <input class="input" type="text" name="res_code" value="<%= res_code %>" required>
                    </div>
                    <div>
                        <label>Guest Name</label>
                        <input class="input" type="text" name="guest_name" value="<%= guest_name %>" required>
                    </div>
                </div>

                <div class="row">
                    <div>
                        <label>Address</label>
                        <input class="input" type="text" name="address" value="<%= address %>" required>
                    </div>
                    <div>
                        <label>Phone</label>
                        <input class="input" type="text" name="phone" value="<%= phone %>" required>
                    </div>
                </div>

                <div class="row">
                    <div>
                        <label>Room Name</label>
                        <input class="input" type="text" name="room_name" value="<%= room_name %>" required>
                    </div>
                    <div>
                        <label>Total Amount ($)</label>
                        <input class="input" type="number" step="0.01" name="total_amount" value="<%= total_amount %>" required>
                    </div>
                </div>

                <div class="row">
                    <div>
                        <label>Check-in</label>
                        <input class="input" type="date" name="check_in" value="<%= check_in %>" required>
                    </div>
                    <div>
                        <label>Check-out</label>
                        <input class="input" type="date" name="check_out" value="<%= check_out %>" required>
                    </div>
                </div>

                <div class="btnRow">
                    <button class="btn" type="submit">
                        <i class="fa-regular fa-floppy-disk"></i> Update Reservation
                    </button>

                    <a class="btn2" href="ReservationsServlet">
                        <i class="fa-solid fa-arrow-left"></i> Back
                    </a>
                </div>
            </form>
        </div>
    </main>

</div>
</body>
</html>