package repository;

import connect.DatabaseConnection;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserRepository implements IUserRepository {

    @Override
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM Users";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                users.add(new User(
                        resultSet.getInt("user_id"),
                        resultSet.getString("username"),
                        resultSet.getString("email"),
                        resultSet.getString("phone_number"),
                        resultSet.getString("password"),
                        resultSet.getString("type")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public User findById(int id) {
        String query = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return new User(
                        resultSet.getInt("user_id"),
                        resultSet.getString("username"),
                        resultSet.getString("email"),
                        resultSet.getString("phone_number"),
                        resultSet.getString("password"),
                        resultSet.getString("type")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void save(User user) {
        String query = "INSERT INTO Users (username, email, phone_number, password, type) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, user.getUsername());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPhoneNumber());
            statement.setString(4, user.getPassword());
            statement.setString(5, user.getType());

            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(int id, User user) {
        String query = "UPDATE Users SET username = ?, email = ?, phone_number = ?, password = ?, type = ? WHERE user_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, user.getUsername());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPhoneNumber());
            statement.setString(4, user.getPassword());
            statement.setString(5, user.getType());
            statement.setInt(6, id);

            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        String query = "DELETE FROM Users WHERE user_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<User> findByName(String keyword) {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM Users WHERE username LIKE ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, "%" + keyword + "%");
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                users.add(new User(
                        resultSet.getInt("user_id"),
                        resultSet.getString("username"),
                        resultSet.getString("email"),
                        resultSet.getString("phone_number"),
                        resultSet.getString("password"),
                        resultSet.getString("type")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public User findByEmailAndPassword(String email, String password) {
        String query = "SELECT * FROM Users WHERE (email = ? OR phone_number = ?) AND password = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, email);
            statement.setString(2, email);
            statement.setString(3, password);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return new User(
                        resultSet.getInt("user_id"),
                        resultSet.getString("username"),
                        resultSet.getString("email"),
                        resultSet.getString("phone_number"),
                        resultSet.getString("password"),
                        resultSet.getString("type")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
