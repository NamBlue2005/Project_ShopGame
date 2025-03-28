package controller.user;

import model.GameAccount;
import model.User; // Giả sử bạn muốn hiển thị cả thông tin người mua
import repository.GameAccountRepository;
import repository.UserRepository; // Repo để lấy thông tin user nếu cần

// --- Sử dụng javax ---
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
// ---

import java.io.IOException;
import java.net.URLEncoder;

// Map servlet với URL /purchase cho cả GET và POST
@WebServlet(name = "PurchaseServlet", urlPatterns = {"/purchase"})
public class PurchaseServlet extends HttpServlet {

    private GameAccountRepository gameAccountRepository;
    private UserRepository userRepository; // Optional: Nếu muốn lấy thông tin user

    @Override
    public void init() {
        gameAccountRepository = new GameAccountRepository();
        userRepository = new UserRepository(); // Khởi tạo nếu dùng
        System.out.println("PurchaseServlet initialized.");
    }

    /**
     * Hiển thị trang xác nhận mua hàng.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // 1. Kiểm tra đăng nhập
        if (session == null || session.getAttribute("userId") == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang login, lưu lại đích đến là purchase
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
            // 2. Validate Account ID
            if (accountIdStr == null || accountIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Thiếu ID tài khoản cần mua.");
            }
            int accountId = Integer.parseInt(accountIdStr.trim());

            // 3. Lấy thông tin tài khoản game từ DB (bao gồm cả giá)
            // Đảm bảo hàm getGameAccountById lấy cả giá (do mapResultSetToGameAccount đã sửa)
            GameAccount accountToPurchase = gameAccountRepository.getGameAccountById(accountId);

            // 4. Kiểm tra tài khoản có tồn tại và có đang bán không ('ACTIVE')
            if (accountToPurchase == null) {
                throw new IllegalArgumentException("Không tìm thấy tài khoản với ID = " + accountId);
            }
            if (!"ACTIVE".equalsIgnoreCase(accountToPurchase.getStatus())) {
                // Nếu không active (ví dụ: đã bán, bị khóa...) thì không cho mua
                throw new IllegalStateException("Tài khoản này hiện không có sẵn để mua (Trạng thái: " + accountToPurchase.getStatus() + ").");
            }

            // 5. (Tùy chọn) Lấy thông tin người dùng đang đăng nhập
            // User buyer = userRepository.getUserById(userId);
            // request.setAttribute("buyerInfo", buyer);

            // 6. Đặt thông tin tài khoản vào request để JSP hiển thị
            request.setAttribute("accountToPurchase", accountToPurchase);

            // 7. Forward đến trang JSP xác nhận
            String jspPath = "/views/user/purchase_confirm.jsp"; // File JSP mới cần tạo
            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu accountId không phải là số
            System.err.println("Invalid accountId format: " + accountIdStr);
            response.sendRedirect(request.getContextPath() + "/accounts?error=" + URLEncoder.encode("ID tài khoản không hợp lệ.", "UTF-8"));
        } catch (IllegalArgumentException | IllegalStateException e) {
            // Xử lý lỗi không tìm thấy tài khoản hoặc tài khoản không hợp lệ
            System.err.println("Error preparing purchase: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/accounts?error=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            // Xử lý lỗi chung khác
            System.err.println("Error in PurchaseServlet doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi chuẩn bị trang mua hàng.");
        }
    }

    /**
     * Xử lý yêu cầu xác nhận mua hàng (sẽ làm ở bước sau).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(request.getContextPath() + "/views/user/thanhtoan.jsp").forward(request, response);
//        response.getWriter().println("<html><body><h1>POST request to /purchase received. Processing coming soon...</h1></body></html>");

    }
}