<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin - Quản lý tài khoản game (Gemini Style)</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
  <style>
    body {
      padding-top: 20px;
      padding-bottom: 60px;

    }

    .table th, .table td {
      vertical-align: middle;
    }

    .table-hover tbody tr:hover {
      background-color: rgba(74, 79, 235, 0.1);
    }


    .thead-gemini th {
      background-color: #4A4FEB;
      color: #ffffff;
      border-color: #4A4FEB;
    }

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
            <li><a class="dropdown-item" href="$/admin/profile">Profile</a></li>
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
  <h1>Quản lý tài khoản game</h1>

  <%-- Hiển thị thông báo (nếu có) --%>
  <c:if test="${not empty message}">
    <div class="alert alert-${not empty messageType ? messageType : 'info'} alert-dismissible fade show mt-3" role="alert">
      <c:out value="${message}" />
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <%-- Nút Thêm Mới (Mở Add Modal) --%>
  <div class="my-3">
    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addAccountModal">
      <i class="fas fa-plus"></i> Thêm tài khoản mới
    </button>
  </div>

  <%-- Form Tìm Kiếm --%>
  <div class="card mb-3">
    <div class="card-header">
      <i class="fas fa-search"></i> Tìm kiếm tài khoản
    </div>
    <div class="card-body">
      <form action="${pageContext.request.contextPath}/admin/game-accounts" method="get">
        <div class="row g-3">
          <div class="col-md-3">
            <label for="searchGameAccountId" class="form-label">ID</label>
            <input type="number" class="form-control" id="searchGameAccountId" name="gameAccountId" value="${param.gameAccountId}">
          </div>
          <div class="col-md-3">
            <label for="searchAccountUsername" class="form-label">Tên tài khoản</label>
            <input type="text" class="form-control" id="searchAccountUsername" name="accountUsername" value="${param.accountUsername}">
          </div>
          <div class="col-md-3">
            <label for="searchGameRank" class="form-label">Rank</label>
            <input type="text" class="form-control" id="searchGameRank" name="gameRank" value="${param.gameRank}">
          </div>
          <div class="col-md-3">
            <label for="searchStatus" class="form-label">Trạng thái</label>
            <select class="form-select" id="searchStatus" name="status">
              <option value="" ${empty param.status ? 'selected' : ''}>-- Tất cả --</option>
              <option value="ACTIVE" ${param.status eq 'ACTIVE' ? 'selected' : ''}>Active</option>
              <option value="INACTIVE" ${param.status eq 'INACTIVE' ? 'selected' : ''}>Inactive</option>
              <option value="BANNED" ${param.status eq 'BANNED' ? 'selected' : ''}>Banned</option>
              <option value="SUSPENDED" ${param.status eq 'SUSPENDED' ? 'selected' : ''}>Suspended</option>
            </select>
          </div>
          <div class="col-12 mt-3">
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-search"></i> Tìm kiếm
            </button>
            <a href="${pageContext.request.contextPath}/admin/game-accounts" class="btn btn-secondary">
              <i class="fas fa-eraser"></i> Xóa lọc
            </a>
          </div>
        </div>
      </form>
    </div>
  </div>

  <%-- Bảng Danh Sách Tài Khoản --%>
  <h2>Danh sách tài khoản</h2>
  <div class="table-responsive">
    <table class="table table-striped table-hover">
      <thead class="thead-gemini">
      <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Rank</th>
        <th>Tiền</th>
        <th>Số tướng</th>
        <th>Số skin</th>
        <th>Trạng thái</th>
        <th style="width: 120px;">Hành động</th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty gameAccounts}">
          <tr>
            <td colspan="8" class="text-center fst-italic">Không có tài khoản game nào phù hợp.</td>
          </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="account" items="${gameAccounts}">
            <tr>
              <td><c:out value="${account.gameAccountId}" /></td>
              <td><c:out value="${account.accountUsername}" /></td>
              <td><c:out value="${account.gameRank}" /></td>
              <td><fmt:formatNumber value="${account.inGameCurrency}" type="number" minFractionDigits="0" maxFractionDigits="2"/></td>
              <td><c:out value="${account.numberOfChampions}" /></td>
              <td><c:out value="${account.numberOfSkins}" /></td>
              <td>
                <span class="badge
                                    <c:choose>
                                        <c:when test="${account.status eq 'ACTIVE'}">bg-success</c:when>
                                        <c:when test="${account.status eq 'INACTIVE'}">bg-secondary</c:when>
                                        <c:when test="${account.status eq 'BANNED'}">bg-danger</c:when>
                                         <c:when test="${account.status eq 'SUSPENDED'}">bg-warning text-dark</c:when>
                                        <c:otherwise>bg-info</c:otherwise>
                                    </c:choose>
                                "><c:out value="${account.status}" /></span>
              </td>
              <td>
                <button type="button" class="btn btn-warning btn-sm edit-btn"
                        data-bs-toggle="modal" data-bs-target="#editAccountModal"
                        data-account-id="${account.gameAccountId}"
                        data-username="<c:out value="${account.accountUsername}"/>"
                        data-password="<c:out value="${account.accountPassword}"/>"
                        data-rank="<c:out value="${account.gameRank}"/>"
                        data-currency="${account.inGameCurrency}"
                        data-champions="${account.numberOfChampions}"
                        data-skins="${account.numberOfSkins}"
                        data-status="${account.status}"
                        title="Sửa">
                  <i class="fas fa-edit"></i>
                </button>
                  <%-- Nút Xóa  --%>
                <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteConfirmModal" data-account-id="${account.gameAccountId}" data-account-name="<c:out value="${account.accountUsername}"/>" title="Xóa">
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


