<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- Dùng nếu cần định dạng số/ngày --%>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản Lý Người Dùng</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <style>
    body { background-color: #f8f9fa; padding-top: 20px; }
    .container-xl { max-width: 1300px; }
    .table th, .table td { vertical-align: middle; font-size: 0.95rem; } /* Hơi nhỏ chữ 1 chút */
    .action-buttons a, .action-buttons button { margin-right: 5px; }
    .form-label { font-weight: 500; }
    .modal-body .form-control, .modal-body .form-select { margin-bottom: 0.75rem; } /* Khoảng cách vừa phải trong modal */
    .validation-error-list { padding-left: 1.5rem; margin-bottom: 0; } /* Định dạng danh sách lỗi validation */
  </style>
</head>
<body>

<jsp:include page="navbar.jsp"></jsp:include>

<div class="container-xl">
  <h2 class="mb-4 text-center">Quản Lý Người Dùng</h2>


  <c:if test="${not empty message}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <i class="fas fa-check-circle me-2"></i>${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <i class="fas fa-exclamation-triangle me-2"></i>${error}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <c:if test="${not empty errors}">
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
      <i class="fas fa-exclamation-circle me-2"></i><strong>Vui lòng kiểm tra lại thông tin nhập:</strong>
      <ul class="mb-0 mt-2 validation-error-list">
        <c:forEach var="errMsg" items="${errors}">
          <li>${errMsg}</li>
        </c:forEach>
      </ul>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>


  <div class="card shadow-sm">
    <div class="card-header d-flex flex-wrap justify-content-between align-items-center bg-light"> <%-- Nền nhạt hơn --%>
      <h5 class="card-title mb-0 me-3">Danh sách người dùng</h5>
      <button type="button" class="btn btn-success btn-sm mt-2 mt-md-0" data-bs-toggle="modal" data-bs-target="#userModal" id="addUserBtn">
        <i class="fas fa-plus me-1"></i> Thêm Người Dùng
      </button>
    </div>
    <div class="card-body">

      <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="row g-3 mb-4 align-items-center border p-3 rounded bg-white">
        <input type="hidden" name="action" value="search">
        <div class="col-md-5">
          <label for="searchTerm" class="visually-hidden">Từ khóa</label>
          <input type="text" class="form-control form-control-sm" id="searchTerm" name="searchTerm" placeholder="Tìm theo username, email, số điện thoại..." value="<c:out value='${searchTerm}'/>">
        </div>
        <div class="col-md-4">
          <label for="searchType" class="visually-hidden">Loại TK</label>
          <select id="searchType" name="searchType" class="form-select form-select-sm">
            <option value="" ${empty searchType ? 'selected' : ''}>-- Tất cả loại tài khoản --</option>
            <option value="ADMIN" ${searchType == 'ADMIN' ? 'selected' : ''}>Admin</option>
            <option value="USER" ${searchType == 'USER' ? 'selected' : ''}>User</option>
          </select>
        </div>
        <div class="col-md-auto">
          <button type="submit" class="btn btn-primary btn-sm">
            <i class="fas fa-search me-1"></i> Lọc
          </button>
          <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm ms-2" title="Reset bộ lọc">
            <i class="fas fa-sync-alt"></i>
          </a>
        </div>
      </form>
      <%-- --- Hết Form Tìm kiếm --- --%>

      <%-- Bảng danh sách User --%>
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover table-sm"> <%-- table-sm cho nhỏ gọn hơn --%>
          <thead class="table-dark">
          <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Số điện thoại</th>
            <th>Loại TK</th>
            <th style="width: 130px;">Hành động</th> <%-- Giảm độ rộng chút --%>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="user" items="${userList}">
            <tr>
              <td>${user.userId}</td>
              <td><c:out value="${user.username}"/></td>
              <td><c:out value="${user.email}"/></td>
              <td><c:out value="${user.phoneNumber}"/></td>
              <td>
                <c:choose>
                  <c:when test="${user.type == 'ADMIN'}"><span class="badge text-bg-danger">Admin</span></c:when> <%-- text-bg-* cho BS 5.3 --%>
                  <c:otherwise><span class="badge text-bg-secondary">User</span></c:otherwise>
                </c:choose>
              </td>
              <td class="action-buttons text-center"> <%-- Căn giữa nút --%>
                  <%-- Nút Sửa - Mở Modal với dữ liệu --%>
                <button type="button" class="btn btn-sm btn-outline-warning editUserBtn"
                        data-bs-toggle="modal" data-bs-target="#userModal"
                        data-userid="${user.userId}"
                        data-username="<c:out value='${user.username}'/>"
                        data-email="<c:out value='${user.email}'/>"
                        data-phonenumber="<c:out value='${user.phoneNumber}'/>"
                        data-usertype="${user.type}"
                        title="Chỉnh sửa người dùng ${user.username}">
                  <i class="fas fa-edit"></i>
                </button>
                  <%-- Nút Xóa - Link trực tiếp với confirm JS --%>

                <c:if test="${user.userId != sessionScope.userId}">
                  <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=${user.userId}"
                     class="btn btn-sm btn-outline-danger"
                     onclick="return confirm('Xác nhận xóa người dùng [${user.username}] (ID: ${user.userId})?\nHành động này không thể hoàn tác!');"
                     title="Xóa người dùng ${user.username}">
                    <i class="fas fa-trash-alt"></i>
                  </a>
                </c:if>
                <c:if test="${user.userId == sessionScope.userId}">
                  <button type="button" class="btn btn-sm btn-outline-secondary" disabled title="Không thể xóa tài khoản của chính bạn">
                    <i class="fas fa-trash-alt"></i>
                  </button>
                </c:if>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty userList}">
            <tr>
              <td colspan="6" class="text-center fst-italic p-4">Không tìm thấy người dùng nào phù hợp với tiêu chí lọc.</td>
            </tr>
          </c:if>
          </tbody>
        </table>
      </div>
      <%-- --- Hết Bảng danh sách User --- --%>

      <%-- Optional: Phân trang (nếu có) --%>
      <%-- Ví dụ: <nav aria-label="Page navigation">...</nav> --%>

    </div> <%-- End card-body --%>
  </div> <%-- End card --%>
