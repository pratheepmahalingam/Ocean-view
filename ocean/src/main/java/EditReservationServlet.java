import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EditReservationServlet")
public class EditReservationServlet extends HttpServlet {

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/oceanviewresort?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Session check
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
            int id = Integer.parseInt(idStr);

            Class.forName("com.mysql.cj.jdbc.Driver");

            String sql = "SELECT id, res_code, guest_name, address, phone, room_name, check_in, check_out, total_amount " +
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
                        request.setAttribute("room_name", rs.getString("room_name"));
                        request.setAttribute("check_in", rs.getDate("check_in").toString());
                        request.setAttribute("check_out", rs.getDate("check_out").toString());
                        request.setAttribute("total_amount", rs.getDouble("total_amount"));

                        RequestDispatcher rd = request.getRequestDispatcher("editReservation.jsp");
                        rd.forward(request, response);
                        return;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // if not found or error
        response.sendRedirect("ReservationsServlet");
    }
}