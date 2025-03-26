package controller.admin;

import model.DiscountCode;
import repository.DiscountRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "DiscountController", urlPatterns = {"/admin/discounts", "/admin/discounts/add", "/admin/discounts/update", "/admin/discounts/delete"})
public class DiscountController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/admin/discounts":
                    listDiscountCodes(request, response);
                    break;
                case "/admin/discounts/add":
                    showAddForm(request, response);
                    break;
                case "/admin/discounts/update":
                    showUpdateForm(request, response);
                    break;
                case "/admin/discounts/delete":
                    deleteDiscountCode(request, response);
                    break;
                default:
                    listDiscountCodes(request, response);
                    break;
            }
        } catch (SQLException ex) {
            request.setAttribute("message", "Database error: " + ex.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/views/admin/error.jsp").forward(request,response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/admin/discounts/add":
                    addDiscountCode(request, response);
                    break;
                case "/admin/discounts/update":
                    updateDiscountCode(request, response);
                    break;
            }
        } catch (SQLException ex) {
            request.setAttribute("message", "Database error: " + ex.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/views/admin/error.jsp").forward(request,response);

        }
    }
    private void listDiscountCodes(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {

        String discountIdStr = request.getParameter("discountId");
        String code = request.getParameter("code");
        String discountType = request.getParameter("discountType");
        String validFromStr = request.getParameter("validFrom");
        String validToStr = request.getParameter("validTo");

        Integer discountId = null;
        if(discountIdStr != null && !discountIdStr.trim().isEmpty()){
            try {
                discountId = Integer.parseInt(discountIdStr);
            }catch (NumberFormatException e){
                request.setAttribute("message", "Invalid discount ID format.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/views/admin/discount_list.jsp").forward(request,response);
                return;
            }
        }

        Date validFrom = null;
        if (validFromStr != null && !validFromStr.trim().isEmpty()) {
            try {
                validFrom = Date.valueOf(validFromStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("message", "Invalid 'valid from' date format.  Useരിയായ-MM-dd.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/views/admin/discount_list.jsp").forward(request, response);
                return;
            }
        }

        Date validTo = null;
        if (validToStr != null && !validToStr.trim().isEmpty()) {
            try {
                validTo = Date.valueOf(validToStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("message", "Invalid 'valid to' date format.  Useരിയായ-MM-dd.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/views/admin/discount_list.jsp").forward(request, response);

                return;
            }
        }

        List<DiscountCode> discountCodes = DiscountRepository.findDiscountCodes(discountId, code, discountType, validFrom, validTo);

        request.setAttribute("discountCodes", discountCodes);
        request.setAttribute("param",request.getParameterMap()); // giữ lại các tham số

        request.getRequestDispatcher("/views/admin/discount_list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/discount_add.jsp").forward(request, response);
    }

    private void addDiscountCode(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        String code = request.getParameter("code");
        String discountType = request.getParameter("discountType");
        String discountValueStr = request.getParameter("discountValue");
        String validFromStr = request.getParameter("validFrom");
        String validToStr = request.getParameter("validTo");
        String usageLimitStr = request.getParameter("usageLimit");

        if (code == null || code.trim().isEmpty() || discountType == null || discountType.trim().isEmpty() ||
                discountValueStr == null || discountValueStr.trim().isEmpty() || validFromStr == null || validFromStr.trim().isEmpty() ||
                validToStr == null || validToStr.trim().isEmpty() || usageLimitStr == null || usageLimitStr.trim().isEmpty()) {
            request.setAttribute("message", "All fields are required.");
            request.setAttribute("messageType", "danger");
            showAddForm(request, response); // Hiển thị lại form, kèm thông báo lỗi
            return;
        }

        if(!DiscountRepository.isCodeUnique(code)){
            request.setAttribute("message","Code already exit");
            request.setAttribute("messageType", "danger");
            showAddForm(request,response);
            return;
        }

        double discountValue;
        try {
            discountValue = Double.parseDouble(discountValueStr);
            if("percentage".equals(discountType) && (discountValue <=0 || discountValue >100)){
                request.setAttribute("message", "Invalid discount value. For percentage, it must be between 0 and 100.");
                request.setAttribute("messageType", "danger");
                showAddForm(request, response);
                return;

            }
            if("fixed".equals(discountType) && discountValue <=0){
                request.setAttribute("message","Invalid discount value. For fixed amount, it must be positive number");
                request.setAttribute("messageType","danger");
                showAddForm(request,response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid discount value format.");
            request.setAttribute("messageType", "danger");
            showAddForm(request, response);
            return;
        }

        Date validFrom;
        try {
            validFrom = Date.valueOf(validFromStr);
        } catch (IllegalArgumentException e) {
            request.setAttribute("message", "Invalid 'valid from' date format. Useരിയായ-MM-dd.");
            request.setAttribute("messageType", "danger");
            showAddForm(request, response);
            return;
        }

        Date validTo;
        try {
            validTo = Date.valueOf(validToStr);
        } catch (IllegalArgumentException e) {
            request.setAttribute("message", "Invalid 'valid to' date format.  Useരിയായ-MM-dd.");
            request.setAttribute("messageType", "danger");
            showAddForm(request, response);
            return;
        }
        if (validTo.before(validFrom)) {
            request.setAttribute("message", "'Valid to' date must be after 'valid from' date.");
            request.setAttribute("messageType", "danger");
            showAddForm(request, response);
            return;
        }

        int usageLimit;
        try {
            usageLimit = Integer.parseInt(usageLimitStr);
            if(usageLimit <=0){
                request.setAttribute("message","Usage limit must be positive number");
                request.setAttribute("messageType", "danger");
                showAddForm(request,response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid usage limit format.");
            request.setAttribute("messageType", "danger");
            showAddForm(request, response);
            return;
        }


        DiscountCode newDiscountCode = new DiscountCode(code, discountType, discountValue, validFrom, validTo, usageLimit, 0);


        try {
            DiscountRepository.addDiscountCode(newDiscountCode);
            request.setAttribute("message", "Discount code added successfully! ID: " + newDiscountCode.getDiscountId());
            request.setAttribute("messageType", "success");
            listDiscountCodes(request, response);

        } catch (SQLException e) {
            request.setAttribute("message", "Database error: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            showAddForm(request,response);
        }
    }


    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String discountIdStr = request.getParameter("discountId");
        if(discountIdStr == null || discountIdStr.trim().isEmpty()){
            request.setAttribute("message","Discount ID is required");
            request.setAttribute("messageType", "danger");
            listDiscountCodes(request,response);
            return;
        }
        int discountId;
        try{
            discountId = Integer.parseInt(discountIdStr);
        }catch (NumberFormatException e){
            request.setAttribute("message","Invalid Discount ID format");
            request.setAttribute("messageType","danger");
            listDiscountCodes(request,response);
            return;
        }

        DiscountCode discountCode = DiscountRepository.getDiscountCodeById(discountId);
        if (discountCode == null) {
            request.setAttribute("message", "Discount code not found.");
            request.setAttribute("messageType", "danger");
            listDiscountCodes(request, response);
        } else {
            request.setAttribute("discountCode", discountCode);
            request.getRequestDispatcher("/views/admin/discount_update.jsp").forward(request, response);
        }
    }


    private void updateDiscountCode(HttpServletRequest request, HttpServletResponse response) throws  IOException, ServletException, SQLException {
        String discountIdStr = request.getParameter("discountId");
        String code = request.getParameter("code");
        String discountType = request.getParameter("discountType");
        String discountValueStr = request.getParameter("discountValue");
        String validFromStr = request.getParameter("validFrom");
        String validToStr = request.getParameter("validTo");
        String usageLimitStr = request.getParameter("usageLimit");

        if (discountIdStr == null || discountIdStr.trim().isEmpty() ||code == null || code.trim().isEmpty() || discountType == null || discountType.trim().isEmpty() ||
                discountValueStr == null || discountValueStr.trim().isEmpty() || validFromStr == null || validFromStr.trim().isEmpty() ||
                validToStr == null || validToStr.trim().isEmpty() || usageLimitStr == null || usageLimitStr.trim().isEmpty()) {
            request.setAttribute("message", "All fields are required.");
            request.setAttribute("messageType", "danger");
            showUpdateForm(request, response);
            return;
        }

        int discountId;
        try{
            discountId = Integer.parseInt(discountIdStr);

        }catch (NumberFormatException e){
            request.setAttribute("message", "Invalid Discount ID format");
            request.setAttribute("messageType","danger");
            showUpdateForm(request,response);
            return;
        }

        if(!DiscountRepository.isCodeUnique(code, discountId)){ // truyền thêm discountId để bỏ qua chính nó
            request.setAttribute("message","Code already exit");
            request.setAttribute("messageType", "danger");
            showUpdateForm(request,response);
            return;
        }

        double discountValue;
        try {
            discountValue = Double.parseDouble(discountValueStr);
            if("percentage".equals(discountType) && (discountValue <=0 || discountValue >100)){
                request.setAttribute("message", "Invalid discount value. For percentage, it must be between 0 and 100.");
                request.setAttribute("messageType", "danger");
                showUpdateForm(request, response);
                return;

            }
            if("fixed".equals(discountType) && discountValue <=0){
                request.setAttribute("message","Invalid discount value. For fixed amount, it must be positive number");
                request.setAttribute("messageType","danger");
                showUpdateForm(request,response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid discount value format.");
            request.setAttribute("messageType", "danger");
            showUpdateForm(request,response);
            return;
        }

        Date validFrom;
        try {
            validFrom = Date.valueOf(validFromStr);
        } catch (IllegalArgumentException e) {
            request.setAttribute("message", "Invalid 'valid from' date format. Useരിയായ-MM-dd.");
            request.setAttribute("messageType", "danger");
            showUpdateForm(request,response);
            return;
        }

        Date validTo;
        try {
            validTo = Date.valueOf(validToStr);
        } catch (IllegalArgumentException e) {
            request.setAttribute("message", "Invalid 'valid to' date format.  Useരിയായ-MM-dd.");
            request.setAttribute("messageType", "danger");
            showUpdateForm(request,response);
            return;
        }
        if (validTo.before(validFrom)) {
            request.setAttribute("message", "'Valid to' date must be after 'valid from' date.");
            request.setAttribute("messageType", "danger");
            showUpdateForm(request,response);
            return;
        }

        int usageLimit;
        try {
            usageLimit = Integer.parseInt(usageLimitStr);
            if(usageLimit <=0){
                request.setAttribute("message","Usage limit must be positive number");
                request.setAttribute("messageType", "danger");
                showUpdateForm(request,response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid usage limit format.");
            request.setAttribute("messageType", "danger");
            showUpdateForm(request,response);
            return;
        }

        DiscountCode oldDiscountCode = DiscountRepository.getDiscountCodeById(discountId);
        if (oldDiscountCode == null) {
            request.setAttribute("message", "Discount code not found.");
            request.setAttribute("messageType", "danger");
            listDiscountCodes(request, response); // Back to list
            return;
        }

        DiscountCode updatedDiscountCode = new DiscountCode(code, discountType, discountValue, validFrom, validTo, usageLimit, oldDiscountCode.getTimesUsed());
        updatedDiscountCode.setDiscountId(discountId);

        try {
            DiscountRepository.updateDiscountCode(updatedDiscountCode);
            request.setAttribute("message", "Discount code updated successfully!");
            request.setAttribute("messageType", "success");
            listDiscountCodes(request, response);
        } catch (SQLException e) {
            request.setAttribute("message", "Database error: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            showUpdateForm(request,response);
        }
    }
    private  void deleteDiscountCode(HttpServletRequest request, HttpServletResponse response) throws  ServletException, IOException, SQLException{
        String discountIdStr = request.getParameter("discountId");
        if(discountIdStr == null || discountIdStr.trim().isEmpty()){
            request.setAttribute("message", "Discount ID is required to delete.");
            request.setAttribute("messageType", "danger");
            listDiscountCodes(request, response);
            return;
        }
        int discountId;
        try {
            discountId = Integer.parseInt(discountIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid Discount ID format.");
            request.setAttribute("messageType", "danger");
            listDiscountCodes(request, response);
            return;
        }

        try {
            DiscountRepository.deleteDiscountCode(discountId);
            request.setAttribute("message", "Discount code deleted successfully!");
            request.setAttribute("messageType", "success");
        } catch (SQLException e) {
            request.setAttribute("message", "Error deleting discount code: " + e.getMessage());
            request.setAttribute("messageType", "danger");
        }
        listDiscountCodes(request, response);
    }
}