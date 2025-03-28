package service;

import model.Order;

import java.sql.SQLException;
import java.util.List;

public interface IOrderService {

    void addOrder(Order order) throws SQLException;

    void updateOrder(Order order) throws SQLException;

    void deleteOrder(int orderId) throws SQLException;

    Order getOrderById(int orderId) throws SQLException;

    List<Order> getAllOrders() throws SQLException;

    List<Order> getOrdersByUserId(int userId) throws SQLException;
}