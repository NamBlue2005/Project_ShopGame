package model;

public class Orders {
    private String userId;
    private String gameAccountId;
    private String orderDate;
    private String orderStatus;
    private double totalAmount;
    private String paymentMethod;
    private String discountId;

    public Orders(String userId, String gameAccountId, String orderDate, String orderStatus, double totalAmount, String paymentMethod, String discountId) {
        this.userId = userId;
        this.gameAccountId = gameAccountId;
        this.orderDate = orderDate;
        this.orderStatus = orderStatus;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.discountId = discountId;
    }

    public String getUserId() {
        return userId;
    }

    public String getGameAccountId() {
        return gameAccountId;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public String getDiscountId() {
        return discountId;
    }
}