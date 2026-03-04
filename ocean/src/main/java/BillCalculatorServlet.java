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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Session protection
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ user types only digits after 00
        String q = request.getParameter("q");
        if (q == null) q = "";
        q = q.trim().replaceAll("[^0-9]", "");

        request.setAttribute("q", q);

        if (q.isEmpty()) {
            request.setAttribute("err", "Please enter digits after RES-00 (example: 12).");
            request.getRequestDispatcher("billCalculator.jsp").forward(request, response);
            return;
        }

        // optional: pad 1 digit to 2 digits
        if (q.length() == 1) q = "0" + q;

        // ✅ final reservation code
        String resCode = "RES-00" + q;
        request.setAttribute("resCodeFull", resCode);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // ✅ join room_types to always get latest price and calculate updated total
            String sql =
                    "SELECT r.guest_name, rt.type_name, rt.price_per_night, r.check_in, r.check_out " +
                    "FROM reservations r " +
                    "JOIN room_types rt ON r.room_type_id = rt.id " +
                    "WHERE r.res_code=? LIMIT 1";

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, resCode);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {

                        String guest = rs.getString("guest_name");
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

                        long nights = ChronoUnit.DAYS.between(in, out);
                        if (nights < 1) nights = 1;

                        double total = nights * pricePerNight;

                        request.setAttribute("guest", guest);
                        request.setAttribute("room", room);
                        request.setAttribute("checkIn", in.toString());
                        request.setAttribute("checkOut", out.toString());
                        request.setAttribute("nights", (int) nights);
                        request.setAttribute("total", total);
                        request.setAttribute("msg", "Bill calculated successfully!");
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