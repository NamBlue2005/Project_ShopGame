package service;

import model.TopUpTransaction;
import repository.ITopUpTransactionRepository;
import repository.TopUpTransactionRepository;

import java.util.List;

public class TopUpTransactionService implements ITopUpTransactionService {
    private final ITopUpTransactionRepository repository = new TopUpTransactionRepository();

    @Override
    public List<TopUpTransaction> getTopUpTransactions(Integer transactionId, Integer userId, String status, String paymentMethod) {
        return repository.findTopUpTransactions(transactionId, userId, status, paymentMethod);
    }

    @Override
    public boolean createTopUpTransaction(TopUpTransaction transaction) {
        return repository.addTopUpTransaction(transaction);
    }

    @Override
    public boolean modifyTopUpTransaction(TopUpTransaction transaction) {
        return repository.updateTopUpTransaction(transaction);
    }

    @Override
    public boolean removeTopUpTransaction(int transactionId) {
        return repository.deleteTopUpTransaction(transactionId);
    }
}