package controller.user; // Đặt trong package controller.user

import model.User;
import repository.UserRepository;

// --- Sử dụng javax ---
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
// ---

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern; // Import để kiểm tra email

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"}) // Map với URL /register
public class RegisterServlet extends HttpServlet {

    private UserRepository userRepository;
    // Biểu thức chính quy cơ bản để kiểm tra email
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");

    @Override
    public void init() {
        userRepository = new UserRepository();
        System.out.println("RegisterServlet initialized.");
    }

    /**
     * Hiển thị trang đăng ký.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Chỉ cần forward đến trang JSP đăng ký
        String jspPath = "/views/public/register.jsp"; // Đường dẫn đến file JSP form đăng ký
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    /**
     * Xử lý thông tin đăng ký gửi từ form.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy thông tin từ form
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        List<String> errors = new ArrayList<>(); // Lưu danh sách lỗi validation
        boolean success = false;

        // --- Bắt đầu Validation ---
        // 1. Kiểm tra trường bắt buộc
        if (username == null || username.trim().isEmpty()) errors.add("Tên đăng nhập không được để trống.");
        if (email == null || email.trim().isEmpty()) errors.add("Email không được để trống.");
        if (password == null || password.isEmpty()) errors.add("Mật khẩu không được để trống.");
        if (confirmPassword == null || confirmPassword.isEmpty()) errors.add("Xác nhận mật khẩu không được để trống.");

        // 2. Kiểm tra các điều kiện khác nếu các trường cơ bản đã có
        if (errors.isEmpty()) {
            username = username.trim();
            email = email.trim();
            phoneNumber = (phoneNumber != null) ? phoneNumber.trim() : ""; // Cho phép phone rỗng

            // 2.1. Độ dài username
            if (username.length() < 3) errors.add("Tên đăng nhập phải có ít nhất 3 ký tự.");

            // 2.2. Định dạng email
            if (!EMAIL_PATTERN.matcher(email).matches()) errors.add("Định dạng email không hợp lệ.");

            // 2.3. Độ dài mật khẩu
            if (password.length() < 6) errors.add("Mật khẩu phải có ít nhất 6 ký tự.");

            // 2.4. Khớp mật khẩu
            if (!password.equals(confirmPassword)) errors.add("Mật khẩu xác nhận không khớp.");

            // 2.5. Kiểm tra trùng lặp (chỉ kiểm tra nếu các mục trên OK)
            if (errors.isEmpty()) {
                try {
                    if (userRepository.isUsernameExists(username)) {
                        errors.add("Tên đăng nhập này đã được sử dụng.");
                    }
                    // currentUserId = 0 vì đây là thêm mới
                    if (userRepository.isEmailExists(email, 0)) {
                        errors.add("Email này đã được sử dụng.");
                    }
                } catch (Exception e) {
                    errors.add("Lỗi khi kiểm tra thông tin người dùng.");
                    e.printStackTrace(); // Ghi log lỗi DB nếu có
                }
            }
        }
        // --- Kết thúc Validation ---

        // --- Xử lý kết quả ---
        if (!errors.isEmpty()) {
            // Nếu có lỗi validation: Đặt lỗi và dữ liệu cũ vào request, forward về form
            request.setAttribute("errors", errors);
            // Đặt lại dữ liệu đã nhập (trừ password) để hiển thị lại trên form
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            // Forward lại trang register JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/public/register.jsp");
            dispatcher.forward(request, response);
        } else {
            // Nếu không có lỗi validation: Tiến hành thêm user
            try {
                // Tạo user mới, mặc định là 'USER'
                // Lưu ý: Vẫn dùng password thô
                User newUser = new User(username, email, phoneNumber, password, "USER");

                boolean added = userRepository.addUser(newUser);

                if (added) {
                    // Đăng ký thành công: Chuyển hướng đến trang đăng nhập với thông báo
                    String successMessage = URLEncoder.encode("Đăng ký thành công! Vui lòng đăng nhập.", "UTF-8");
                    response.sendRedirect(request.getContextPath() + "/login?register=success&message=" + successMessage);
                } else {
                    // Lỗi không xác định từ repository (ví dụ addUser trả về false)
                    request.setAttribute("errorMessage", "Đăng ký thất bại do lỗi không xác định. Vui lòng thử lại.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/views/public/register.jsp");
                    dispatcher.forward(request, response);
                }
            } catch (Exception e) {
                // Lỗi nghiêm trọng (ví dụ: lỗi DB khi INSERT dù đã check trùng)
                System.err.println("!!! Error during user registration persistence: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi hệ thống trong quá trình đăng ký. Vui lòng thử lại sau.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/public/register.jsp");
                dispatcher.forward(request, response);
            }
        }
    }
}