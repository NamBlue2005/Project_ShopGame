package controller.user;

import model.User;
import repository.UserRepository;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UserLoginServlet", urlPatterns = "/login")
public class UserLogin extends HttpServlet {
    private final UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("views/user/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        User user = userRepository.findByEmailAndPassword(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userType", user.getType());

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("views/user/login.jsp").forward(request, response);
        }
    }
}
