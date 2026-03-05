<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // ✅ Session protection (user must login to use guided mode)
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Ocean View - Help (Guided Mode)</title>

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
            --shadow: 0 12px 30px rgba(7,31,46,0.10);
        }

        *{ box-sizing:border-box; font-family: "Segoe UI", Arial, sans-serif; }

        body{
            margin:0;
            background: radial-gradient(1200px 500px at 20% 0%, rgba(31,209,249,.20), transparent 60%),
                        radial-gradient(1000px 500px at 85% 10%, rgba(182,33,254,.18), transparent 60%),
                        var(--bg);
            color:var(--text);
        }

        .topbar{
            height:64px;
            background: linear-gradient(135deg, var(--nav), var(--nav2));
            color:#fff;
            display:flex;
            align-items:center;
            padding:0 18px;
            gap:12px;
            position:sticky;
            top:0;
            z-index:10;
            box-shadow: 0 8px 20px rgba(0,0,0,0.18);
        }

        .brand{
            display:flex;
            align-items:center;
            gap:10px;
            font-weight:700;
            letter-spacing:.2px;
        }
        .brand i{ color: #bff7ff; }

        .spacer{ flex:1; }

        /* ✅ Back button (go to DashboardServlet) */
        .back-btn{
            display:flex;
            align-items:center;
            gap:8px;
            padding:10px 14px;
            border-radius:999px;
            border:1px solid rgba(255,255,255,0.18);
            background: rgba(255,255,255,0.10);
            color:#fff;
            font-weight:800;
            cursor:pointer;
            text-decoration:none;
            transition:.15s ease;
            margin-right: 10px;
        }
        .back-btn:hover{
            background: rgba(255,255,255,0.18);
            transform: translateY(-1px);
        }

        .userchip{
            display:flex;
            align-items:center;
            gap:10px;
            padding:8px 12px;
            border-radius:999px;
            background: rgba(255,255,255,0.10);
            border: 1px solid rgba(255,255,255,0.15);
        }
        .userchip .dot{
            width:10px; height:10px; border-radius:50%;
            background: linear-gradient(135deg, var(--accentA), var(--accentB));
        }

        .wrap{
            max-width: 1200px;
            margin: 18px auto 40px;
            padding: 0 14px;
        }

        .grid{
            display:grid;
            grid-template-columns: 380px 1fr;
            gap: 16px;
            align-items:start;
        }

        .card{
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: var(--shadow);
            overflow:hidden;
        }

        .card-hd{
            display:flex;
            align-items:center;
            gap:10px;
            padding: 14px 16px;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(180deg, rgba(31,209,249,0.10), rgba(182,33,254,0.06));
            font-weight: 700;
        }
        .card-hd i{ color: var(--nav); }

        /* Topics list */
        .topics{ padding: 10px; }
        .topic{
            width:100%;
            border: 1px solid var(--border);
            background: #fff;
            border-radius: 14px;
            padding: 12px 12px;
            display:flex;
            align-items:center;
            gap:12px;
            cursor:pointer;
            transition: .15s ease;
            margin-bottom: 10px;
            text-align:left;
        }
        .topic:hover{
            transform: translateY(-1px);
            box-shadow: 0 10px 22px rgba(7,31,46,0.08);
        }
        .topic.active{
            border-color: rgba(31,209,249,0.55);
            background: linear-gradient(90deg, rgba(31,209,249,0.16), rgba(182,33,254,0.10));
        }
        .topic .icon{
            width:44px; height:44px;
            border-radius: 14px;
            display:grid;
            place-items:center;
            background: linear-gradient(135deg, rgba(31,209,249,0.20), rgba(182,33,254,0.14));
            border: 1px solid rgba(7,31,46,0.08);
            flex: 0 0 auto;
        }
        .topic .icon i{ color: var(--nav); }
        .topic .t{ display:flex; flex-direction:column; gap:2px; }
        .topic .t b{ font-size: 16px; }
        .topic .t span{ font-size: 13px; color: var(--muted); line-height: 1.25; }

        /* Right content */
        .content{ padding: 14px 16px 18px; }

        .shot{
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow:hidden;
            background:#fff;
        }
        .shot-hd{
            display:flex;
            align-items:center;
            gap:10px;
            padding: 12px 12px;
            border-bottom: 1px solid var(--border);
            font-weight: 700;
        }
        .shot-hd i{ color: var(--nav); }
        .shot img{
            display:block;
            width:100%;
            height:auto;
            background:#eef3f8;
        }

        .steps{
            padding: 12px 12px 14px;
            border-top: 1px solid var(--border);
        }
        .steps h3{ margin: 0 0 8px; font-size: 18px; }
        .steps ol{ margin: 0; padding-left: 20px; color: var(--text); }
        .steps li{ margin: 6px 0; color: var(--text); font-weight: 600; }
        .steps p{ margin: 10px 0 0; color: var(--muted); font-weight: 600; }

        /* Quick links */
        .qlinks{ margin-top: 14px; padding: 10px; }
        .qitem{
            display:flex;
            align-items:center;
            justify-content:space-between;
            padding: 12px 12px;
            border: 1px solid var(--border);
            border-radius: 14px;
            margin-bottom: 10px;
            background: #fff;
            cursor:pointer;
            transition: .15s ease;
        }
        .qitem:hover{
            box-shadow: 0 10px 22px rgba(7,31,46,0.08);
            transform: translateY(-1px);
        }
        .qitem .left{
            display:flex; align-items:center; gap:10px;
            font-weight: 700;
        }
        .qitem .left i{ color: var(--nav); }
        .qitem small{ color: var(--muted); font-weight: 700; }

        @media (max-width: 980px){
            .grid{ grid-template-columns: 1fr; }
        }
    </style>
</head>

<body>
    <div class="topbar">
        <div class="brand">
            <i class="fa-solid fa-book-open"></i>
            <span>Ocean View Resort • Help (Guided Mode)</span>
        </div>

        <div class="spacer"></div>

        <!-- ✅ Back button → DashboardServlet -->
        <a class="back-btn" href="DashboardServlet">
            <i class="fa-solid fa-arrow-left"></i>
            Back
        </a>

        <div class="userchip" title="Logged in user">
            <span class="dot"></span>
            <span><%= username %></span>
        </div>
    </div>

    <div class="wrap">
        <div class="grid">

            <!-- LEFT: Topics (Security/Logout REMOVED) -->
            <div class="card">
                <div class="card-hd">
                    <i class="fa-solid fa-list"></i>
                    <span>Topics</span>
                </div>

                <div class="topics">
                    <button class="topic active" data-topic="login" type="button">
                        <div class="icon"><i class="fa-solid fa-right-to-bracket"></i></div>
                        <div class="t">
                            <b>Login</b>
                            <span>How to login and access the system dashboard.</span>
                        </div>
                    </button>

                    <button class="topic" data-topic="dashboard" type="button">
                        <div class="icon"><i class="fa-solid fa-chart-line"></i></div>
                        <div class="t">
                            <b>Dashboard</b>
                            <span>View totals, active today, room types, revenue and recent reservations.</span>
                        </div>
                    </button>

                    <button class="topic" data-topic="add" type="button">
                        <div class="icon"><i class="fa-solid fa-user-plus"></i></div>
                        <div class="t">
                            <b>Add Reservation</b>
                            <span>Create a new booking with guest details, room type and dates.</span>
                        </div>
                    </button>

                    <button class="topic" data-topic="reservations" type="button">
                        <div class="icon"><i class="fa-solid fa-list-check"></i></div>
                        <div class="t">
                            <b>Reservations (Search / Delete)</b>
                            <span>Search reservation and delete records if needed.</span>
                        </div>
                    </button>

                    <button class="topic" data-topic="bill" type="button">
                        <div class="icon"><i class="fa-solid fa-receipt"></i></div>
                        <div class="t">
                            <b>Bill Calculator</b>
                            <span>Calculate total bill using reservation code.</span>
                        </div>
                    </button>
                </div>
            </div>

            <!-- RIGHT: Content -->
            <div>
                <div class="card">
                    <div class="card-hd">
                        <i class="fa-solid fa-circle-info"></i>
                        <span id="topicTitle">Login</span>
                    </div>

                    <div class="content">
                        <div class="shot">
                            <div class="shot-hd">
                                <i class="fa-solid fa-image"></i>
                                <span>Screenshot</span>
                            </div>
                            <img id="topicImage" src="images/help-login.png" alt="Help screenshot"/>
                            <div class="steps">
                                <h3 id="stepsTitle">How to login</h3>
                                <ol id="stepsList">
                                    <li>Open Home page and click Login.</li>
                                    <li>Enter your Username and Password.</li>
                                    <li>Click Sign In.</li>
                                    <li>If details are correct, you will enter the Dashboard.</li>
                                </ol>
                                <p id="stepsNote"></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick links -->
                <div class="card" style="margin-top:14px;">
                    <div class="card-hd">
                        <i class="fa-solid fa-link"></i>
                        <span>Quick Links</span>
                    </div>
                    <div class="qlinks">
                        <div class="qitem" data-topic="dashboard">
                            <div class="left"><i class="fa-solid fa-chart-line"></i>Dashboard</div>
                            <small>View KPIs</small>
                        </div>
                        <div class="qitem" data-topic="reservations">
                            <div class="left"><i class="fa-solid fa-list-check"></i>Reservations</div>
                            <small>Search / Delete</small>
                        </div>
                        <div class="qitem" data-topic="add">
                            <div class="left"><i class="fa-solid fa-user-plus"></i>Add Reservation</div>
                            <small>Create Booking</small>
                        </div>
                        <div class="qitem" data-topic="bill">
                            <div class="left"><i class="fa-solid fa-receipt"></i>Bill Calculator</div>
                            <small>Generate Bill</small>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <script>
        const TOPICS = {
            login: {
                title: "Login",
                img: "images/help-login.png",
                stepsTitle: "How to login",
                steps: [
                    "Open Home page and click Login.",
                    "Enter your Username and Password.",
                    "Click Sign In.",
                    "If details are correct, you will enter the Dashboard."
                ],
                note: ""
            },
            dashboard: {
                title: "Dashboard",
                img: "images/help-dashboard.png",
                stepsTitle: "How to use Dashboard",
                steps: [
                    "Login to enter the Dashboard.",
                    "View Total Reservations, Active Today, Room Types and Estimated Revenue.",
                    "Check Recent Reservations list to see latest bookings.",
                    "Use menu links to go to Add Reservation, Reservations or Bill Calculator."
                ],
                note: ""
            },
            add: {
                title: "Add Reservation",
                img: "images/help-add.png",
                stepsTitle: "How to add a reservation",
                steps: [
                    "Open Add Reservation page.",
                    "Enter guest details (name, phone, address).",
                    "Select Room Type and choose Check-in / Check-out dates.",
                    "Click Save / Add Reservation to create the booking."
                ],
                note: ""
            },
            reservations: {
                title: "Reservations (Search / Delete)",
                img: "images/help-reservations.png",
                stepsTitle: "How to search / delete reservations",
                steps: [
                    "Open Reservations page.",
                    "Use the search box (ex: reservation code / guest name) and click Search.",
                    "View matching results in the list.",
                    "If needed, click Delete to remove a reservation record."
                ],
                note: "Tip: Delete only when you are sure the reservation should be removed."
            },
            bill: {
                title: "Bill Calculator",
                img: "images/help-bill.png",
                stepsTitle: "How to calculate a bill",
                steps: [
                    "Open Bill Calculator page.",
                    "Enter the Reservation Code.",
                    "Click Calculate / Generate Bill.",
                    "System will calculate nights × room price and show the total amount."
                ],
                note: ""
            }
        };

        const topicTitle = document.getElementById("topicTitle");
        const topicImage = document.getElementById("topicImage");
        const stepsTitle = document.getElementById("stepsTitle");
        const stepsList  = document.getElementById("stepsList");
        const stepsNote  = document.getElementById("stepsNote");

        function setActiveTopic(key){
            const t = TOPICS[key];
            if(!t) return;

            topicTitle.textContent = t.title;
            topicImage.src = t.img;
            topicImage.alt = t.title + " screenshot";
            stepsTitle.textContent = t.stepsTitle;

            stepsList.innerHTML = "";
            t.steps.forEach(s=>{
                const li = document.createElement("li");
                li.textContent = s;
                stepsList.appendChild(li);
            });

            stepsNote.textContent = t.note || "";

            document.querySelectorAll(".topic").forEach(btn=>{
                btn.classList.toggle("active", btn.dataset.topic === key);
            });

            if (window.innerWidth <= 980) {
                document.querySelector(".card-hd").scrollIntoView({behavior:"smooth", block:"start"});
            }
        }

        document.querySelectorAll(".topic").forEach(btn=>{
            btn.addEventListener("click", ()=> setActiveTopic(btn.dataset.topic));
        });

        document.querySelectorAll(".qitem").forEach(item=>{
            item.addEventListener("click", ()=> setActiveTopic(item.dataset.topic));
        });

        setActiveTopic("login");
    </script>
</body>
</html>