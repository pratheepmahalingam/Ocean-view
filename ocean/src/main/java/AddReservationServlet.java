import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String resCode = request.getParameter("res_code");
        String guestName = request.getParameter("guest_name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String roomName = request.getParameter("room_name");
        String checkIn = request.getParameter("check_in");
        String checkOut = request.getParameter("check_out");
        String totalAmount = request.getParameter("total_amount");

        // ✅ Validation
        if (isEmpty(resCode) || isEmpty(guestName) || isEmpty(address) || isEmpty(phone)
                || isEmpty(roomName) || isEmpty(checkIn) || isEmpty(checkOut) || isEmpty(totalAmount)) {

            request.setAttribute("err", "All fields are required!");
            request.getRequestDispatcher("addReservation.jsp").forward(request, response);
            return;
        }

        // ✅ check-out must be after check-in (simple check)
        if (checkOut.compareTo(checkIn) <= 0) {
            request.setAttribute("err", "Check-out date must be after check-in date!");
            request.getRequestDispatcher("addReservation.jsp").forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String sql = "INSERT INTO reservations " +
                    "(res_code, guest_name, address, phone, room_name, check_in, check_out, total_amount) " +
                    "VALUES (?,?,?,?,?,?,?,?)";

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, resCode.trim());
                ps.setString(2, guestName.trim());
                ps.setString(3, address.trim());
                ps.setString(4, phone.trim());
                ps.setString(5, roomName.trim());
                ps.setDate(6, java.sql.Date.valueOf(checkIn));
                ps.setDate(7, java.sql.Date.valueOf(checkOut));
                ps.setDouble(8, Double.parseDouble(totalAmount));

                ps.executeUpdate();
            }

            request.setAttribute("msg", "Reservation saved successfully!");
            request.getRequestDispatcher("addReservation.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            // Usually duplicate res_code gives error
            request.setAttribute("err", "Error: " + e.getMessage());
            request.getRequestDispatcher("addReservation.jsp").forward(request, response);
        }
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}