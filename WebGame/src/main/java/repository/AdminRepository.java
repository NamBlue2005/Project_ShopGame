package repository;

import connect.DatabaseConnection;
import model.Order;
import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminRepository {
    private static final String SELECT_ALL_ORDERS = "SELECT * FROM ORDERS";
    private static final String SELECT_USER_BY_USERNAME_AND_PASSWORD = "SELECT * FROM Users WHERE username = ? AND type = 'ADMIN'";
    private static final String INSERT_ORDER = "INSERT INTO ORDERS (user_id, game_account_id, order_date, order_status, total_amount, payment_method, discount_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ORDER_BY_ID = "SELECT * FROM ORDERS WHERE order_id = ?";
    private static final String FIND_ORDER = "select * from orders where order_id like ? and user_id like ?  and game_account_id like ? and  order_status like ? ";



    public static List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_ORDERS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                int orderId = resultSet.getInt("order_id");
                int userId = resultSet.getInt("user_id");
                int gameAccountId = resultSet.getInt("game_account_id");
                Timestamp orderDate = resultSet.getTimestamp("order_date");
                String orderStatus = resultSet.getString("order_status");
                double totalAmount = resultSet.getDouble("total_amount");
                String paymentMethod = resultSet.getString("payment_method");
                Integer discountId = resultSet.getInt("discount_id");
                if (resultSet.wasNull()) {
                    discountId = null;
                }
                Order order = new Order(userId, gameAccountId, orderDate, orderStatus, totalAmount, paymentMethod, discountId);
                order.setOrderId(orderId);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error getting all orders", e);
        }
        return orders;
    }

    public static User getUserByUsernameAndPassword(String username, String password) {
        User user = null;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_USERNAME_AND_PASSWORD)) {

            preparedStatement.setString(1, username);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    String dbPassword = resultSet.getString("password");
                    if (password.equals(dbPassword)) {
                        user = new User();
                        user.setUserId(resultSet.getInt("user_id"));
                        user.setUsername(resultSet.getString("username"));
                        user.setEmail(resultSet.getString("email"));
                        user.setPhoneNumber(resultSet.getString("phone_number"));
                        user.setPassword(dbPassword);
                        user.setType(resultSet.getString("type"));
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error getting user by username and password", e);
        }
        return user;
    }

    public static void addOrder(Order order) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {
            preparedStatement.setInt(1, order.getUserId());
            preparedStatement.setInt(2, order.getGameAccountId());
            preparedStatement.setTimestamp(3, order.getOrderDate());
            preparedStatement.setString(4, order.getOrderStatus());
            preparedStatement.setDouble(5, order.getTotalAmount());
            preparedStatement.setString(6, order.getPaymentMethod());

            if (order.getDiscountId() != null) {
                preparedStatement.setInt(7, order.getDiscountId());
            } else {
                preparedStatement.setNull(7, Types.INTEGER);
            }

            preparedStatement.executeUpdate();
            try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    order.setOrderId(generatedKeys.getInt(1)); // Quan trọng: set ID vào object
                } else {
                    throw new SQLException("Creating order failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException(e);
        }
    }

    public static Order getOrderById(int orderId) throws SQLException {
        Order order = null;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ORDER_BY_ID)) {

            preparedStatement.setInt(1, orderId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    int userId = resultSet.getInt("user_id");
                    int gameAccountId = resultSet.getInt("game_account_id");
                    Timestamp orderDate = resultSet.getTimestamp("order_date");
                    String orderStatus = resultSet.getString("order_status");
                    double totalAmount = resultSet.getDouble("total_amount");
                    String paymentMethod = resultSet.getString("payment_method");
                    Integer discountId = resultSet.getInt("discount_id");
                    if (resultSet.wasNull()) {
                        discountId = null;
                    }
                    order = new Order(userId, gameAccountId, orderDate, orderStatus, totalAmount, paymentMethod, discountId);
                    order.setOrderId(orderId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error getting order by ID", e);

        }
        return order;
    }

    public static List<Order> findOrders(Integer orderId, Integer userId, Integer gameAccountId, String orderStatus) {
        List<Order> orders = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(FIND_ORDER)) {

            // Set parameters, handling null values
            preparedStatement.setString(1, orderId != null ? "%" + orderId + "%" : "%");
            preparedStatement.setString(2, userId != null ? "%" + userId + "%" : "%");
            preparedStatement.setString(3, gameAccountId != null ? "%" + gameAccountId + "%" : "%");
            preparedStatement.setString(4, orderStatus != null ? "%" + orderStatus + "%" : "%");


            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    int fetchedOrderId = resultSet.getInt("order_id");
                    int fetchedUserId = resultSet.getInt("user_id");
                    int fetchedGameAccountId = resultSet.getInt("game_account_id");
                    Timestamp fetchedOrderDate = resultSet.getTimestamp("order_date");
                    String fetchedOrderStatus = resultSet.getString("order_status");
                    double fetchedTotalAmount = resultSet.getDouble("total_amount");
                    String fetchedPaymentMethod = resultSet.getString("payment_method");
                    Integer fetchedDiscountId = resultSet.getInt("discount_id");
                    if (resultSet.wasNull()) {
                        fetchedDiscountId = null;
                    }

                    Order order = new Order(fetchedUserId, fetchedGameAccountId, fetchedOrderDate, fetchedOrderStatus,
                            fetchedTotalAmount, fetchedPaymentMethod, fetchedDiscountId);
                    order.setOrderId(fetchedOrderId); // Set the order ID
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error searching orders", e);

        }
        return orders;
    }

}