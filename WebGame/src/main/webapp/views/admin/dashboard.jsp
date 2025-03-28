<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <%-- Bootstrap CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    <%-- Font Awesome --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        .main-content {
            flex: 1;
        }
        .card-icon {
            font-size: 3rem;
            /* Thay var(--bs-primary) bằng mã màu Hex */
            color: #0d6efd; /* Mã màu Hex cho primary */
            margin-bottom: 1rem;
        }
        .card {
            transition: transform .2s ease-in-out, box-shadow .2s ease-in-out;
            border: none;
            box-shadow: 0 .125rem .25rem rgba(0,0,0,.075);
            height: 100%;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 .5rem 1rem rgba(0,0,0,.15);
        }
        .card-body {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
        .card-title { margin-bottom: 0.5rem; }
        .card-text { min-height: 40px; margin-bottom: 1.5rem; }
        footer { background-color: #e9ecef; }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"></jsp:include>
<%-- Main Content Area --%>
<div class="container mt-4 mb-5 main-content">

    <c:if test="${not empty sessionScope.username}">
        <h3 class="mb-4">Chào mừng trở lại, <span class="fw-bold text-primary">${sessionScope.username}</span>!</h3>
    </c:if>

    <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4">

        <%-- Card Quản lý User --%>
        <div class="col">
            <div class="card">
                <div class="card-body">
                    <%-- Thay var(--bs-indigo) bằng mã màu Hex --%>
                    <i class="fas fa-users-cog card-icon" style="color: #6610f2;"></i>
                    <h5 class="card-title">Quản lý Người Dùng</h5>
                    <p class="card-text text-muted small">Thêm, sửa, xóa và tìm kiếm tài khoản người dùng và admin.</p>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-primary stretched-link">Đi đến quản lý</a>
                </div>
            </div>
        </div>

        <%-- Card Quản lý Tài khoản Game --%>
        <div class="col">
            <div class="card">
                <div class="card-body">
                    <%-- Thay var(--bs-success) bằng mã màu Hex --%>
                    <i class="fas fa-gamepad card-icon" style="color: #198754;"></i>
                    <h5 class="card-title">Quản lý Tài khoản Game</h5>
                    <p class="card-text text-muted small">Quản lý thông tin các tài khoản game đang bán.</p>
                    <a href="${pageContext.request.contextPath}/admin/game-accounts" class="btn btn-outline-success stretched-link">Đi đến quản lý</a>
                </div>
            </div>
        </div>

        <%-- Card Quản lý Mã giảm giá --%>
        <div class="col">
            <div class="card">
                <div class="card-body">
                    <%-- Thay var(--bs-info) bằng mã màu Hex --%>
                    <i class="fas fa-tags card-icon" style="color: #0dcaf0;"></i>
                    <h5 class="card-title">Quản lý Mã Giảm Giá</h5>
                    <p class="card-text text-muted small">Tạo và quản lý các mã khuyến mãi cho cửa hàng.</p>
                    <a href="${pageContext.request.contextPath}/admin/discounts" class="btn btn-outline-info stretched-link">Đi đến quản lý</a>
                </div>
            </div>
        </div>

        <%-- Card Quản lý Đơn hàng --%>
        <div class="col">
            <div class="card">
                <div class="card-body">
                    <%-- Thay var(--bs-warning) bằng mã màu Hex --%>
                    <i class="fas fa-shopping-cart card-icon" style="color: #ffc107;"></i>
                    <h5 class="card-title">Quản lý Đơn Hàng</h5>
                    <p class="card-text text-muted small">Xem và cập nhật trạng thái các đơn hàng của khách.</p>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-warning stretched-link">Đi đến quản lý</a>
                </div>
            </div>
        </div>

        <%-- Card Quản lý Giao dịch nạp tiền --%>
        <div class="col">
            <div class="card">
                <div class="card-body">
                    <%-- Thay var(--bs-danger) bằng mã màu Hex --%>
                    <i class="fas fa-money-check-alt card-icon" style="color: #dc3545;"></i>
                    <h5 class="card-title">Quản lý Giao Dịch Nạp</h5>
                    <p class="card-text text-muted small">Xem lịch sử và trạng thái các giao dịch nạp tiền.</p>
                    <a href="${pageContext.request.contextPath}/admin/topup-transactions" class="btn btn-outline-danger stretched-link">Đi đến quản lý</a>
                </div>
            </div>
        </div>

        <%-- Card Thống kê (Ví dụ) --%>
        <div class="col">
            <div class="card bg-light">
                <div class="card-body">
                    <%-- Icon này dùng class text-secondary, IDE thường hiểu được, không cần đổi --%>
                    <i class="fas fa-chart-line card-icon text-secondary"></i>
                    <h5 class="card-title">Thống kê & Báo cáo</h5>
                    <p class="card-text text-muted small">Xem các báo cáo doanh thu, người dùng (Chưa triển khai).</p>
                    <button class="btn btn-outline-secondary" disabled>Xem báo cáo</button>
                </div>
            </div>
        </div>

    </div> <%-- End row --%>
</div> <%-- End container --%>


<%-- Footer --%>
<footer class="py-3 mt-auto">
    <div class="container text-center">
        <small class="text-muted">&copy; ${currentYear} Game Store Admin Panel. All Rights Reserved.</small>
    </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
</body>
</html>