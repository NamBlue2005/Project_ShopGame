package service;

import model.TopUpTransaction;
import java.util.List;

public interface ITopUpTransactionService {
    List<TopUpTransaction> getTopUpTransactions(Integer transactionId, Integer userId, String status, String paymentMethod);
    boolean createTopUpTransaction(TopUpTransaction transaction);
    boolean modifyTopUpTransaction(TopUpTransaction transaction);
    boolean removeTopUpTransaction(int transactionId);
}