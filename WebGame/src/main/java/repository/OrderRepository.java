package repository;

import model.Order; // Import model Order
import connect.DatabaseConnection; // Import lớp kết nối của bạn

import java.sql.*; // Import các lớp cần thiết của JDBC

public class OrderRepository {

    // Câu lệnh SQL để thêm một đơn hàng mới
    private static final String INSERT_ORDER =
            "INSERT INTO Orders (user_id, game_account_id, order_date, order_status, total_amount, payment_method, discount_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

    /**
     * Thêm một đơn hàng mới vào cơ sở dữ liệu sử dụng Connection được cung cấp.
     * Được thiết kế để chạy bên trong một transaction do lớp khác quản lý (ví dụ: Servlet).
     *
     * @param order Đối tượng Order chứa thông tin đơn hàng cần thêm.
     * @param conn  Đối tượng Connection đã được thiết lập transaction (setAutoCommit(false)).
     * @return true nếu thêm thành công (ít nhất 1 dòng bị ảnh hưởng), false nếu không.
     * @throws SQLException Nếu có lỗi xảy ra trong quá trình thực thi SQL (để Servlet có thể rollback).
     */
    public boolean addOrder(Order order, Connection conn) throws SQLException {
        // Hàm này không tự mở/đóng connection, mà dùng connection được truyền vào.
        // Nó cũng không tự commit hay rollback, việc đó do nơi gọi (Servlet) quyết định.
        // Nó cũng không bắt SQLException mà ném ra để nơi gọi biết và rollback.

        // Sử dụng try-with-resources cho PreparedStatement để nó tự đóng
        try (PreparedStatement ps = conn.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getGameAccountId());
            // Đảm bảo orderDate không null trước khi set (có thể đặt trong servlet)
            ps.setTimestamp(3, (order.getOrderDate() != null) ? order.getOrderDate() : new Timestamp(System.currentTimeMillis()));
            ps.setString(4, order.getOrderStatus());
            ps.setDouble(5, order.getTotalAmount());
            ps.setString(6, order.getPaymentMethod());

            // Xử lý discountId có thể null
            if (order.getDiscountId() != null) {
                ps.setInt(7, order.getDiscountId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            // Thực thi lệnh INSERT
            int affectedRows = ps.executeUpdate();

            // (Tùy chọn) Lấy và đặt ID vừa được tạo cho đối tượng Order
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setOrderId(generatedKeys.getInt(1)); // Gán ID vào object
                        System.out.println("OrderRepository: Inserted order with generated ID: " + order.getOrderId());
                    }
                }
            } else {
                System.err.println("OrderRepository: Insert order failed, no rows affected.");
            }

            return affectedRows > 0; // Trả về true nếu có dòng được thêm
        }
        // SQLException sẽ được ném ra nếu có lỗi
    }

    // Bạn có thể thêm các phương thức khác cho Order ở đây nếu cần
    // Ví dụ: getOrdersByUserId(int userId), getOrderById(int orderId), ...
}