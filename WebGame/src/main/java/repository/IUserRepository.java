package repository;

import model.User;
import java.util.List;

public interface IUserRepository {
    List<User> findAll();
    User findById(int id);
    void save(User user);
    void update(int id, User user);
    void delete(int id);
    List<User> findByName(String keyword);
    User findByEmailAndPassword(String email, String password);
}
