package controller.user; // Đặt trong package controller.user như bạn yêu cầu

import model.User;
import repository.UserRepository;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"}) // Map với URL /login
public class LoginServlet extends HttpServlet {

    private UserRepository userRepository;

    @Override
    public void init() {
        userRepository = new UserRepository(); // Khởi tạo UserRepository
        System.out.println("LoginServlet (User) initialized.");
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy thông báo lỗi (nếu có từ redirect sau POST thất bại)
        String errorMessage = request.getParameter("error");
        if (errorMessage != null && !errorMessage.isEmpty()) {
            request.setAttribute("errorMessage", errorMessage); // Đặt vào request để JSP hiển thị
        }

        // Lấy và chuyển tiếp các tham số redirect để giữ ngữ cảnh
        String redirectTarget = request.getParameter("redirect");
        String accountId = request.getParameter("accountId");
        if (redirectTarget != null) request.setAttribute("redirect", redirectTarget);
        if (accountId != null) request.setAttribute("accountId", accountId);

        // Forward đến trang login JSP (theo đường dẫn bạn yêu cầu)
        String jspPath = "/views/public/login.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    /**
     * Xử lý thông tin đăng nhập gửi từ form.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy thông tin từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Lấy lại tham số redirect từ hidden input (nếu có)
        String redirectTarget = request.getParameter("redirect");
        String accountId = request.getParameter("accountId");

        String destination = request.getContextPath() + "/login"; // Trang mặc định nếu đăng nhập lỗi
        String errorMessage = null;

        // Kiểm tra dữ liệu đầu vào cơ bản
        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            errorMessage = "Vui lòng nhập tên đăng nhập và mật khẩu.";
        } else {
            try {
                // Tìm user trong DB bằng username
                // Đảm bảo UserRepository có hàm này và nó trả về User object (có cả password)
                User user = userRepository.getUserByUsername(username.trim());

                if (user != null) {
                    // Nếu tìm thấy user, kiểm tra mật khẩu
                    // !!! CẢNH BÁO: So sánh mật khẩu dạng text thô - KHÔNG AN TOÀN !!!
                    // Chỉ dùng tạm vì bạn yêu cầu bỏ qua hashing
                    if (password.equals(user.getPassword())) {
                        // --- Đăng nhập thành công ---

                        // Tạo hoặc lấy session hiện có
                        HttpSession session = request.getSession();

                        // Lưu thông tin cần thiết vào session
                        session.setAttribute("userId", user.getUserId());
                        session.setAttribute("username", user.getUsername());
                        session.setAttribute("userType", user.getType()); // Lưu cả loại user

                        // Đặt thời gian timeout cho session (ví dụ: 1800 giây = 30 phút)
                        session.setMaxInactiveInterval(1800);

                        System.out.println("User login successful: " + user.getUsername() + ", Type: " + user.getType());

                        // --- Xử lý chuyển hướng ---
                        if ("purchase".equals(redirectTarget) && accountId != null && !accountId.isEmpty()) {
                            // Nếu trước đó người dùng bấm "Mua ngay", chuyển đến trang mua hàng
                            destination = request.getContextPath() + "/purchase?accountId=" + accountId;
                            System.out.println("Redirecting to purchase page: " + destination);
                        } else {
                            // Nếu không, chuyển về trang danh sách tài khoản công khai hoặc trang chủ
                            destination = request.getContextPath() + "/accounts"; // Hoặc "/"
                            System.out.println("Redirecting to default page: " + destination);
                        }

                        response.sendRedirect(destination); // Thực hiện chuyển hướng
                        return; // *** Rất quan trọng: Kết thúc xử lý sau khi redirect thành công ***

                    } else {
                        // Sai mật khẩu
                        errorMessage = "Tên đăng nhập hoặc mật khẩu không chính xác.";
                    }
                } else {
                    // Không tìm thấy username
                    errorMessage = "Tên đăng nhập hoặc mật khẩu không chính xác.";
                }
            } catch (Exception e) {
                // Lỗi không mong muốn (ví dụ: lỗi kết nối DB)
                System.err.println("!!! Error during user login: " + e.getMessage());
                e.printStackTrace();
                errorMessage = "Đã xảy ra lỗi hệ thống trong quá trình đăng nhập.";
            }
        }

        // --- Xử lý khi đăng nhập thất bại ---
        System.out.println("Login failed for user: " + username + ", Reason: " + errorMessage);
        // Redirect về trang login, gửi kèm thông báo lỗi và các tham số redirect
        String redirectParams = "?error=" + URLEncoder.encode(errorMessage, "UTF-8");
        if (redirectTarget != null) redirectParams += "&redirect=" + redirectTarget;
        if (accountId != null) redirectParams += "&accountId=" + accountId;

        response.sendRedirect(request.getContextPath() + "/login" + redirectParams);
    }
}