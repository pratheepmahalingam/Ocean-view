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

@WebServlet("/registerServlet")
public class registerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // ✅ Input validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required");
            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
            rd.forward(request, response);
            return;
        }

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // DB Connection using try-with-resources
            String dbURL = "jdbc:mysql://localhost:3306/ICBT"; // Your DB name
            String dbUser = "root"; // Your DB username
            String dbPass = "";     // Your DB password

            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass)) {

                // 🔍 Check if username already exists
                String checkSql = "SELECT id FROM users WHERE username=?";
                try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
                    psCheck.setString(1, username);
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next()) {
                            request.setAttribute("error", "Username already exists");
                            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
                            rd.forward(request, response);
                            return;
                        }
                    }
                }

                // ✅ Insert new user
                String insertSql = "INSERT INTO users (username, password) VALUES (?, ?)";
                try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                    psInsert.setString(1, username);
                    psInsert.setString(2, password); // hashed password
                    psInsert.executeUpdate();
                }

                // Success → redirect to login page
                request.setAttribute("success", "Registration successful! Please login.");
                RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
                rd.forward(request, response);

            }

        } catch (Exception e) {
            e.printStackTrace(); // Logs exact DB or server errors
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
            rd.forward(request, response);
        }
    }
}
