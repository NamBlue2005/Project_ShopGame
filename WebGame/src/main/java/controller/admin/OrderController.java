package controller.admin;

import model.Order;
import repository.AdminRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "OrderController", urlPatterns = {"/admin/orders"})
public class OrderController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }
        String action = request.getServletPath();

        try {
            if ("/admin/orders".equals(action)) {
                listOrders(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException ex) {
            request.setAttribute("message", "Database error: " + ex.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/views/admin/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String orderIdStr = request.getParameter("orderId");
        String userIdStr = request.getParameter("userId");
        String gameAccountIdStr = request.getParameter("gameAccountId");
        String orderStatus = request.getParameter("orderStatus");

        Integer orderId = (orderIdStr != null && !orderIdStr.isEmpty()) ? Integer.parseInt(orderIdStr) : null;
        Integer userId = (userIdStr != null && !userIdStr.isEmpty()) ? Integer.parseInt(userIdStr) : null;
        Integer gameAccountId = (gameAccountIdStr != null && !gameAccountIdStr.isEmpty()) ? Integer.parseInt(gameAccountIdStr) : null;

        List<Order> orders = AdminRepository.findOrders(orderId, userId, gameAccountId, orderStatus);
        request.setAttribute("orders", orders);
        request.setAttribute("param", request.getParameterMap());
        request.getRequestDispatcher("/views/admin/order_list.jsp").forward(request, response);
    }
}