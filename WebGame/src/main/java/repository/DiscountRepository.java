package repository;

import connect.DatabaseConnection;
import model.DiscountCode;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiscountRepository {

    private static final String INSERT_DISCOUNT_CODE = "INSERT INTO DiscountCodes (code, discount_type, discount_value, valid_from, valid_to, usage_limit) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_DISCOUNT_CODE = "UPDATE DiscountCodes SET code = ?, discount_type = ?, discount_value = ?, valid_from = ?, valid_to = ?, usage_limit = ? WHERE discount_id = ?";
    private static final String DELETE_DISCOUNT_CODE = "DELETE FROM DiscountCodes WHERE discount_id = ?";
    private static final String SELECT_DISCOUNT_CODE_BY_ID = "SELECT * FROM DiscountCodes WHERE discount_id = ?";
    private static final String FIND_DISCOUNT_CODES = "SELECT * FROM DiscountCodes WHERE 1=1"; // Mệnh đề WHERE 1=1 để dễ nối thêm điều kiện
    private static final String IS_CODE_UNIQUE = "SELECT COUNT(*) FROM DiscountCodes WHERE code = ?";


    public static void addDiscountCode(DiscountCode discountCode) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_DISCOUNT_CODE, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setString(1, discountCode.getCode());
            preparedStatement.setString(2, discountCode.getDiscountType());
            preparedStatement.setDouble(3, discountCode.getDiscountValue());
            preparedStatement.setDate(4, discountCode.getValidFrom());
            preparedStatement.setDate(5, discountCode.getValidTo());
            preparedStatement.setInt(6, discountCode.getUsageLimit());

            preparedStatement.executeUpdate();

            //Lấy ID
            try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    discountCode.setDiscountId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating discount code failed, no ID obtained.");
                }
            }

        } catch (SQLException e){
            e.printStackTrace();
            throw new SQLException(e);
        }
    }


    public static void updateDiscountCode(DiscountCode discountCode) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_DISCOUNT_CODE)) {

            preparedStatement.setString(1, discountCode.getCode());
            preparedStatement.setString(2, discountCode.getDiscountType());
            preparedStatement.setDouble(3, discountCode.getDiscountValue());
            preparedStatement.setDate(4, discountCode.getValidFrom());
            preparedStatement.setDate(5, discountCode.getValidTo());
            preparedStatement.setInt(6, discountCode.getUsageLimit());
            preparedStatement.setInt(7, discountCode.getDiscountId());

            preparedStatement.executeUpdate();

        }catch (SQLException e){
            e.printStackTrace();
            throw new SQLException(e);
        }
    }


    public static void deleteDiscountCode(int discountId) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_DISCOUNT_CODE)) {

            preparedStatement.setInt(1, discountId);
            preparedStatement.executeUpdate();
        }catch (SQLException e){
            e.printStackTrace();
            throw  new SQLException(e);
        }
    }

    public static DiscountCode getDiscountCodeById(int discountId) throws SQLException {
        DiscountCode discountCode = null;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_DISCOUNT_CODE_BY_ID)) {

            preparedStatement.setInt(1, discountId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    discountCode = mapResultSetToDiscountCode(resultSet);
                }
            }
        } catch (SQLException e){
            e.printStackTrace();
            throw new SQLException(e);
        }
        return discountCode;
    }
    public static boolean isCodeUnique(String code, Integer excludeId) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(IS_CODE_UNIQUE + (excludeId != null ? " AND discount_id != ?" : ""))) {

            preparedStatement.setString(1, code);
            if (excludeId != null) {
                preparedStatement.setInt(2, excludeId);
            }

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    int count = resultSet.getInt(1);
                    return count == 0; // Nếu count = 0, nghĩa là code chưa tồn tại (unique)
                }
            }
        } catch (SQLException e){
            e.printStackTrace();
            throw  new SQLException(e);
        }
        return false; // Default: coi như không unique để an toàn
    }
    public static boolean isCodeUnique(String code) throws SQLException{
        return isCodeUnique(code,null);
    }

    // Tìm kiếm/lọc
    public static List<DiscountCode> findDiscountCodes(Integer discountId, String code, String discountType, Date validFrom, Date validTo) throws SQLException {
        List<DiscountCode> discountCodes = new ArrayList<>();
        StringBuilder queryBuilder = new StringBuilder(FIND_DISCOUNT_CODES);
        List<Object> params = new ArrayList<>();

        if (discountId != null) {
            queryBuilder.append(" AND discount_id = ?");
            params.add(discountId);
        }
        if (code != null && !code.isEmpty()) {
            queryBuilder.append(" AND code LIKE ?");
            params.add("%" + code + "%");
        }
        if (discountType != null && !discountType.isEmpty()) {
            queryBuilder.append(" AND discount_type = ?");
            params.add(discountType);
        }
        if (validFrom != null) {
            queryBuilder.append(" AND valid_from >= ?");
            params.add(validFrom);
        }
        if (validTo != null) {
            queryBuilder.append(" AND valid_to <= ?");
            params.add(validTo);
        }

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(queryBuilder.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                preparedStatement.setObject(i + 1, params.get(i));
            }

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    DiscountCode discountCode = mapResultSetToDiscountCode(resultSet);
                    discountCodes.add(discountCode);
                }
            }
        } catch (SQLException e){
            e.printStackTrace();
            throw new SQLException(e);
        }
        return discountCodes;
    }
    //hàm con
    private static DiscountCode mapResultSetToDiscountCode(ResultSet resultSet) throws SQLException {
        DiscountCode discountCode = new DiscountCode();
        discountCode.setDiscountId(resultSet.getInt("discount_id"));
        discountCode.setCode(resultSet.getString("code"));
        discountCode.setDiscountType(resultSet.getString("discount_type"));
        discountCode.setDiscountValue(resultSet.getDouble("discount_value"));
        discountCode.setValidFrom(resultSet.getDate("valid_from"));
        discountCode.setValidTo(resultSet.getDate("valid_to"));
        discountCode.setUsageLimit(resultSet.getInt("usage_limit"));
        discountCode.setTimesUsed(resultSet.getInt("times_used"));
        return discountCode;
    }
    //Lấy tất cả
    public static List<DiscountCode> getAllDiscountCodes() throws SQLException{
        return findDiscountCodes(null,null,null,null,null);
    }

}