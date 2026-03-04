import java.io.IOException;
import java.sql.*;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ReservationsServlet")
public class ReservationsServlet extends HttpServlet {

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

        String q = request.getParameter("q");
        if (q == null) q = "";
        q = q.trim();

        // allow only digits (safety)
        q = q.replaceAll("[^0-9]", "");

        List<Map<String, String>> list = new ArrayList<>();

        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (Exception ignored) {}

        boolean hasSearch = !q.isEmpty();

        // digits => res_code = RES-00 + digits (pad 1 digit to 2)
        String resCodeSearch = null;
        if (hasSearch) {
            if (q.length() == 1) q = "0" + q;   // 1 -> 01
            resCodeSearch = "RES-00" + q;       // 12 -> RES-0012
        }

        String sql =
            "SELECT r.id, r.res_code, r.guest_name, r.address, r.phone, " +
            "       rt.type_name AS room_type, r.check_in, r.check_out " +
            "FROM reservations r " +
            "JOIN room_types rt ON r.room_type_id = rt.id ";

        if (hasSearch) {
            sql += "WHERE r.res_code = ? ";
        }

        sql += "ORDER BY r.id DESC";

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (hasSearch) {
                ps.setString(1, resCodeSearch);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> m = new HashMap<>();
                    m.put("id", rs.getString("id"));
                    m.put("res_code", rs.getString("res_code"));
                    m.put("guest_name", rs.getString("guest_name"));
                    m.put("address", rs.getString("address"));
                    m.put("phone", rs.getString("phone"));
                    m.put("room_type", rs.getString("room_type"));
                    m.put("check_in", rs.getString("check_in"));
                    m.put("check_out", rs.getString("check_out"));
                    list.add(m);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ✅ keep q in the input (digits only)
        request.setAttribute("q", q);
        request.setAttribute("reservations", list);
        request.getRequestDispatcher("reservations.jsp").forward(request, response);
    }
}