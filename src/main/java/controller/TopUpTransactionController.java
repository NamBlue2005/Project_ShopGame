package controller;

import model.TopUpTransaction;
import service.ITopUpTransactionService;
import service.TopUpTransactionService;

import java.sql.Timestamp;
import java.util.List;

public class TopUpTransactionController {
    private final ITopUpTransactionService service = new TopUpTransactionService();

    public List<TopUpTransaction> getAllTransactions(Integer transactionId, Integer userId, String status, String paymentMethod) {
        return service.getTopUpTransactions(transactionId, userId, status, paymentMethod);
    }

    public String createTransaction(int userId, double amount, String paymentMethod, String status) {
        TopUpTransaction transaction = new TopUpTransaction(userId, amount, new Timestamp(System.currentTimeMillis()), paymentMethod, status);
        return service.createTopUpTransaction(transaction) ? "Giao dịch nạp tiền đã được thêm thành công!" : "Thêm giao dịch thất bại!";
    }

    public String updateTransaction(int transactionId, int userId, double amount, String paymentMethod, String status) {
        TopUpTransaction transaction = new TopUpTransaction(userId, amount, new Timestamp(System.currentTimeMillis()), paymentMethod, status);
        transaction.setTransactionId(transactionId);
        return service.modifyTopUpTransaction(transaction) ? "Cập nhật giao dịch thành công!" : "Cập nhật thất bại!";
    }

    public String deleteTransaction(int transactionId) {
        return service.removeTopUpTransaction(transactionId) ? "Xóa giao dịch thành công!" : "Xóa giao dịch thất bại!";
    }
}