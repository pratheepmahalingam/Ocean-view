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
        :root{
            --nav:#071f2e;
            --nav2:#051826;
            --bg:#f2f6fb;
            --card:#ffffff;
            --text:#112232;
            --muted:#6f8090;
            --accentA:#1fd1f9;
            --accentB:#b621fe;
            --border: rgba(7,31,46,0.10);
            --shadow: 0 12px 28px rgba(7,31,46,0.10);
            --radius:16px;
        }

        *{ box-sizing:border-box; font-family: "Segoe UI", Arial, sans-serif; }
        body{ margin:0; background:var(--bg); color:var(--text); }
        .layout{ display:flex; min-height:100vh; }

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
            display:flex;
            align-items:center;
            gap:10px;
            padding:10px 10px 18px;
            font-weight:1000;
            letter-spacing:0.3px;
            font-size:20px;
        }
        .brand i{ color:#1fd1f9; }

        .nav{ margin-top:10px; }
        .nav a{
            display:flex;
            align-items:center;
            gap:12px;
            padding:12px 12px;
            border-radius:14px;
            color:#dbe7f1;
            text-decoration:none;
            margin:6px 6px;
            font-weight:800;
        }
        .nav a:hover{ background:rgba(255,255,255,0.10); }
        .nav a.active{
            background:rgba(255,255,255,0.12);
            border:1px solid rgba(255,255,255,0.12);
        }
        .nav i{ width:20px; text-align:center; }

        .sidebar-footer{
            position:absolute;
            left:14px; right:14px; bottom:16px;
            padding:12px 12px;
            border-top:1px solid rgba(255,255,255,0.12);
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:10px;
            font-size:13px;
            color:#b9cbdc;
        }
        .logout{
            color:#b9cbdc;
            text-decoration:none;
            padding:8px 10px;
            border-radius:12px;
        }
        .logout:hover{ background:rgba(255,255,255,0.10); }

        /* Main */
        .main{ flex:1; padding:26px 26px 40px; }

        .pageTitle{
            margin:0;
            font-size:40px;
            font-weight:1000;
            letter-spacing:0.2px;
        }
        .subtitle{
            margin-top:8px;
            color:var(--muted);
            font-weight:800;
        }

        .grid{
            margin-top:18px;
            display:grid;
            grid-template-columns: 1.15fr 0.85fr;
            gap:16px;
            align-items:start;
        }

        .card{
            background:var(--card);
            border:1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding:18px;
        }

        .sectionTitle{
            margin:0 0 12px;
            font-size:18px;
            font-weight:1000;
        }

        .helpItem{
            display:flex;
            gap:12px;
            padding:12px 12px;
            border-radius:14px;
            border:1px solid rgba(7,31,46,0.07);
            background:#fbfdff;
            margin-bottom:12px;
        }
        .helpIcon{
            width:42px;
            height:42px;
            border-radius:14px;
            display:flex;
            align-items:center;
            justify-content:center;
            background: linear-gradient(90deg, rgba(31,209,249,0.18), rgba(182,33,254,0.14));
            border:1px solid rgba(31,209,249,0.20);
            font-size:16px;
            color:#0b3f52;
            flex:0 0 auto;
        }
        .helpItem h3{
            margin:0;
            font-size:15px;
            font-weight:1000;
        }
        .helpItem p{
            margin:6px 0 0;
            color:var(--muted);
            font-weight:800;
            font-size:13px;
            line-height:1.5;
        }

        .tip{
            margin-top:12px;
            padding:12px 12px;
            border-radius:14px;
            background: linear-gradient(90deg, rgba(31,209,249,0.12), rgba(182,33,254,0.10));
            border:1px solid rgba(31,209,249,0.18);
            color:#113447;
            font-weight:900;
            font-size:13px;
        }

        /* Screenshot card */
        .shotWrap{
            margin-top:12px;
            border-radius:14px;
            overflow:hidden;
            border:1px solid rgba(7,31,46,0.10);
            background:#f7fbff;
        }
        .shotHeader{
            padding:12px 12px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:10px;
            font-weight:1000;
            border-bottom:1px solid rgba(7,31,46,0.08);
            background:#ffffff;
        }
        .shotHeader .tag{
            font-size:12px;
            font-weight:1000;
            padding:6px 10px;
            border-radius:999px;
            background: rgba(31,209,249,0.14);
            border:1px solid rgba(31,209,249,0.18);
            color:#0b3f52;
            white-space:nowrap;
        }

        .shotImg{
            width:100%;
            display:block;
            max-height:420px;
            object-fit:cover;
        }

        .shotHint{
            padding:12px 12px;
            color:var(--muted);
            font-weight:800;
            font-size:13px;
            line-height:1.6;
        }

        .quickLinks{
            display:grid;
            gap:10px;
            margin-top:10px;
        }
        .qbtn{
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:10px;
            text-decoration:none;
            padding:12px 12px;
            border-radius:14px;
            background:#fbfdff;
            border:1px solid rgba(7,31,46,0.08);
            color:var(--text);
            font-weight:1000;
        }
        .qbtn:hover{ background:#f4fbff; }
        .qbtn span{ color:var(--muted); font-weight:900; font-size:12px; }

        @media(max-width: 980px){
            .grid{ grid-template-columns: 1fr; }
        }
        @media(max-width: 720px){
            .sidebar{ display:none; }
            .main{ padding:18px; }
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
            <a href="AddReservationServlet"><i class="fa-solid fa-user-plus"></i>Add Reservation</a>
            <a href="ReservationsServlet"><i class="fa-solid fa-list"></i>Reservations</a>
            <a href="billCalculator.jsp"><i class="fa-solid fa-receipt"></i>Bill Calculator</a>
            <a class="active" href="help.jsp"><i class="fa-regular fa-circle-question"></i>Help</a>
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
        <h1 class="pageTitle">Help & System Guide</h1>
        <div class="subtitle">How to use Ocean View Resort Reservation System</div>

        <div class="grid">
            <!-- Left: Guide -->
            <div class="card">
                <div class="sectionTitle"><i class="fa-solid fa-book"></i> User Guide</div>

                <div class="helpItem">
                    <div class="helpIcon"><i class="fa-solid fa-table-columns"></i></div>
                    <div>
                        <h3>Dashboard</h3>
                        <p>View total reservations, active guests, estimated revenue, and recent bookings.</p>
                    </div>
                </div>

                <div class="helpItem">
                    <div class="helpIcon"><i class="fa-solid fa-user-plus"></i></div>
                    <div>
                        <h3>Add Reservation</h3>
                        <p>Create reservations with guest details, room type, check-in and check-out dates.</p>
                    </div>
                </div>

                <div class="helpItem">
                    <div class="helpIcon"><i class="fa-solid fa-list"></i></div>
                    <div>
                        <h3>Reservations</h3>
                        <p>Search by reservation code / name / phone, then edit or delete records.</p>
                    </div>
                </div>

                <div class="helpItem">
                    <div class="helpIcon"><i class="fa-solid fa-pen-to-square"></i></div>
                    <div>
                        <h3>Edit Reservation</h3>
                        <p>Update check-out dates. Bill calculator will show the updated total automatically.</p>
                    </div>
                </div>

                <div class="helpItem" style="margin-bottom:0;">
                    <div class="helpIcon"><i class="fa-solid fa-receipt"></i></div>
                    <div>
                        <h3>Bill Calculator</h3>
                        <p>Enter reservation code (RES-xxxx). Total = nights × price per night (updated dates included).</p>
                    </div>
                </div>

                <div class="tip">
                    <i class="fa-solid fa-shield-halved"></i>
                    Security Tip: Always use <b>Logout</b> after work. Session protection keeps your system safe.
                </div>
            </div>

            <!-- Right: Screenshot + Quick links -->
            <div class="card">
                <div class="sectionTitle"><i class="fa-solid fa-image"></i> System Screenshot</div>

                <div class="shotWrap">
                    <div class="shotHeader">
                        <div><i class="fa-solid fa-camera"></i> Ocean View System Preview</div>
                        <div class="tag">images/help-system.png</div>
                    </div>

                    <!-- ✅ Put your screenshot here: /images/help-system.png -->
                    <img class="shotImg" src="images/help-system.png" alt="System Screenshot"
                         onerror="this.style.display='none'; document.getElementById('noShot').style.display='block';"/>

                    <div id="noShot" class="shotHint" style="display:none;">
                        Screenshot not found.<br/>
                        Save your screenshot as <b>images/help-system.png</b> and reload this page.
                    </div>

                    <div class="shotHint">
                        How to add screenshot:
                        <br/>1) Take screenshot (Snipping Tool)
                        <br/>2) Save as: <b>help-system.png</b>
                        <br/>3) Put in: <b>WebContent/images/</b> (or <b>webapp/images/</b>)
                    </div>
                </div>

                <div class="sectionTitle" style="margin-top:14px;">
                    <i class="fa-solid fa-link"></i> Quick Links
                </div>

                <div class="quickLinks">
                    <a class="qbtn" href="DashboardServlet">
                        <div><i class="fa-solid fa-table-columns"></i> Dashboard</div>
                        <span>View KPIs</span>
                    </a>

                    <a class="qbtn" href="ReservationsServlet">
                        <div><i class="fa-solid fa-list"></i> Reservations</div>
                        <span>Search / Edit</span>
                    </a>

                    <a class="qbtn" href="billCalculator.jsp">
                        <div><i class="fa-solid fa-receipt"></i> Bill Calculator</div>
                        <span>Calculate Bill</span>
                    </a>
                </div>

            </div>
        </div>
    </main>

</div>
</body>
</html>