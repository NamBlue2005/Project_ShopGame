package controller.admin;

import model.Order;
// import repository.AdminRepository; // Chắc là dùng OrderRepository thay thế?
import repository.OrderRepository; // Import OrderRepository mới (hoặc repo chứa hàm update status)

import javax.servlet.RequestDispatcher; // Đổi sang javax nếu dùng javax
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder; // Import để encode message
import java.sql.SQLException;
import java.util.ArrayList; // Import nếu cần
import java.util.List;

// Thêm mapping mới vào đây
@WebServlet(name = "OrderController", urlPatterns = {"/admin/orders", "/admin/orders/updateStatus"})
public class OrderController extends HttpServlet {

    // Khởi tạo OrderRepository (thay vì AdminRepository nếu hàm xử lý order nằm riêng)
    private OrderRepository orderRepository;
    // private AdminRepository adminRepository; // Bỏ nếu không dùng đến

    private static final String JSP_LIST_PATH = "/views/admin/order_list.jsp"; // Đường dẫn JSP list

    @Override
    public void init() {
        orderRepository = new OrderRepository(); // Khởi tạo repo
        // adminRepository = new AdminRepository();
        System.out.println("OrderController initialized.");
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        String action = request.getServletPath();
        System.out.println("OrderController doGet: " + action);

        try {
            if ("/admin/orders".equals(action)) {
                listOrders(request, response);
            } else {
                // Các action GET khác nếu có (ví dụ: xem chi tiết)
                // Hiện tại không có action GET nào khác liên quan đến /updateStatus
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) { // Bắt Exception rộng hơn
            handleErrorForward(request, response, "Lỗi tải danh sách đơn hàng: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Yêu cầu không hợp lệ.");
            return;
        }

        String action = request.getServletPath();
        System.out.println("OrderController doPost: " + action);

        try {
            // Thêm xử lý cho action mới
            if ("/admin/orders/updateStatus".equals(action)) {
                updateOrderStatus(request, response);
            } else {
                // Các action POST khác nếu có
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            }
        } catch (Exception e) { // Bắt Exception rộng hơn
            handleErrorRedirect(request, response, "Lỗi xử lý yêu cầu cập nhật: " + e.getMessage(), e);
        }
    }

    // listOrders: Sửa lại để gọi hàm tìm kiếm từ OrderRepository nếu cần
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        // Đọc thông báo từ URL param (nếu redirect từ update/delete)
        String message = request.getParameter("message");
        String messageType = request.getParameter("messageType");
        if (message != null && !message.isEmpty()) {
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType != null ? messageType : "info");
        }

        String orderIdStr = request.getParameter("orderId");
        String userIdStr = request.getParameter("userId");
        String gameAccountIdStr = request.getParameter("gameAccountId");
        String orderStatus = request.getParameter("orderStatus");

        // Parse parameters (nên dùng hàm helper để tránh lặp code và lỗi)
        Integer orderId = parseIntParameter(request, "orderId", null);
        Integer userId = parseIntParameter(request, "userId", null);
        Integer gameAccountId = parseIntParameter(request, "gameAccountId", null);

        List<Order> orders = new ArrayList<>(); // Khởi tạo list rỗng
        try {
            // Giả sử bạn có hàm findOrders trong OrderRepository tương tự như trong AdminRepository cũ
            // Hoặc gọi hàm getAllOrders nếu không tìm kiếm
            // orders = orderRepository.findOrders(orderId, userId, gameAccountId, orderStatus);
            // Tạm thời lấy tất cả nếu chưa có hàm findOrders riêng
            orders = orderRepository.getAllOrders(); // Cần tạo hàm này trong OrderRepository
        } catch (Exception e) {
            System.err.println("Error fetching orders: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách đơn hàng."); // Đặt lỗi vào request
        }

