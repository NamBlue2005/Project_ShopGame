<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Quản lý đơn hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { padding-top: 20px; }
        .table th, .table td { vertical-align: middle; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Admin Panel</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="/admin/dashboard">Home</a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user"></i> ${sessionScope.username} (ID: ${sessionScope.userId}, Type: ${sessionScope.userType})
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="/admin/profile">Profile</a></li>
                        <li><a class="dropdown-item" href="#">Settings</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/adminLogin">Logout</a></li> <%-- Cũng nên dùng contextPath --%>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <h1>Quản lý đơn hàng</h1>

    <%-- Thông báo --%>
    <c:if test="${not empty message}">
        <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="mb-3 card">
        <div class="card-header">
            <h3>Tìm kiếm đơn hàng</h3>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/orders" method="get">
                <div class="row g-3 align-items-center">
                    <div class="col-md">
                        <label for="searchOrderId" class="form-label">ID Đơn hàng</label>
                        <input type="number" class="form-control" name="orderId" id="searchOrderId" placeholder="Nhập ID" value="${param.orderId}">
                    </div>
                    <div class="col-md">
                        <label for="searchUserId" class="form-label">ID Người dùng</label>
                        <input type="number" class="form-control" name="userId" id="searchUserId" placeholder="Nhập ID" value="${param.userId}">
                    </div>
                    <div class="col-md">
                        <label for="searchGameAccountId" class="form-label">ID Tài khoản game</label>
                        <input type="number" class="form-control" name="gameAccountId" id="searchGameAccountId" placeholder="Nhập ID"  value="${param.gameAccountId}">
                    </div>
                    <div class="col-md">
                        <label for="searchOrderStatus" class="form-label">Trạng thái</label>
                        <select class="form-select" name="orderStatus" id="searchOrderStatus">
                            <option value="" ${empty param.orderStatus ? 'selected' : ''}>Tất cả</option>
                            <option value="pending" ${param.orderStatus == 'pending' ? 'selected' : ''}>Pending</option>
                            <option value="completed" ${param.orderStatus == 'completed' ? 'selected' : ''}>Completed</option>
                            <option value="cancelled" ${param.orderStatus == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    <div class="col-md-auto align-self-end">
                        <button type="submit" class="btn btn-primary">Tìm</button>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">Xóa lọc</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <table class="table table-striped table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>User ID</th>
            <th>Game Acc ID</th>
            <th>Ngày đặt</th>
            <th>Trạng thái</th>
            <th>Tổng tiền</th>
            <th>PT Thanh toán</th>
            <th>Discount ID</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty orders}">
                <c:forEach items="${orders}" var="order">
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.userId}</td>
                        <td>${order.gameAccountId}</td>
                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td>
                            <span class="badge
                                <c:choose>
                                    <c:when test="${order.orderStatus == 'pending'}">bg-warning text-dark</c:when>
                                    <c:when test="${order.orderStatus == 'completed'}">bg-success</c:when>
                                    <c:when test="${order.orderStatus == 'cancelled'}">bg-danger</c:when>
                                    <c:otherwise>bg-secondary</c:otherwise>
                                </c:choose>
                            ">${order.orderStatus}</span>
                        </td>
                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                        <td>${order.paymentMethod}</td>
                        <td>${order.discountId == null ? '-' : order.discountId}</td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="8" class="text-center">Không tìm thấy đơn hàng nào.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>