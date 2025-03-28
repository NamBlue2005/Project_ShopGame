package servlet;

import model.User;
import service.IUserService;
import service.UserService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
    private final IUserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        User user = userService.getUserById(userId);

        if (user == null) {
            response.sendRedirect("error.jsp?message=User+not+found");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        User currentUser = userService.getUserById(userId);

        if (currentUser != null) {
            currentUser.setEmail(request.getParameter("email"));
            currentUser.setPhoneNumber(request.getParameter("phoneNumber"));
            userService.updateUser(currentUser);
            session.setAttribute("user", currentUser);
        }

        response.sendRedirect("profile?updated=true");
    }
}