<%-- ==================== CÁC MODAL ======================= --%>

<div class="modal fade" id="addAccountModal" tabindex="-1" aria-labelledby="addAccountModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/admin/game-accounts/add" method="post" id="addAccountForm">
        <div class="modal-header">
          <h5 class="modal-title" id="addAccountModalLabel"><i class="fas fa-plus-circle"></i> Thêm tài khoản game mới</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <%-- Các trường input cho form thêm --%>
          <div class="row mb-3">
            <label for="accountUsername_add" class="col-sm-3 col-form-label">Tên tài khoản <span class="text-danger">*</span></label>
            <div class="col-sm-9"><input type="text" class="form-control" id="accountUsername_add" name="accountUsername_add" required></div>
          </div>
          <div class="row mb-3">
            <label for="accountPassword_add" class="col-sm-3 col-form-label">Mật khẩu <span class="text-danger">*</span></label>
            <div class="col-sm-9"><input type="password" class="form-control" id="accountPassword_add" name="accountPassword_add" required></div>
          </div>
          <div class="row mb-3">
            <label for="gameRank_add" class="col-sm-3 col-form-label">Rank</label>
            <div class="col-sm-9"><input type="text" class="form-control" id="gameRank_add" name="gameRank_add"></div>
          </div>
          <div class="row mb-3">
            <label for="inGameCurrency_add" class="col-sm-3 col-form-label">Tiền trong game</label>
            <div class="col-sm-9"><input type="number" step="0.01" min="0" class="form-control" id="inGameCurrency_add" name="inGameCurrency_add" value="0"></div>
          </div>
          <div class="row mb-3">
            <label for="numberOfChampions_add" class="col-sm-3 col-form-label">Số tướng</label>
            <div class="col-sm-9"><input type="number" min="0" class="form-control" id="numberOfChampions_add" name="numberOfChampions_add" value="0"></div>
          </div>
          <div class="row mb-3">
            <label for="numberOfSkins_add" class="col-sm-3 col-form-label">Số skin</label>
            <div class="col-sm-9"><input type="number" min="0" class="form-control" id="numberOfSkins_add" name="numberOfSkins_add" value="0"></div>
          </div>
          <div class="row mb-3">
            <label for="status_add" class="col-sm-3 col-form-label">Trạng thái <span class="text-danger">*</span></label>
            <div class="col-sm-9">
              <select class="form-select" id="status_add" name="status_add" required>
                <option value="ACTIVE" selected>Active</option>
                <option value="INACTIVE">Inactive</option>
                <option value="BANNED">Banned</option>
                <option value="SUSPENDED">Suspended</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fas fa-times"></i> Đóng</button>
          <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Thêm tài khoản</button>
        </div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade" id="editAccountModal" tabindex="-1" aria-labelledby="editAccountModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/admin/game-accounts/update" method="post" id="editAccountForm">
        <input type="hidden" name="gameAccountId_edit" id="gameAccountId_edit">
        <div class="modal-header">
          <h5 class="modal-title" id="editAccountModalLabel"><i class="fas fa-edit"></i> Sửa tài khoản game</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <%-- Các trường input cho form sửa --%>
          <div class="row mb-3">
            <label for="accountUsername_edit" class="col-sm-3 col-form-label">Tên tài khoản <span class="text-danger">*</span></label>
            <div class="col-sm-9"><input type="text" class="form-control" id="accountUsername_edit" name="accountUsername_edit" required></div>
          </div>
          <div class="row mb-3">
            <label for="accountPassword_edit" class="col-sm-3 col-form-label">Mật khẩu <span class="text-danger">*</span></label>
            <div class="col-sm-9">
              <%-- type="text" để admin xem được mật khẩu hiện tại --%>
              <input type="text" class="form-control" id="accountPassword_edit" name="accountPassword_edit" required>
            </div>
          </div>
          <div class="row mb-3">
            <label for="gameRank_edit" class="col-sm-3 col-form-label">Rank</label>
            <div class="col-sm-9"><input type="text" class="form-control" id="gameRank_edit" name="gameRank_edit"></div>
          </div>
          <div class="row mb-3">
            <label for="inGameCurrency_edit" class="col-sm-3 col-form-label">Tiền trong game</label>
            <div class="col-sm-9"><input type="number" step="0.01" min="0" class="form-control" id="inGameCurrency_edit" name="inGameCurrency_edit"></div>
          </div>
          <div class="row mb-3">
            <label for="numberOfChampions_edit" class="col-sm-3 col-form-label">Số tướng</label>
            <div class="col-sm-9"><input type="number" min="0" class="form-control" id="numberOfChampions_edit" name="numberOfChampions_edit"></div>
          </div>
          <div class="row mb-3">
            <label for="numberOfSkins_edit" class="col-sm-3 col-form-label">Số skin</label>
            <div class="col-sm-9"><input type="number" min="0" class="form-control" id="numberOfSkins_edit" name="numberOfSkins_edit"></div>
          </div>
          <div class="row mb-3">
            <label for="status_edit" class="col-sm-3 col-form-label">Trạng thái <span class="text-danger">*</span></label>
            <div class="col-sm-9">
              <select class="form-select" id="status_edit" name="status_edit" required>
                <option value="ACTIVE">Active</option>
                <option value="INACTIVE">Inactive</option>
                <option value="BANNED">Banned</option>
                <option value="SUSPENDED">Suspended</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fas fa-times"></i> Đóng</button>
          <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Lưu thay đổi</button>
        </div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title" id="deleteConfirmModalLabel"><i class="fas fa-exclamation-triangle"></i> Xác nhận xóa tài khoản</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        Bạn có chắc chắn muốn xóa tài khoản <strong id="deleteAccountName"></strong> (ID: <span id="deleteAccountIdSpan"></span>)?<br>
        <span class="text-danger fw-bold">Hành động này không thể hoàn tác!</span>
      </div>
      <div class="modal-footer">
        <form id="deleteForm" action="${pageContext.request.contextPath}/admin/game-accounts/delete" method="get">
          <input type="hidden" name="id" id="deleteAccountIdInput" value="">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fas fa-times"></i> Hủy</button>
          <button type="submit" class="btn btn-danger"><i class="fas fa-trash-alt"></i> Xác nhận Xóa</button>
        </form>
      </div>
    </div>
  </div>
