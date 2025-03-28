package repository;

import model.TopUpTransaction;
import java.util.List;

public interface ITopUpTransactionRepository {
    List<TopUpTransaction> findTopUpTransactions(Integer transactionId, Integer userId, String status, String paymentMethod);
    boolean addTopUpTransaction(TopUpTransaction transaction);
    boolean updateTopUpTransaction(TopUpTransaction transaction);
    boolean deleteTopUpTransaction(int transactionId);
}