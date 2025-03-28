package service;

import model.User;
import repository.IUserRepository;
import repository.UserRepository;
import java.util.List;

public class UserService implements IUserService {
    private final IUserRepository IUserRepository = new UserRepository();

    @Override
    public User getUserById(int userId) {
        return IUserRepository.findById(userId);
    }

    @Override
    public User getUserByUsername(String username) {
        return IUserRepository.findByUsername(username);
    }

    @Override
    public List<User> getAllUsers() {
        return IUserRepository.findAll();
    }

    @Override
    public void registerUser(User user) {
        IUserRepository.save(user);
    }

    @Override
    public void updateUser(User user) {
        IUserRepository.update(user);
    }

    @Override
    public void deleteUser(int userId) {
        IUserRepository.delete(userId);
    }
}