package repository;

import connect.DatabaseConnection;
import model.Order;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AdminRepository {

    public static List<Order> getAll() {
        List<Order> orders = new ArrayList<>();
        Connection connection = DatabaseConnection.getConnection();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement("SELECT * FROM orders");
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                int orderId = resultSet.getInt("order_id");
                int userId = resultSet.getInt("user_id");
                int gameAccountId = resultSet.getInt("game_account_id");
                String orderDate = resultSet.getString("order_date");
                String orderStatus = resultSet.getString("order_status");
                double totalAmount = resultSet.getDouble("total_amount");
                String paymentMethod = resultSet.getString("payment_method");
                Integer discountId = resultSet.getInt("discount_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }
}
