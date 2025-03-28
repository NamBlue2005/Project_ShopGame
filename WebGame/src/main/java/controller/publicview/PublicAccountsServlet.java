package controller.publicview; // Hoặc package controller của bạn

import model.GameAccount;
import repository.GameAccountRepository;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PublicAccountsServlet", urlPatterns = {"/"})
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

            List<GameAccount> accountList = gameAccountRepository.getAvailableAccountsForPublic();
            request.setAttribute("accountList", accountList);
            String jspPath = "/views/public/accounts.jsp";
            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.err.println("Error loading public accounts: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tải danh sách tài khoản.");
        }
    }
}