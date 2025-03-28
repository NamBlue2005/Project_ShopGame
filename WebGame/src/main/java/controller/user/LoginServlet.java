package controller.user;

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

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private UserRepository userRepository;

    @Override
    public void init() {
        userRepository = new UserRepository();
        System.out.println("LoginServlet (User) initialized.");
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");


        String errorMessage = request.getParameter("error");
        if (errorMessage != null && !errorMessage.isEmpty()) {
            request.setAttribute("errorMessage", errorMessage);
        }


        String redirectTarget = request.getParameter("redirect");
        String accountId = request.getParameter("accountId");
        if (redirectTarget != null) request.setAttribute("redirect", redirectTarget);
        if (accountId != null) request.setAttribute("accountId", accountId);

        String jspPath = "/views/public/login.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String redirectTarget = request.getParameter("redirect");
        String accountId = request.getParameter("accountId");

        String destination = request.getContextPath() + "/login";
        String errorMessage = null;


        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            errorMessage = "Vui lòng nhập tên đăng nhập và mật khẩu.";
        } else {
            try {
                User user = userRepository.getUserByUsername(username.trim());

                if (user != null) {

                    if (password.equals(user.getPassword())) {
                        HttpSession session = request.getSession();
                        session.setAttribute("userId", user.getUserId());
                        session.setAttribute("username", user.getUsername());
                        session.setAttribute("userType", user.getType());

                        session.setMaxInactiveInterval(1800);

                        System.out.println("User login successful: " + user.getUsername() + ", Type: " + user.getType());

                        if ("purchase".equals(redirectTarget) && accountId != null && !accountId.isEmpty()) {
                            destination = request.getContextPath() + "/purchase?accountId=" + accountId;
                            System.out.println("Redirecting to purchase page: " + destination);
                        } else {
                            destination = request.getContextPath() + "/accounts"; // Hoặc "/"
                            System.out.println("Redirecting to default page: " + destination);
                        }

                        response.sendRedirect(destination); // Thực hiện chuyển hướng
                        return;

                    } else {
                        errorMessage = "Tên đăng nhập hoặc mật khẩu không chính xác.";
                    }
                } else {
                    errorMessage = "Tên đăng nhập hoặc mật khẩu không chính xác.";
                }
            } catch (Exception e) {
                System.err.println("!!! Error during user login: " + e.getMessage());
                e.printStackTrace();
                errorMessage = "Đã xảy ra lỗi hệ thống trong quá trình đăng nhập.";
            }
        }

        System.out.println("Login failed for user: " + username + ", Reason: " + errorMessage);
        String redirectParams = "?error=" + URLEncoder.encode(errorMessage, "UTF-8");
        if (redirectTarget != null) redirectParams += "&redirect=" + redirectTarget;
        if (accountId != null) redirectParams += "&accountId=" + accountId;

        response.sendRedirect(request.getContextPath() + "/login" + redirectParams);
    }
}