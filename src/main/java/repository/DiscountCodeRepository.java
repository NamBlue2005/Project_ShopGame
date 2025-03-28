package repository;

import model.DiscountCode;
import connect.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiscountCodeRepository implements IDiscountCodeRepository {

    @Override
    public List<DiscountCode> findAll() {
        List<DiscountCode> discountCodes = new ArrayList<>();
        String sql = "SELECT * FROM DiscountCodes ORDER BY validTo DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                discountCodes.add(mapResultSetToDiscountCode(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discountCodes;
    }

    @Override
    public DiscountCode findByCode(String code) {
        String sql = "SELECT * FROM DiscountCodes WHERE code = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDiscountCode(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean addDiscountCode(DiscountCode discountCode) {
        String sql = "INSERT INTO DiscountCodes (code, discountType, discountValue, validFrom, validTo, usageLimit, timesUsed) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, discountCode.getCode());
            ps.setString(2, discountCode.getDiscountType());
            ps.setDouble(3, discountCode.getDiscountValue());
            ps.setDate(4, discountCode.getValidFrom());
            ps.setDate(5, discountCode.getValidTo());
            ps.setInt(6, discountCode.getUsageLimit());
            ps.setInt(7, discountCode.getTimesUsed());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateDiscountCode(DiscountCode discountCode) {
        String sql = "UPDATE DiscountCodes SET code=?, discountType=?, discountValue=?, validFrom=?, validTo=?, usageLimit=?, timesUsed=? WHERE discountId=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, discountCode.getCode());
            ps.setString(2, discountCode.getDiscountType());
            ps.setDouble(3, discountCode.getDiscountValue());
            ps.setDate(4, discountCode.getValidFrom());
            ps.setDate(5, discountCode.getValidTo());
            ps.setInt(6, discountCode.getUsageLimit());
            ps.setInt(7, discountCode.getTimesUsed());
            ps.setInt(8, discountCode.getDiscountId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteDiscountCode(int discountId) {
        String sql = "DELETE FROM DiscountCodes WHERE discountId=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, discountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private DiscountCode mapResultSetToDiscountCode(ResultSet rs) throws SQLException {
        return new DiscountCode(
                rs.getString("code"),
                rs.getString("discountType"),
                rs.getDouble("discountValue"),
                rs.getDate("validFrom"),
                rs.getDate("validTo"),
                rs.getInt("usageLimit"),
                rs.getInt("timesUsed")
        );
    }
}