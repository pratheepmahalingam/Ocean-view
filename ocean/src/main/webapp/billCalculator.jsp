<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) { response.sendRedirect("login.jsp"); return; }

    String msg = (String) request.getAttribute("msg");
    String err = (String) request.getAttribute("err");

    String q = (String) request.getAttribute("q");
    if (q == null) q = "";

    String resCodeFull = (String) request.getAttribute("resCodeFull");
    if (resCodeFull == null) resCodeFull = "";

    String hotelName = (String) request.getAttribute("hotelName");
    String hotelAddress = (String) request.getAttribute("hotelAddress");
    String hotelPhone = (String) request.getAttribute("hotelPhone");
    String hotelEmail = (String) request.getAttribute("hotelEmail");
    if (hotelName == null) hotelName = "Ocean View Resort";
    if (hotelAddress == null) hotelAddress = "Galle, Sri Lanka";
    if (hotelPhone == null) hotelPhone = "+94 0123456789";
    if (hotelEmail == null) hotelEmail = "support@oceanviewresort.lk";

    String guest = (String) request.getAttribute("guest");
    String guestPhone = (String) request.getAttribute("guestPhone");
    String guestAddress = (String) request.getAttribute("guestAddress");

    String room = (String) request.getAttribute("room");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");

    Integer nights = (Integer) request.getAttribute("nights");
    Double pricePerNight = (Double) request.getAttribute("pricePerNight");
    Double subtotal = (Double) request.getAttribute("subtotal");
    Double total = (Double) request.getAttribute("total");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View - Bill</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

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
            width:270px; padding:18px 14px; position:sticky; top:0; height:100vh;
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
            margin-top:18px; width:min(980px,100%);
            background:var(--panel); border:1px solid var(--border);
            border-radius:var(--radius); box-shadow:var(--shadow);
            backdrop-filter: blur(18px); padding:18px;
        }
        .msg{
            margin-top:12px; padding:12px 14px; border-radius:14px;
            font-weight:1000; display:flex; align-items:center; gap:10px;
            border:1px solid rgba(255,255,255,0.14);
        }
        .ok{background: rgba(38,208,206,0.14); color:#d7fffe;}
        .bad{background: rgba(255,90,115,0.14); color:#ffe3e8; border-color: rgba(255,90,115,0.25);}

        label{display:block;font-weight:1000;color:rgba(234,242,255,0.85);margin:10px 0 8px;font-size:13px;}
        .codeRow{
            display:flex; align-items:center; gap:10px; width:100%;
            background: var(--panel2); border:1px solid rgba(255,255,255,0.14);
            border-radius:16px; padding:12px;
        }
        .prefix{
            font-weight:1000; color:#061018;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            padding:8px 10px; border-radius:12px; white-space:nowrap;
        }
        .codeRow input{
            width:100%; border:none; outline:none;
            background: rgba(0,0,0,0.18);
            border:1px solid rgba(255,255,255,0.12);
            color:#fff; padding:12px; border-radius:14px;
            font-size:15px; font-weight:1000;
        }

        .actions{display:flex; gap:10px; flex-wrap:wrap; margin-top:14px;}
        .btn{
            border:none;border-radius:14px;padding:12px 16px;
            font-weight:1000;font-size:15px;color:#061018;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            cursor:pointer; box-shadow: 0 16px 40px rgba(0,0,0,0.35);
            display:inline-flex;align-items:center;gap:10px;
        }
        .btnGhost{
            border:1px solid rgba(255,255,255,0.16);
            border-radius:14px; padding:12px 16px;
            font-weight:1000; font-size:15px;
            color:rgba(234,242,255,0.92);
            background: rgba(0,0,0,0.18);
            cursor:pointer;
            display:inline-flex;align-items:center;gap:10px;
            text-decoration:none;
        }
        .btnGhost:hover{background: rgba(255,255,255,0.10);}

        /* Bill preview */
        .bill{ margin-top:18px; background: rgba(255,255,255,0.10); border:1px solid rgba(255,255,255,0.16);
              border-radius:18px; padding:18px; }
        .billTop{ display:flex; justify-content:space-between; gap:12px; flex-wrap:wrap;
                  padding-bottom:12px; border-bottom:1px dashed rgba(255,255,255,0.20); }
        .billTop h2{ margin:0; font-size:24px; font-weight:1000; }
        .hotelInfo{ margin-top:6px; color:rgba(234,242,255,0.82); font-weight:900; font-size:13px; line-height:1.45; }
        .hotelInfo i{ width:16px; color:rgba(38,208,206,0.95); margin-right:6px; }
        .billMeta{ text-align:right; font-weight:900; color:rgba(234,242,255,0.86); }
        .billMeta .small{ color:rgba(234,242,255,0.70); font-size:12px; margin-top:4px; }

        .billGrid{ margin-top:12px; display:grid; grid-template-columns:1fr 1fr; gap:12px; }
        .bBox{ background:rgba(0,0,0,0.16); border:1px solid rgba(255,255,255,0.12); border-radius:16px; padding:12px 14px; }
        .k{ color:var(--muted); font-weight:1000; font-size:12px; text-transform:uppercase; letter-spacing:.25px; }
        .v{ margin-top:6px; font-weight:1000; font-size:15px; }

        .items{ margin-top:14px; border-radius:16px; overflow:hidden; border:1px solid rgba(255,255,255,0.12); }
        .items table{ width:100%; border-collapse:collapse; background:rgba(0,0,0,0.14); }
        .items th, .items td{ padding:12px; border-bottom:1px solid rgba(255,255,255,0.08); }
        .items th{ font-size:12px; color:rgba(234,242,255,0.72); text-transform:uppercase; letter-spacing:.3px; background:rgba(255,255,255,0.04); }
        .items td{ font-weight:950; color:rgba(234,242,255,0.92); }
        .right{text-align:right;}

        .totalRow{ margin-top:14px; display:flex; justify-content:flex-end; }
        .totalBox{ width:min(380px,100%); background:rgba(0,0,0,0.18); border:1px solid rgba(255,255,255,0.14);
                   border-radius:16px; padding:12px 14px; }
        .totalLine{ display:flex; justify-content:space-between; padding:8px 0; font-weight:950; }
        .totalLine.small{ color:rgba(234,242,255,0.80); font-weight:900; }
        .grand{ border-top:1px dashed rgba(255,255,255,0.22); margin-top:8px; padding-top:10px; font-size:18px; }

        .billFooter{
            margin-top:12px; padding-top:12px; border-top:1px dashed rgba(255,255,255,0.20);
            color:rgba(234,242,255,0.76); font-weight:900; font-size:12px;
            display:flex; justify-content:space-between; flex-wrap:wrap; gap:10px;
        }

        @media(max-width:980px){ .billGrid{grid-template-columns:1fr;} }
        @media(max-width:760px){ .sidebar{display:none;} .main{padding:18px;} .pageTitle{font-size:34px;} }
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
            <a class="active" href="billCalculator.jsp"><i class="fa-solid fa-receipt"></i>Bill</a>
            <a href="help.jsp"><i class="fa-regular fa-circle-question"></i>Help</a>
        </nav>
        <div class="sidebar-footer">
            <div>Signed in as <b><%= username %></b></div>
            <a class="logout" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i></a>
        </div>
    </aside>

    <main class="main">
        <h1 class="pageTitle">Bill</h1>
        <div class="subtitle">Enter digits after RES-00 to generate bill</div>

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
                    <input type="text" name="q" value="<%= q %>"
                           placeholder="ex: 12 => RES-0012"
                           inputmode="numeric" pattern="[0-9]*" maxlength="6" required />
                </div>

                <div class="actions">
                    <button class="btn" type="submit">
                        <i class="fa-solid fa-file-invoice-dollar"></i> Generate Bill
                    </button>

                    <% if (total != null && nights != null) { %>
                        <!-- ✅ Show Bill (ONLY shows bill, no print option) -->
                        <a class="btnGhost" href="PrintBillServlet?action=show&q=<%= q %>" target="_blank">
                            <i class="fa-solid fa-eye"></i> Show Bill
                        </a>

                        <!-- ✅ Print Bill (downloads bill file) -->
                        <a class="btnGhost" href="PrintBillServlet?action=download&q=<%= q %>">
                            <i class="fa-solid fa-print"></i> Print Bill
                        </a>
                    <% } %>
                </div>
            </form>

            <% if (total != null && nights != null) { %>
                <!-- Bill preview -->
                <div class="bill">
                    <div class="billTop">
                        <div>
                            <h2><%= hotelName %> — Bill</h2>
                            <div class="hotelInfo">
                                <div><i class="fa-solid fa-location-dot"></i><%= hotelAddress %></div>
                                <div><i class="fa-solid fa-phone"></i><%= hotelPhone %></div>
                                <div><i class="fa-solid fa-envelope"></i><%= hotelEmail %></div>
                            </div>
                        </div>

                        <div class="billMeta">
                            <div><span style="opacity:.75;">Reservation:</span> <b><%= resCodeFull %></b></div>
                            <div class="small">
                                Generated by: <%= username %><br/>
                                Date: <%= java.time.LocalDate.now().toString() %>
                            </div>
                        </div>
                    </div>

                    <div class="billGrid">
                        <div class="bBox"><div class="k">Guest Name</div><div class="v"><%= guest %></div></div>
                        <div class="bBox"><div class="k">Guest Phone</div><div class="v"><%= (guestPhone==null||guestPhone.trim().isEmpty()) ? "-" : guestPhone %></div></div>
                        <div class="bBox"><div class="k">Guest Address</div><div class="v"><%= (guestAddress==null||guestAddress.trim().isEmpty()) ? "-" : guestAddress %></div></div>
                        <div class="bBox"><div class="k">Room Type</div><div class="v"><%= room %></div></div>
                        <div class="bBox"><div class="k">Check-in</div><div class="v"><%= checkIn %></div></div>
                        <div class="bBox"><div class="k">Check-out</div><div class="v"><%= checkOut %></div></div>
                    </div>

                    <div class="items">
                        <table>
                            <thead>
                                <tr>
                                    <th>Description</th>
                                    <th class="right">Nights</th>
                                    <th class="right">Price / Night</th>
                                    <th class="right">Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Room charge (<%= room %>)</td>
                                    <td class="right"><%= nights %></td>
                                    <td class="right">$<%= String.format("%,.2f", pricePerNight) %></td>
                                    <td class="right">$<%= String.format("%,.2f", subtotal) %></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="totalRow">
                        <div class="totalBox">
                            <div class="totalLine small"><span>Subtotal</span><span>$<%= String.format("%,.2f", subtotal) %></span></div>
                            <div class="totalLine small"><span>Taxes</span><span>$0.00</span></div>
                            <div class="totalLine grand"><span>Total</span><span>$<%= String.format("%,.2f", total) %></span></div>
                        </div>
                    </div>

                    <div class="billFooter">
                        <div><%= hotelName %> • <%= hotelAddress %></div>
                        <div>Support: <%= hotelPhone %> • <%= hotelEmail %></div>
                    </div>
                </div>
            <% } %>

        </div>
    </main>

</div>

<script>
    const inp = document.querySelector('input[name="q"]');
    if (inp){
        inp.addEventListener('input', () => {
            inp.value = inp.value.replace(/[^0-9]/g, '');
        });
    }
</script>

</body>
</html>