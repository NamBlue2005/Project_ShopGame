package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import connect.DatabaseConnection;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "UPDATE users SET email = ?, phone_number = ? WHERE user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                stmt.setString(2, phoneNumber);
                stmt.setInt(3, userId);
                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    // Cập nhật lại session với thông tin mới
                    session.setAttribute("email", email);
                    session.setAttribute("phoneNumber", phoneNumber);
                    response.sendRedirect("profile.jsp?message=Update successful!");
                } else {
                    response.sendRedirect("edit_profile.jsp?message=Update failed. Try again!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit_profile.jsp?message=System error!");
        }
    }
}
