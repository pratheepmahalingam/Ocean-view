<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    // ✅ Session protection
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String q = (String) request.getAttribute("q");
    if (q == null) q = "";

    List<Map<String, String>> list =
            (List<Map<String, String>>) request.getAttribute("reservations");
    if (list == null) list = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View - Reservations</title>
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
            --accent:#0f5f7a;
            --border: rgba(12,42,61,0.10);
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
        .pageTitle{
            font-size:40px;
            font-weight:900;
            margin:0;
        }

        /* Search */
        .searchWrap{
            margin-top: 14px;
            width: min(560px, 95%);
            background:#fff;
            border:1px solid var(--border);
            border-radius: 10px;
            padding: 10px 12px;
            display:flex;
            align-items:center;
            gap:10px;
            box-shadow: 0 8px 18px rgba(12,42,61,0.06);
        }
        .searchWrap i{color:#7a8897;}
        .searchWrap input{
            border:none; outline:none; width:100%;
            font-size:15px;
        }

        /* Cards grid */
        .grid{
            margin-top: 24px;
            display:grid;
            grid-template-columns: repeat(2, minmax(260px, 1fr));
            gap: 18px;
        }
        .resCard{
            background:var(--card);
            border-radius:var(--radius);
            border:1px solid rgba(12,42,61,0.06);
            box-shadow: var(--shadow);
            padding: 16px 18px;
            position:relative;
            min-height: 150px;
        }
        .chip{
            display:inline-block;
            background:#eef3f7;
            color:#2a3a49;
            font-weight:800;
            font-size:12px;
            padding: 6px 10px;
            border-radius: 999px;
        }
        .deleteBtn{
            position:absolute;
            right:14px; top:14px;
            border:none;
            background:transparent;
            color:#647789;
            cursor:pointer;
            font-size:16px;
            padding:8px;
            border-radius:10px;
        }
        .deleteBtn:hover{background:#f1f4f7;color:#d33;}
        .name{
            margin: 12px 0 8px;
            font-size:22px;
            font-weight:900;
        }
        .line{
            color: var(--muted);
            font-weight:700;
            margin: 6px 0;
        }
        .room{
            margin-top: 10px;
            font-weight:900;
        }
        .dates{
            margin-top: 8px;
            color:#6b7c8d;
            font-weight:800;
        }
        .empty{
            margin-top:20px;
            color: var(--muted);
            font-weight:800;
        }

        @media (max-width: 980px){
            .grid{grid-template-columns: 1fr;}
        }
        @media (max-width: 720px){
            .sidebar{display:none;}
            .main{padding:18px;}
            .searchWrap{width:100%;}
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
        <h1 class="pageTitle">Reservations</h1>

        <!-- Search Form -->
        <form class="searchWrap" action="ReservationsServlet" method="get">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" name="q" value="<%= q %>"
                   placeholder="Search by name or reservation #" />
        </form>

        <div class="grid">
            <%
                if (list.isEmpty()) {
            %>
                <div class="empty">No reservations found.</div>
            <%
                } else {
                    for (Map<String, String> r : list) {
            %>
                <div class="resCard">
                    <span class="chip"><%= r.get("res_code") %></span>

                    <!-- Delete button -->
                    <form action="DeleteReservationServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= r.get("id") %>" />
                        <button class="deleteBtn" type="submit" title="Delete"
                                onclick="return confirm('Delete this reservation?');">
                            <i class="fa-regular fa-trash-can"></i>
                        </button>
                    </form>

                    <div class="name"><%= r.get("guest_name") %></div>

                    <div class="line"><%= r.get("address") %></div>
                    <div class="line"><%= r.get("phone") %></div>

                    <div class="room"><%= r.get("room_name") %></div>
                    <div class="dates"><%= r.get("check_in") %> → <%= r.get("check_out") %></div>
                </div>
            <%
                    }
                }
            %>
        </div>
    </main>

</div>
</body>
</html>