</div> <%-- End container-xl --%>


<%-- ================================================== --%>
<%-- MODAL THÊM/SỬA USER                               --%>
<%-- ================================================== --%>
<div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false"> <%-- Ngăn đóng khi click ngoài hoặc bấm ESC --%>
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form id="userForm" action="${pageContext.request.contextPath}/admin/users" method="POST">
        <div class="modal-header">
          <h5 class="modal-title" id="userModalLabel">Thêm Người Dùng Mới</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">

          <input type="hidden" name="action" id="formAction" value="save">
          <input type="hidden" name="userId" id="formUserId" value="">
          <div class="mb-3 row">
            <label for="username" class="col-sm-3 col-form-label">Username <span class="text-danger">*</span></label>
            <div class="col-sm-9">
              <input type="text" class="form-control" id="username" name="username" required minlength="3" value="<c:out value='${formData.username}'/>">
            </div>
          </div>
          <div class="mb-3 row">
            <label for="email" class="col-sm-3 col-form-label">Email <span class="text-danger">*</span></label>
            <div class="col-sm-9">
              <input type="email" class="form-control" id="email" name="email" required value="<c:out value='${formData.email}'/>">
            </div>
          </div>
          <div class="mb-3 row">
            <label for="phoneNumber" class="col-sm-3 col-form-label">Số điện thoại</label>
            <div class="col-sm-9">
              <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" value="<c:out value='${formData.phoneNumber}'/>">
            </div>
          </div>
          <div class="mb-3 row">
            <label for="password" class="col-sm-3 col-form-label">Mật khẩu <span id="passwordRequired" class="text-danger">*</span></label>
            <div class="col-sm-9">
              <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu (ít nhất 6 ký tự)" aria-describedby="passwordHelp" minlength="6">
              <div id="passwordHelp" class="form-text text-muted">Để trống nếu không muốn thay đổi mật khẩu khi chỉnh sửa. Bắt buộc khi thêm mới.</div>
            </div>
          </div>
          <div class="mb-3 row">
            <label for="type" class="col-sm-3 col-form-label">Loại tài khoản <span class="text-danger">*</span></label>
            <div class="col-sm-9">
              <select class="form-select" id="type" name="type" required>
                <option value="USER" ${formData.type == 'USER' ? 'selected' : ''}>User</option>
                <option value="ADMIN" ${formData.type == 'ADMIN' ? 'selected' : ''}>Admin</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>

          <button type="submit" class="btn btn-primary" id="submitBtn">Thêm Người Dùng</button>
        </div>
      </form>
    </div>
  </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>


<script>
  const userModalEl = document.getElementById('userModal');
  const userModal = new bootstrap.Modal(userModalEl);
  const modalTitle = document.getElementById('userModalLabel');
  const userForm = document.getElementById('userForm');
  const formAction = document.getElementById('formAction');
  const formUserId = document.getElementById('formUserId');
  const passwordInput = document.getElementById('password');
  const passwordRequiredSpan = document.getElementById('passwordRequired');
  const submitBtn = document.getElementById('submitBtn');
  userModalEl.addEventListener('show.bs.modal', event => {
    const button = event.relatedTarget;
    userForm.reset();
    formUserId.value = '';
    passwordInput.required = true;
    passwordRequiredSpan.style.display = 'inline';
    passwordInput.placeholder = 'Nhập mật khẩu (ít nhất 6 ký tự)';
    document.getElementById('username').value = '';
    document.getElementById('email').value = '';
    document.getElementById('phoneNumber').value = '';
    document.getElementById('type').value = 'USER'; // Mặc định là User

    if (button && button.id === 'addUserBtn') {
      modalTitle.textContent = 'Thêm Người Dùng Mới';
      formAction.value = 'save';
      submitBtn.textContent = 'Thêm Người Dùng';
    } else if (button && button.classList.contains('editUserBtn')) {
      const userId = button.getAttribute('data-userid');
      modalTitle.textContent = 'Chỉnh Sửa Người Dùng (ID: ' + userId + ')';
      formAction.value = 'update';
      formUserId.value = userId;
      submitBtn.textContent = 'Lưu Thay Đổi';
      document.getElementById('username').value = button.getAttribute('data-username');
      document.getElementById('email').value = button.getAttribute('data-email');
      document.getElementById('phoneNumber').value = button.getAttribute('data-phonenumber');
      document.getElementById('type').value = button.getAttribute('data-usertype');
      passwordInput.required = false;
      passwordRequiredSpan.style.display = 'none'; // Ẩn dấu *
      passwordInput.placeholder = 'Để trống nếu không muốn thay đổi';
    }
    <c:if test="${not empty formData}">
    console.log("Detected old form data from validation error.");

    // if (formAction.value === 'update' && formUserId.value === '${formData.userId}') {
    document.getElementById('username').value = '<c:out value="${formData.username}"/>';
    document.getElementById('email').value = '<c:out value="${formData.email}"/>';
    document.getElementById('phoneNumber').value = '<c:out value="${formData.phoneNumber}"/>';
    document.getElementById('type').value = '${formData.type}';
    </c:if>

  });


  userModalEl.addEventListener('hidden.bs.modal', event => {

  });

</script>

</body>
</html>