package repository;

import model.User;
import java.util.List;

public interface IUserRepository {
    User findById(int userId);
    User findByUsername(String username);
    List<User> findAll();
    void save(User user);
    void update(User user);
    void delete(int userId);

}