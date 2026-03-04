<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Object idObj = request.getAttribute("id");
    String id = (idObj == null) ? "" : String.valueOf(idObj);

    String res_code = (String) request.getAttribute("res_code");
    String guest_name = (String) request.getAttribute("guest_name");
    String address = (String) request.getAttribute("address");
    String phone = (String) request.getAttribute("phone");
    String check_in = (String) request.getAttribute("check_in");
    String check_out = (String) request.getAttribute("check_out");

    Integer room_type_id = (Integer) request.getAttribute("room_type_id");
    if (room_type_id == null) room_type_id = 0;

    @SuppressWarnings("unchecked")
    List<Map<String, String>> roomTypes =
            (List<Map<String, String>>) request.getAttribute("roomTypes");
    if (roomTypes == null) roomTypes = new ArrayList<>();

    if (res_code == null) res_code = "";
    if (guest_name == null) guest_name = "";
    if (address == null) address = "";
    if (phone == null) phone = "";
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

        .grid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap:14px;
            margin-top:10px;
        }
        .field{
            background:var(--panel2);
            border:1px solid rgba(255,255,255,0.14);
            border-radius:16px;
            padding:12px;
        }
        label{display:block;font-weight:1000;color:rgba(234,242,255,0.85);margin-bottom:8px;font-size:13px;}
        .input, select{
            width:100%;
            border:none; outline:none;
            background: rgba(0,0,0,0.18);
            border:1px solid rgba(255,255,255,0.12);
            color:#fff;
            padding:12px;
            border-radius:14px;
            font-size:15px;
            font-weight:900;
        }
        select option{ color:#0c2a3d; }

        .actions{
            margin-top:14px;
            display:flex;
            gap:12px;
            flex-wrap:wrap;
        }
        .btn{
            border:none;border-radius:14px;padding:12px 16px;
            font-weight:1000;font-size:15px;color:#061018;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            cursor:pointer;
            box-shadow: 0 16px 40px rgba(0,0,0,0.35);
            display:inline-flex;align-items:center;gap:10px;
        }
        .btn:hover{filter:brightness(1.05);transform:translateY(-1px);}
        .btn:active{transform:translateY(1px);}

        .btnGhost{
            text-decoration:none;
            border-radius:14px;padding:12px 16px;
            font-weight:1000;font-size:15px;
            color: rgba(234,242,255,0.90);
            background: rgba(255,255,255,0.10);
            border:1px solid rgba(255,255,255,0.14);
            display:inline-flex;align-items:center;gap:10px;
        }
        .btnGhost:hover{background: rgba(255,255,255,0.14);}

        @media(max-width:980px){.grid{grid-template-columns:1fr;}}
        @media(max-width:760px){.sidebar{display:none;}.main{padding:18px;}.pageTitle{font-size:34px;}}
    </style>
</head>

<body>
<div class="layout">

    <aside class="sidebar">
        <div class="brand"><i class="fa-solid fa-water"></i><span>Ocean View</span></div>
        <nav class="nav">
            <a href="DashboardServlet"><i class="fa-solid fa-table-columns"></i>Dashboard</a>
            <a href="addReservation.jsp"><i class="fa-solid fa-user-plus"></i>Add Reservation</a>
            <a class="active" href="ReservationsServlet"><i class="fa-solid fa-list"></i>Reservations</a>
            <a href="billCalculator.jsp"><i class="fa-solid fa-receipt"></i>Bill Calculator</a>
            <a href="help.jsp"><i class="fa-regular fa-circle-question"></i>Help</a>
        </nav>
        <div class="sidebar-footer">
            <div>Signed in as <b><%= username %></b></div>
            <a class="logout" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i></a>
        </div>
    </aside>

    <main class="main">
        <h1 class="pageTitle">Edit Reservation</h1>
        <div class="subtitle">Update reservation details (bill updates using new dates)</div>

        <div class="card">
            <form action="UpdateReservationServlet" method="post" autocomplete="off">
                <input type="hidden" name="id" value="<%= id %>">

                <div class="grid">
                    <div class="field">
                        <label>Reservation Code</label>
                        <input class="input" type="text" name="res_code" value="<%= res_code %>" required>
                    </div>

                    <div class="field">
                        <label>Guest Name</label>
                        <input class="input" type="text" name="guest_name" value="<%= guest_name %>" required>
                    </div>

                    <div class="field">
                        <label>Address</label>
                        <input class="input" type="text" name="address" value="<%= address %>" required>
                    </div>

                    <div class="field">
                        <label>Phone</label>
                        <input class="input" type="text" name="phone" value="<%= phone %>" required>
                    </div>

                    <div class="field">
                        <label>Room Type</label>
                        <select class="input" name="room_type_id" required>
                            <option value="">-- Select Room Type --</option>
                            <%
                                for (Map<String, String> rt : roomTypes) {
                                    int rid = Integer.parseInt(rt.get("id"));
                                    String selected = (rid == room_type_id) ? "selected" : "";
                            %>
                                <option value="<%= rid %>" <%= selected %>>
                                    <%= rt.get("type_name") %> ($<%= rt.get("price_per_night") %>/night)
                                </option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="field">
                        <label>Check-in Date</label>
                        <input class="input" type="date" name="check_in" value="<%= check_in %>" required>
                    </div>

                    <div class="field">
                        <label>Check-out Date</label>
                        <input class="input" type="date" name="check_out" value="<%= check_out %>" required>
                    </div>

                    <div class="field" style="display:flex;align-items:center;justify-content:center;">
                        <div style="color:rgba(234,242,255,0.72);font-weight:1000;">
                            <i class="fa-solid fa-circle-info"></i>
                            Total is recalculated from nights × price/night.
                        </div>
                    </div>
                </div>

                <div class="actions">
                    <button class="btn" type="submit">
                        <i class="fa-regular fa-floppy-disk"></i> Update Reservation
                    </button>

                    <a class="btnGhost" href="ReservationsServlet">
                        <i class="fa-solid fa-arrow-left"></i> Back
                    </a>
                </div>
            </form>
        </div>
    </main>

</div>
</body>
</html>