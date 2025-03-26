package repository;

import model.GameAccount;
import connect.DatabaseConnection; // Đảm bảo import đúng class kết nối của bạn

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GameAccountRepository {

    // Thêm một tài khoản game mới vào database
    public int addGameAccount(GameAccount account) {
        // SỬA LẠI TÊN CỘT: in_game_currency
        String sql = "INSERT INTO GameAccounts (account_username, account_password, game_rank, in_game_currency, number_of_champions, number_of_skins, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, account.getAccountUsername());
            ps.setString(2, account.getAccountPassword());
            ps.setString(3, account.getGameRank());
            ps.setDouble(4, account.getInGameCurrency()); // Vị trí 4 tương ứng với in_game_currency
            ps.setInt(5, account.getNumberOfChampions());
            ps.setInt(6, account.getNumberOfSkins());
            ps.setString(7, account.getStatus());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding game account: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // Cập nhật thông tin tài khoản game
    public boolean updateGameAccount(GameAccount account) {
        // SỬA LẠI TÊN CỘT: in_game_currency
        String sql = "UPDATE GameAccounts SET account_username = ?, account_password = ?, game_rank = ?, in_game_currency = ?, number_of_champions = ?, number_of_skins = ?, status = ? WHERE game_account_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, account.getAccountUsername());
            ps.setString(2, account.getAccountPassword());
            ps.setString(3, account.getGameRank());
            ps.setDouble(4, account.getInGameCurrency()); // Vị trí 4 tương ứng với in_game_currency
            ps.setInt(5, account.getNumberOfChampions());
            ps.setInt(6, account.getNumberOfSkins());
            ps.setString(7, account.getStatus());
            ps.setInt(8, account.getGameAccountId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating game account: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Xóa tài khoản game theo ID (Không thay đổi)
    public boolean deleteGameAccount(int gameAccountId) {
        String sql = "DELETE FROM GameAccounts WHERE game_account_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, gameAccountId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting game account: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Lấy thông tin tài khoản game theo ID (Phụ thuộc vào mapResultSetToGameAccount)
    public GameAccount getGameAccountById(int gameAccountId) {
        String sql = "SELECT * FROM GameAccounts WHERE game_account_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, gameAccountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToGameAccount(rs); // Gọi hàm mapping đã sửa
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting game account by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Tìm kiếm tài khoản game theo các tiêu chí (Phụ thuộc vào mapResultSetToGameAccount)
    public List<GameAccount> findGameAccounts(Integer gameAccountId, String accountUsername, String gameRank, String status) {
        List<GameAccount> accounts = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM GameAccounts WHERE 1=1");
        List<Object> parameters = new ArrayList<>();

        if (gameAccountId != null) {
            sqlBuilder.append(" AND game_account_id = ?");
            parameters.add(gameAccountId);
        }
        if (accountUsername != null && !accountUsername.trim().isEmpty()) {
            sqlBuilder.append(" AND account_username LIKE ?");
            parameters.add("%" + accountUsername.trim() + "%");
        }
        if (gameRank != null && !gameRank.trim().isEmpty()) {
            sqlBuilder.append(" AND game_rank = ?");
            parameters.add(gameRank.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            sqlBuilder.append(" AND status = ?");
            parameters.add(status.trim());
        }
        sqlBuilder.append(" ORDER BY game_account_id DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    accounts.add(mapResultSetToGameAccount(rs)); // Gọi hàm mapping đã sửa
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding game accounts: " + e.getMessage());
            e.printStackTrace();
        }
        return accounts;
    }

    // Hàm tiện ích để map một dòng ResultSet thành đối tượng GameAccount
    private GameAccount mapResultSetToGameAccount(ResultSet rs) throws SQLException {
        GameAccount account = new GameAccount();
        account.setGameAccountId(rs.getInt("game_account_id"));
        account.setAccountUsername(rs.getString("account_username"));
        account.setAccountPassword(rs.getString("account_password"));
        account.setGameRank(rs.getString("game_rank"));
        // SỬA LẠI TÊN CỘT KHI ĐỌC TỪ RESULTSET: in_game_currency
        account.setInGameCurrency(rs.getDouble("in_game_currency"));
        account.setNumberOfChampions(rs.getInt("number_of_champions"));
        account.setNumberOfSkins(rs.getInt("number_of_skins"));
        account.setStatus(rs.getString("status"));
        return account;
    }


}