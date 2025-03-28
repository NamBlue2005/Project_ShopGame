package controller.user;

import model.User;
import repository.UserRepository;

// --- Sử dụng javax ---
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
// ---

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet(name = "UserProfileServlet", urlPatterns = {"/profile"})
public class UserProfileServlet extends HttpServlet {

    private UserRepository userRepository;
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    private static final String JSP_PROFILE_PATH = "/views/user/profile.jsp";

    @Override
    public void init() {
        userRepository = new UserRepository();
        System.out.println("UserProfileServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" + URLEncoder.encode("Vui lòng đăng nhập.", "UTF-8"));
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        try {
            User userInfo = userRepository.getUserById(userId);

            if (userInfo != null) {
                request.setAttribute("userInfo", userInfo);
                String successMessage = request.getParameter("message");
                if (successMessage != null && !successMessage.isEmpty()) {
                    request.setAttribute("successMessage", successMessage); // Đổi tên cho rõ nghĩa hơn
                }

                RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_PROFILE_PATH);
                dispatcher.forward(request, response);
            } else {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login?error=" + URLEncoder.encode("Không tìm thấy thông tin.", "UTF-8"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải thông tin cá nhân.");
            RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_PROFILE_PATH);
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Yêu cầu không hợp lệ.");
            return;
        }

        Integer sessionUserId = (Integer) session.getAttribute("userId");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");

        List<String> errors = new ArrayList<>();
        User currentUserInfo = null;

        try {
            currentUserInfo = userRepository.getUserById(sessionUserId);
            if (currentUserInfo == null) {
                throw new ServletException("Không tìm thấy thông tin người dùng hiện tại.");
            }

            // --- Validation ---
            if (email == null || email.trim().isEmpty()) {
                errors.add("Email không được để trống.");
            } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
                errors.add("Định dạng email không hợp lệ.");
            } else if (!email.trim().equalsIgnoreCase(currentUserInfo.getEmail()) && userRepository.isEmailExists(email.trim(), sessionUserId)) {
                errors.add("Email này đã được sử dụng bởi tài khoản khác.");
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                User formData = new User();
                formData.setUserId(sessionUserId);
                formData.setUsername(currentUserInfo.getUsername());
                formData.setEmail(email);
                formData.setPhoneNumber(phoneNumber);
                formData.setType(currentUserInfo.getType());
                request.setAttribute("userInfo", formData);
                RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_PROFILE_PATH);
                dispatcher.forward(request, response);
            } else {
                currentUserInfo.setEmail(email.trim());
                currentUserInfo.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);

                boolean updated = userRepository.updateUser(currentUserInfo);

                if (updated) {
                    String successMessage = URLEncoder.encode("Cập nhật thông tin thành công!", "UTF-8");
                    response.sendRedirect(request.getContextPath() + "/profile?message=" + successMessage);
                } else {
                    request.setAttribute("errorMessage", "Cập nhật thất bại do lỗi hệ thống.");
                    request.setAttribute("userInfo", currentUserInfo);
                    RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_PROFILE_PATH);
                    dispatcher.forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật thông tin.");
            if (currentUserInfo != null) request.setAttribute("userInfo", currentUserInfo);
            RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_PROFILE_PATH);
            dispatcher.forward(request, response);
        }
    }
}