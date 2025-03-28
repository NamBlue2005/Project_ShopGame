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
    /* Giữ lại style hover của bạn */
    .table-hover tbody tr:hover {
      background-color: rgba(74, 79, 235, 0.1);
    }
    /* Bỏ .thead-gemini, dùng table-dark */
    .action-buttons .btn { margin-right: 0.25rem; }
    .card-header-button { text-decoration: none; color: inherit; }
    .card-header-button:hover { color: #0d6efd; } /* Màu primary mặc định */
    footer { background-color: #e9ecef; }
    .modal-body .form-control-sm, .modal-body .form-select-sm { margin-bottom: 0.5rem; } /* Giảm margin bottom trong modal */
    .col-form-label-sm { padding-top: calc(0.25rem + 1px); padding-bottom: calc(0.25rem + 1px); } /* Chỉnh label sm */
  </style>
</head>
<body>

<%-- Include Navbar từ file riêng --%>
<jsp:include page="navbar.jsp" />

<div class="container-xl main-content">

  <%-- Tiêu đề trang và nút Thêm --%>
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="mb-0">Quản lý Tài khoản Game</h2>
    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addAccountModal">
      <i class="fas fa-plus me-1"></i> Thêm Tài Khoản
    </button>
  </div>

  <%-- Thông báo (message và error lấy từ URL parameter theo servlet của bạn) --%>
  <c:if test="${not empty param.message}">
    <div class="alert alert-${not empty param.messageType ? param.messageType : 'info'} alert-dismissible fade show" role="alert">
      <c:out value="${param.message}" />
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>
  <%-- Lưu ý: Phần hiển thị lỗi validation (nếu có) cần được servlet của bạn xử lý và đặt vào request attribute nếu muốn hiển thị riêng --%>


  <%-- Form tìm kiếm - Card có thể thu gọn (Giữ nguyên) --%>
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

  <%-- Bảng Danh Sách Tài Khoản --%>
  <div class="card shadow-sm">
    <div class="card-header bg-light">
      <h5 class="mb-0">Danh sách tài khoản</h5>
    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <%-- Sử dụng class table-hover của bạn, đổi header thành table-dark --%>
        <table class="table table-striped table-hover table-sm mb-0">
          <thead class="table-dark">
          <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Rank</th>
            <th class="text-end">Tiền</th>
            <th class="text-center">Tướng</th>
            <th class="text-center">Skin</th>
            <th class="text-end">Giá bán</th> <%-- Thêm cột giá bán --%>
            <th class="text-center">Trạng thái</th>
            <th class="text-center" style="width: 100px;">Hành động</th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty gameAccounts}">
              <tr>
                <td colspan="9" class="text-center fst-italic p-4">Không có tài khoản game nào phù hợp.</td> <%-- Tăng colspan --%>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="account" items="${gameAccounts}">
                <tr>
                  <td><c:out value="${account.gameAccountId}" /></td>
                  <td><c:out value="${account.accountUsername}" /></td>
                  <td><c:out value="${account.gameRank}" /></td>
                  <td class="text-end pe-3"><fmt:formatNumber value="${account.inGameCurrency}" type="number" minFractionDigits="0" maxFractionDigits="2"/></td>
                  <td class="text-center"><c:out value="${account.numberOfChampions}" /></td>
                  <td class="text-center"><c:out value="${account.numberOfSkins}" /></td>
                    <%-- Hiển thị giá bán --%>
                  <td class="text-end pe-3 fw-bold"><fmt:formatNumber value="${account.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
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
                      <%-- Nút Sửa - Thêm data-price --%>
                    <button type="button" class="btn btn-outline-warning btn-sm edit-btn"
                            data-bs-toggle="modal" data-bs-target="#editAccountModal"
                            data-account-id="${account.gameAccountId}"
                            data-username="<c:out value="${account.accountUsername}"/>"
                            data-password="<c:out value="${account.accountPassword}"/>" <%-- Giữ lại password --%>
                            data-rank="<c:out value="${account.gameRank}"/>"
                            data-currency="${account.inGameCurrency}"
                            data-champions="${account.numberOfChampions}"
                            data-skins="${account.numberOfSkins}"
                            data-status="${account.status}"
                            data-price="${account.price}" <%-- THÊM GIÁ BÁN VÀO ĐÂY --%>
                            title="Sửa tài khoản ${account.accountUsername}">
                      <i class="fas fa-edit"></i>
                    </button>
                      <%-- Nút Xóa (Giữ nguyên) --%>
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

</div> <%-- End container --%>

<%-- ==================== MODALS ======================= --%>
<%-- Thêm trường Price vào Add và Edit Modal --%>

<%-- Add Modal --%>
<div class="modal fade" id="addAccountModal" tabindex="-1" aria-labelledby="addAccountModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/admin/game-accounts/add" method="post" id="addAccountForm">
        <div class="modal-header">
          <h5 class="modal-title" id="addAccountModalLabel"><i class="fas fa-plus-circle me-2"></i>Thêm tài khoản game mới</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="row mb-2">
            <label for="accountUsername_add" class="col-sm-4 col-form-label col-form-label-sm">Tên tài khoản <span class="text-danger">*</span></label>
            <div class="col-sm-8"><input type="text" class="form-control form-control-sm" id="accountUsername_add" name="accountUsername_add" required></div>
          </div>
          <div class="row mb-2">
            <label for="accountPassword_add" class="col-sm-4 col-form-label col-form-label-sm">Mật khẩu <span class="text-danger">*</span></label>
            <div class="col-sm-8"><input type="password" class="form-control form-control-sm" id="accountPassword_add" name="accountPassword_add" required></div>
          </div>
          <div class="row mb-2">
            <label for="price_add" class="col-sm-4 col-form-label col-form-label-sm">Giá bán (₫) <span class="text-danger">*</span></label>
            <div class="col-sm-8"><input type="number" step="1000" min="0" class="form-control form-control-sm" id="price_add" name="price_add" required value="0" placeholder="Ví dụ: 50000"></div>
          </div>
          <div class="row mb-2">
            <label for="gameRank_add" class="col-sm-4 col-form-label col-form-label-sm">Rank</label>
            <div class="col-sm-8"><input type="text" class="form-control form-control-sm" id="gameRank_add" name="gameRank_add"></div>
          </div>
          <div class="row mb-2">
            <label for="inGameCurrency_add" class="col-sm-4 col-form-label col-form-label-sm">Tiền trong game</label>
            <div class="col-sm-8"><input type="number" step="any" min="0" class="form-control form-control-sm" id="inGameCurrency_add" name="inGameCurrency_add" value="0"></div>
          </div>
          <div class="row mb-2">
            <label for="numberOfChampions_add" class="col-sm-4 col-form-label col-form-label-sm">Số tướng</label>
            <div class="col-sm-8"><input type="number" min="0" class="form-control form-control-sm" id="numberOfChampions_add" name="numberOfChampions_add" value="0"></div>
          </div>
          <div class="row mb-2">
            <label for="numberOfSkins_add" class="col-sm-4 col-form-label col-form-label-sm">Số skin</label>
            <div class="col-sm-8"><input type="number" min="0" class="form-control form-control-sm" id="numberOfSkins_add" name="numberOfSkins_add" value="0"></div>
          </div>
          <div class="row mb-2">
            <label for="status_add" class="col-sm-4 col-form-label col-form-label-sm">Trạng thái <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <select class="form-select form-select-sm" id="status_add" name="status_add" required>
                <option value="ACTIVE" selected>Active</option> <%-- Mặc định là Active khi thêm --%>
                <option value="INACTIVE">Inactive</option>
                <option value="BANNED">Banned</option>
                <option value="SUSPENDED">Suspended</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal"><i class="fas fa-times me-1"></i>Đóng</button>
          <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-save me-1"></i>Thêm tài khoản</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%-- Edit Modal --%>
<div class="modal fade" id="editAccountModal" tabindex="-1" aria-labelledby="editAccountModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/admin/game-accounts/update" method="post" id="editAccountForm">
        <input type="hidden" name="gameAccountId_edit" id="gameAccountId_edit">
        <div class="modal-header">
          <h5 class="modal-title" id="editAccountModalLabel"><i class="fas fa-edit me-2"></i>Sửa thông tin tài khoản game</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="row mb-2">
            <label for="accountUsername_edit" class="col-sm-4 col-form-label col-form-label-sm">Tên tài khoản <span class="text-danger">*</span></label>
            <div class="col-sm-8"><input type="text" class="form-control form-control-sm" id="accountUsername_edit" name="accountUsername_edit" required></div>
          </div>
          <div class="row mb-2">
            <label for="accountPassword_edit" class="col-sm-4 col-form-label col-form-label-sm">Mật khẩu <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="text" class="form-control form-control-sm" id="accountPassword_edit" name="accountPassword_edit" required>
              <small class="form-text text-danger"><i class="fas fa-exclamation-triangle me-1"></i>Lưu ý: Mật khẩu hiển thị dạng văn bản thô.</small>
            </div>
          </div>
          <div class="row mb-2">
            <label for="price_edit" class="col-sm-4 col-form-label col-form-label-sm">Giá bán (₫)</label>
            <div class="col-sm-8"><input type="number" step="1000" min="0" class="form-control form-control-sm" id="price_edit" name="price_edit" placeholder="Nhập giá bán"></div>
          </div>
          <div class="row mb-2">
            <label for="gameRank_edit" class="col-sm-4 col-form-label col-form-label-sm">Rank</label>
            <div class="col-sm-8"><input type="text" class="form-control form-control-sm" id="gameRank_edit" name="gameRank_edit"></div>
          </div>
          <div class="row mb-2">
            <label for="inGameCurrency_edit" class="col-sm-4 col-form-label col-form-label-sm">Tiền trong game</label>
            <div class="col-sm-8"><input type="number" step="any" min="0" class="form-control form-control-sm" id="inGameCurrency_edit" name="inGameCurrency_edit"></div>
          </div>
          <div class="row mb-2">
            <label for="numberOfChampions_edit" class="col-sm-4 col-form-label col-form-label-sm">Số tướng</label>
            <div class="col-sm-8"><input type="number" min="0" class="form-control form-control-sm" id="numberOfChampions_edit" name="numberOfChampions_edit"></div>
          </div>
          <div class="row mb-2">
            <label for="numberOfSkins_edit" class="col-sm-4 col-form-label col-form-label-sm">Số skin</label>
            <div class="col-sm-8"><input type="number" min="0" class="form-control form-control-sm" id="numberOfSkins_edit" name="numberOfSkins_edit"></div>
          </div>
          <div class="row mb-2">
            <label for="status_edit" class="col-sm-4 col-form-label col-form-label-sm">Trạng thái <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <select class="form-select form-select-sm" id="status_edit" name="status_edit" required>
                <option value="ACTIVE">Active</option>
                <option value="INACTIVE">Inactive</option>
                <option value="BANNED">Banned</option>
                <option value="SUSPENDED">Suspended</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal"><i class="fas fa-times me-1"></i>Đóng</button>
          <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-save me-1"></i>Lưu thay đổi</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%-- Delete Modal (Giữ nguyên) --%>
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="deleteForm" action="${pageContext.request.contextPath}/admin/game-accounts/delete" method="get"> <%-- Hoặc POST nếu servlet đổi --%>
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title" id="deleteConfirmModalLabel"><i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa tài khoản</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          Bạn có chắc chắn muốn xóa tài khoản <strong id="deleteAccountName" class="text-primary"></strong> (ID: <span id="deleteAccountIdSpan" class="fw-bold"></span>)?<br>
          <span class="text-danger fw-bold">Hành động này không thể hoàn tác!</span>
          <input type="hidden" name="id" id="deleteAccountIdInput" value="">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal"><i class="fas fa-times me-1"></i>Hủy</button>
          <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-trash-alt me-1"></i>Xác nhận Xóa</button>
        </div>
      </form>
    </div>
  </div>
</div>


<%-- Footer (Giữ nguyên) --%>
<footer class="py-3 mt-auto bg-light">
  <div class="container text-center">
    <small class="text-muted">&copy; ${currentYear} Game Store Admin Panel. All Rights Reserved.</small>
  </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<%-- Scripts --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Script Collapse (Giữ nguyên)
  const collapseElement = document.getElementById('collapseSearch');
  const collapseIcon = document.querySelector('a[href="#collapseSearch"] .collapse-icon');
  if (collapseElement && collapseIcon) { /* ... code xử lý icon collapse ... */ }
  if (collapseElement && collapseIcon) {
    collapseElement.addEventListener('show.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); });
    collapseElement.addEventListener('hide.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-up','fa-chevron-down'); });
    if (collapseElement.classList.contains('show')) { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); }
  }

  // Script xử lý Modals (Cập nhật để lấy thêm price cho Edit)
  const addAccountModal = document.getElementById('addAccountModal');
  const editAccountModal = document.getElementById('editAccountModal');
  const deleteConfirmModal = document.getElementById('deleteConfirmModal');

  // Reset Add Modal khi đóng
  if (addAccountModal) {
    addAccountModal.addEventListener('hidden.bs.modal', event => {
      addAccountModal.querySelector('#addAccountForm').reset();
    });
    // Đặt giá trị mặc định cho price khi mở modal Add
    addAccountModal.addEventListener('show.bs.modal', event => {
      const priceAddInput = addAccountModal.querySelector('#price_add');
      if(priceAddInput && !priceAddInput.value){ // Chỉ đặt nếu chưa có giá trị (tránh ghi đè nếu có lỗi validation)
        priceAddInput.value = '0';
      }
    });
  }

  // Populate Edit Modal
  if (editAccountModal) {
    editAccountModal.addEventListener('show.bs.modal', event => {
      const button = event.relatedTarget;
      const accountId = button.getAttribute('data-account-id');
      const username = button.getAttribute('data-username');
      const password = button.getAttribute('data-password');
      const rank = button.getAttribute('data-rank');
      const currency = button.getAttribute('data-currency');
      const champions = button.getAttribute('data-champions');
      const skins = button.getAttribute('data-skins');
      const status = button.getAttribute('data-status');
      const price = button.getAttribute('data-price'); // *** Lấy giá bán ***

      const modalForm = editAccountModal.querySelector('#editAccountForm');
      modalForm.querySelector('#gameAccountId_edit').value = accountId;
      modalForm.querySelector('#accountUsername_edit').value = username;
      modalForm.querySelector('#accountPassword_edit').value = password;
      modalForm.querySelector('#gameRank_edit').value = rank;
      modalForm.querySelector('#inGameCurrency_edit').value = currency;
      modalForm.querySelector('#numberOfChampions_edit').value = champions;
      modalForm.querySelector('#numberOfSkins_edit').value = skins;
      modalForm.querySelector('#status_edit').value = status;
      modalForm.querySelector('#price_edit').value = price; // *** Điền giá bán ***
    });
  }

  // Populate Delete Modal (Giữ nguyên)
  if (deleteConfirmModal) {
    deleteConfirmModal.addEventListener('show.bs.modal', event => {
      const button = event.relatedTarget;
      const accountId = button.getAttribute('data-account-id');
      const accountName = button.getAttribute('data-account-name');
      deleteConfirmModal.querySelector('#deleteAccountIdInput').value = accountId;
      deleteConfirmModal.querySelector('#deleteAccountName').textContent = accountName;
      deleteConfirmModal.querySelector('#deleteAccountIdSpan').textContent = accountId;
    });
  }
</script>
</body>
</html>