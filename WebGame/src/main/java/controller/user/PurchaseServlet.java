package controller.user;

import model.GameAccount;
import repository.GameAccountRepository;
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

@WebServlet(name = "PurchaseServlet", urlPatterns = {"/purchase"})
public class PurchaseServlet extends HttpServlet {

    private GameAccountRepository gameAccountRepository;
    private UserRepository userRepository;

    @Override
    public void init() {
        gameAccountRepository = new GameAccountRepository();
        userRepository = new UserRepository();
        System.out.println("PurchaseServlet initialized.");
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            String accountIdParam = request.getParameter("accountId");
            String redirectParams = "?redirect=purchase";
            if (accountIdParam != null) {
                redirectParams += "&accountId=" + accountIdParam;
            }
            response.sendRedirect(request.getContextPath() + "/login" + redirectParams + "&error=" + URLEncoder.encode("Vui lòng đăng nhập để mua hàng.", "UTF-8"));
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String accountIdStr = request.getParameter("accountId");

        try {
            if (accountIdStr == null || accountIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Thiếu ID tài khoản cần mua.");
            }
            int accountId = Integer.parseInt(accountIdStr.trim());
            GameAccount accountToPurchase = gameAccountRepository.getGameAccountById(accountId);
            if (accountToPurchase == null) {
                throw new IllegalArgumentException("Không tìm thấy tài khoản với ID = " + accountId);
            }
            if (!"ACTIVE".equalsIgnoreCase(accountToPurchase.getStatus())) {
                throw new IllegalStateException("Tài khoản này hiện không có sẵn để mua (Trạng thái: " + accountToPurchase.getStatus() + ").");
            }
            request.setAttribute("accountToPurchase", accountToPurchase);
            String jspPath = "/views/user/purchase_confirm.jsp"; // File JSP mới cần tạo
            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid accountId format: " + accountIdStr);
            response.sendRedirect(request.getContextPath() + "/accounts?error=" + URLEncoder.encode("ID tài khoản không hợp lệ.", "UTF-8"));
        } catch (IllegalArgumentException | IllegalStateException e) {
            System.err.println("Error preparing purchase: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/accounts?error=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            System.err.println("Error in PurchaseServlet doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi chuẩn bị trang mua hàng.");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(request.getContextPath() + "/views/user/thanhtoan.jsp").forward(request, response);

    }
}