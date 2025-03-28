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

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && "ADMIN".equals(session.getAttribute("userType"));
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/adminLogin?error=Unauthorized");
            return;
        }

        HttpSession session = request.getSession();
        String message = (String) session.getAttribute("message");
        if (message != null) {
            request.setAttribute("message", message);
            session.removeAttribute("message");
        }
        String error = (String) session.getAttribute("error");
        if (error != null) {

            if ("validationFailed".equals(request.getParameter("error"))) {
                List<String> validationErrors = (List<String>) session.getAttribute("validationErrors");
                if(validationErrors != null) {
                    request.setAttribute("errors", validationErrors); 
                    session.removeAttribute("validationErrors");

                } else {
                    request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
                }
            } else {
                request.setAttribute("error", error);
            }
            session.removeAttribute("error");
        }


        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {

                case "delete":
                    deleteUser(request, response);
                    break;
                case "search":
                    searchUsers(request, response);
                    break;
                case "list":
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in UserServlet doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            listUsers(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/adminLogin?error=Unauthorized");
            return;
        }

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
                    insertUser(request, response);
                    break;
                case "update":
                    updateUser(request, response);
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


    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> userList = userRepository.getAllUsers();
        request.setAttribute("userList", userList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/user-list.jsp"); 
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

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/user-list.jsp"); 
        dispatcher.forward(request, response);
    }
    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        boolean success = false;

        try {
          
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String password = request.getParameter("password");
            String type = request.getParameter("type");

        
            if (username == null || username.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    password == null || password.isEmpty() || 
                    type == null || type.trim().isEmpty())
            {
                session.setAttribute("error", "Vui lòng điền đầy đủ các trường bắt buộc (*).");
                response.sendRedirect(request.getContextPath() + "/admin/users?error=missingFields");
                return;
            }

           
            User newUser = new User(username.trim(), email.trim(), (phoneNumber != null ? phoneNumber.trim() : null), password, type);

            System.out.println("Attempting to add user (simplified): " + newUser.getUsername()); 
            success = userRepository.addUser(newUser);

          
            if (success) {
                System.out.println("User added successfully: " + newUser.getUsername());
                session.setAttribute("message", "Thêm người dùng '" + username + "' thành công!");
            } else {
              
                System.err.println("repository.addUser returned false for user: " + newUser.getUsername());
                session.setAttribute("error", "Thêm người dùng thất bại. Kiểm tra lại thông tin hoặc liên hệ quản trị viên.");
            }

        } catch (Exception e) { 
            
            System.err.println("!!! Error inserting user DB (simplified): " + e.getMessage());
            e.printStackTrace(); 
           
            session.setAttribute("error", "Lỗi khi thêm người dùng. Nguyên nhân có thể do trùng tên đăng nhập/email hoặc lỗi hệ thống.");
            
        }

     
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdParam = request.getParameter("userId");
        int userId = -1;
        try {
            userId = Integer.parseInt(userIdParam);
            String username = request.getParameter("username").trim();
            String email = request.getParameter("email").trim();
            String phoneNumber = request.getParameter("phoneNumber").trim();
            String password = request.getParameter("password");
            String type = request.getParameter("type");


            List<String> errors = validateUserInput(username, email, null, userId); 


            if (password != null && !password.isEmpty() && password.length() < 6) {
                errors.add("Mật khẩu mới phải có ít nhất 6 ký tự.");
            }

            if (!errors.isEmpty()) {
                session.setAttribute("validationErrors", errors);
                User formData = new User(username, email, phoneNumber, "", type);
                formData.setUserId(userId);
                session.setAttribute("formData", formData);

                response.sendRedirect(request.getContextPath() + "/admin/users?error=validationFailed&id=" + userId); 
                return;
            }

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
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }


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

    private List<String> validateUserInput(String username, String email, String password, int currentUserId) {
        List<String> errors = new ArrayList<>();

        if (username == null || username.trim().isEmpty()) { errors.add("Tên đăng nhập không được để trống."); }
        else if (username.length() < 3) { errors.add("Tên đăng nhập phải có ít nhất 3 ký tự."); }
        else if (currentUserId <= 0 && userRepository.isUsernameExists(username)) { errors.add("Tên đăng nhập '" + username + "' đã tồn tại.");}

        if (email == null || email.trim().isEmpty()) { errors.add("Email không được để trống."); }
        else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) { errors.add("Định dạng email không hợp lệ."); }
        else if (userRepository.isEmailExists(email, currentUserId)) { errors.add("Email '" + email + "' đã được sử dụng."); }

        if (currentUserId <= 0) { 
            if (password == null || password.isEmpty()) { errors.add("Mật khẩu không được để trống khi thêm mới."); }
            else if (password.length() < 6) { errors.add("Mật khẩu phải có ít nhất 6 ký tự."); }
        }

        return errors;
    }


}
