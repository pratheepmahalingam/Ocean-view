import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddReservationServlet")
public class AddReservationServlet extends HttpServlet {

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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                // ✅ Load room types from database
                List<Map<String, String>> types = new ArrayList<>();
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT id, type_name, price_per_night FROM room_types ORDER BY id");
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        Map<String, String> m = new HashMap<>();
                        m.put("id", String.valueOf(rs.getInt("id")));
                        m.put("type_name", rs.getString("type_name"));
                        m.put("price", String.format("%.2f", rs.getDouble("price_per_night")));
                        types.add(m);
                    }
                }
                request.setAttribute("roomTypes", types);

                // ✅ Generate next reservation code
                int next = 1;
                try (PreparedStatement ps2 = con.prepareStatement("SELECT MAX(id) FROM reservations");
                     ResultSet rs2 = ps2.executeQuery()) {

                    if (rs2.next()) {
                        next = rs2.getInt(1) + 1;
                        if (next < 1) next = 1;
                    }
                }
                request.setAttribute("nextCode", String.format("RES-%04d", next));
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("err", "Server error: " + e.getMessage());
        }

        request.getRequestDispatcher("addReservation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String resCode = safe(request.getParameter("res_code"));
        String guestName = safe(request.getParameter("guest_name"));
        String address = safe(request.getParameter("address"));
        String phone = safe(request.getParameter("phone")).replaceAll("\\D+", "");
        String roomTypeIdStr = safe(request.getParameter("room_type_id")); // ✅ ID
        String checkInStr = safe(request.getParameter("check_in"));
        String checkOutStr = safe(request.getParameter("check_out"));

        if (resCode.isEmpty() || guestName.isEmpty() || address.isEmpty() ||
                phone.isEmpty() || roomTypeIdStr.isEmpty() ||
                checkInStr.isEmpty() || checkOutStr.isEmpty()) {

            request.setAttribute("err", "All fields are required!");
            doGet(request, response);
            return;
        }

        if (!phone.matches("\\d{10}")) {
            request.setAttribute("err", "Phone number must be exactly 10 digits!");
            doGet(request, response);
            return;
        }

        int roomTypeId;
        try {
            roomTypeId = Integer.parseInt(roomTypeIdStr);
        } catch (Exception ex) {
            request.setAttribute("err", "Please select a valid room type!");
            doGet(request, response);
            return;
        }

        LocalDate inDate, outDate;
        try {
            inDate = LocalDate.parse(checkInStr);
            outDate = LocalDate.parse(checkOutStr);
        } catch (Exception e) {
            request.setAttribute("err", "Invalid date format!");
            doGet(request, response);
            return;
        }

        if (!outDate.isAfter(inDate)) {
            request.setAttribute("err", "Check-out must be after check-in!");
            doGet(request, response);
            return;
        }

        long nights = ChronoUnit.DAYS.between(inDate, outDate);
        if (nights < 1) nights = 1;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                // ✅ Get room name + price using ID
                double price = 0.0;
                String roomName = null;

                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT type_name, price_per_night FROM room_types WHERE id=? LIMIT 1")) {
                    ps.setInt(1, roomTypeId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            roomName = rs.getString("type_name");
                            price = rs.getDouble("price_per_night");
                        }
                    }
                }

                if (roomName == null || price <= 0) {
                    request.setAttribute("err", "Room type not found or invalid price!");
                    doGet(request, response);
                    return;
                }

                double total = price * nights;

                // ✅ Insert reservation (matches common schema: room_type_id + room_name)
                String sql = "INSERT INTO reservations " +
                        "(res_code, guest_name, address, phone, room_type_id, room_name, check_in, check_out, total_amount) " +
                        "VALUES (?,?,?,?,?,?,?,?,?)";

                try (PreparedStatement insert = con.prepareStatement(sql)) {
                    insert.setString(1, resCode);
                    insert.setString(2, guestName);
                    insert.setString(3, address);
                    insert.setString(4, phone);
                    insert.setInt(5, roomTypeId);
                    insert.setString(6, roomName);
                    insert.setDate(7, java.sql.Date.valueOf(inDate));
                    insert.setDate(8, java.sql.Date.valueOf(outDate));
                    insert.setDouble(9, total);
                    insert.executeUpdate();
                }

                request.setAttribute("msg", "Reservation saved successfully!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("err", "Database error: " + e.getMessage());
        }

        doGet(request, response);
    }

    private String safe(String s) {
        return (s == null) ? "" : s.trim();
    }
}