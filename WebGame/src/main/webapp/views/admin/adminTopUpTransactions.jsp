<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin - Quản lý giao dịch nạp tiền</title>
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
            <li><a class="dropdown-item" href="#">Profile</a></li>
            <li><a class="dropdown-item" href="#">Settings</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="adminLogout">Logout</a></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>
<div class="container">
  <h1>Quản lý giao dịch nạp tiền</h1>

  <%-- Thông báo (nếu có) --%>
  <c:if test="${not empty message}">
    <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
        ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <%-- Form tìm kiếm --%>
  <div class="card mb-3">
    <div class="card-header">
      <h3>Tìm kiếm giao dịch</h3>
    </div>
    <div class="card-body">
      <form action="${pageContext.request.contextPath}/admin/topup-transactions" method="get">
        <div class="row g-3 align-items-center">
          <div class="col-md">
            <label for="searchTransactionId" class="form-label">ID Giao dịch</label>
            <input type="number" class="form-control" name="transactionId" id="searchTransactionId" placeholder="Nhập ID" value="${param.transactionId}">
          </div>
          <div class="col-md">
            <label for="searchUserId" class="form-label">ID Người dùng</label>
            <input type="number" class="form-control" name="userId" id="searchUserId" placeholder="Nhập ID" value="${param.userId}">
          </div>
          <div class="col-md">
            <label for="searchStatus" class="form-label">Trạng thái</label>
            <select class="form-select" name="status" id="searchStatus">
              <option value="" ${empty param.status ? 'selected' : ''}>Tất cả</option>
              <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Completed</option>
              <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
              <option value="failed" ${param.status == 'failed' ? 'selected' : ''}>Failed</option>
            </select>
          </div>
          <div class="col-md">
            <label for="searchPaymentMethod" class="form-label">Phương thức</label>
            <select class="form-select" name="paymentMethod" id="searchPaymentMethod">
              <option value="" ${empty param.paymentMethod ? 'selected' : ''}>Tất cả</option>
              <option value="ngân hàng" ${param.paymentMethod == 'ngân hàng' ? 'selected' : ''}>Ngân hàng</option>
              <option value="Momo" ${param.paymentMethod == 'Momo' ? 'selected' : ''}>Momo</option>
              <option value="thẻ cào" ${param.paymentMethod == 'thẻ cào' ? 'selected' : ''}>Thẻ cào</option>
            </select>
          </div>

          <div class="col-md-auto align-self-end">
            <button type="submit" class="btn btn-primary">Tìm</button>
            <a href="${pageContext.request.contextPath}/admin/topup-transactions" class="btn btn-secondary">Xóa lọc</a>
          </div>
        </div>
      </form>
    </div>
  </div>

  <%-- Bảng hiển thị danh sách --%>
  <table class="table table-striped table-bordered">
    <thead class="table-dark">
    <tr>
      <th>ID</th>
      <th>User ID</th>
      <th>Số tiền</th>
      <th>Ngày giao dịch</th>
      <th>Phương thức</th>
      <th>Trạng thái</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
      <c:when test="${not empty topUpTransactions}">
        <c:forEach items="${topUpTransactions}" var="transaction">
          <tr>
            <td>${transaction.transactionId}</td>
            <td>${transaction.userId}</td>
            <td><fmt:formatNumber value="${transaction.amount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
            <td><fmt:formatDate value="${transaction.transactionDate}" pattern="dd/MM/yyyy HH:mm"/></td>
            <td>${transaction.paymentMethod}</td>
            <td>
                            <span class="badge
                                <c:choose>
                                    <c:when test="${transaction.status == 'completed'}">bg-success</c:when>
                                    <c:when test="${transaction.status == 'pending'}">bg-warning text-dark</c:when>
                                    <c:when test="${transaction.status == 'failed'}">bg-danger</c:when>
                                    <c:otherwise>bg-secondary</c:otherwise>
                                </c:choose>
                            ">${transaction.status}</span>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="6" class="text-center">Không có giao dịch nào.</td>
        </tr>
      </c:otherwise>
    </c:choose>
    </tbody>
  </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>