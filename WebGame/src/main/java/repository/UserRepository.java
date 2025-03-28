package repository;

import connect.DatabaseConnection;
import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserRepository {


    private static final String SELECT_ALL_USERS = "SELECT user_id, username, email, phone_number, type FROM Users ORDER BY user_id ASC";
    private static final String SELECT_USER_BY_ID = "SELECT user_id, username, email, phone_number, type FROM Users WHERE user_id = ?";
    private static final String INSERT_USER = "INSERT INTO Users (username, email, phone_number, password, type) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_USER = "UPDATE Users SET username = ?, email = ?, phone_number = ?, type = ? WHERE user_id = ?";
     private static final String UPDATE_USER_WITH_PASSWORD = "UPDATE Users SET username = ?, email = ?, phone_number = ?, password = ?, type = ? WHERE user_id = ?";
    private static final String DELETE_USER = "DELETE FROM Users WHERE user_id = ?";
    private static final String SELECT_USER_BY_USERNAME = "SELECT user_id, username, email, phone_number, password, type FROM Users WHERE username = ?";
    private static final String CHECK_USERNAME_EXISTS = "SELECT 1 FROM Users WHERE username = ? LIMIT 1";
    private static final String CHECK_EMAIL_EXISTS = "SELECT 1 FROM Users WHERE email = ? AND user_id != ? LIMIT 1";
    private static final String CHECK_EMAIL_EXISTS_ON_ADD = "SELECT 1 FROM Users WHERE email = ? LIMIT 1";
    private static final String SEARCH_USERS = "SELECT user_id, username, email, phone_number, type FROM Users WHERE " +
            "(username LIKE ? OR email LIKE ? OR phone_number LIKE ?) " + // Tìm theo từ khóa chung
            "AND (? IS NULL OR type = ?) " + // Lọc theo type nếu có
            "ORDER BY user_id ASC";

    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                userList.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
            e.printStackTrace(); // Hoặc log lỗi bằng thư viện logging
        }
        return userList;
    }

    public User getUserById(int userId) {
        User user = null;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_USER_BY_ID)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by ID " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }


    public User getUserByUsername(String username) {
        User user = null;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_USER_BY_USERNAME)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUserWithPassword(rs); // Dùng hàm map khác để lấy cả password
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by username " + username + ": " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }

    public boolean addUser(User user) {

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_USER)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getType());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error adding user " + user.getUsername() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }


    public boolean updateUser(User user) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_USER)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getType());
            ps.setInt(5, user.getUserId()); // Điều kiện WHERE

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating user " + user.getUserId() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }


    public boolean updateUserWithPassword(User user) {

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_USER_WITH_PASSWORD)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getType());
            ps.setInt(6, user.getUserId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating user (with password) " + user.getUserId() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }



    public boolean deleteUser(int userId) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_USER)) {

            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {

            if (e.getSQLState().startsWith("23")) { // Mã lỗi SQL state cho vi phạm ràng buộc
                System.err.println("Cannot delete user " + userId + " due to existing related records (e.g., orders).");
            } else {
                System.err.println("Error deleting user " + userId + ": " + e.getMessage());
            }
            e.printStackTrace();
            return false;
        }
    }


    public boolean isUsernameExists(String username) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(CHECK_USERNAME_EXISTS)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // True nếu có bản ghi
            }
        } catch (SQLException e) {
            System.err.println("Error checking username existence for " + username + ": " + e.getMessage());
            e.printStackTrace();
            return true; // Trả về true khi lỗi để an toàn, ngăn việc tạo trùng
        }
    }

    public boolean isEmailExists(String email, int currentUserId) {
        String sql = (currentUserId <= 0) ? CHECK_EMAIL_EXISTS_ON_ADD : CHECK_EMAIL_EXISTS;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, email);
            if (currentUserId > 0) {
                ps.setInt(2, currentUserId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // True nếu có bản ghi
            }
        } catch (SQLException e) {
            System.err.println("Error checking email existence for " + email + ": " + e.getMessage());
            e.printStackTrace();
            return true;
        }
    }



    public List<User> searchUsers(String searchTerm, String userType) {
        List<User> userList = new ArrayList<>();
        String searchPattern = (searchTerm == null || searchTerm.trim().isEmpty()) ? "%" : "%" + searchTerm.trim() + "%";
        String typeFilter = (userType == null || userType.trim().isEmpty()) ? null : userType.trim().toUpperCase();


        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SEARCH_USERS)) {

            ps.setString(1, searchPattern); // Cho username LIKE ?
            ps.setString(2, searchPattern); // Cho email LIKE ?
            ps.setString(3, searchPattern); // Cho phone_number LIKE ?

            // Xử lý tham số thứ 4 và 5 cho điều kiện type
            if (typeFilter != null) {
                ps.setString(4, typeFilter); // Tham số thứ 4: type = ?
                ps.setString(5, typeFilter); // Tham số thứ 5: giá trị của type
            } else {
                // Nếu không lọc theo type, đặt tham số thứ 4 là NULL để điều kiện (? IS NULL OR type = ?) thành true
                // và tham số thứ 5 không quan trọng (có thể đặt là null hoặc giá trị bất kỳ)
                ps.setNull(4, Types.VARCHAR);
                ps.setNull(5, Types.VARCHAR); // Hoặc ps.setString(5, "");
            }


            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    userList.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching users: " + e.getMessage());
            e.printStackTrace();
        }
        return userList;
    }



    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setType(rs.getString("type"));
        return user;
    }


    private User mapResultSetToUserWithPassword(ResultSet rs) throws SQLException {
        User user = mapResultSetToUser(rs); // Gọi hàm map cơ bản trước
        user.setPassword(rs.getString("password")); // Thêm password
        return user;
    }

}