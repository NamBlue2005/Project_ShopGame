package controller;

import model.Order;
import service.IOrderService;
import service.OrderService;

import java.sql.SQLException;
import java.util.List;

public class OrderController {

    private final IOrderService orderService;

    public OrderController() {
        this.orderService = new OrderService();
    }

    public void addOrder(Order order) {
        try {
            orderService.addOrder(order);
            System.out.println("Order added successfully.");
        } catch (SQLException e) {
            System.err.println("Error adding order: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateOrder(Order order) {
        try {
            orderService.updateOrder(order);
            System.out.println("Order updated successfully.");
        } catch (SQLException e) {
            System.err.println("Error updating order: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void deleteOrder(int orderId) {
        try {
            orderService.deleteOrder(orderId);
            System.out.println("Order deleted successfully.");
        } catch (SQLException e) {
            System.err.println("Error deleting order: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public Order getOrderById(int orderId) {
        try {
            return orderService.getOrderById(orderId);
        } catch (SQLException e) {
            System.err.println("Error getting order by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<Order> getAllOrders() {
        try {
            return orderService.getAllOrders();
        } catch (SQLException e) {
            System.err.println("Error getting all orders: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<Order> getOrdersByUserId(int userId) {
        try {
            return orderService.getOrdersByUserId(userId);
        } catch (SQLException e) {
            System.err.println("Error getting orders by user ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}