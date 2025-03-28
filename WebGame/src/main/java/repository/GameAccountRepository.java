package repository;

import model.GameAccount;
import connect.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GameAccountRepository {

    private static final String INSERT_ACCOUNT = "INSERT INTO GameAccounts (account_username, account_password, game_rank, in_game_currency, number_of_champions, number_of_skins, status, price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_ACCOUNT = "UPDATE GameAccounts SET account_username = ?, account_password = ?, game_rank = ?, in_game_currency = ?, number_of_champions = ?, number_of_skins = ?, status = ?, price = ? WHERE game_account_id = ?";
    private static final String DELETE_ACCOUNT = "DELETE FROM GameAccounts WHERE game_account_id = ?";
    private static final String SELECT_BY_ID = "SELECT * FROM GameAccounts WHERE game_account_id = ?";
    private static final String FIND_ACCOUNTS_BASE = "SELECT * FROM GameAccounts WHERE 1=1";
    private static final String SELECT_PUBLIC_ACCOUNTS =
            "SELECT game_account_id, game_rank, number_of_champions, number_of_skins, price " +
                    "FROM GameAccounts WHERE status = 'ACTIVE' ORDER BY price ASC";

    public int addGameAccount(GameAccount account) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_ACCOUNT, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, account.getAccountUsername());
            ps.setString(2, account.getAccountPassword());
            ps.setString(3, account.getGameRank());
            ps.setDouble(4, account.getInGameCurrency());
            ps.setInt(5, account.getNumberOfChampions());
            ps.setInt(6, account.getNumberOfSkins());
            ps.setString(7, account.getStatus());
            ps.setDouble(8, account.getPrice());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Giữ lại để xem lỗi nếu có sự cố
        }
        return -1;
    }

    public boolean updateGameAccount(GameAccount account) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_ACCOUNT)) {

            ps.setString(1, account.getAccountUsername());
            ps.setString(2, account.getAccountPassword());
            ps.setString(3, account.getGameRank());
            ps.setDouble(4, account.getInGameCurrency());
            ps.setInt(5, account.getNumberOfChampions());
            ps.setInt(6, account.getNumberOfSkins());
            ps.setString(7, account.getStatus());
            ps.setDouble(8, account.getPrice());
            ps.setInt(9, account.getGameAccountId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteGameAccount(int gameAccountId) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_ACCOUNT)) {
            ps.setInt(1, gameAccountId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public GameAccount getGameAccountById(int gameAccountId) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, gameAccountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToGameAccount(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<GameAccount> findGameAccounts(Integer gameAccountId, String accountUsername, String gameRank, String status) {
        List<GameAccount> accounts = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(FIND_ACCOUNTS_BASE);
        List<Object> parameters = new ArrayList<>();

        if (gameAccountId != null && gameAccountId > 0) {
            sqlBuilder.append(" AND game_account_id = ?");
            parameters.add(gameAccountId);
        }
        if (accountUsername != null && !accountUsername.trim().isEmpty()) {
            sqlBuilder.append(" AND account_username LIKE ?");
            parameters.add("%" + accountUsername.trim() + "%");
        }
        if (gameRank != null && !gameRank.trim().isEmpty()) {
            sqlBuilder.append(" AND game_rank LIKE ?");
            parameters.add("%" + gameRank.trim() + "%");
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
                    accounts.add(mapResultSetToGameAccount(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return accounts;
    }

    public List<GameAccount> getAvailableAccountsForPublic() {
        List<GameAccount> accounts = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_PUBLIC_ACCOUNTS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                GameAccount account = new GameAccount();
                account.setGameAccountId(rs.getInt("game_account_id"));
                account.setGameRank(rs.getString("game_rank"));
                account.setNumberOfChampions(rs.getInt("number_of_champions"));
                account.setNumberOfSkins(rs.getInt("number_of_skins"));
                account.setPrice(rs.getDouble("price"));
                accounts.add(account);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return accounts;
    }

    private GameAccount mapResultSetToGameAccount(ResultSet rs) throws SQLException {
        GameAccount account = new GameAccount();
        account.setGameAccountId(rs.getInt("game_account_id"));
        account.setAccountUsername(rs.getString("account_username"));
        account.setAccountPassword(rs.getString("account_password"));
        account.setGameRank(rs.getString("game_rank"));
        account.setInGameCurrency(rs.getDouble("in_game_currency"));
        account.setNumberOfChampions(rs.getInt("number_of_champions"));
        account.setNumberOfSkins(rs.getInt("number_of_skins"));
        account.setStatus(rs.getString("status"));
        account.setPrice(rs.getDouble("price"));
        return account;
    }
}