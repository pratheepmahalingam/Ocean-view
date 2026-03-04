import java.io.IOException;
import java.sql.*;
import java.util.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/EditReservationServlet")
public class EditReservationServlet extends HttpServlet {

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

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("ReservationsServlet");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            int id = Integer.parseInt(idStr);

            // 1) Load room types for dropdown
            List<Map<String, String>> roomTypes = new ArrayList<>();
            String rtSql = "SELECT id, type_name, price_per_night FROM room_types ORDER BY id ASC";
            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(rtSql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, String> m = new HashMap<>();
                    m.put("id", String.valueOf(rs.getInt("id")));
                    m.put("type_name", rs.getString("type_name"));
                    m.put("price_per_night", String.valueOf(rs.getDouble("price_per_night")));
                    roomTypes.add(m);
                }
            }

            // 2) Load reservation
            String sql = "SELECT id, res_code, guest_name, address, phone, room_type_id, check_in, check_out " +
                         "FROM reservations WHERE id=? LIMIT 1";

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        request.setAttribute("id", rs.getInt("id"));
                        request.setAttribute("res_code", rs.getString("res_code"));
                        request.setAttribute("guest_name", rs.getString("guest_name"));
                        request.setAttribute("address", rs.getString("address"));
                        request.setAttribute("phone", rs.getString("phone"));
                        request.setAttribute("room_type_id", rs.getInt("room_type_id"));
                        request.setAttribute("check_in", rs.getDate("check_in").toString());
                        request.setAttribute("check_out", rs.getDate("check_out").toString());
                        request.setAttribute("roomTypes", roomTypes);

                        RequestDispatcher rd = request.getRequestDispatcher("editReservation.jsp");
                        rd.forward(request, response);
                        return;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ReservationsServlet");
    }
}