import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateReservationServlet")
public class UpdateReservationServlet extends HttpServlet {

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/oceanviewresort?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        String resCode = request.getParameter("res_code");
        String guest = request.getParameter("guest_name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String roomTypeIdStr = request.getParameter("room_type_id");
        String checkInStr = request.getParameter("check_in");
        String checkOutStr = request.getParameter("check_out");

        if (idStr == null || roomTypeIdStr == null || checkInStr == null || checkOutStr == null) {
            response.sendRedirect("ReservationsServlet");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            int roomTypeId = Integer.parseInt(roomTypeIdStr);

            LocalDate in = LocalDate.parse(checkInStr);
            LocalDate out = LocalDate.parse(checkOutStr);

            long nights = ChronoUnit.DAYS.between(in, out);
            if (nights < 1) nights = 1;

            Class.forName("com.mysql.cj.jdbc.Driver");

            double pricePerNight = 0.0;

            // Get price per night from room_types
            String priceSql = "SELECT price_per_night FROM room_types WHERE id=? LIMIT 1";
            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(priceSql)) {
                ps.setInt(1, roomTypeId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        pricePerNight = rs.getDouble("price_per_night");
                    } else {
                        response.sendRedirect("ReservationsServlet");
                        return;
                    }
                }
            }

            double totalAmount = nights * pricePerNight;

            // Update reservation + total_amount
            String updateSql =
                    "UPDATE reservations SET res_code=?, guest_name=?, address=?, phone=?, " +
                    "room_type_id=?, check_in=?, check_out=?, total_amount=? WHERE id=?";

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(updateSql)) {

                ps.setString(1, resCode);
                ps.setString(2, guest);
                ps.setString(3, address);
                ps.setString(4, phone);
                ps.setInt(5, roomTypeId);
                ps.setDate(6, java.sql.Date.valueOf(in));
                ps.setDate(7, java.sql.Date.valueOf(out));
                ps.setDouble(8, totalAmount);
                ps.setInt(9, id);

                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ReservationsServlet");
    }
}