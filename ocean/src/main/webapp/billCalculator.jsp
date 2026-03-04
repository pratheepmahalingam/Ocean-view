<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String msg = (String) request.getAttribute("msg");
    String err = (String) request.getAttribute("err");

    String q = (String) request.getAttribute("q"); // digits only after 00
    if (q == null) q = "";

    String resCodeFull = (String) request.getAttribute("resCodeFull"); // RES-00xx
    if (resCodeFull == null) resCodeFull = "";

    String guest = (String) request.getAttribute("guest");
    String room = (String) request.getAttribute("room");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");
    Integer nights = (Integer) request.getAttribute("nights");
    Double total = (Double) request.getAttribute("total");
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
            --bg1:#071a2b; --bg2:#081d33;
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
            margin:0; min-height:100vh; color: var(--text);
            background:
                radial-gradient(900px 500px at 15% 10%, rgba(38,208,206,0.25), transparent 60%),
                radial-gradient(900px 500px at 85% 90%, rgba(110,88,255,0.22), transparent 60%),
                linear-gradient(180deg, var(--bg1), var(--bg2));
        }
        .layout{display:flex;min-height:100vh;}

        .sidebar{
            width:270px; padding:18px 14px;
            position:sticky; top:0; height:100vh;
            background: linear-gradient(180deg, rgba(255,255,255,0.10), rgba(255,255,255,0.05));
            border-right:1px solid rgba(255,255,255,0.10);
            backdrop-filter: blur(18px);
        }
        .brand{display:flex;align-items:center;gap:10px;padding:10px 10px 18px;font-weight:1000;font-size:20px;}
        .brand i{color:var(--accent);}
        .nav a{
            display:flex;align-items:center;gap:12px;padding:12px;border-radius:14px;
            color:rgba(234,242,255,0.85);text-decoration:none;margin:6px;font-weight:900;border:1px solid transparent;
        }
        .nav a:hover{background:rgba(255,255,255,0.08);border-color:rgba(255,255,255,0.10);}
        .nav a.active{
            background: linear-gradient(90deg, rgba(38,208,206,0.20), rgba(110,88,255,0.18));
            border:1px solid rgba(255,255,255,0.12);
        }
        .sidebar-footer{
            position:absolute;left:14px;right:14px;bottom:16px;
            display:flex;align-items:center;justify-content:space-between;
            color:rgba(234,242,255,0.75);font-size:13px;padding:12px;border-top:1px solid rgba(255,255,255,0.10);
        }
        .logout{
            color:rgba(234,242,255,0.80);text-decoration:none;padding:9px 10px;border-radius:12px;
            border:1px solid rgba(255,255,255,0.12);
        }
        .logout:hover{background:rgba(255,255,255,0.08);}

        .main{flex:1;padding:26px 26px 40px;}
        .pageTitle{margin:0;font-size:42px;font-weight:1000;}
        .subtitle{margin-top:8px;color:var(--muted);font-weight:900;}

        .card{
            margin-top:18px;
            width:min(920px,100%);
            background:var(--panel);
            border:1px solid var(--border);
            border-radius:var(--radius);
            box-shadow:var(--shadow);
            backdrop-filter: blur(18px);
            padding:18px;
        }

        .msg{
            margin-top:12px;
            padding:12px 14px;
            border-radius:14px;
            font-weight:1000;
            display:flex;
            align-items:center;
            gap:10px;
            border:1px solid rgba(255,255,255,0.14);
        }
        .ok{background: rgba(38,208,206,0.14); color:#d7fffe;}
        .bad{background: rgba(255,90,115,0.14); color:#ffe3e8; border-color: rgba(255,90,115,0.25);}

        label{display:block;font-weight:1000;color:rgba(234,242,255,0.85);margin:10px 0 8px;font-size:13px;}

        .codeRow{
            display:flex;
            align-items:center;
            gap:10px;
            width:100%;
            background: var(--panel2);
            border:1px solid rgba(255,255,255,0.14);
            border-radius:16px;
            padding:12px;
        }
        .prefix{
            font-weight:1000;
            color:#061018;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            padding:8px 10px;
            border-radius:12px;
            white-space:nowrap;
        }
        .codeRow input{
            width:100%;
            border:none;
            outline:none;
            background: rgba(0,0,0,0.18);
            border:1px solid rgba(255,255,255,0.12);
            color:#fff;
            padding:12px;
            border-radius:14px;
            font-size:15px;
            font-weight:1000;
        }
        .codeRow input::placeholder{ color: rgba(255,255,255,0.55); }

        .btn{
            margin-top:14px;
            border:none;border-radius:14px;padding:12px 16px;
            font-weight:1000;font-size:15px;color:#061018;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            cursor:pointer;
            box-shadow: 0 16px 40px rgba(0,0,0,0.35);
            display:inline-flex;align-items:center;gap:10px;
        }
        .btn:hover{filter:brightness(1.05);transform:translateY(-1px);}
        .btn:active{transform:translateY(1px);}

        .hint{
            margin-top:10px;
            color: var(--muted);
            font-weight:1000;
        }

        .resultGrid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap:14px;
            margin-top: 14px;
        }
        .box{
            background: var(--panel2);
            border:1px solid rgba(255,255,255,0.14);
            border-radius:16px;
            padding:12px 14px;
        }
        .k{color: var(--muted); font-weight:1000; font-size:13px;}
        .v{margin-top:6px; font-weight:1000; font-size:16px;}

        @media(max-width:980px){ .resultGrid{grid-template-columns:1fr;} }
        @media(max-width:760px){ .sidebar{display:none;}.main{padding:18px;}.pageTitle{font-size:34px;} }
    </style>
</head>

<body>
<div class="layout">

    <aside class="sidebar">
        <div class="brand"><i class="fa-solid fa-water"></i><span>Ocean View</span></div>
        <nav class="nav">
            <a href="DashboardServlet"><i class="fa-solid fa-table-columns"></i>Dashboard</a>
            <a href="addReservation.jsp"><i class="fa-solid fa-user-plus"></i>Add Reservation</a>
            <a href="ReservationsServlet"><i class="fa-solid fa-list"></i>Reservations</a>
            <a class="active" href="billCalculator.jsp"><i class="fa-solid fa-receipt"></i>Bill Calculator</a>
            <a href="help.jsp"><i class="fa-regular fa-circle-question"></i>Help</a>
        </nav>
        <div class="sidebar-footer">
            <div>Signed in as <b><%= username %></b></div>
            <a class="logout" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i></a>
        </div>
    </aside>

    <main class="main">
        <h1 class="pageTitle">Bill Calculator</h1>
        <div class="subtitle">Enter digits after RES-00 to calculate bill</div>

        <div class="card">
            <% if (msg != null) { %>
                <div class="msg ok"><i class="fa-solid fa-circle-check"></i> <%= msg %></div>
            <% } %>
            <% if (err != null) { %>
                <div class="msg bad"><i class="fa-solid fa-triangle-exclamation"></i> <%= err %></div>
            <% } %>

            <form action="BillCalculatorServlet" method="get" autocomplete="off">
                <label>Reservation Code</label>

                <div class="codeRow">
                    <span class="prefix">RES-00</span>
                    <input type="text"
                           name="q"
                           value="<%= q %>"
                           placeholder="ex: 12 => RES-0012"
                           inputmode="numeric"
                           pattern="[0-9]*"
                           maxlength="6"
                           required />
                </div>

                <button class="btn" type="submit">
                    <i class="fa-solid fa-calculator"></i> Calculate
                </button>

                <% if (!resCodeFull.isEmpty()) { %>
                    <div class="hint">Searching: <span style="color:var(--accent);font-weight:1000;"><%= resCodeFull %></span></div>
                <% } %>
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