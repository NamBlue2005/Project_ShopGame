package model;
import java.sql.Timestamp;

public class Order {

    private int orderId;
    private int userId;
    private int gameAccountId;
    private Timestamp orderDate;
    private String orderStatus;
    private double totalAmount;  // double thay vì BigDecimal
    private String paymentMethod;
    private Integer discountId; // Integer (nullable)


    public Order() {}

    public Order(int userId, int gameAccountId, Timestamp orderDate, String orderStatus,
                 double totalAmount, String paymentMethod, Integer discountId) {
        this.userId = userId;
        this.gameAccountId = gameAccountId;
        this.orderDate = orderDate;
        this.orderStatus = orderStatus;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.discountId = discountId;
    }
    public Order(int orderId, int userId, int gameAccountId, Timestamp orderDate, String orderStatus,
                 double totalAmount, String paymentMethod, Integer discountId) {
        this.orderId = orderId;
        this.userId = userId;
        this.gameAccountId = gameAccountId;
        this.orderDate = orderDate;
        this.orderStatus = orderStatus;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.discountId = discountId;
    }


    // Getters and Setters

    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId){
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getGameAccountId() {
        return gameAccountId;
    }

    public void setGameAccountId(int gameAccountId) {
        this.gameAccountId = gameAccountId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }


    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Integer getDiscountId() {
        return discountId;
    }

    public void setDiscountId(Integer discountId) {
        this.discountId = discountId;
    }
    //toString

}