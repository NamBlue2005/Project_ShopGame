package model;
// Không cần import java.math.BigDecimal; nữa

public class GameAccount {

    private int gameAccountId;
    private String accountUsername;
    private String accountPassword;
    private String gameRank;
    private double inGameCurrency; // double thay vì BigDecimal
    private int numberOfChampions;
    private int numberOfSkins;
    private String status;

    // Constructors
    public GameAccount() {}

    public GameAccount(String accountUsername, String accountPassword, String gameRank, double inGameCurrency,
                       int numberOfChampions, int numberOfSkins, String status) {
        this.accountUsername = accountUsername;
        this.accountPassword = accountPassword;
        this.gameRank = gameRank;
        this.inGameCurrency = inGameCurrency;
        this.numberOfChampions = numberOfChampions;
        this.numberOfSkins = numberOfSkins;
        this.status = status;
    }

    // Getters and Setters (bắt buộc)

    public int getGameAccountId() {
        return gameAccountId;
    }

    public void setGameAccountId(int gameAccountId) {
        this.gameAccountId = gameAccountId;
    }

    public String getAccountUsername() {
        return accountUsername;
    }

    public void setAccountUsername(String accountUsername) {
        this.accountUsername = accountUsername;
    }

    public String getAccountPassword() {
        return accountPassword;
    }

    public void setAccountPassword(String accountPassword) {
        this.accountPassword = accountPassword;
    }

    public String getGameRank() {
        return gameRank;
    }

    public void setGameRank(String gameRank) {
        this.gameRank = gameRank;
    }

    public double getInGameCurrency() {
        return inGameCurrency;
    }

    public void setInGameCurrency(double inGameCurrency) {
        this.inGameCurrency = inGameCurrency;
    }

    public int getNumberOfChampions() {
        return numberOfChampions;
    }

    public void setNumberOfChampions(int numberOfChampions) {
        this.numberOfChampions = numberOfChampions;
    }

    public int getNumberOfSkins() {
        return numberOfSkins;
    }

    public void setNumberOfSkins(int numberOfSkins) {
        this.numberOfSkins = numberOfSkins;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // toString()
    @Override
    public String toString() {
        return "GameAccount{" +
                "gameAccountId=" + gameAccountId +
                ", accountUsername='" + accountUsername + '\'' +
                ", accountPassword='" + accountPassword + '\'' +
                ", gameRank='" + gameRank + '\'' +
                ", inGameCurrency=" + inGameCurrency +
                ", numberOfChampions=" + numberOfChampions +
                ", numberOfSkins=" + numberOfSkins +
                ", status='" + status + '\'' +
                '}';
    }
}