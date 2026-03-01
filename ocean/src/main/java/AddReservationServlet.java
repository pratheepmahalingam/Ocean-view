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

                // ✅ Load room types for dropdown
                List<Map<String, String>> types = new ArrayList<>();
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT type_name, price_per_night FROM room_types ORDER BY id");
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        Map<String, String> m = new HashMap<>();
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
        String roomType = safe(request.getParameter("room_type"));  // ✅ NAME ONLY
        String checkInStr = safe(request.getParameter("check_in"));
        String checkOutStr = safe(request.getParameter("check_out"));

        if (resCode.isEmpty() || guestName.isEmpty() || address.isEmpty() ||
                phone.isEmpty() || roomType.isEmpty() || checkInStr.isEmpty() || checkOutStr.isEmpty()) {
            request.setAttribute("err", "All fields are required!");
            doGet(request, response);
            return;
        }

        if (!phone.matches("\\d{10}")) {
            request.setAttribute("err", "Phone number must be exactly 10 digits!");
            doGet(request, response);
            return;
        }

        LocalDate in, out;
        try {
            in = LocalDate.parse(checkInStr);
            out = LocalDate.parse(checkOutStr);
        } catch (Exception e) {
            request.setAttribute("err", "Invalid date!");
            doGet(request, response);
            return;
        }

        if (!out.isAfter(in)) {
            request.setAttribute("err", "Check-out must be after check-in!");
            doGet(request, response);
            return;
        }

        long nights = ChronoUnit.DAYS.between(in, out);
        if (nights < 1) nights = 1;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                // ✅ Get room price by room type name
                double price = 0.0;
                try (PreparedStatement pricePs = con.prepareStatement(
                        "SELECT price_per_night FROM room_types WHERE type_name=? LIMIT 1")) {
                    pricePs.setString(1, roomType);
                    try (ResultSet rs = pricePs.executeQuery()) {
                        if (rs.next()) price = rs.getDouble(1);
                    }
                }

                if (price <= 0) {
                    request.setAttribute("err", "Room price not found!");
                    doGet(request, response);
                    return;
                }

                double total = price * nights;

                // ✅ Insert using room_type NAME only
                String sql = "INSERT INTO reservations " +
                        "(res_code, guest_name, address, phone, room_type, check_in, check_out, total_amount) " +
                        "VALUES (?,?,?,?,?,?,?,?)";

                try (PreparedStatement insert = con.prepareStatement(sql)) {
                    insert.setString(1, resCode);
                    insert.setString(2, guestName);
                    insert.setString(3, address);
                    insert.setString(4, phone);
                    insert.setString(5, roomType);
                    insert.setDate(6, java.sql.Date.valueOf(in));
                    insert.setDate(7, java.sql.Date.valueOf(out));
                    insert.setDouble(8, total);
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