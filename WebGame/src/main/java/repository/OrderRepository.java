package repository;

import model.Order; // Import model Order
import connect.DatabaseConnection; // Import lớp kết nối của bạn

import java.sql.*; // Import các lớp cần thiết của JDBC
import java.util.ArrayList;
import java.util.List;

public class OrderRepository {

    // Câu lệnh SQL để thêm một đơn hàng mới
    private static final String INSERT_ORDER = "INSERT INTO Orders (user_id, game_account_id, order_date, order_status, total_amount, payment_method, discount_id) " +  "VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_ORDER_STATUS = "UPDATE Orders SET order_status = ? WHERE order_id = ?";


    public boolean addOrder(Order order, Connection conn) throws SQLException {

        try (PreparedStatement ps = conn.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getGameAccountId());
            ps.setTimestamp(3, (order.getOrderDate() != null) ? order.getOrderDate() : new Timestamp(System.currentTimeMillis()));
            ps.setString(4, order.getOrderStatus());
            ps.setDouble(5, order.getTotalAmount());
            ps.setString(6, order.getPaymentMethod());

            if (order.getDiscountId() != null) {
                ps.setInt(7, order.getDiscountId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            int affectedRows = ps.executeUpdate();

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

    }
    public boolean updateOrderStatus(int orderId, String newStatus) {
        try (Connection conn = DatabaseConnection.getConnection(); // Tự quản lý connection
             PreparedStatement ps = conn.prepareStatement(UPDATE_ORDER_STATUS)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId);

            int affectedRows = ps.executeUpdate();
            return affectedRows == 1; // Chỉ trả về true nếu đúng 1 dòng được cập nhật

        } catch (SQLException e) {
            System.err.println("Error updating order status for ID " + orderId + ": " + e.getMessage());
            e.printStackTrace(); // Nên dùng logger
            return false; // Trả về false nếu có lỗi SQL
        } catch (Exception e) {
            System.err.println("Unexpected error updating order status for ID " + orderId + ": " + e.getMessage());
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi khác
        }
    }
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY order_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs)); // Cần hàm map này
            }
        }
        return orders;
    }
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setGameAccountId(rs.getInt("game_account_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setDiscountId(rs.getObject("discount_id", Integer.class)); // Lấy nullable Integer
        return order;
    }
}