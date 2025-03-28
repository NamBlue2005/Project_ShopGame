package service;

import model.Order;

import java.sql.SQLException;
import java.util.List;

public interface IOrderService {

    // Thêm đơn hàng mới
    void addOrder(Order order) throws SQLException;

    // Cập nhật thông tin đơn hàng
    void updateOrder(Order order) throws SQLException;

    // Xóa đơn hàng theo ID
    void deleteOrder(int orderId) throws SQLException;

    // Lấy đơn hàng theo ID
    Order getOrderById(int orderId) throws SQLException;

    // Lấy tất cả các đơn hàng
    List<Order> getAllOrders() throws SQLException;

    // Lấy các đơn hàng của người dùng theo userId
    List<Order> getOrdersByUserId(int userId) throws SQLException;
}