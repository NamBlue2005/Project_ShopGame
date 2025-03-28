package repository;

import model.Order; 
import connect.DatabaseConnection; 

import java.sql.*;

public class OrderRepository {

   
    private static final String INSERT_ORDER =
            "INSERT INTO Orders (user_id, game_account_id, order_date, order_status, total_amount, payment_method, discount_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

    
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
                        order.setOrderId(generatedKeys.getInt(1));
                        System.out.println("OrderRepository: Inserted order with generated ID: " + order.getOrderId());
                    }
                }
            } else {
                System.err.println("OrderRepository: Insert order failed, no rows affected.");
            }

            return affectedRows > 0; 
        }
    
    }

}
