<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng nhập - Game Store</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <style>
    html, body {
      height: 100%;
    }
    body {
      display: flex;
      align-items: center; /* Căn giữa dọc */
      justify-content: center; /* Căn giữa ngang */
      background-color: #f0f2f5; /* Màu nền hơi khác */
      padding-top: 40px;  /* Khoảng cách trên */
      padding-bottom: 40px; /* Khoảng cách dưới */
    }
    .login-card {
      max-width: 450px;
      width: 100%;
      border: none; /* Bỏ viền card */
      border-radius: 0.5rem; /* Bo góc nhiều hơn */
    }
    .card-body {
      padding: 2rem; /* Tăng padding */
    }
    .form-floating > label {
      padding-left: 2rem; /* Đẩy label vào trong chút */
    }
    .form-floating > .form-control {
      padding-left: 2rem; /* Đảm bảo text input không bị che */
    }
    .form-floating > .form-control:focus ~ label,
    .form-floating > .form-control:not(:placeholder-shown) ~ label {
      padding-left: 0.75rem; /* Dịch chuyển label khi focus/có chữ */
    }
    .form-floating > .fas { /* Style cho icon trong floating label */
      position: absolute;
      top: 50%;
      left: 0.75rem;
      transform: translateY(-50%);
      color: #6c757d; /* Màu icon xám */
      z-index: 2; /* Đảm bảo icon nổi lên trên */
    }
  </style>
</head>
<body>

<div class="card login-card shadow-lg"> <%-- Đổ bóng rõ hơn --%>
  <div class="card-body p-4 p-lg-5">
    <div class="text-center mb-4">
      <a class="navbar-brand fs-4 fw-bold text-dark" href="${pageContext.request.contextPath}/">
        <i class="fas fa-ghost text-primary me-2"></i>Acc Game Store
      </a>
      <h5 class="text-muted mt-2">Đăng nhập tài khoản của bạn</h5>
    </div>


    <%-- Hiển thị thông báo lỗi nếu có từ URL parameter --%>
    <c:if test="${not empty param.error}">
      <div class="alert alert-danger small py-2 px-3 d-flex align-items-center" role="alert">
        <i class="fas fa-exclamation-triangle me-2"></i>
        <div><c:out value="${param.error}"/></div>
      </div>
    </c:if>

    <%-- Form đăng nhập --%>
    <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
      <%-- Input ẩn để giữ lại thông tin redirect nếu có từ trang trước --%>
      <%-- Servlet sẽ đọc các param này từ URL của GET request và đặt vào request attribute --%>
      <%-- Hoặc JSP đọc trực tiếp từ param như thế này cũng được nếu Servlet không set attribute --%>
      <c:if test="${not empty param.redirect}">
        <input type="hidden" name="redirect" value="<c:out value='${param.redirect}'/>">
      </c:if>
      <c:if test="${not empty param.accountId}">
        <input type="hidden" name="accountId" value="<c:out value='${param.accountId}'/>">
      </c:if>

      <%-- Sử dụng Floating Labels với Icon --%>
      <div class="form-floating mb-3 position-relative">
        <i class="fas fa-user"></i>
        <input type="text" class="form-control" id="username" name="username" placeholder="Tên đăng nhập" required autofocus value="${param.username}"> <%-- Giữ lại username nếu đăng nhập lỗi --%>
        <label for="username">Tên đăng nhập</label>
      </div>
      <div class="form-floating mb-3 position-relative">
        <i class="fas fa-lock"></i>
        <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required>
        <label for="password">Mật khẩu</label>
      </div>

      <div class="d-flex justify-content-between align-items-center mb-3">
        <%-- Checkbox Nhớ mật khẩu (chưa có chức năng) --%>
        <div class="form-check">
          <input class="form-check-input" type="checkbox" value="" id="rememberPasswordCheck">
          <label class="form-check-label small" for="rememberPasswordCheck">
            Nhớ tài khoản
          </label>
        </div>
        <a href="#" class="small text-decoration-none">Quên mật khẩu?</a>
      </div>


      <div class="d-grid mb-3">
        <button class="btn btn-primary btn-lg fw-bold" type="submit">
          <i class="fas fa-sign-in-alt me-2"></i> Đăng nhập
        </button>
      </div>

      <div class="text-center">
        <small class="text-muted">Chưa có tài khoản?</small>
        <a href="${pageContext.request.contextPath}/register" class="ms-1 fw-bold text-decoration-none">Đăng ký ngay!</a>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>