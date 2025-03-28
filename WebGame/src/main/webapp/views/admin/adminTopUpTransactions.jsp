<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin - Quản lý Giao dịch Nạp tiền</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <style>
    body {
      background-color: #f8f9fa;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    .navbar .nav-link.active {
      font-weight: bold;
    }
    .main-content {
      flex: 1;
      padding-top: 1.5rem;
      padding-bottom: 3rem;
    }
    .table th, .table td { vertical-align: middle; }
    .card-header-button { text-decoration: none; color: inherit; }
  
    .card-header-button:hover {
      color: #0d6efd; 
    }
  
    footer { background-color: #e9ecef; }
    .badge { min-width: 70px; display: inline-block; }
  </style>
</head>
<body>

<%-- Include Navbar --%>
<jsp:include page="navbar.jsp"></jsp:include>

<div class="container-xl main-content">

  <%-- Tiêu đề trang --%>
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="mb-0">Quản lý Giao dịch Nạp tiền</h2>
  </div>

  <%-- Thông báo (Giữ nguyên) --%>
  <c:if test="${not empty message}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${error}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>
  <c:if test="${not empty errors}"> <%-- Hiển thị lỗi validation nếu có --%>
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
      <i class="fas fa-exclamation-circle me-2"></i><strong>Vui lòng kiểm tra lại thông tin nhập:</strong>
      <ul class="mb-0 mt-2 validation-error-list" style="padding-left: 1.5rem;">
        <c:forEach var="errMsg" items="${errors}">
          <li>${errMsg}</li>
        </c:forEach>
      </ul>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <%-- Form tìm kiếm - Card có thể thu gọn (Giữ nguyên) --%>
  <div class="card shadow-sm mb-4">
    <div class="card-header bg-light">
      <a class="card-header-button d-flex justify-content-between align-items-center"
         data-bs-toggle="collapse" href="#collapseSearch" role="button" aria-expanded="false" aria-controls="collapseSearch">
        <h5 class="mb-0"><i class="fas fa-filter me-2"></i>Bộ lọc / Tìm kiếm Giao dịch</h5>
        <i class="fas fa-chevron-down collapse-icon"></i>
      </a>
    </div>
    <div class="collapse" id="collapseSearch">
      <div class="card-body p-3">
        <form action="${pageContext.request.contextPath}/admin/topup-transactions" method="get">
          <div class="row g-2 align-items-center">
            <div class="col-lg-2 col-md-4 col-sm-6">
              <input type="number" class="form-control form-control-sm" name="transactionId" placeholder="ID Giao dịch" value="${param.transactionId}">
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
              <input type="number" class="form-control form-control-sm" name="userId" placeholder="ID Người dùng" value="${param.userId}">
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
              <select class="form-select form-select-sm" name="status">
                <option value="" ${empty param.status ? 'selected' : ''}>-- Trạng thái --</option>
                <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Completed</option>
                <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                <option value="failed" ${param.status == 'failed' ? 'selected' : ''}>Failed</option>
              </select>
            </div>
            <div class="col-lg-3 col-md-4 col-sm-6">
              <select class="form-select form-select-sm" name="paymentMethod">
                <option value="" ${empty param.paymentMethod ? 'selected' : ''}>-- Phương thức TT --</option>
                <option value="ngân hàng" ${param.paymentMethod == 'ngân hàng' ? 'selected' : ''}>Ngân hàng</option>
                <option value="Momo" ${param.paymentMethod == 'Momo' ? 'selected' : ''}>Momo</option>
                <option value="thẻ cào" ${param.paymentMethod == 'thẻ cào' ? 'selected' : ''}>Thẻ cào</option>
              </select>
            </div>
            <div class="col-lg-auto col-md-12 ms-auto text-end">
              <button type="submit" class="btn btn-primary btn-sm">
                <i class="fas fa-search me-1"></i> Lọc
              </button>
              <a href="${pageContext.request.contextPath}/admin/topup-transactions" class="btn btn-outline-secondary btn-sm ms-1" title="Xóa bộ lọc">
                <i class="fas fa-times"></i>
              </a>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>

  <%-- Bảng hiển thị danh sách (Giữ nguyên) --%>
  <div class="card shadow-sm">
    <div class="card-header bg-light">
      <h5 class="mb-0">Danh sách Giao dịch</h5>
    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover table-sm mb-0">
          <thead class="table-dark">
          <tr>
            <th>ID</th>
            <th>User ID</th>
            <th>Số tiền</th>
            <th>Ngày GD</th>
            <th>Phương thức</th>
            <th class="text-center">Trạng thái</th>
          </tr>
          </thead>
          <tbody>
          <%-- Logic hiển thị giữ nguyên --%>
          <c:choose>
            <c:when test="${not empty topUpTransactions}">
              <c:forEach items="${topUpTransactions}" var="transaction">
                <tr>
                  <td>${transaction.transactionId}</td>
                  <td>${transaction.userId}</td>
                  <td class="text-end pe-3"><fmt:formatNumber value="${transaction.amount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                  <td><fmt:formatDate value="${transaction.transactionDate}" pattern="HH:mm dd/MM/yyyy"/></td>
                  <td>${transaction.paymentMethod}</td>
                  <td class="text-center">
                                        <span class="badge rounded-pill
                                            <c:choose>
                                                <c:when test="${transaction.status == 'completed'}">text-bg-success</c:when>
                                                <c:when test="${transaction.status == 'pending'}">text-bg-warning</c:when>
                                                <c:when test="${transaction.status == 'failed'}">text-bg-danger</c:when>
                                                <c:otherwise>text-bg-secondary</c:otherwise>
                                            </c:choose>
                                        ">${transaction.status}</span>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr>
                <td colspan="6" class="text-center fst-italic p-4">Không có giao dịch nào phù hợp.</td>
              </tr>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</div> <%-- End container --%>

<%-- Footer (Giữ nguyên) --%>
<footer class="py-3 mt-auto">
  <div class="container text-center">
    <small class="text-muted">&copy; ${currentYear} Game Store Admin Panel. All Rights Reserved.</small>
  </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%-- Script Collapse (Giữ nguyên) --%>
<script>
  const collapseElement = document.getElementById('collapseSearch');
  const collapseIcon = document.querySelector('a[href="#collapseSearch"] .collapse-icon');
  if (collapseElement && collapseIcon) {
    collapseElement.addEventListener('show.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); });
    collapseElement.addEventListener('hide.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-up','fa-chevron-down'); });
    if (collapseElement.classList.contains('show')) { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); }
  }
</script>
</body>
</html>
