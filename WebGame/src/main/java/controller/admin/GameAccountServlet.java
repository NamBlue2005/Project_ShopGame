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

    @Override
    public void init() {
        gameAccountRepository = new GameAccountRepository();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        String path = request.getServletPath();
        try {
            switch (path) {
                case "/admin/game-accounts/delete":
                    deleteGameAccount(request, response);
                    break;
                case "/admin/game-accounts":
                default:
                    listGameAccounts(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi trong doGet: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Yêu cầu không hợp lệ hoặc phiên làm việc đã hết hạn.");
            return;
        }

        String path = request.getServletPath();
        if (path == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ.");
            return;
        }

        try {
            switch (path) {
                case "/admin/game-accounts/add":
                    addGameAccount(request, response);
                    break;
                case "/admin/game-accounts/update":
                    updateGameAccount(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Phương thức POST không được hỗ trợ cho URL này.");
                    break;
            }
        } catch (Exception e) {
            handleErrorRedirect(request, response, "Lỗi xử lý yêu cầu POST: " + e.getMessage(), e);
        }
    }

    private void listGameAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String message = request.getParameter("message");
        String messageType = request.getParameter("messageType");
        if (message != null && !message.isEmpty()) {
            request.setAttribute("message", message);
            request.setAttribute("messageType", (messageType != null && !messageType.isEmpty()) ? messageType : "info");
        }

        Integer searchGameAccountId = parseIntParameter(request, "gameAccountId", null);
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
        RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_LIST_PATH);
        dispatcher.forward(request, response);
    }

    private void addGameAccount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String message = null;
        String messageType = "danger";
        try {
            String username = request.getParameter("accountUsername_add");
            String password = request.getParameter("accountPassword_add");
            String rank = request.getParameter("gameRank_add");
            double currency = parseDoubleParameter(request, "inGameCurrency_add", 0.0);
            int champions = parseIntParameter(request, "numberOfChampions_add", 0);
            int skins = parseIntParameter(request, "numberOfSkins_add", 0);
            String status = request.getParameter("status_add");
            double price = parseDoubleParameter(request, "price_add", 0.0); 

            if (username == null || username.trim().isEmpty() || password == null || password.isEmpty() || status == null || status.isEmpty()) {
                message = "Tên tài khoản, mật khẩu và trạng thái là bắt buộc.";
            } else {
                GameAccount newAccount = new GameAccount();
                newAccount.setAccountUsername(username.trim());
                newAccount.setAccountPassword(password);
                newAccount.setGameRank(rank != null ? rank.trim() : null);
                newAccount.setInGameCurrency(currency);
                newAccount.setNumberOfChampions(champions);
                newAccount.setNumberOfSkins(skins);
                newAccount.setStatus(status);
                newAccount.setPrice(price);

                int newId = gameAccountRepository.addGameAccount(newAccount);
                if (newId != -1) {
                    message = "Thêm tài khoản thành công! ID mới = " + newId;
                    messageType = "success";
                } else {
                    message = "Thêm tài khoản thất bại (có thể do lỗi DB hoặc dữ liệu không hợp lệ).";
                }
            }
        } catch (Exception e) {
            message = "Lỗi hệ thống khi thêm tài khoản.";
            handleErrorRedirect(request, response, message, e);
            return;
        }
        sendRedirectWithMessage(request, response, "/admin/game-accounts", message, messageType);
    }

    private void updateGameAccount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String message = null;
        String messageType = "danger";
        String redirectUrl = "/admin/game-accounts"; 
        try {
            int id = parseIntParameter(request, "gameAccountId_edit", -1);
            if (id == -1) {
                message = "Thiếu ID tài khoản để cập nhật.";
            } else {
                redirectUrl = "/admin/game-accounts"; 
                String username = request.getParameter("accountUsername_edit");
                String password = request.getParameter("accountPassword_edit");
                String rank = request.getParameter("gameRank_edit");
                double currency = parseDoubleParameter(request, "inGameCurrency_edit", 0.0);
                int champions = parseIntParameter(request, "numberOfChampions_edit", 0);
                int skins = parseIntParameter(request, "numberOfSkins_edit", 0);
                String status = request.getParameter("status_edit");
                double price = parseDoubleParameter(request, "price_edit", -1.0); 

                if (username == null || username.trim().isEmpty() || password == null || password.isEmpty() || status == null || status.isEmpty()) {
                    message = "Tên tài khoản, mật khẩu và trạng thái là bắt buộc.";
                } else {
                    GameAccount existingAccount = gameAccountRepository.getGameAccountById(id);
                    if (existingAccount == null) {
                        message = "Không tìm thấy tài khoản với ID = " + id + " để cập nhật.";
                        messageType = "warning";
                    } else {
                        existingAccount.setAccountUsername(username.trim());
                        existingAccount.setGameRank(rank != null ? rank.trim() : null);
                        existingAccount.setInGameCurrency(currency);
                        existingAccount.setNumberOfChampions(champions);
                        existingAccount.setNumberOfSkins(skins);
                        existingAccount.setStatus(status);
                        if (price >= 0) {
                            existingAccount.setPrice(price);
                        }
                        if (password != null && !password.isEmpty()) {
                            existingAccount.setAccountPassword(password);
                        }

                        boolean success = gameAccountRepository.updateGameAccount(existingAccount);
                        if (success) {
                            message = "Cập nhật tài khoản ID " + id + " thành công!";
                            messageType = "success";
                        } else {
                            message = "Cập nhật tài khoản ID " + id + " thất bại (có thể do lỗi DB).";
                        }
                    }
                }
            }
        } catch (Exception e) {
            message = "Lỗi hệ thống khi cập nhật tài khoản.";
            handleErrorRedirect(request, response, message, e);
            return;
        }
        sendRedirectWithMessage(request, response, redirectUrl, message, messageType);
    }

    private void deleteGameAccount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String message; String messageType;
        try {
            int id = parseIntParameter(request,"id", -1);
            if (id == -1) {
                message = "Thiếu ID tài khoản để xóa.";
                messageType = "warning";
            } else {
                boolean success = gameAccountRepository.deleteGameAccount(id);
                if (success) {
                    message = "Xóa tài khoản ID " + id + " thành công!";
                    messageType = "success";
                } else {
                    message = "Xóa tài khoản ID " + id + " thất bại (có thể do tài khoản không tồn tại hoặc lỗi khóa ngoại).";
                    messageType = "danger";
                }
            }
        } catch (Exception e) {
            message = "Lỗi khi xóa tài khoản.";
            messageType = "danger";
            handleErrorRedirect(request, response, message, e);
            return;
        }
        sendRedirectWithMessage(request, response, "/admin/game-accounts", message, messageType);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage, Exception e) throws ServletException, IOException {
        if (e != null) { e.printStackTrace(); } // Keep stack trace for debugging
        request.setAttribute("message", errorMessage);
        request.setAttribute("messageType", "danger");
        RequestDispatcher dispatcher = request.getRequestDispatcher(JSP_LIST_PATH);
        dispatcher.forward(request, response);
    }

    private void handleErrorRedirect(HttpServletRequest request, HttpServletResponse response, String errorMessage, Exception e) throws IOException {
        if (e != null) { e.printStackTrace(); } // Keep stack trace
        sendRedirectWithMessage(request, response, "/admin/game-accounts", errorMessage, "danger");
    }

    private void sendRedirectWithMessage(HttpServletRequest request, HttpServletResponse response, String targetUrl, String message, String messageType) throws IOException {
        String encodedMessage = "";
        String finalUrl = request.getContextPath() + targetUrl;
        String separator = "?";

        if (message != null && !message.isEmpty()) {
            try {
                encodedMessage = URLEncoder.encode(message, "UTF-8");
                finalUrl += separator + "message=" + encodedMessage;
                separator = "&";
            }
            catch (UnsupportedEncodingException e) { e.printStackTrace(); }
        }
        if (messageType != null && !messageType.isEmpty()) {
            finalUrl += separator + "messageType=" + messageType;
        }
        response.sendRedirect(finalUrl);
    }

    private int parseIntParameter(HttpServletRequest request, String paramName, Integer defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try { return Integer.parseInt(paramValue.trim()); }
            catch (NumberFormatException e) { }
        }
        return (defaultValue != null) ? defaultValue : 0;
    }

    private double parseDoubleParameter(HttpServletRequest request, String paramName, double defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try { return Double.parseDouble(paramValue.trim()); }
            catch (NumberFormatException e) {  }
        }
        return defaultValue;
    }
}
