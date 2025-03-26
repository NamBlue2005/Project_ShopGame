package repository; // Đặt trong package repository

import model.TopUpTransaction;
import connect.DatabaseConnection; // Sử dụng class kết nối của bạn

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TopUpTransactionRepository {

    public List<TopUpTransaction> findTopUpTransactions(Integer transactionId, Integer userId, String status, String paymentMethod) {
        List<TopUpTransaction> transactions = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM TopUpTransactions WHERE 1=1";

            if (transactionId != null) {
                sql += " AND transaction_id = ?";
            }
            if (userId != null) {
                sql += " AND user_id = ?";
            }
            if (status != null && !status.isEmpty()) {
                sql += " AND status = ?";
            }
            if (paymentMethod != null && !paymentMethod.isEmpty()) {
                sql += " AND payment_method = ?";
            }

            sql += " ORDER BY transaction_date DESC";

            preparedStatement = connection.prepareStatement(sql);

            int parameterIndex = 1;
            if (transactionId != null) {
                preparedStatement.setInt(parameterIndex++, transactionId);
            }
            if (userId != null) {
                preparedStatement.setInt(parameterIndex++, userId);
            }
            if (status != null && !status.isEmpty()) {
                preparedStatement.setString(parameterIndex++, status);
            }
            if (paymentMethod != null && !paymentMethod.isEmpty()) {
                preparedStatement.setString(parameterIndex++, paymentMethod);
            }

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                TopUpTransaction transaction = new TopUpTransaction();
                transaction.setTransactionId(resultSet.getInt("transaction_id"));
                transaction.setUserId(resultSet.getInt("user_id"));
                transaction.setAmount(resultSet.getDouble("amount"));
                transaction.setTransactionDate(resultSet.getTimestamp("transaction_date"));
                transaction.setPaymentMethod(resultSet.getString("payment_method"));
                transaction.setStatus(resultSet.getString("status"));
                transactions.add(transaction);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Lỗi khi truy vấn cơ sở dữ liệu: " + e.getMessage(), e);
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return transactions;
    }
}