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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/oceanviewresort?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter username and password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        username = username.trim();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String sql = "SELECT id, username, password, role FROM users WHERE username=? LIMIT 1";

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, username);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        String dbPassword = rs.getString("password");
                        String role = rs.getString("role");
                        int userId = rs.getInt("id");

                        if (password.equals(dbPassword)) {
                            HttpSession session = request.getSession(true);
                            session.setAttribute("userId", userId);
                            session.setAttribute("username", username);
                            session.setAttribute("role", role);

                            response.sendRedirect("menu.jsp");
                        } else {
                            request.setAttribute("error", "Invalid username or password!");
                            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                            rd.forward(request, response);
                        }
                    } else {
                        request.setAttribute("error", "Invalid username or password!");
                        RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                        rd.forward(request, response);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
