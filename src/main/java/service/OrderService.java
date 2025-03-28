package service;

import model.Order;
import repository.OrderRepository;
import repository.IOrderRepository;

import java.sql.SQLException;
import java.util.List;

public class OrderService implements IOrderService {

    private final IOrderRepository orderRepository;

    public OrderService() {
        this.orderRepository = new OrderRepository();
    }

    @Override
    public void addOrder(Order order) throws SQLException {
        orderRepository.addOrder(order);
    }

    @Override
    public void updateOrder(Order order) throws SQLException {
        orderRepository.updateOrder(order);
    }

    @Override
    public void deleteOrder(int orderId) throws SQLException {
        orderRepository.deleteOrder(orderId);
    }

    @Override
    public Order getOrderById(int orderId) throws SQLException {
        return orderRepository.getOrderById(orderId);
    }

    @Override
    public List<Order> getAllOrders() throws SQLException {
        return orderRepository.getAllOrders();
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        return orderRepository.getOrdersByUserId(userId);
    }
}