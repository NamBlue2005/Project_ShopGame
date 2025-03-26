package controller.admin;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.GameAccount;
import repository.GameAccountRepository;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.io.UnsupportedEncodingException;

@WebServlet(name = "GameAccountServlet", urlPatterns = {
        "/admin/game-accounts",
        "/admin/game-accounts/add",
        "/admin/game-accounts/update",
        "/admin/game-accounts/delete"
})
public class GameAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private GameAccountRepository gameAccountRepository;
    private static final String JSP_LIST_PATH = "/views/admin/gameAccountList.jsp";

    public void init() {
        gameAccountRepository = new GameAccountRepository();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }
        String path = request.getServletPath();
        System.out.println("DEBUG: doGet Path: " + path);

        try {
            switch (path) {
                // Không còn case /add và /edit cho GET nữa
                case "/admin/game-accounts/delete":
                    deleteGameAccount(request, response);
                    break;
                case "/admin/game-accounts":
                default:
                    // Chỉ còn hiển thị danh sách/tìm kiếm
                    listGameAccounts(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi trong doGet: " + e.getMessage(), e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        System.out.println("DEBUG: doPost Path: " + path);

        if (path == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
            return;
        }

        try {
            switch (path) {
                case "/admin/game-accounts/add": // Xử lý POST từ Add Modal
                    addGameAccount(request, response);
                    break;
                case "/admin/game-accounts/update": // Xử lý POST từ Edit Modal
                    updateGameAccount(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported for this URL.");
                    break;
            }
        } catch (Exception e) {
            handleErrorRedirect(request, response, "Lỗi xử lý yêu cầu: " + e.getMessage(), e);
        }
    }

    // --- Các phương thức xử lý ---

    // listGameAccounts không cần set viewMode nữa
    private void listGameAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG: Executing listGameAccounts (Modal version)");
        String message = request.getParameter("message");
        String messageType = request.getParameter("messageType");

        Integer searchGameAccountId = null;
        String gameAccountIdStr = request.getParameter("gameAccountId");
        if (gameAccountIdStr != null && !gameAccountIdStr.trim().isEmpty()) {
            try {
                searchGameAccountId = Integer.parseInt(gameAccountIdStr.trim());
            } catch (NumberFormatException e) {
                System.err.println("Invalid search gameAccountId format: " + gameAccountIdStr);
            }
        }
        String searchAccountUsername = request.getParameter("accountUsername");
        String searchGameRank = request.getParameter("gameRank");
        String searchStatus = request.getParameter("status");

        List<GameAccount> accounts = gameAccountRepository.findGameAccounts(
                searchGameAccountId,
                searchAccountUsername,
                searchGameRank,
                searchStatus
        );

        request.setAttribute("gameAccounts", accounts);
        if (message != null && !message.isEmpty()) {
            request.setAttribute("message", message);
            request.setAttribute("messageType", (messageType != null && !messageType.isEmpty()) ? messageType : "info");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_LIST_PATH);
        dispatcher.forward(request, response);
    }

    // addGameAccount, updateGameAccount, deleteGameAccount giữ nguyên logic xử lý POST/GET delete
    // Nhưng không cần showEditView nữa.
    // (Code các hàm add, update, delete, handleError... giữ nguyên như trước, chỉ cần đảm bảo chúng redirect đúng sau khi xử lý)
    private void addGameAccount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("DEBUG: Processing addGameAccount (POST from Modal)");
        String message; String messageType;
        try {
            String username = request.getParameter("accountUsername_add"); // Đổi tên input để tránh trùng lặp nếu cần
            String password = request.getParameter("accountPassword_add");
            String rank = request.getParameter("gameRank_add");
            double currency = parseDoubleParameter(request, "inGameCurrency_add", 0.0);
            int champions = parseIntParameter(request, "numberOfChampions_add", 0);
            int skins = parseIntParameter(request, "numberOfSkins_add", 0);
            String status = request.getParameter("status_add");

            GameAccount newAccount = new GameAccount(username, password /* hash */, rank, currency, champions, skins, status);
            int newId = gameAccountRepository.addGameAccount(newAccount);

            if (newId != -1) { message = "Thêm tài khoản thành công! ID = " + newId; messageType = "success"; }
            else { message = "Thêm tài khoản thất bại."; messageType = "danger"; }
        } catch (Exception e) { message = "Lỗi khi thêm tài khoản."; messageType = "danger"; handleErrorRedirect(request, response, message, e); return;}
        sendRedirectWithMessage(request, response, "/admin/game-accounts", message, messageType);
    }

    private void updateGameAccount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("DEBUG: Processing updateGameAccount (POST from Modal)");
        String message; String messageType;
        try {
            int id = parseIntParameter(request, "gameAccountId_edit", -1); // Lấy ID từ hidden input
            if (id == -1) throw new NumberFormatException("Missing or invalid gameAccountId_edit");

            String username = request.getParameter("accountUsername_edit");
            String password = request.getParameter("accountPassword_edit"); // Check rỗng để không đổi
            String rank = request.getParameter("gameRank_edit");
            double currency = parseDoubleParameter(request, "inGameCurrency_edit", 0.0);
            int champions = parseIntParameter(request, "numberOfChampions_edit", 0);
            int skins = parseIntParameter(request, "numberOfSkins_edit", 0);
            String status = request.getParameter("status_edit");

            GameAccount existingAccount = gameAccountRepository.getGameAccountById(id);
            if (existingAccount == null) { message = "Không tìm thấy tài khoản ID " + id; messageType = "warning";
            } else {
                existingAccount.setAccountUsername(username);
                existingAccount.setGameRank(rank);
                existingAccount.setInGameCurrency(currency);
                existingAccount.setNumberOfChampions(champions);
                existingAccount.setNumberOfSkins(skins);
                existingAccount.setStatus(status);
                if (password != null && !password.isEmpty()) { existingAccount.setAccountPassword(password /* hash */); }

                boolean success = gameAccountRepository.updateGameAccount(existingAccount);
                if (success) { message = "Cập nhật tài khoản ID " + id + " thành công!"; messageType = "success"; }
                else { message = "Cập nhật tài khoản ID " + id + " thất bại."; messageType = "danger"; }
            }
        } catch (Exception e) { message = "Lỗi khi cập nhật tài khoản."; messageType = "danger"; handleErrorRedirect(request, response, message, e); return; }
        sendRedirectWithMessage(request, response, "/admin/game-accounts", message, messageType);
    }

    private void deleteGameAccount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("DEBUG: Executing deleteGameAccount");
        String message; String messageType;
        try {
            int id = parseIntParameter(request,"id", -1);
            if (id == -1) throw new NumberFormatException("Missing or invalid id");
            boolean success = gameAccountRepository.deleteGameAccount(id);
            if (success) { message = "Xóa tài khoản ID " + id + " thành công!"; messageType = "success"; }
            else { message = "Xóa tài khoản ID " + id + " thất bại."; messageType = "danger"; }
        } catch (Exception e) { message = "Lỗi khi xóa tài khoản."; messageType = "danger"; handleErrorRedirect(request, response, message, e); return; }
        sendRedirectWithMessage(request, response, "/admin/game-accounts", message, messageType);
    }

    // --- Hàm tiện ích (handleError, handleErrorRedirect, sendRedirectWithMessage, parseIntParameter, parseDoubleParameter) ---
    // Giữ nguyên các hàm này như phiên bản trước
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage, Exception e) throws ServletException, IOException {
        if (e != null) { System.err.println(errorMessage + ": " + e.getMessage()); e.printStackTrace(); }
        else { System.err.println(errorMessage); }
        request.setAttribute("message", errorMessage);
        request.setAttribute("messageType", "danger");
        listGameAccounts(request, response);
    }

    private void handleErrorRedirect(HttpServletRequest request, HttpServletResponse response, String errorMessage, Exception e) throws IOException {
        if (e != null) { System.err.println(errorMessage + ": " + e.getMessage()); e.printStackTrace(); }
        else { System.err.println(errorMessage); }
        sendRedirectWithMessage(request, response, "/admin/game-accounts", errorMessage, "danger");
    }

    private void sendRedirectWithMessage(HttpServletRequest request, HttpServletResponse response, String targetUrl, String message, String messageType) throws IOException {
        String encodedMessage = "";
        if (message != null && !message.isEmpty()) {
            try { encodedMessage = URLEncoder.encode(message, "UTF-8"); } // Dùng "UTF-8" cho JDK < 10
            catch (UnsupportedEncodingException e) { System.err.println("UTF-8 encoding not supported? Should not happen."); encodedMessage = "Error+encoding+message"; }
        }
        response.sendRedirect(request.getContextPath() + targetUrl + "?message=" + encodedMessage + "&messageType=" + messageType);
    }

    private int parseIntParameter(HttpServletRequest request, String paramName, int defaultValue) { /* Giữ nguyên */
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try { return Integer.parseInt(paramValue.trim()); }
            catch (NumberFormatException e) { System.err.println("Invalid integer format for parameter '" + paramName + "': " + paramValue); }
        }
        return defaultValue;
    }
    private double parseDoubleParameter(HttpServletRequest request, String paramName, double defaultValue) { /* Giữ nguyên */
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try { return Double.parseDouble(paramValue.trim()); }
            catch (NumberFormatException e) { System.err.println("Invalid double format for parameter '" + paramName + "': " + paramValue); }
        }
        return defaultValue;
    }
}