package repository;

import model.TopUpTransaction;
import connect.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TopUpTransactionRepository implements ITopUpTransactionRepository {

    @Override
    public List<TopUpTransaction> findTopUpTransactions(Integer transactionId, Integer userId, String status, String paymentMethod) {
        List<TopUpTransaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM TopUpTransactions WHERE 1=1";

        if (transactionId != null) sql += " AND transaction_id = ?";
        if (userId != null) sql += " AND user_id = ?";
        if (status != null && !status.isEmpty()) sql += " AND status = ?";
        if (paymentMethod != null && !paymentMethod.isEmpty()) sql += " AND payment_method = ?";
        sql += " ORDER BY transaction_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;
            if (transactionId != null) ps.setInt(index++, transactionId);
            if (userId != null) ps.setInt(index++, userId);
            if (status != null && !status.isEmpty()) ps.setString(index++, status);
            if (paymentMethod != null && !paymentMethod.isEmpty()) ps.setString(index++, paymentMethod);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    transactions.add(mapResultSetToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }

    @Override
    public boolean addTopUpTransaction(TopUpTransaction transaction) {
        String sql = "INSERT INTO TopUpTransactions (user_id, amount, transaction_date, payment_method, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, transaction.getUserId());
            ps.setDouble(2, transaction.getAmount());
            ps.setTimestamp(3, transaction.getTransactionDate());
            ps.setString(4, transaction.getPaymentMethod());
            ps.setString(5, transaction.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateTopUpTransaction(TopUpTransaction transaction) {
        String sql = "UPDATE TopUpTransactions SET user_id=?, amount=?, transaction_date=?, payment_method=?, status=? WHERE transaction_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, transaction.getUserId());
            ps.setDouble(2, transaction.getAmount());
            ps.setTimestamp(3, transaction.getTransactionDate());
            ps.setString(4, transaction.getPaymentMethod());
            ps.setString(5, transaction.getStatus());
            ps.setInt(6, transaction.getTransactionId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteTopUpTransaction(int transactionId) {
        String sql = "DELETE FROM TopUpTransactions WHERE transaction_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, transactionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private TopUpTransaction mapResultSetToTransaction(ResultSet rs) throws SQLException {
        return new TopUpTransaction(
                rs.getInt("user_id"),
                rs.getDouble("amount"),
                rs.getTimestamp("transaction_date"),
                rs.getString("payment_method"),
                rs.getString("status")
        );
    }
}