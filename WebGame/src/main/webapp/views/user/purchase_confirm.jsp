<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận Mua Tài Khoản - Game Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
    <style>
        body { background-color: #f8f9fa; display: flex; flex-direction: column; min-height: 100vh;}
        .main-content { flex: 1; padding-top: 2rem; padding-bottom: 3rem;}
        footer { background-color: #e9ecef; }
        .confirm-card { max-width: 600px; margin: auto; }
        .list-group-item { background: none; border-color: rgba(0,0,0,.05);}
        .price-confirm { font-size: 1.5rem; color: #dc3545; font-weight: bold;}
    </style>
</head>
<body>

<%-- Include Navbar Public --%>
<jsp:include page="/views/public/navbar_public.jsp" />

<div class="container main-content">
    <h2 class="text-center mb-4">Xác nhận thông tin mua hàng</h2>

    <c:if test="${not empty accountToPurchase}">
        <div class="card shadow-sm confirm-card">
            <div class="card-header bg-light">
                <h5 class="mb-0">Tài khoản: #${accountToPurchase.gameAccountId}</h5>
            </div>
            <div class="card-body">
                <h6 class="card-subtitle mb-3 text-muted">Vui lòng kiểm tra lại thông tin tài khoản bạn muốn mua:</h6>
                <ul class="list-group list-group-flush mb-3">
                    <c:if test="${not empty accountToPurchase.gameRank}">
                        <li class="list-group-item d-flex justify-content-between">
                            <span><i class="fas fa-medal text-secondary me-2"></i>Rank:</span>
                            <strong class="text-dark">${accountToPurchase.gameRank}</strong>
                        </li>
                    </c:if>
                    <c:if test="${accountToPurchase.numberOfChampions > 0}">
                        <li class="list-group-item d-flex justify-content-between">
                            <span><i class="fas fa-user-shield text-secondary me-2"></i>Số tướng:</span>
                            <strong>${accountToPurchase.numberOfChampions}</strong>
                        </li>
                    </c:if>
                    <c:if test="${accountToPurchase.numberOfSkins > 0}">
                        <li class="list-group-item d-flex justify-content-between">
                            <span><i class="fas fa-mask text-secondary me-2"></i>Số skin:</span>
                            <strong>${accountToPurchase.numberOfSkins}</strong>
                        </li>
                    </c:if>
                    <li class="list-group-item d-flex justify-content-between">
                        <span><i class="fas fa-tag text-secondary me-2"></i>Giá bán:</span>
                        <strong class="price-confirm">
                            <fmt:formatNumber value="${accountToPurchase.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </strong>
                    </li>
                </ul>

                    <%-- Form để xác nhận mua hàng (POST về /purchase) --%>
                <form action="${pageContext.request.contextPath}/purchase" method="POST" class="text-center">
                        <%-- Gửi lại ID tài khoản để servlet POST biết mua cái nào --%>
                    <input type="hidden" name="accountId" value="${accountToPurchase.gameAccountId}">
                        <%-- Có thể thêm các input khác nếu cần (ví dụ: mã giảm giá) --%>

                    <p class="text-muted small mb-3">Bằng việc nhấn "Xác nhận", bạn đồng ý với các điều khoản mua hàng.</p>

                    <a href="${pageContext.request.contextPath}/accounts" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Quay lại
                    </a>
                    <button type="submit" class="btn btn-danger btn-lg ms-2">
                        <i class="fas fa-check-circle me-1"></i> Xác nhận Mua Hàng
                    </button>
                </form>

            </div> <%-- End card-body --%>
        </div> <%-- End card --%>
    </c:if>

    <%-- Hiển thị nếu không tìm thấy tài khoản (trường hợp servlet chuyển lỗi đến đây thay vì redirect) --%>
    <c:if test="${empty accountToPurchase && not empty errorMessage}">
        <div class="alert alert-warning text-center" role="alert">
                ${errorMessage} <a href="${pageContext.request.contextPath}/accounts">Quay lại danh sách</a>.
        </div>
    </c:if>

</div> <%-- End container --%>

<%-- Footer --%>
<footer class="py-3 mt-auto bg-light">
    <div class="container text-center">
        <small class="text-muted">&copy; ${currentYear} Game Store. All Rights Reserved.</small>
    </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>