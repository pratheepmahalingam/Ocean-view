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

    @SuppressWarnings("unchecked")
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
            --bg1:#071a2b;
            --bg2:#081d33;
            --panel: rgba(255,255,255,0.10);
            --panel2: rgba(255,255,255,0.14);
            --border: rgba(255,255,255,0.18);
            --text:#eaf2ff;
            --muted: rgba(234,242,255,0.78);
            --accent:#26d0ce;
            --accent2:#6e58ff;
            --warn:#ff5a73;
            --shadow: 0 28px 70px rgba(0,0,0,0.45);
            --radius:18px;
        }

        *{ box-sizing:border-box; font-family:"Segoe UI", Arial, sans-serif; }

        body{
            margin:0;
            min-height:100vh;
            color: var(--text);
            background:
                radial-gradient(900px 500px at 15% 10%, rgba(38,208,206,0.25), transparent 60%),
                radial-gradient(900px 500px at 85% 90%, rgba(110,88,255,0.22), transparent 60%),
                linear-gradient(180deg, var(--bg1), var(--bg2));
        }

        .layout{ display:flex; min-height:100vh; }

        /* Sidebar */
        .sidebar{
            width:270px;
            padding:18px 14px;
            position:sticky; top:0; height:100vh;
            background: linear-gradient(180deg, rgba(255,255,255,0.10), rgba(255,255,255,0.05));
            border-right:1px solid rgba(255,255,255,0.10);
            backdrop-filter: blur(18px);
        }
        .brand{
            display:flex; align-items:center; gap:10px;
            padding:10px 10px 18px;
            font-weight:1000; font-size:20px;
        }
        .brand i{ color: var(--accent); }
        .nav a{
            display:flex; align-items:center; gap:12px;
            padding:12px;
            border-radius:14px;
            color: rgba(234,242,255,0.85);
            text-decoration:none;
            margin:6px;
            font-weight:900;
            border:1px solid transparent;
        }
        .nav a:hover{
            background: rgba(255,255,255,0.08);
            border-color: rgba(255,255,255,0.10);
        }
        .nav a.active{
            background: linear-gradient(90deg, rgba(38,208,206,0.20), rgba(110,88,255,0.18));
            border:1px solid rgba(255,255,255,0.12);
        }

        .sidebar-footer{
            position:absolute; left:14px; right:14px; bottom:16px;
            display:flex; align-items:center; justify-content:space-between;
            color: rgba(234,242,255,0.75);
            font-size:13px;
            padding:12px 12px;
            border-top:1px solid rgba(255,255,255,0.10);
        }
        .logout{
            color: rgba(234,242,255,0.80);
            text-decoration:none;
            padding:9px 10px;
            border-radius:12px;
            border:1px solid rgba(255,255,255,0.12);
        }
        .logout:hover{ background: rgba(255,255,255,0.08); }

        /* Main */
        .main{ flex:1; padding:26px 26px 40px; }
        .pageTitle{ margin:0; font-size:42px; font-weight:1000; }
        .subtitle{ margin-top:8px; color: var(--muted); font-weight:900; }

        /* Search */
        .searchWrap{
            margin-top:16px;
            width: min(720px, 100%);
            background: var(--panel);
            border:1px solid var(--border);
            border-radius: var(--radius);
            padding:12px 12px;
            display:flex;
            align-items:center;
            gap:10px;
            box-shadow: var(--shadow);
            backdrop-filter: blur(18px);
        }
        .searchWrap i{ color: rgba(234,242,255,0.75); }
        .prefix{
            font-weight:1000;
            color:#061018;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            padding:7px 10px;
            border-radius:12px;
            white-space:nowrap;
        }
        .searchWrap input{
            width:100%;
            border:none;
            outline:none;
            background: rgba(0,0,0,0.18);
            border:1px solid rgba(255,255,255,0.12);
            color:#fff;
            padding:12px 12px;
            border-radius:14px;
            font-weight:1000;
        }
        .searchWrap input::placeholder{ color: rgba(255,255,255,0.55); }
        .searchBtn{
            border:none;
            cursor:pointer;
            padding:12px 14px;
            border-radius:14px;
            font-weight:1000;
            color:#061018;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
        }
        .searchBtn:hover{ filter:brightness(1.05); transform: translateY(-1px); }
        .searchBtn:active{ transform: translateY(1px); }

        /* Cards */
        .grid{
            margin-top:18px;
            display:grid;
            grid-template-columns: repeat(2, minmax(280px, 1fr));
            gap:14px;
        }
        .card{
            background: var(--panel);
            border:1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            backdrop-filter: blur(18px);
            padding:14px 14px;
            position:relative;
            min-height:170px;
        }
        .chip{
            display:inline-flex;
            align-items:center;
            gap:8px;
            font-weight:1000;
            color:#061018;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            padding:7px 10px;
            border-radius:999px;
        }

        .editBtn, .deleteBtn{
            position:absolute;
            top:12px;
            padding:10px 12px;
            border-radius:14px;
            border:1px solid rgba(255,255,255,0.12);
            background: rgba(255,255,255,0.10);
            color: rgba(234,242,255,0.90);
            cursor:pointer;
            text-decoration:none;
        }
        .editBtn{ right:56px; }
        .deleteBtn{ right:12px; }
        .editBtn:hover{ background: rgba(38,208,206,0.16); }
        .deleteBtn:hover{ background: rgba(255,90,115,0.18); }

        .name{ margin:14px 0 8px; font-size:22px; font-weight:1000; }
        .line{ color: var(--muted); font-weight:900; margin:6px 0; }
        .room{ margin-top:10px; font-weight:1000; }
        .dates{ margin-top:8px; color: rgba(234,242,255,0.80); font-weight:900; }

        .empty{
            margin-top:18px;
            padding:14px;
            border-radius: var(--radius);
            background: rgba(255,255,255,0.08);
            border:1px dashed rgba(255,255,255,0.18);
            color: var(--muted);
            font-weight:1000;
        }

        @media(max-width: 980px){
            .grid{ grid-template-columns:1fr; }
        }
        @media(max-width: 760px){
            .sidebar{ display:none; }
            .main{ padding:18px; }
            .pageTitle{ font-size:34px; }
            .searchWrap{ flex-wrap:wrap; }
            .searchBtn{ width:100%; }
        }
    </style>
