package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import connect.DatabaseConnection;
import model.User; // Import model User

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn != null) {
                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    stmt.setString(2, password);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            HttpSession session = request.getSession();
                            session.setAttribute("userId", rs.getInt("user_id"));
                            session.setAttribute("username", rs.getString("username"));
                            session.setAttribute("email", rs.getString("email"));
                            session.setAttribute("phoneNumber", rs.getString("phone_number"));
                            session.setAttribute("type", rs.getString("type"));
                            response.sendRedirect("index.jsp"); // Đăng nhập thành công
                        } else {
                            response.sendRedirect("login.jsp?error=1"); // Sai tài khoản/mật khẩu
                        }
                    }
                }
            } else {
                response.sendRedirect("login.jsp?error=2"); // Lỗi kết nối DB
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=3"); // Lỗi hệ thống
        }
    }
}
