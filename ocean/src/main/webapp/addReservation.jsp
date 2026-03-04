<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ✅ Prevent direct access to JSP (force servlet)
    if (request.getAttribute("roomTypes") == null) {
        response.sendRedirect("AddReservationServlet");
        return;
    }

    String msg = (String) request.getAttribute("msg");
    String err = (String) request.getAttribute("err");

    String nextCode = (String) request.getAttribute("nextCode");
    if (nextCode == null) nextCode = "RES-0001";

    @SuppressWarnings("unchecked")
    List<Map<String, String>> roomTypes =
            (List<Map<String, String>>) request.getAttribute("roomTypes");
    if (roomTypes == null) roomTypes = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View - Add Reservation</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        :root{
            /* ✅ New Theme (Teal + Indigo + Glass) */
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

        *{ box-sizing:border-box; font-family: "Segoe UI", Arial, sans-serif; }

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

        /* ✅ Sidebar */
        .sidebar{
            width:270px;
            padding:18px 14px;
            position:sticky; top:0; height:100vh;

            background: linear-gradient(180deg, rgba(255,255,255,0.10), rgba(255,255,255,0.05));
            border-right: 1px solid rgba(255,255,255,0.10);
            backdrop-filter: blur(18px);
        }

        .brand{
            display:flex; align-items:center; gap:10px;
            padding:10px 10px 18px;
            font-weight:900;
            font-size:20px;
            letter-spacing:0.3px;
        }
        .brand i{ color: var(--accent); }

        .nav{ margin-top:6px; }
        .nav a{
            display:flex; align-items:center; gap:12px;
            padding:12px 12px;
            border-radius:14px;
            color: rgba(234,242,255,0.85);
            text-decoration:none;
            margin:6px 6px;
            font-weight:800;
            border: 1px solid transparent;
        }
        .nav a:hover{
            background: rgba(255,255,255,0.08);
            border-color: rgba(255,255,255,0.10);
        }
        .nav a.active{
            background: linear-gradient(90deg, rgba(38,208,206,0.20), rgba(110,88,255,0.18));
            border: 1px solid rgba(255,255,255,0.12);
        }
        .nav i{ width:18px; text-align:center; }

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

        /* ✅ Main */
        .main{
            flex:1;
            padding:26px 26px 40px;
        }

        .topbar{
            display:flex;
            align-items:flex-start;
            justify-content:space-between;
            gap:16px;
            flex-wrap:wrap;
        }

        .pageTitle{
            margin:0;
            font-size:42px;
            font-weight:1000;
            letter-spacing:0.4px;
        }
        .subtitle{
            margin-top:8px;
            color: var(--muted);
            font-weight:800;
        }

        /* ✅ Form Card */
        .formCard{
            margin-top:18px;
            width: min(920px, 100%);
            background: var(--panel);
            border:1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            backdrop-filter: blur(18px);
            padding:18px;
        }

        .msg{
            margin-top:12px;
            padding:12px 14px;
            border-radius:14px;
            font-weight:900;
            display:flex;
            align-items:center;
            gap:10px;
            border:1px solid rgba(255,255,255,0.14);
        }
        .ok{
            background: rgba(38,208,206,0.14);
            color: #d7fffe;
        }
        .bad{
            background: rgba(255,90,115,0.14);
            color: #ffe3e8;
            border-color: rgba(255,90,115,0.25);
        }

        .grid{
            margin-top:10px;
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap:14px;
        }

        .field{
            background: var(--panel2);
            border:1px solid rgba(255,255,255,0.14);
            border-radius: 16px;
            padding: 12px 12px;
        }

        label{
            display:block;
            font-weight:900;
            color: rgba(234,242,255,0.85);
            margin-bottom: 8px;
            font-size:13px;
        }

        .input, select{
            width:100%;
            border:none;
            outline:none;
            background: rgba(0,0,0,0.18);
            color: #fff;
            border:1px solid rgba(255,255,255,0.12);
            border-radius: 14px;
            padding: 12px 12px;
            font-size:15px;
        }

        .input::placeholder{ color: rgba(255,255,255,0.55); }

        select option{ color:#0c2a3d; }

        .readonly{
            background: rgba(0,0,0,0.30);
            border-color: rgba(255,255,255,0.10);
        }

        .helpText{
            margin-top:8px;
            color: rgba(234,242,255,0.70);
            font-weight:800;
            font-size:12px;
        }

        .phoneError{
            display:none;
            margin-top:10px;
            padding:10px 12px;
            border-radius:14px;
            background: rgba(255,90,115,0.14);
            border: 1px solid rgba(255,90,115,0.25);
            color:#ffe3e8;
            font-weight:900;
        }

        .actions{
            margin-top: 14px;
            display:flex;
            gap:12px;
            flex-wrap:wrap;
        }

        .btn{
            border:none;
            border-radius: 14px;
            padding: 12px 16px;
            font-weight:1000;
            font-size:15px;
            color:#061018;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            cursor:pointer;
            box-shadow: 0 16px 40px rgba(0,0,0,0.35);
            display:inline-flex;
            align-items:center;
            gap:10px;
        }
        .btn:hover{ filter: brightness(1.05); transform: translateY(-1px); }
        .btn:active{ transform: translateY(1px); }

        .btnGhost{
            text-decoration:none;
            border-radius: 14px;
            padding: 12px 16px;
            font-weight:1000;
            font-size:15px;
            color: rgba(234,242,255,0.90);
            background: rgba(255,255,255,0.10);
            border:1px solid rgba(255,255,255,0.14);
            display:inline-flex;
            align-items:center;
            gap:10px;
        }
        .btnGhost:hover{ background: rgba(255,255,255,0.14); }

        @media(max-width: 980px){
            .grid{ grid-template-columns: 1fr; }
        }
        @media(max-width: 760px){
            .sidebar{ display:none; }
            .main{ padding: 18px; }
            .pageTitle{ font-size: 34px; }
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
            <a class="active" href="AddReservationServlet"><i class="fa-solid fa-user-plus"></i>Add Reservation</a>
            <a href="ReservationsServlet"><i class="fa-solid fa-list"></i>Reservations</a>
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
        <div class="topbar">
            <div>
                <h1 class="pageTitle">Add Reservation</h1>
                <div class="subtitle">Create a new reservation record</div>
            </div>
        </div>

        <div class="formCard">

            <% if (msg != null) { %>
                <div class="msg ok"><i class="fa-solid fa-circle-check"></i> <%= msg %></div>
            <% } %>

            <% if (err != null) { %>
                <div class="msg bad"><i class="fa-solid fa-triangle-exclamation"></i> <%= err %></div>
            <% } %>

            <div id="dateError" class="msg bad" style="display:none;">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span id="dateErrorText">Invalid dates.</span>
            </div>

            <form action="AddReservationServlet" method="post"
                  onsubmit="return validatePhone() && validateDates();" autocomplete="off">

                <div class="grid">
                    <div class="field">
                        <label>Reservation Code</label>
                        <input class="input readonly" type="text" name="res_code" value="<%= nextCode %>" readonly>
                        <div class="helpText">Auto-generated code.</div>
                    </div>

                    <div class="field">
                        <label>Guest Name</label>
                        <input class="input" type="text" name="guest_name" placeholder="Enter guest name" required>
                    </div>

                    <div class="field">
                        <label>Address</label>
                        <input class="input" type="text" name="address" placeholder="Enter address" required>
                    </div>

                    <div class="field">
                        <label>Phone (10 digits)</label>
                        <input class="input" id="phone" type="text" name="phone"
                               inputmode="numeric" maxlength="10" placeholder="07XXXXXXXX" required>
                        <div id="phoneError" class="phoneError">Only 10 digits allowed.</div>
                    </div>

                    <div class="field">
                        <label>Room Type</label>
                        <select class="input" name="room_type_id" required>
                            <option value="">-- Select Room Type --</option>
                            <% for (Map<String, String> rt : roomTypes) { %>
                                <option value="<%= rt.get("id") %>">
                                    <%= rt.get("type_name") %> ( $<%= rt.get("price") %> / night )
                                </option>
                            <% } %>
                        </select>
                        <div class="helpText">Price depends on selected room type.</div>
                    </div>

                    <div class="field">
                        <label>Check-in Date</label>
                        <input class="input" id="checkIn" type="date" name="check_in" required>
                        <div class="helpText">Only today or future dates allowed.</div>
                    </div>

                    <div class="field">
                        <label>Check-out Date</label>
                        <input class="input" id="checkOut" type="date" name="check_out" required>
                        <div class="helpText">Must be after check-in date.</div>
                    </div>

                    <div class="field" style="display:flex;align-items:center;justify-content:center;">
                        <div style="color:rgba(234,242,255,0.72);font-weight:900;">
                            <i class="fa-solid fa-circle-info"></i>
                            Bill is calculated later in Bill Calculator.
                        </div>
                    </div>
                </div>

                <div class="actions">
                    <button class="btn" type="submit">
                        <i class="fa-solid fa-plus"></i> Save Reservation
                    </button>

                    <a class="btnGhost" href="ReservationsServlet">
                        <i class="fa-solid fa-list"></i> View Reservations
                    </a>
                </div>

            </form>
        </div>
    </main>
</div>

<script>
    // ✅ PHONE validation
    const phoneInput = document.getElementById("phone");
    const phoneError = document.getElementById("phoneError");

    phoneInput.addEventListener("input", () => {
        phoneInput.value = phoneInput.value.replace(/\D/g, "");
        if (phoneInput.value.length > 10) {
            phoneInput.value = phoneInput.value.slice(0, 10);
        }
        phoneError.style.display = "none";
    });

    function validatePhone(){
        const v = phoneInput.value.trim();
        if (v.length !== 10) {
            phoneError.textContent = "Phone number must be exactly 10 digits.";
            phoneError.style.display = "block";
            return false;
        }
        phoneError.style.display = "none";
        return true;
    }

    // ✅ DATE validation (disable past dates + error messages)
    const checkIn = document.getElementById("checkIn");
    const checkOut = document.getElementById("checkOut");
    const dateError = document.getElementById("dateError");
    const dateErrorText = document.getElementById("dateErrorText");

    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth()+1).padStart(2, "0");
    const dd = String(today.getDate()).padStart(2, "0");
    const todayStr = `${yyyy}-${mm}-${dd}`;

    checkIn.min = todayStr;
    checkOut.min = todayStr;

    checkIn.addEventListener("change", () => {
        if (!checkIn.value) return;
        checkOut.min = checkIn.value;
        if (checkOut.value && checkOut.value <= checkIn.value) {
            checkOut.value = "";
        }
        hideDateError();
    });

    checkOut.addEventListener("change", hideDateError);

    function showDateError(msg){
        dateErrorText.textContent = msg;
        dateError.style.display = "flex";
    }
    function hideDateError(){
        dateError.style.display = "none";
    }

    function validateDates(){
        hideDateError();

        if (!checkIn.value || !checkOut.value) return true;

        if (checkIn.value < todayStr){
            showDateError("Check-in date cannot be in the past. Please select today or a future date.");
            return false;
        }

        if (checkOut.value <= checkIn.value){
            showDateError("Check-out date must be after the check-in date.");
            return false;
        }
        return true;
    }
</script>

</body>
</html>