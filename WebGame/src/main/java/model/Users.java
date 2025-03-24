package model;

public class Users {
    private int userId;
    private String username;
    private String email;
    private String phoneNumber;
    private String password;
    private String type;

    public Users(int userId, String username, String email, String phoneNumber, String password, String type) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.type = type;
    }

    public int getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public String getType() {
        return type;
    }
}