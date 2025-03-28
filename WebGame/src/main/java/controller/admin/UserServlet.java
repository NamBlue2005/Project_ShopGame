package controller.admin;

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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UserServlet", urlPatterns = {"/admin/users"})
public class UserServlet extends HttpServlet {

    private UserRepository userRepository;

    @Override
    public void init() {
        userRepository = new UserRepository();
    }

    // --- HÀM KIỂM TRA SESSION ADMIN ---
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && "ADMIN".equals(session.getAttribute("userType"));
    }
    // --- ---

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // --- KIỂM TRA QUYỀN ADMIN ---
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/adminLogin?error=Unauthorized");
            return;
        }
        // --- ---

        // Lấy session để xử lý message/error từ redirect trước đó
        HttpSession session = request.getSession();
        String message = (String) session.getAttribute("message");
        if (message != null) {
            request.setAttribute("message", message);
            session.removeAttribute("message");
        }
        String error = (String) session.getAttribute("error");
        if (error != null) {
            // Phân biệt lỗi validation với lỗi khác nếu cần
            if ("validationFailed".equals(request.getParameter("error"))) {
                List<String> validationErrors = (List<String>) session.getAttribute("validationErrors");
                if(validationErrors != null) {
                    request.setAttribute("errors", validationErrors); // Đặt lỗi validation vào request để JSP hiển thị
                    session.removeAttribute("validationErrors");
                    // (Optional) Lấy dữ liệu form cũ nếu lưu trong session
                    // User formData = (User) session.getAttribute("formData");
                    // if (formData != null) {
                    //     request.setAttribute("formData", formData);
                    //     session.removeAttribute("formData");
                    // }
                } else {
                    request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại."); // Lỗi chung nếu không thấy validationErrors
                }
            } else {
                request.setAttribute("error", error); // Lỗi thông thường khác
            }
            session.removeAttribute("error"); // Xóa key lỗi chung khỏi session
        }


        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                // case "add": // Không cần nữa, form trong modal
                //     break;
                // case "edit": // Không cần nữa, form trong modal
                //     break;
                case "delete":
                    deleteUser(request, response); // Vẫn cần xử lý delete
                    break;       // Quan trọng: break sau delete để không chạy listUsers ngay
                case "search":
                    searchUsers(request, response);
                    break;
                case "list":
                default:
                    listUsers(request, response); // Hiển thị danh sách (mặc định)
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in UserServlet doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            listUsers(request, response); // Cố gắng hiển thị lại trang list với lỗi
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // --- KIỂM TRA QUYỀN ADMIN ---
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/adminLogin?error=Unauthorized");
            return;
        }
        // --- ---

        // Lấy session để dùng cho việc đặt message/error
        HttpSession session = request.getSession();

        String action = request.getParameter("action");
        if (action == null) {
            session.setAttribute("error", "Hành động không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            switch (action) {
                case "save":
                    insertUser(request, response); // Gọi hàm xử lý insert
                    break;
                case "update":
                    updateUser(request, response); // Gọi hàm xử lý update
                    break;
                default:
                    session.setAttribute("error", "Hành động không được hỗ trợ.");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in UserServlet doPost: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống khi xử lý yêu cầu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    // --- Các phương thức xử lý nghiệp vụ ---

    // listUsers, searchUsers: Giữ nguyên như trước

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> userList = userRepository.getAllUsers();
        request.setAttribute("userList", userList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/user-list.jsp"); // Đổi tên JSP
        dispatcher.forward(request, response);
    }

    private void searchUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("searchTerm");
        String searchType = request.getParameter("searchType");

        List<User> userList = userRepository.searchUsers(searchTerm, searchType);

        request.setAttribute("userList", userList);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("searchType", searchType);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/user-list.jsp"); // Đổi tên JSP
        dispatcher.forward(request, response);
    }


    // showAddForm, showEditForm: Không cần nữa

    // insertUser: Cập nhật xử lý lỗi validation
    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = request.getParameter("username").trim();
        String email = request.getParameter("email").trim();
        String phoneNumber = request.getParameter("phoneNumber").trim();
        String password = request.getParameter("password");
        String type = request.getParameter("type");

        // --- Validation ---
        List<String> errors = validateUserInput(username, email, password, 0);
        if (!errors.isEmpty()) {
            // *** THAY ĐỔI: Lưu lỗi vào session và redirect ***
            session.setAttribute("validationErrors", errors);
            // (Optional) Lưu dữ liệu form vào session để điền lại (khá phức tạp với modal sau redirect)
            User formData = new User(username, email, phoneNumber, "", type); // Không lưu lại pass
            session.setAttribute("formData", formData); // Lưu ý: JSP cần đọc và xử lý cái này nếu muốn điền lại

            response.sendRedirect(request.getContextPath() + "/admin/users?error=validationFailed"); // Redirect về list
            return; // Dừng xử lý
        }
        // --- Hết Validation ---

        User newUser = new User(username, email, phoneNumber, password, type); // Dùng pass trực tiếp

        try {
            if (userRepository.addUser(newUser)) {
                session.setAttribute("message", "Thêm người dùng '" + username + "' thành công!");
            } else {
                session.setAttribute("error", "Thêm người dùng thất bại do lỗi không xác định."); // Lỗi chung
            }
        } catch (Exception e) {
            System.err.println("Error inserting user DB: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu khi thêm người dùng.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users"); // Redirect về list sau khi xử lý
    }

    // updateUser: Cập nhật xử lý lỗi validation
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdParam = request.getParameter("userId");
        int userId = -1; // Giá trị mặc định nếu parse lỗi

        try {
            userId = Integer.parseInt(userIdParam);
            String username = request.getParameter("username").trim();
            String email = request.getParameter("email").trim();
            String phoneNumber = request.getParameter("phoneNumber").trim();
            String password = request.getParameter("password");
            String type = request.getParameter("type");

            // --- Validation ---
            List<String> errors = validateUserInput(username, email, null, userId); // null cho pass khi update

            // Thêm check độ dài password nếu có nhập
            if (password != null && !password.isEmpty() && password.length() < 6) {
                errors.add("Mật khẩu mới phải có ít nhất 6 ký tự.");
            }

            if (!errors.isEmpty()) {
                // *** THAY ĐỔI: Lưu lỗi vào session và redirect ***
                session.setAttribute("validationErrors", errors);
                // (Optional) Lưu dữ liệu form
                User formData = new User(username, email, phoneNumber, "", type);
                formData.setUserId(userId);
                session.setAttribute("formData", formData);

                response.sendRedirect(request.getContextPath() + "/admin/users?error=validationFailed&id=" + userId); // Redirect về list, có thể kèm ID
                return; // Dừng xử lý
            }
            // --- Hết Validation ---

            User user = new User(username, email, phoneNumber, password, type);
            user.setUserId(userId);

            boolean result;
            if (password != null && !password.isEmpty()) {
                result = userRepository.updateUserWithPassword(user);
            } else {
                result = userRepository.updateUser(user);
            }

            if (result) {
                session.setAttribute("message", "Cập nhật người dùng ID " + userId + " thành công!");
            } else {
                session.setAttribute("error", "Cập nhật người dùng ID " + userId + " thất bại.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID người dùng không hợp lệ: " + userIdParam);
        } catch (Exception e) {
            System.err.println("Error updating user DB: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu khi cập nhật người dùng.");
        }
        // Luôn redirect về list sau khi xử lý xong (kể cả lỗi DB)
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }


    // deleteUser: Giữ nguyên như trước (đã có session check + tự xóa)
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            int userIdToDelete = Integer.parseInt(request.getParameter("id"));
            Integer currentAdminUserId = (Integer) session.getAttribute("userId");

            if (currentAdminUserId != null && currentAdminUserId == userIdToDelete) {
                session.setAttribute("error", "Bạn không thể tự xóa tài khoản admin của mình!");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            if (userRepository.deleteUser(userIdToDelete)) {
                session.setAttribute("message", "Xóa người dùng ID " + userIdToDelete + " thành công!");
            } else {
                session.setAttribute("error", "Xóa người dùng ID " + userIdToDelete + " thất bại. Người dùng có thể không tồn tại hoặc có dữ liệu liên quan.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID người dùng không hợp lệ.");
        } catch (Exception e) {
            System.err.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Lỗi khi xóa người dùng: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    // validateUserInput: Giữ nguyên như trước
    private List<String> validateUserInput(String username, String email, String password, int currentUserId) {
        List<String> errors = new ArrayList<>();
        // Username
        if (username == null || username.trim().isEmpty()) { errors.add("Tên đăng nhập không được để trống."); }
        else if (username.length() < 3) { errors.add("Tên đăng nhập phải có ít nhất 3 ký tự."); }
        else if (currentUserId <= 0 && userRepository.isUsernameExists(username)) { errors.add("Tên đăng nhập '" + username + "' đã tồn tại.");}
        // Email
        if (email == null || email.trim().isEmpty()) { errors.add("Email không được để trống."); }
        else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) { errors.add("Định dạng email không hợp lệ."); }
        else if (userRepository.isEmailExists(email, currentUserId)) { errors.add("Email '" + email + "' đã được sử dụng."); }
        // Password (chỉ check độ dài nếu nhập, bắt buộc khi thêm mới)
        if (currentUserId <= 0) { // Thêm mới
            if (password == null || password.isEmpty()) { errors.add("Mật khẩu không được để trống khi thêm mới."); }
            else if (password.length() < 6) { errors.add("Mật khẩu phải có ít nhất 6 ký tự."); }
        }
        // Lưu ý: Không check độ dài pass khi update ở đây nữa vì đã check trong updateUser
        return errors;
    }


    @Override
    public void destroy() {
        // Dọn dẹp nếu cần
    }
}