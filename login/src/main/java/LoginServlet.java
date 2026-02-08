import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ICBT",
                    "root",
                    ""   
            );

            String sql = "SELECT * FROM users WHERE username=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ SUCCESS → FORWARD
                request.setAttribute("username", username);
                RequestDispatcher rd = request.getRequestDispatcher("welcome.jsp");
                rd.forward(request, response);
                return; // VERY IMPORTANT
            } else {
                // ❌ FAILED → BACK TO LOGIN
                request.setAttribute("error", "Invalid username or password");
                RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
                rd.forward(request, response);
                return;
            }

        } catch (Exception e) {
            // 🔴 SHOW ERROR (for debugging)
            response.setContentType("text/html");
            response.getWriter().println("<h3>Error occurred</h3>");
            e.printStackTrace(response.getWriter());
        }
    }
}
