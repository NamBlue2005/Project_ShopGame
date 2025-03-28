package model;

public class GameAccount {
    private int gameAccountId;
    private String accountUsername;
    private String accountPassword;
    private String gameRank;
    private double inGameCurrency;
    private int numberOfChampions;
    private int numberOfSkins;
    private String status;

    public GameAccount(int gameAccountId, String accountUsername, String accountPassword, String gameRank,
                       double inGameCurrency, int numberOfChampions, int numberOfSkins, String status) {
        this.gameAccountId = gameAccountId;
        this.accountUsername = accountUsername;
        this.accountPassword = accountPassword;
        this.gameRank = gameRank;
        this.inGameCurrency = inGameCurrency;
        this.numberOfChampions = numberOfChampions;
        this.numberOfSkins = numberOfSkins;
        this.status = status;
    }

    public int getGameAccountId() { return gameAccountId; }
    public String getAccountUsername() { return accountUsername; }
    public String getAccountPassword() { return accountPassword; }
    public String getGameRank() { return gameRank; }
    public double getInGameCurrency() { return inGameCurrency; }
    public int getNumberOfChampions() { return numberOfChampions; }
    public int getNumberOfSkins() { return numberOfSkins; }
    public String getStatus() { return status; }
}
