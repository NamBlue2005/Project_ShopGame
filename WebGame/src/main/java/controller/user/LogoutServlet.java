package controller.user; // Đặt cùng package với LoginServlet, UserProfileServlet

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"}) // Map với URL /logout
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        System.out.println("LogoutServlet: doGet called.");
      HttpSession session = request.getSession(false);
    if (session != null) {
            String username = (String) session.getAttribute("username"); // Lấy username trước khi hủy để log (tùy chọn)
            session.invalidate();
            System.out.println("Session invalidated for user: " + username);
        } else {
            System.out.println("LogoutServlet: No active session found to invalidate.");
        }
     String logoutMessage = URLEncoder.encode("Bạn đã đăng xuất thành công.", "UTF-8");
        response.sendRedirect(request.getContextPath() + "/login?message=" + logoutMessage);
        }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}