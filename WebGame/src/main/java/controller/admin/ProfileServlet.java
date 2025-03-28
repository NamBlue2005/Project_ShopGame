package controller.admin;

import model.User;
import repository.AdminRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null && session.getAttribute("userType").equals("ADMIN")) {
            try {
                int userId = (Integer) session.getAttribute("userId");
                User userProfile = AdminRepository.getAdminUserById(userId);

                if (userProfile != null) {
                    request.setAttribute("userProfile", userProfile);
                    request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);
                } else {

                    request.setAttribute("errorMessage", "Could not retrieve profile information for user ID: " + userId);
                    request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);
                       }
            } catch (NumberFormatException e) {
                System.err.println("Invalid userId format in session.");
                response.sendRedirect(request.getContextPath() + "/adminLogin?error=InvalidSessionData");
            } catch (Exception e) {
                System.err.println("Unexpected error in ProfileServlet: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("errorMessage", "An unexpected error occurred while retrieving the profile.");
                request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/adminLogin?error=Unauthorized");
        }
    }
}