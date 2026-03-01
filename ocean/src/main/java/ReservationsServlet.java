import java.io.IOException;
import java.sql.*;
import java.util.*;

import jakarta.servlet.*;
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

        List<Map<String,String>> list = new ArrayList<>();

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

            String sql = "SELECT r.id,r.res_code,r.guest_name,r.address,r.phone," +
                         "rt.type_name,r.check_in,r.check_out " +
                         "FROM reservations r " +
                         "JOIN room_types rt ON r.room_type_id=rt.id " +
                         "ORDER BY r.id DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String,String> m = new HashMap<>();
                m.put("id",rs.getString("id"));
                m.put("res_code",rs.getString("res_code"));
                m.put("guest_name",rs.getString("guest_name"));
                m.put("address",rs.getString("address"));
                m.put("phone",rs.getString("phone"));
                m.put("room_type",rs.getString("type_name"));
                m.put("check_in",rs.getString("check_in"));
                m.put("check_out",rs.getString("check_out"));
                list.add(m);
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        request.setAttribute("reservations",list);
        request.getRequestDispatcher("reservations.jsp")
               .forward(request,response);
    }
}