        request.setAttribute("orders", orders);
        // Giữ lại các tham số tìm kiếm để hiển thị lại trên form
        request.setAttribute("paramOrderId", orderIdStr); // Gửi lại string gốc
        request.setAttribute("paramUserId", userIdStr);
        request.setAttribute("paramGameAccountId", gameAccountIdStr);
        request.setAttribute("paramOrderStatus", orderStatus);

        RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_LIST_PATH);
        dispatcher.forward(request, response);
    }

    // --- HÀM MỚI ĐỂ CẬP NHẬT STATUS ---
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String message;
        String messageType = "danger"; // Mặc định lỗi

        try {
            int orderId = parseIntParameter(request, "orderId", -1); // Đọc từ input ẩn
            String newStatus = request.getParameter("newOrderStatus"); // Đọc từ select

            // Validation cơ bản
            if (orderId <= 0) {
                throw new IllegalArgumentException("ID đơn hàng không hợp lệ.");
            }
            if (newStatus == null || (!newStatus.equals("pending") && !newStatus.equals("completed") && !newStatus.equals("cancelled"))) {
                throw new IllegalArgumentException("Trạng thái mới không hợp lệ.");
            }

            // Gọi hàm repository để cập nhật (cần tạo hàm này)
            boolean success = orderRepository.updateOrderStatus(orderId, newStatus);

            if (success) {
                message = "Cập nhật trạng thái đơn hàng #" + orderId + " thành công!";
                messageType = "success";
            } else {
                message = "Cập nhật trạng thái đơn hàng #" + orderId + " thất bại (có thể do đơn hàng không tồn tại).";
            }

        } catch (IllegalArgumentException e) {
            message = "Dữ liệu không hợp lệ: " + e.getMessage();
        } catch (Exception e) { // Bắt các lỗi khác (ví dụ SQLException từ repo)
            message = "Lỗi hệ thống khi cập nhật trạng thái.";
            handleErrorRedirect(request, response, message, e); // Dùng hàm redirect lỗi
            return; // Quan trọng
        }

        // Redirect về trang danh sách với thông báo
        sendRedirectWithMessage(request, response, "/admin/orders", message, messageType);
    }
    // --- HẾT HÀM MỚI ---


    // --- Các hàm helper (giữ nguyên hoặcปรับปรุง) ---
    private void handleErrorForward(HttpServletRequest request, HttpServletResponse response, String errorMessage, Exception e) throws ServletException, IOException {
        if (e != null) { e.printStackTrace(); }
        request.setAttribute("error", errorMessage); // Đặt lỗi vào request attribute
        RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_LIST_PATH); // Forward về trang list
        dispatcher.forward(request, response);
    }

    private void handleErrorRedirect(HttpServletRequest request, HttpServletResponse response, String errorMessage, Exception e) throws IOException {
        if (e != null) { e.printStackTrace(); }
        sendRedirectWithMessage(request, response, "/admin/orders", errorMessage, "danger");
    }

    private void sendRedirectWithMessage(HttpServletRequest request, HttpServletResponse response, String targetUrl, String message, String messageType) throws IOException {
        String encodedMessage = "";
        String finalUrl = request.getContextPath() + targetUrl;
        String separator = (finalUrl.contains("?")) ? "&" : "?"; // Kiểm tra nếu URL đã có ?

        if (message != null && !message.isEmpty()) {
            try {
                encodedMessage = URLEncoder.encode(message, "UTF-8");
                finalUrl += separator + "message=" + encodedMessage;
                separator = "&";
            }
            catch (UnsupportedEncodingException e) { e.printStackTrace(); }
        }
        if (messageType != null && !messageType.isEmpty()) {
            finalUrl += separator + "messageType=" + messageType;
        }
        response.sendRedirect(finalUrl);
    }

    private Integer parseIntParameter(HttpServletRequest request, String paramName, Integer defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try { return Integer.parseInt(paramValue.trim()); }
            catch (NumberFormatException e) { /* Ignore */ }
        }
        return defaultValue;
    }
    // Thêm hàm parseDouble nếu cần
    // --- ---
}