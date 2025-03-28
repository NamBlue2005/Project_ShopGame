<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng ký tài khoản - Game Store</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <style>
    html, body {
      height: 100%;
    }
    body {
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #f0f2f5;
      padding-top: 40px;
      padding-bottom: 40px;
    }
    .register-card {
      max-width: 550px; /* Rộng hơn chút cho nhiều trường hơn */
      width: 100%;
      border: none;
      border-radius: 0.5rem;
    }
    .card-body {
      padding: 2rem;
    }
    .form-floating > label { padding-left: 2rem; }
    .form-floating > .form-control { padding-left: 2rem; }
    .form-floating > .form-control:focus ~ label,
    .form-floating > .form-control:not(:placeholder-shown) ~ label { padding-left: 0.75rem; }
    .form-floating > .fas { position: absolute; top: 50%; left: 0.75rem; transform: translateY(-50%); color: #6c757d; z-index: 2; }
    .validation-error-list { padding-left: 1.5rem; margin-bottom: 0; font-size: 0.9em; }
  </style>
</head>
<body>

<div class="card register-card shadow-lg">
  <div class="card-body p-4 p-lg-5">
    <div class="text-center mb-4">
      <a class="navbar-brand fs-4 fw-bold text-dark" href="${pageContext.request.contextPath}/">
        <i class="fas fa-ghost text-primary me-2"></i>Acc Game Store
      </a>
      <h5 class="text-muted mt-2">Tạo tài khoản mới</h5>
    </div>

    <%-- Hiển thị lỗi chung nếu có (từ errorMessage) --%>
    <c:if test="${not empty errorMessage}">
      <div class="alert alert-danger small py-2 px-3" role="alert">
        <i class="fas fa-times-circle me-1"></i> ${errorMessage}
      </div>
    </c:if>

    <%-- Hiển thị danh sách lỗi validation nếu có (từ errors) --%>
    <c:if test="${not empty errors}">
      <div class="alert alert-warning small py-2 px-3" role="alert">
        <strong class="d-block mb-1"><i class="fas fa-exclamation-triangle me-1"></i> Vui lòng sửa các lỗi sau:</strong>
        <ul class="mb-0 validation-error-list">
          <c:forEach var="errMsg" items="${errors}">
            <li>${errMsg}</li>
          </c:forEach>
        </ul>
      </div>
    </c:if>

    <%-- Form đăng ký --%>
    <form action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
      <%-- Các trường input sử dụng floating label và icon --%>
      <%-- Giữ lại giá trị cũ nếu có lỗi validation (trừ password) --%>
      <div class="form-floating mb-3 position-relative">
        <i class="fas fa-user"></i>
        <%-- Dùng requestScope để lấy giá trị từ servlet forward về --%>
        <input type="text" class="form-control" id="username" name="username" placeholder="Tên đăng nhập" required minlength="3" value="<c:out value='${username}'/>" autofocus>
        <label for="username">Tên đăng nhập <span class="text-danger">*</span></label>
      </div>

      <div class="form-floating mb-3 position-relative">
        <i class="fas fa-envelope"></i>
        <input type="email" class="form-control" id="email" name="email" placeholder="Email" required value="<c:out value='${email}'/>">
        <label for="email">Địa chỉ Email <span class="text-danger">*</span></label>
      </div>

      <div class="form-floating mb-3 position-relative">
        <i class="fas fa-phone"></i>
        <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" placeholder="Số điện thoại (tùy chọn)" value="<c:out value='${phoneNumber}'/>">
        <label for="phoneNumber">Số điện thoại</label>
      </div>

      <div class="form-floating mb-3 position-relative">
        <i class="fas fa-lock"></i>
        <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required minlength="6">
        <label for="password">Mật khẩu <span class="text-danger">*</span></label>
        <small class="form-text text-muted">Phải có ít nhất 6 ký tự.</small>
      </div>

      <div class="form-floating mb-3 position-relative">
        <i class="fas fa-check-circle"></i>
        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu" required minlength="6">
        <label for="confirmPassword">Xác nhận mật khẩu <span class="text-danger">*</span></label>
      </div>

      <div class="d-grid mb-3 mt-4">
        <button class="btn btn-success btn-lg fw-bold" type="submit">
          <i class="fas fa-user-plus me-2"></i> Đăng ký
        </button>
      </div>

      <div class="text-center">
        <small class="text-muted">Đã có tài khoản?</small>
        <a href="${pageContext.request.contextPath}/login" class="ms-1 fw-bold text-decoration-none">Đăng nhập ngay!</a>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>