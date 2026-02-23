<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // ✅ Session protection
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View - New Reservation</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        :root{
            --nav:#0c2a3d;
            --nav2:#0a2232;
            --bg:#f3f6fb;
            --card:#ffffff;
            --muted:#6c7b88;
            --text:#13202c;
            --stroke: rgba(10, 34, 50, 0.10);
            --shadow: 0 12px 28px rgba(12,42,61,0.12);
            --radius:16px;
            --primary:#0f5f7a;
            --primary2:#0b3f52;
            --chip:#e9f2f7;
        }

        *{box-sizing:border-box;font-family: Arial, Helvetica, sans-serif;}
        body{margin:0;background:var(--bg);color:var(--text);}
        .layout{display:flex;min-height:100vh;}

        /* Sidebar */
        .sidebar{
            width:270px;
            background: linear-gradient(180deg, var(--nav), var(--nav2));
            color:#fff;
            padding:18px 14px;
            position:sticky;
            top:0;
            height:100vh;
        }
        .brand{
            display:flex;align-items:center;gap:10px;
            padding:10px 10px 18px;
            font-weight:900;font-size:20px;
            border-bottom:1px solid rgba(255,255,255,0.08);
            margin-bottom: 10px;
        }
        .brand i{color:#f3b04a;}
        .nav{margin-top:10px;}
        .nav a{
            display:flex;align-items:center;gap:12px;
            padding:12px 12px;border-radius:12px;
            color:#dbe7f1;text-decoration:none;
            margin:6px 6px;font-weight:700;
        }
        .nav a:hover{background:rgba(255,255,255,0.08);}
        .nav a.active{
            background: rgba(255,255,255,0.10);
            border:1px solid rgba(255,255,255,0.10);
        }
        .nav i{width:18px;text-align:center;}

        .sidebar-footer{
            position:absolute;left:14px;right:14px;bottom:16px;
            display:flex;align-items:center;justify-content:space-between;
            color:#b7c9d9;font-size:13px;
            padding:10px 12px;border-top:1px solid rgba(255,255,255,0.10);
        }
        .logout{
            color:#b7c9d9;text-decoration:none;
            padding:8px 10px;border-radius:10px;
        }
        .logout:hover{background:rgba(255,255,255,0.08);}

        /* Main */
        .main{flex:1;padding:26px 26px 40px;}
        .pageTitle{
            display:flex;align-items:center;gap:12px;
            font-size:40px;font-weight:900;margin:0;
            letter-spacing:0.2px;
        }
        .pageTitle .titleIcon{
            width:44px;height:44px;border-radius:14px;
            display:flex;align-items:center;justify-content:center;
            background: linear-gradient(180deg, var(--primary), var(--primary2));
            color:#fff;
            box-shadow: 0 10px 22px rgba(15,95,122,0.25);
        }
        .subtitle{margin-top:8px;color:var(--muted);font-size:15px;}

        /* Form card */
        .card{
            margin-top:18px;
            background: var(--card);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--stroke);
            padding: 22px;
            width: min(820px, 100%);
        }

        .grid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px 18px;
        }
        .full{grid-column: 1 / -1;}

        label{
            display:block;
            font-weight:800;
            color:#2a3844;
            margin: 6px 0 10px;
            font-size:14px;
        }

        .control{
            width:100%;
            padding: 12px 12px;
            border-radius: 12px;
            border: 1px solid rgba(10,34,50,0.16);
            background: #fbfdff;
            outline: none;
            font-size: 15px;
            transition: 0.15s ease;
        }
        .control:focus{
            border-color: rgba(15,95,122,0.55);
            box-shadow: 0 0 0 4px rgba(15,95,122,0.10);
            background:#fff;
        }

        .rowBtn{
            margin-top: 18px;
            display:flex;
            gap: 12px;
            align-items:center;
        }
        .btn{
            border:none;
            padding: 12px 18px;
            border-radius: 12px;
            background: linear-gradient(90deg, var(--primary2), var(--primary));
            color:#fff;
            font-weight:900;
            font-size: 15px;
            cursor:pointer;
            box-shadow: 0 10px 22px rgba(11,63,82,0.22);
        }
        .btn:hover{ filter: brightness(1.03); }
        .hint{
            color: var(--muted);
            font-weight: 700;
            font-size: 13px;
            background: var(--chip);
            padding: 10px 12px;
            border-radius: 999px;
        }

        .msg{
            margin-top: 14px;
            padding: 12px 12px;
            border-radius: 12px;
            font-weight: 800;
            border: 1px solid rgba(0,0,0,0.08);
        }
        .msg.ok{ background: rgba(25,135,84,0.10); color:#0f5132; border-color: rgba(25,135,84,0.22); }
        .msg.err{ background: rgba(220,53,69,0.10); color:#842029; border-color: rgba(220,53,69,0.22); }

        @media (max-width: 980px){
            .grid{ grid-template-columns: 1fr; }
        }
        @media (max-width: 720px){
            .sidebar{display:none;}
            .main{padding:18px;}
            .pageTitle{font-size:34px;}
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
            <a class="active" href="reservation.jsp"><i class="fa-solid fa-user-plus"></i>Add Reservation</a>
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

        <h1 class="pageTitle">
            <span class="titleIcon"><i class="fa-solid fa-user-plus"></i></span>
            New Reservation
        </h1>
        <div class="subtitle">Create a new guest reservation for Ocean View Resort</div>

        <!-- optional messages from servlet -->
        <%
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            if (success != null) {
        %>
            <div class="msg ok"><i class="fa-solid fa-circle-check"></i> <%= success %></div>
        <%
            } else if (error != null) {
        %>
            <div class="msg err"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div>
        <%
            }
        %>

        <section class="card">
            <!-- ✅ Change action to your servlet name if different -->
            <form action="AddReservationServlet" method="post">
                <div class="grid">

                    <div>
                        <label>Guest Name</label>
                        <input class="control" type="text" name="guestName" placeholder="Full name" required />
                    </div>

                    <div>
                        <label>Contact Number</label>
                        <input class="control" type="text" name="contactNumber" placeholder="+94 XX XXX XXXX" required />
                    </div>

                    <div class="full">
                        <label>Address</label>
                        <input class="control" type="text" name="address" placeholder="Guest address" required />
                    </div>

                    <div class="full">
                        <label>Room Type</label>
                        <select class="control" name="roomType" required>
                            <option value="Standard">Standard</option>
                            <option value="Deluxe">Deluxe</option>
                            <option value="Suite">Suite</option>
                            <option value="Family">Family</option>
                        </select>
                    </div>

                    <div>
                        <label>Check-in Date</label>
                        <input class="control" type="date" name="checkIn" required />
                    </div>

                    <div>
                        <label>Check-out Date</label>
                        <input class="control" type="date" name="checkOut" required />
                    </div>

                </div>

                <div class="rowBtn">
                    <button class="btn" type="submit">
                        <i class="fa-solid fa-plus"></i> Create Reservation
                    </button>
                    <div class="hint">
                        <i class="fa-solid fa-circle-info"></i>
                        Make sure dates are correct
                    </div>
                </div>
            </form>
        </section>

    </main>
</div>
</body>
</html>