</head>

<body>
<div class="layout">

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

    <main class="main">
        <h1 class="pageTitle">Reservations</h1>
        <div class="subtitle">Search using reservation digits after RES-00</div>

        <!-- ✅ RES-00 fixed search bar -->
        <form class="searchWrap" action="ReservationsServlet" method="get" autocomplete="off">
            <i class="fa-solid fa-magnifying-glass"></i>
            <span class="prefix">RES-00</span>

            <input type="text"
                   name="q"
                   value="<%= q %>"
                   placeholder="Enter digits (ex: 12 => RES-0012)"
                   inputmode="numeric"
                   pattern="[0-9]*"
                   maxlength="6" />

            <button class="searchBtn" type="submit">
                <i class="fa-solid fa-arrow-right"></i> Search
            </button>
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
                <div class="card">
                    <div class="chip">
                        <i class="fa-solid fa-hashtag"></i>
                        <span><%= r.get("res_code") %></span>
                    </div>

                    <a class="editBtn" href="EditReservationServlet?id=<%= r.get("id") %>" title="Edit">
                        <i class="fa-regular fa-pen-to-square"></i>
                    </a>

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

                    <div class="room"><i class="fa-solid fa-bed"></i> <%= r.get("room_type") %></div>
                    <div class="dates"><i class="fa-regular fa-calendar"></i> <%= r.get("check_in") %> → <%= r.get("check_out") %></div>
                </div>
            <%
                    }
                }
            %>
        </div>
    </main>
</div>

<script>
    // ✅ digits only
    const inp = document.querySelector('input[name="q"]');
    if (inp){
        inp.addEventListener('input', () => {
            inp.value = inp.value.replace(/[^0-9]/g, '');
        });
    }
</script>

</body>
</html>