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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String resCode = request.getParameter("res_code");
        if (resCode == null || resCode.trim().isEmpty()) {
            request.setAttribute("err", "Please enter reservation code!");
            request.getRequestDispatcher("billCalculator.jsp").forward(request, response);
            return;
        }

        resCode = resCode.trim();
        request.setAttribute("resCode", resCode);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String sql = "SELECT guest_name, room_name, check_in, check_out, total_amount " +
                         "FROM reservations WHERE res_code=? LIMIT 1";

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, resCode);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        String guest = rs.getString("guest_name");
                        String room = rs.getString("room_name");
                        LocalDate in = rs.getDate("check_in").toLocalDate();
                        LocalDate out = rs.getDate("check_out").toLocalDate();
                        double total = rs.getDouble("total_amount");

                        long nights = ChronoUnit.DAYS.between(in, out);
                        if (nights < 1) nights = 1;

                        request.setAttribute("guest", guest);
                        request.setAttribute("room", room);
                        request.setAttribute("checkIn", in.toString());
                        request.setAttribute("checkOut", out.toString());
                        request.setAttribute("nights", (int) nights);
                        request.setAttribute("total", total);
                        request.setAttribute("msg", "Bill calculated successfully!");
                    } else {
                        request.setAttribute("err", "Reservation not found!");
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