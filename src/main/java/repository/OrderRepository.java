package repository;

import model.Order;
import connect.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderRepository implements IOrderRepository {

    private static final String INSERT_ORDER = "INSERT INTO Orders (user_id, game_account_id, order_date, order_status, total_amount, payment_method, discount_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_ORDER = "UPDATE Orders SET user_id = ?, game_account_id = ?, order_date = ?, order_status = ?, total_amount = ?, payment_method = ?, discount_id = ? WHERE order_id = ?";
    private static final String DELETE_ORDER = "DELETE FROM Orders WHERE order_id = ?";
    private static final String SELECT_ORDER_BY_ID = "SELECT * FROM Orders WHERE order_id = ?";
    private static final String SELECT_ALL_ORDERS = "SELECT * FROM Orders";
    private static final String SELECT_ORDERS_BY_USER_ID = "SELECT * FROM Orders WHERE user_id = ?";

    @Override
    public void addOrder(Order order) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setInt(1, order.getUserId());
            preparedStatement.setInt(2, order.getGameAccountId());
            preparedStatement.setTimestamp(3, order.getOrderDate());
            preparedStatement.setString(4, order.getOrderStatus());
            preparedStatement.setDouble(5, order.getTotalAmount());
            preparedStatement.setString(6, order.getPaymentMethod());
            preparedStatement.setObject(7, order.getDiscountId(), Types.INTEGER);

            preparedStatement.executeUpdate();

            try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    order.setOrderId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating order failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException(e);
        }
    }

    @Override
    public void updateOrder(Order order) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_ORDER)) {

            preparedStatement.setInt(1, order.getUserId());
            preparedStatement.setInt(2, order.getGameAccountId());
            preparedStatement.setTimestamp(3, order.getOrderDate());
            preparedStatement.setString(4, order.getOrderStatus());
            preparedStatement.setDouble(5, order.getTotalAmount());
            preparedStatement.setString(6, order.getPaymentMethod());
            preparedStatement.setObject(7, order.getDiscountId(), Types.INTEGER);
            preparedStatement.setInt(8, order.getOrderId());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException(e);
        }
    }

    @Override
    public void deleteOrder(int orderId) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_ORDER)) {
            preparedStatement.setInt(1, orderId);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException(e);
        }
    }

    @Override
    public Order getOrderById(int orderId) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ORDER_BY_ID)) {

            preparedStatement.setInt(1, orderId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToOrder(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException(e);
        }
        return null;
    }

    @Override
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_ORDERS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                orders.add(mapResultSetToOrder(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException(e);
        }
        return orders;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ORDERS_BY_USER_ID)) {

            preparedStatement.setInt(1, userId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    orders.add(mapResultSetToOrder(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException(e);
        }
        return orders;
    }

    private Order mapResultSetToOrder(ResultSet resultSet) throws SQLException {
        Order order = new Order();
        order.setOrderId(resultSet.getInt("order_id"));
        order.setUserId(resultSet.getInt("user_id"));
        order.setGameAccountId(resultSet.getInt("game_account_id"));
        order.setOrderDate(resultSet.getTimestamp("order_date"));
        order.setOrderStatus(resultSet.getString("order_status"));
        order.setTotalAmount(resultSet.getDouble("total_amount"));
        order.setPaymentMethod(resultSet.getString("payment_method"));
        order.setDiscountId(resultSet.getInt("discount_id"));
        return order;
    }
}