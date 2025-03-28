package controller.user; // Đặt cùng package với LoginServlet, UserProfileServlet

// --- Sử dụng javax ---
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
// ---

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

        // 1. Lấy session hiện tại (không tạo mới nếu chưa có)
        HttpSession session = request.getSession(false);

        // 2. Kiểm tra xem session có tồn tại không
        if (session != null) {
            String username = (String) session.getAttribute("username"); // Lấy username trước khi hủy để log (tùy chọn)
            // 3. Hủy session
            session.invalidate();
            System.out.println("Session invalidated for user: " + username);
        } else {
            System.out.println("LogoutServlet: No active session found to invalidate.");
        }

        // 4. Chuyển hướng về trang công khai (ví dụ: trang login hoặc trang chủ)
        // Thêm thông báo logout thành công vào URL parameter (tùy chọn)
        String logoutMessage = URLEncoder.encode("Bạn đã đăng xuất thành công.", "UTF-8");
        response.sendRedirect(request.getContextPath() + "/login?message=" + logoutMessage);
        // Hoặc chuyển về trang chủ: response.sendRedirect(request.getContextPath() + "/");
        // Hoặc trang tài khoản: response.sendRedirect(request.getContextPath() + "/accounts");
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}