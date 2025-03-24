package model;

public class TopUpTransactions {
    private String userId;
    private double amount;
    private String transactionDate;
    private String paymentMethod;
    private String status;

    public TopUpTransactions(String userId, double amount, String transactionDate, String paymentMethod, String status) {
        this.userId = userId;
        this.amount = amount;
        this.transactionDate = transactionDate;
        this.paymentMethod = paymentMethod;
        this.status = status;
    }

    public String getUserId() {
        return userId;
    }

    public double getAmount() {
        return amount;
    }

    public String getTransactionDate() {
        return transactionDate;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public String getStatus() {
        return status;
    }
}