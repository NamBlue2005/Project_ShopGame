package controller.admin;

import model.TopUpTransaction;
import repository.TopUpTransactionRepository;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TopUpTransactionServlet", urlPatterns = "/admin/topup-transactions")
public class TopUpTransactionServlet extends HttpServlet {

    private TopUpTransactionRepository topUpTransactionRepository = new TopUpTransactionRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userIds = (Integer) session.getAttribute("userId");
        if (userIds == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }
        String transactionIdStr = request.getParameter("transactionId");
        String userIdStr = request.getParameter("userId");
        String status = request.getParameter("status");
        String paymentMethod = request.getParameter("paymentMethod");
        Integer transactionId = null;
        if (transactionIdStr != null && !transactionIdStr.isEmpty()) {
            try {
                transactionId = Integer.parseInt(transactionIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("message", "ID giao dịch không hợp lệ.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/views/admin/adminTopUpTransactions.jsp").forward(request, response);
                return;
            }
        }

        Integer userId = null;
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                userId = Integer.parseInt(userIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("message", "ID người dùng không hợp lệ.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/views/admin/adminTopUpTransactions.jsp").forward(request, response);
                return;
            }
        }


        List<TopUpTransaction> transactions = topUpTransactionRepository.findTopUpTransactions(transactionId, userId, status, paymentMethod);

        request.setAttribute("topUpTransactions", transactions);
        request.getRequestDispatcher("/views/admin/adminTopUpTransactions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}