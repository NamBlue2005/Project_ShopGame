package service;

import model.User;
import repository.IUserRepository;
import repository.UserRepository;
import java.util.List;

public class UserService implements IUserService {
    private final IUserRepository userRepository = new UserRepository();

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public User findById(int id) {
        return userRepository.findById(id);
    }

    @Override
    public void save(User user) {
        userRepository.save(user);
    }

    @Override
    public void update(int id, User user) {
        userRepository.update(id, user);
    }

    @Override
    public void delete(int id) {
        userRepository.delete(id);
    }

    @Override
    public List<User> findByName(String keyword) {
        return userRepository.findByName(keyword);
    }

    @Override
    public User findByEmailAndPassword(String email, String password) {
        return userRepository.findByEmailAndPassword(email, password);
    }
}
