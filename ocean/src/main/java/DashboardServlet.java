import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/oceanviewresort?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int totalReservations = 0;
        int activeToday = 0;
        int roomTypes = 0;
        double estRevenue = 0.0;
        List<Map<String, String>> recent = new ArrayList<>();

        LocalDate today = LocalDate.now();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                // 1) total reservations
                try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM reservations");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalReservations = rs.getInt(1);
                }

                // 2) active today (today between check_in and check_out)
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT COUNT(*) FROM reservations WHERE ? BETWEEN check_in AND check_out");
                ) {
                    ps.setDate(1, java.sql.Date.valueOf(today));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) activeToday = rs.getInt(1);
                    }
                }

                // 3) room types available
                try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM room_types");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) roomTypes = rs.getInt(1);
                }

                // 4) estimated revenue (sum total_amount)
                try (PreparedStatement ps = con.prepareStatement("SELECT IFNULL(SUM(total_amount),0) FROM reservations");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) estRevenue = rs.getDouble(1);
                }

                // 5) recent reservations
                String recentSql =
                        "SELECT res_code, guest_name, room_name, check_in, check_out " +
                        "FROM reservations ORDER BY id DESC LIMIT 5";
                try (PreparedStatement ps = con.prepareStatement(recentSql);
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        Map<String, String> row = new HashMap<>();
                        row.put("res_code", rs.getString("res_code"));
                        row.put("guest_name", rs.getString("guest_name"));
                        row.put("room_name", rs.getString("room_name"));
                        row.put("check_in", rs.getDate("check_in").toString());
                        row.put("check_out", rs.getDate("check_out").toString());
                        recent.add(row);
                    }
                }
            }

        } catch (Exception e) {
            // If tables not created yet, dashboard will still load with zeros.
            e.printStackTrace();
        }

        request.setAttribute("totalReservations", totalReservations);
        request.setAttribute("activeToday", activeToday);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("estRevenue", estRevenue);
        request.setAttribute("recentReservations", recent);

        RequestDispatcher rd = request.getRequestDispatcher("menu.jsp");
        rd.forward(request, response);
    }
}