</div>

<%-- Scripts --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Script cho Modal Xóa
  const deleteConfirmModal = document.getElementById('deleteConfirmModal');
  if (deleteConfirmModal) {
    deleteConfirmModal.addEventListener('show.bs.modal', event => {
      const button = event.relatedTarget;
      const accountId = button.getAttribute('data-account-id');
      const accountName = button.getAttribute('data-account-name');
      const modalAccountIdInput = deleteConfirmModal.querySelector('#deleteAccountIdInput');
      const modalAccountNameElement = deleteConfirmModal.querySelector('#deleteAccountName');
      const modalAccountIdSpan = deleteConfirmModal.querySelector('#deleteAccountIdSpan');
      modalAccountIdInput.value = accountId;
      modalAccountNameElement.textContent = accountName;
      modalAccountIdSpan.textContent = accountId;
    });
  }

  // Script cho Modal Sửa (Bao gồm lấy và điền mật khẩu)
  const editAccountModal = document.getElementById('editAccountModal');
  if (editAccountModal) {
    editAccountModal.addEventListener('show.bs.modal', event => {
      const button = event.relatedTarget; // Button đã click

      // Lấy data từ button
      const accountId = button.getAttribute('data-account-id');
      const username = button.getAttribute('data-username');
      const password = button.getAttribute('data-password'); // Lấy password
      const rank = button.getAttribute('data-rank');
      const currency = button.getAttribute('data-currency');
      const champions = button.getAttribute('data-champions');
      const skins = button.getAttribute('data-skins');
      const status = button.getAttribute('data-status');

      // Tìm các element trong form sửa
      const modalForm = editAccountModal.querySelector('#editAccountForm');
      const idInput = modalForm.querySelector('#gameAccountId_edit');
      const usernameInput = modalForm.querySelector('#accountUsername_edit');
      const passwordInput = modalForm.querySelector('#accountPassword_edit'); // Input password
      const rankInput = modalForm.querySelector('#gameRank_edit');
      const currencyInput = modalForm.querySelector('#inGameCurrency_edit');
      const championsInput = modalForm.querySelector('#numberOfChampions_edit');
      const skinsInput = modalForm.querySelector('#numberOfSkins_edit');
      const statusSelect = modalForm.querySelector('#status_edit');

      // Điền dữ liệu vào form
      idInput.value = accountId;
      usernameInput.value = username;
      passwordInput.value = password; // Điền password vào input
      rankInput.value = rank;
      currencyInput.value = currency;
      championsInput.value = champions;
      skinsInput.value = skins;
      statusSelect.value = status;
    });
  }

  // Script reset form Add khi modal đóng
  const addAccountModal = document.getElementById('addAccountModal');
  if (addAccountModal) {
    addAccountModal.addEventListener('hidden.bs.modal', event => {
      addAccountModal.querySelector('#addAccountForm').reset();
    })
  }
</script>
</body>
</html>