package model;

public class User {
    private int userId;
    private String username;
    private String email;
    private String phoneNumber;
    private String password;
    private String type;

    // Constructor mặc định
    public User() {}

    // Constructor không có userId (dùng khi tạo mới user)
    public User(String username, String email, String phoneNumber, String password, String type) {
        this.username = username;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.type = type;
    }

    // Constructor có userId (dùng khi lấy từ database)
    public User(int userId, String username, String email, String phoneNumber, String password, String type) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.type = type;
    }

    // Getters và Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
