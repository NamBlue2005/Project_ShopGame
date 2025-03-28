package repository;

import connect.DatabaseConnection;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserRepository implements IUserRepository {
    private static final String SELECT_BY_ID = "SELECT * FROM Users WHERE user_id = ?";
    private static final String SELECT_BY_USERNAME = "SELECT * FROM Users WHERE username = ?";
    private static final String SELECT_ALL = "SELECT * FROM Users";
    private static final String INSERT_USER = "INSERT INTO Users (username, email, phone_number, password, type) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_USER = "UPDATE Users SET username = ?, email = ?, phone_number = ?, password = ?, type = ? WHERE user_id = ?";
    private static final String DELETE_USER = "DELETE FROM Users WHERE user_id = ?";

    @Override
    public User findById(int userId) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_BY_ID)) {
            statement.setInt(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapUser(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User findByUsername(String username) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_BY_USERNAME)) {
            statement.setString(1, username);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapUser(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ALL);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                users.add(mapUser(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public void save(User user) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS)) {
            setUserParams(statement, user);
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setUserId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(User user) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_USER)) {
            setUserParams(statement, user);
            statement.setInt(6, user.getUserId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int userId) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_USER)) {
            statement.setInt(1, userId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private User mapUser(ResultSet resultSet) throws SQLException {
        User user = new User(
                resultSet.getString("username"),
                resultSet.getString("email"),
                resultSet.getString("phone_number"),
                resultSet.getString("password"),
                resultSet.getString("type")
        );
        user.setUserId(resultSet.getInt("user_id")); // Đảm bảo userId được set
        return user;
    }

    private void setUserParams(PreparedStatement statement, User user) throws SQLException {
        statement.setString(1, user.getUsername());
        statement.setString(2, user.getEmail());
        statement.setString(3, user.getPhoneNumber());
        statement.setString(4, user.getPassword());
        statement.setString(5, user.getType());
    }
}