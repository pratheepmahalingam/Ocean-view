import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/PrintBillServlet")
public class PrintBillServlet extends HttpServlet {

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/oceanviewresort?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    private static final String HOTEL_NAME = "Ocean View Resort";
    private static final String HOTEL_ADDRESS = "Galle, Sri Lanka";
    private static final String HOTEL_PHONE = "+94 0123456789";
    private static final String HOTEL_EMAIL = "support@oceanviewresort.lk";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Session protection
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "show"; // default

        String q = request.getParameter("q");
        if (q == null) q = "";
        q = q.trim().replaceAll("[^0-9]", "");

        if (q.isEmpty()) {
            response.sendRedirect("billCalculator.jsp");
            return;
        }
        if (q.length() == 1) q = "0" + q;

        String resCode = "RES-00" + q;

        String guest = null, guestPhone = null, guestAddress = null, room = null, checkIn = null, checkOut = null;
        double pricePerNight = 0.0;
        int nights = 0;
        double subtotal = 0.0, total = 0.0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String sql =
                "SELECT r.guest_name, r.phone, r.address, rt.type_name, rt.price_per_night, r.check_in, r.check_out " +
                "FROM reservations r " +
                "JOIN room_types rt ON r.room_type_id = rt.id " +
                "WHERE r.res_code = ? LIMIT 1";

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, resCode);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        response.setContentType("text/plain; charset=UTF-8");
                        response.getWriter().println("Reservation not found: " + resCode);
                        return;
                    }

                    guest = rs.getString("guest_name");
                    guestPhone = rs.getString("phone");
                    guestAddress = rs.getString("address");
                    room = rs.getString("type_name");
                    pricePerNight = rs.getDouble("price_per_night");

                    Date inDate = rs.getDate("check_in");
                    Date outDate = rs.getDate("check_out");

                    if (inDate == null || outDate == null) {
                        response.setContentType("text/plain; charset=UTF-8");
                        response.getWriter().println("Missing dates for: " + resCode);
                        return;
                    }

                    LocalDate in = inDate.toLocalDate();
                    LocalDate out = outDate.toLocalDate();

                    long n = ChronoUnit.DAYS.between(in, out);
                    if (n < 1) n = 1;

                    nights = (int) n;
                    checkIn = in.toString();
                    checkOut = out.toString();

                    subtotal = nights * pricePerNight;
                    total = subtotal;
                }
            }
        } catch (Exception e) {
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().println("Server error: " + e.getMessage());
            return;
        }

        String filename = "ocean-bill-" + resCode + ".html";

        response.setContentType("text/html; charset=UTF-8");

        // ✅ download vs show
        if ("download".equalsIgnoreCase(action)) {
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        } else {
            response.setHeader("Content-Disposition", "inline; filename=\"" + filename + "\"");
        }

        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html><html><head><meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width,initial-scale=1'>");
        out.println("<title>Bill - " + esc(resCode) + "</title>");
        out.println("<style>");
        out.println("body{font-family:Segoe UI,Arial,sans-serif;margin:24px;color:#111;background:#fff;}");
        out.println(".wrap{max-width:820px;margin:auto;border:1px solid #ddd;border-radius:14px;padding:18px;}");
        out.println(".top{display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap;border-bottom:1px dashed #bbb;padding-bottom:12px;}");
        out.println(".h1{font-size:22px;font-weight:800;margin:0;}");
        out.println(".muted{color:#444;font-size:13px;line-height:1.5;margin-top:6px;}");
        out.println(".meta{text-align:right;font-size:13px;color:#333;}");
        out.println(".grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:12px;}");
        out.println(".box{border:1px solid #ddd;border-radius:12px;padding:10px 12px;}");
        out.println(".k{font-size:11px;color:#555;text-transform:uppercase;letter-spacing:.3px;font-weight:700;}");
        out.println(".v{margin-top:6px;font-size:14px;font-weight:700;}");
        out.println("table{width:100%;border-collapse:collapse;margin-top:12px;border:1px solid #ddd;border-radius:12px;overflow:hidden;}");
        out.println("th,td{padding:10px;border-bottom:1px solid #eee;text-align:left;}");
        out.println("th{background:#f6f7f9;font-size:12px;color:#444;text-transform:uppercase;letter-spacing:.3px;}");
        out.println(".right{text-align:right;}");
        out.println(".total{display:flex;justify-content:flex-end;margin-top:12px;}");
        out.println(".totalBox{width:320px;border:1px solid #ddd;border-radius:12px;padding:10px 12px;}");
        out.println(".line{display:flex;justify-content:space-between;padding:6px 0;font-weight:700;}");
        out.println(".grand{border-top:1px dashed #bbb;margin-top:8px;padding-top:10px;font-size:16px;}");
        out.println(".foot{margin-top:12px;border-top:1px dashed #bbb;padding-top:10px;font-size:12px;color:#444;display:flex;justify-content:space-between;gap:10px;flex-wrap:wrap;}");
        out.println("</style></head><body>");

        out.println("<div class='wrap'>");

        out.println("<div class='top'>");
        out.println("<div>");
        out.println("<p class='h1'>" + esc(HOTEL_NAME) + " — Bill</p>");
        out.println("<div class='muted'>");
        out.println("<div><b>Address:</b> " + esc(HOTEL_ADDRESS) + "</div>");
        out.println("<div><b>Phone:</b> " + esc(HOTEL_PHONE) + "</div>");
        out.println("<div><b>Email:</b> " + esc(HOTEL_EMAIL) + "</div>");
        out.println("</div>");
        out.println("</div>");
        out.println("<div class='meta'>");
        out.println("<div><b>Reservation:</b> " + esc(resCode) + "</div>");
        out.println("<div><b>Date:</b> " + LocalDate.now() + "</div>");
        out.println("</div>");
        out.println("</div>");

        out.println("<div class='grid'>");
        out.println("<div class='box'><div class='k'>Guest</div><div class='v'>" + escSafe(guest) + "</div></div>");
        out.println("<div class='box'><div class='k'>Guest Phone</div><div class='v'>" + escSafe(guestPhone) + "</div></div>");
        out.println("<div class='box'><div class='k'>Guest Address</div><div class='v'>" + escSafe(guestAddress) + "</div></div>");
        out.println("<div class='box'><div class='k'>Room Type</div><div class='v'>" + escSafe(room) + "</div></div>");
        out.println("<div class='box'><div class='k'>Check-in</div><div class='v'>" + escSafe(checkIn) + "</div></div>");
        out.println("<div class='box'><div class='k'>Check-out</div><div class='v'>" + escSafe(checkOut) + "</div></div>");
        out.println("</div>");

        out.println("<table>");
        out.println("<thead><tr><th>Description</th><th class='right'>Nights</th><th class='right'>Price/Night</th><th class='right'>Amount</th></tr></thead>");
        out.println("<tbody>");
        out.println("<tr>");
        out.println("<td>Room charge (" + escSafe(room) + ")</td>");
        out.println("<td class='right'>" + nights + "</td>");
        out.println("<td class='right'>$" + String.format("%,.2f", pricePerNight) + "</td>");
        out.println("<td class='right'>$" + String.format("%,.2f", subtotal) + "</td>");
        out.println("</tr>");
        out.println("</tbody></table>");

        out.println("<div class='total'><div class='totalBox'>");
        out.println("<div class='line'><span>Subtotal</span><span>$" + String.format("%,.2f", subtotal) + "</span></div>");
        out.println("<div class='line'><span>Taxes</span><span>$0.00</span></div>");
        out.println("<div class='line grand'><span>Total</span><span>$" + String.format("%,.2f", total) + "</span></div>");
        out.println("</div></div>");

        out.println("<div class='foot'>");
        out.println("<div>" + esc(HOTEL_NAME) + " • " + esc(HOTEL_ADDRESS) + "</div>");
        out.println("<div>Support: " + esc(HOTEL_PHONE) + " • " + esc(HOTEL_EMAIL) + "</div>");
        out.println("</div>");

        out.println("</div></body></html>");
    }

    private static String esc(String s){
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
    private static String escSafe(String s){
        if (s == null || s.trim().isEmpty()) return "-";
        return esc(s);
    }
}