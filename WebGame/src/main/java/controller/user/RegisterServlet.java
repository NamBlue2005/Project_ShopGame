package controller.user; 

import model.User;
import repository.UserRepository;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern; 

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"}) 
public class RegisterServlet extends HttpServlet {

    private UserRepository userRepository;
 
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");

    @Override
    public void init() {
        userRepository = new UserRepository();
        System.out.println("RegisterServlet initialized.");
    }

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

      
        String jspPath = "/views/public/register.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

       
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        List<String> errors = new ArrayList<>(); 
        boolean success = false;

    
        if (username == null || username.trim().isEmpty()) errors.add("Tên đăng nhập không được để trống.");
        if (email == null || email.trim().isEmpty()) errors.add("Email không được để trống.");
        if (password == null || password.isEmpty()) errors.add("Mật khẩu không được để trống.");
        if (confirmPassword == null || confirmPassword.isEmpty()) errors.add("Xác nhận mật khẩu không được để trống.");

       
        if (errors.isEmpty()) {
            username = username.trim();
            email = email.trim();
            phoneNumber = (phoneNumber != null) ? phoneNumber.trim() : ""; 

           
            if (username.length() < 3) errors.add("Tên đăng nhập phải có ít nhất 3 ký tự.");

          
            if (!EMAIL_PATTERN.matcher(email).matches()) errors.add("Định dạng email không hợp lệ.");

          
            if (password.length() < 6) errors.add("Mật khẩu phải có ít nhất 6 ký tự.");

           
            if (!password.equals(confirmPassword)) errors.add("Mật khẩu xác nhận không khớp.");

            if (errors.isEmpty()) {
                try {
                    if (userRepository.isUsernameExists(username)) {
                        errors.add("Tên đăng nhập này đã được sử dụng.");
                    }
                    
                    if (userRepository.isEmailExists(email, 0)) {
                        errors.add("Email này đã được sử dụng.");
                    }
                } catch (Exception e) {
                    errors.add("Lỗi khi kiểm tra thông tin người dùng.");
                    e.printStackTrace(); 
                }
            }
        }

        if (!errors.isEmpty()) {
          
            request.setAttribute("errors", errors);
          
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
          
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/public/register.jsp");
            dispatcher.forward(request, response);
        } else {
          
            try {
            
                User newUser = new User(username, email, phoneNumber, password, "USER");

                boolean added = userRepository.addUser(newUser);

                if (added) {
                  
                    String successMessage = URLEncoder.encode("Đăng ký thành công! Vui lòng đăng nhập.", "UTF-8");
                    response.sendRedirect(request.getContextPath() + "/login?register=success&message=" + successMessage);
                } else {
               
                    request.setAttribute("errorMessage", "Đăng ký thất bại do lỗi không xác định. Vui lòng thử lại.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/views/public/register.jsp");
                    dispatcher.forward(request, response);
                }
            } catch (Exception e) {
               
                System.err.println("!!! Error during user registration persistence: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi hệ thống trong quá trình đăng ký. Vui lòng thử lại sau.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/public/register.jsp");
                dispatcher.forward(request, response);
            }
        }
    }
}
