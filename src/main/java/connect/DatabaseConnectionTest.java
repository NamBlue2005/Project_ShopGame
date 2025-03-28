package connect;

import java.sql.Connection;

public class DatabaseConnectionTest {
    public static void main(String[] args) {
        Connection connection = DatabaseConnection.getConnection();
        if (connection != null) {
            System.out.println("Kết nối thành công!");
        } else {
            System.out.println("Kết nối thất bại!");
        }
    }
}