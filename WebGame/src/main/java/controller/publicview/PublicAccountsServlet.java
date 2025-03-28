package controller.publicview; // Hoặc package controller của bạn

import model.GameAccount;
import repository.GameAccountRepository;

// --- Sử dụng javax ---
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
// ---

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PublicAccountsServlet", urlPatterns = {"/accounts","/"}) // URL công khai
public class PublicAccountsServlet extends HttpServlet {

    private GameAccountRepository gameAccountRepository;

    @Override
    public void init() {
        gameAccountRepository = new GameAccountRepository();
        System.out.println("PublicAccountsServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            Integer accountId = parseIntParameter(request, "accountId", null);
            String rank = request.getParameter("rank");
            Double minPrice = parseDoubleParameter(request, "minPrice", null);
            Double maxPrice = parseDoubleParameter(request, "maxPrice", null);
            Integer minChampions = parseIntParameter(request, "minChampions", null);
            Integer minSkins = parseIntParameter(request, "minSkins", null);

            List<GameAccount> accountList = gameAccountRepository.findPublicAccounts(
                    accountId, rank, minPrice, maxPrice, minChampions, minSkins
            );
            request.setAttribute("accountList", accountList);
            if (accountId != null) request.setAttribute("searchAccountId", accountId);
            if (rank != null) request.setAttribute("searchRank", rank);
            if (minPrice != null) request.setAttribute("searchMinPrice", minPrice);
            if (maxPrice != null) request.setAttribute("searchMaxPrice", maxPrice);
            if (minChampions != null) request.setAttribute("searchMinChampions", minChampions);
            if (minSkins != null) request.setAttribute("searchMinSkins", minSkins);
            String jspPath = "/views/public/accounts.jsp"; // Đường dẫn mới
            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in PublicAccountsServlet doGet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error retrieving or searching game accounts.", e);
        }
    }

    private Integer parseIntParameter(HttpServletRequest request, String paramName, Integer defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramValue.trim());
            } catch (NumberFormatException e) {
                System.err.println("Invalid integer format for parameter '" + paramName + "': " + paramValue);
            }
        }
        return defaultValue;
    }

    private Double parseDoubleParameter(HttpServletRequest request, String paramName, Double defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Double.parseDouble(paramValue.trim());
            } catch (NumberFormatException e) {
                System.err.println("Invalid double format for parameter '" + paramName + "': " + paramValue);
            }
        }
        return defaultValue;
    }

}