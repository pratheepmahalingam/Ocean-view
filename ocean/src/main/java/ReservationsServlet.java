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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String q = request.getParameter("q");
        if (q == null) q = "";
        String like = "%" + q.trim() + "%";

        List<Map<String, String>> list = new ArrayList<>();

        String sql =
                "SELECT id, res_code, guest_name, address, phone, room_name, check_in, check_out " +
                "FROM reservations " +
                "WHERE (? = '' OR guest_name LIKE ? OR res_code LIKE ?) " +
                "ORDER BY id DESC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, q.trim());
                ps.setString(2, like);
                ps.setString(3, like);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> r = new HashMap<>();
                        r.put("id", String.valueOf(rs.getInt("id")));
                        r.put("res_code", rs.getString("res_code"));
                        r.put("guest_name", rs.getString("guest_name"));
                        r.put("address", rs.getString("address"));
                        r.put("phone", rs.getString("phone"));
                        r.put("room_name", rs.getString("room_name"));
                        r.put("check_in", rs.getDate("check_in").toString());
                        r.put("check_out", rs.getDate("check_out").toString());
                        list.add(r);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("q", q);
        request.setAttribute("reservations", list);
        request.getRequestDispatcher("reservations.jsp").forward(request, response);
    }
}