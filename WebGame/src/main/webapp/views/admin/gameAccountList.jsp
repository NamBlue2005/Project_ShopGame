<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin - Quản lý Tài khoản Game</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <style>
    body {
      background-color: #f8f9fa;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    .navbar .nav-link.active { font-weight: bold; }
    .main-content {
      flex: 1;
      padding-top: 1.5rem;
      padding-bottom: 3rem;
    }
    .table th, .table td {
      vertical-align: middle;
      font-size: 0.9rem;
    }
    .table-hover tbody tr:hover {
      background-color: rgba(74, 79, 235, 0.1);
    }
    .action-buttons .btn { margin-right: 0.25rem; }
    .card-header-button { text-decoration: none; color: inherit; }
    .card-header-button:hover { color: #0d6efd; }
    footer { background-color: #e9ecef; }
    .modal-body .form-control, .modal-body .form-select { margin-bottom: 0.75rem; }
  </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container-xl main-content">

  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="mb-0">Quản lý Tài khoản Game</h2>
    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addAccountModal">
      <i class="fas fa-plus me-1"></i> Thêm Tài Khoản
    </button>
  </div>

  <c:if test="${not empty message}">
    <div class="alert alert-${not empty messageType ? messageType : 'info'} alert-dismissible fade show" role="alert">
      <c:out value="${message}" />
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <c:out value="${error}"/>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>
  <c:if test="${not empty errors}">
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
      <i class="fas fa-exclamation-circle me-2"></i><strong>Vui lòng kiểm tra lại thông tin nhập:</strong>
      <ul class="mb-0 mt-2" style="padding-left: 1.5rem;">
        <c:forEach var="errMsg" items="${errors}">
          <li>${errMsg}</li>
        </c:forEach>
      </ul>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <div class="card shadow-sm mb-4">
    <div class="card-header bg-light">
      <a class="card-header-button d-flex justify-content-between align-items-center"
         data-bs-toggle="collapse" href="#collapseSearch" role="button" aria-expanded="false" aria-controls="collapseSearch">
        <h5 class="mb-0"><i class="fas fa-search me-2"></i>Tìm kiếm Tài khoản</h5>
        <i class="fas fa-chevron-down collapse-icon"></i>
      </a>
    </div>
    <div class="collapse" id="collapseSearch">
      <div class="card-body p-3">
        <form action="${pageContext.request.contextPath}/admin/game-accounts" method="get">
          <div class="row g-2 align-items-center">
            <div class="col-lg col-md-3 col-sm-6">
              <input type="number" class="form-control form-control-sm" name="gameAccountId" placeholder="ID" value="${param.gameAccountId}">
            </div>
            <div class="col-lg col-md-3 col-sm-6">
              <input type="text" class="form-control form-control-sm" name="accountUsername" placeholder="Tên tài khoản" value="${param.accountUsername}">
            </div>
            <div class="col-lg col-md-3 col-sm-6">
              <input type="text" class="form-control form-control-sm" name="gameRank" placeholder="Rank" value="${param.gameRank}">
            </div>
            <div class="col-lg col-md-3 col-sm-6">
              <select class="form-select form-select-sm" name="status">
                <option value="" ${empty param.status ? 'selected' : ''}>-- Trạng thái --</option>
                <option value="ACTIVE" ${param.status eq 'ACTIVE' ? 'selected' : ''}>Active</option>
                <option value="INACTIVE" ${param.status eq 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                <option value="BANNED" ${param.status eq 'BANNED' ? 'selected' : ''}>Banned</option>
                <option value="SUSPENDED" ${param.status eq 'SUSPENDED' ? 'selected' : ''}>Suspended</option>
              </select>
            </div>
            <div class="col-lg-auto col-md-12 mt-2 mt-lg-0 ms-auto text-end">
              <button type="submit" class="btn btn-primary btn-sm">
                <i class="fas fa-search me-1"></i> Lọc
              </button>
              <a href="${pageContext.request.contextPath}/admin/game-accounts" class="btn btn-outline-secondary btn-sm ms-1" title="Xóa bộ lọc">
                <i class="fas fa-eraser"></i>
              </a>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>

  <div class="card shadow-sm">
    <div class="card-header bg-light">
      <h5 class="mb-0">Danh sách tài khoản</h5>
    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-striped table-hover table-sm mb-0">
          <thead class="table-dark">
          <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Rank</th>
            <th class="text-end">Tiền</th>
            <th class="text-center">Tướng</th>
            <th class="text-center">Skin</th>
            <th class="text-center">Trạng thái</th>
            <th class="text-center" style="width: 100px;">Hành động</th>
          </tr>
          </thead>
          <tbody>
          <%-- Phần body table giữ nguyên --%>
          <c:choose>
            <c:when test="${empty gameAccounts}">
              <tr>
                <td colspan="8" class="text-center fst-italic p-4">Không có tài khoản game nào phù hợp.</td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="account" items="${gameAccounts}">
                <tr>
                  <td ><c:out value="${account.gameAccountId}" /></td>
                  <td><c:out value="${account.accountUsername}" /></td>
                  <td><c:out value="${account.gameRank}" /></td>
                  <td class="text-end pe-3"><fmt:formatNumber value="${account.inGameCurrency}" type="number" minFractionDigits="0" maxFractionDigits="2"/></td>
                  <td class="text-center"><c:out value="${account.numberOfChampions}" /></td>
                  <td class="text-center"><c:out value="${account.numberOfSkins}" /></td>
                  <td class="text-center">
                                        <span class="badge rounded-pill
                                            <c:choose>
                                                <c:when test="${account.status eq 'ACTIVE'}">text-bg-success</c:when>
                                                <c:when test="${account.status eq 'INACTIVE'}">text-bg-secondary</c:when>
                                                <c:when test="${account.status eq 'BANNED'}">text-bg-danger</c:when>
                                                <c:when test="${account.status eq 'SUSPENDED'}">text-bg-warning</c:when>
                                                <c:otherwise>text-bg-info</c:otherwise>
                                            </c:choose>
                                        "><c:out value="${account.status}" /></span>
                  </td>
                  <td class="text-center action-buttons">
                    <button type="button" class="btn btn-outline-warning btn-sm edit-btn"
                            data-bs-toggle="modal" data-bs-target="#editAccountModal"
                            data-account-id="${account.gameAccountId}"
                            data-username="<c:out value="${account.accountUsername}"/>"
                            data-password="<c:out value="${account.accountPassword}"/>"
                            data-rank="<c:out value="${account.gameRank}"/>"
                            data-currency="${account.inGameCurrency}"
                            data-champions="${account.numberOfChampions}"
                            data-skins="${account.numberOfSkins}"
                            data-status="${account.status}"
                            title="Sửa tài khoản ${account.accountUsername}">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button type="button" class="btn btn-outline-danger btn-sm"
                            data-bs-toggle="modal" data-bs-target="#deleteConfirmModal"
                            data-account-id="${account.gameAccountId}"
                            data-account-name="<c:out value="${account.accountUsername}"/>"
                            title="Xóa tài khoản ${account.accountUsername}">
                      <i class="fas fa-trash-alt"></i>
                    </button>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</div>

<footer class="py-3 mt-auto bg-light">...</footer>
<c:set var="currentYear">...</c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>