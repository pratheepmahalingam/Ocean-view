import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/BillCalculatorServlet")
public class BillCalculatorServlet extends HttpServlet {

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/oceanviewresort?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    // ✅ Hotel details
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

        String username = (String) session.getAttribute("username");
        request.setAttribute("username", username);

        // ✅ Hotel info for bill preview
        request.setAttribute("hotelName", HOTEL_NAME);
        request.setAttribute("hotelAddress", HOTEL_ADDRESS);
        request.setAttribute("hotelPhone", HOTEL_PHONE);
        request.setAttribute("hotelEmail", HOTEL_EMAIL);

        // ✅ digits only after RES-00
        String q = request.getParameter("q");
        if (q == null) q = "";
        q = q.trim().replaceAll("[^0-9]", "");
        request.setAttribute("q", q);

        if (q.isEmpty()) {
            request.setAttribute("err", "Please enter digits after RES-00 (example: 12).");
            request.getRequestDispatcher("billCalculator.jsp").forward(request, response);
            return;
        }

        if (q.length() == 1) q = "0" + q;

        String resCode = "RES-00" + q;
        request.setAttribute("resCodeFull", resCode);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String sql =
                    "SELECT r.res_code, r.guest_name, r.phone, r.address, " +
                    "       rt.type_name, rt.price_per_night, r.check_in, r.check_out " +
                    "FROM reservations r " +
                    "JOIN room_types rt ON r.room_type_id = rt.id " +
                    "WHERE r.res_code = ? " +
                    "LIMIT 1";

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, resCode);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {

                        String guest = rs.getString("guest_name");
                        String guestPhone = rs.getString("phone");
                        String guestAddress = rs.getString("address");

                        String room = rs.getString("type_name");
                        double pricePerNight = rs.getDouble("price_per_night");

                        Date inDate = rs.getDate("check_in");
                        Date outDate = rs.getDate("check_out");

                        if (inDate == null || outDate == null) {
                            request.setAttribute("err", "Reservation dates are missing!");
                            request.getRequestDispatcher("billCalculator.jsp").forward(request, response);
                            return;
                        }

                        LocalDate in = inDate.toLocalDate();
                        LocalDate out = outDate.toLocalDate();

                        long nightsL = ChronoUnit.DAYS.between(in, out);
                        if (nightsL < 1) nightsL = 1;

                        int nights = (int) nightsL;
                        double subtotal = nights * pricePerNight;
                        double total = subtotal;

                        request.setAttribute("guest", guest);
                        request.setAttribute("guestPhone", guestPhone);
                        request.setAttribute("guestAddress", guestAddress);

                        request.setAttribute("room", room);
                        request.setAttribute("checkIn", in.toString());
                        request.setAttribute("checkOut", out.toString());

                        request.setAttribute("nights", nights);
                        request.setAttribute("pricePerNight", pricePerNight);
                        request.setAttribute("subtotal", subtotal);
                        request.setAttribute("total", total);

                        request.setAttribute("msg", "Bill generated successfully!");
                    } else {
                        request.setAttribute("err", "Reservation not found for " + resCode);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("err", "Server error: " + e.getMessage());
        }

        request.getRequestDispatcher("billCalculator.jsp").forward(request, response);
    }
}