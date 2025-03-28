package service;

import model.User;
import java.util.List;

public interface IUserService {
    User getUserById(int userId);
    User getUserByUsername(String username);
    List<User> getAllUsers();
    void registerUser(User user);
    void updateUser(User user);
    void deleteUser(int userId);
}