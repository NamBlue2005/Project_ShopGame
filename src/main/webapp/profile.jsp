<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thông Tin Cá Nhân</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #fff8e1;
    }
    header {
      background: linear-gradient(to right, #ff5722, #ffc107);
      color: white;
    }
    .logo {
      font-size: 1.8rem;
      font-weight: bold;
    }
    .nav-link {
      color: white !important;
    }
    .nav-link:hover {
      color: #ffe082 !important;
    }
    .profile-container {
      max-width: 600px;
      margin: 30px auto;
      background: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }
    .profile-header {
      color: #ff5722;
      border-bottom: 2px solid #ffc107;
      padding-bottom: 10px;
      margin-bottom: 20px;
      text-align: center;
    }
    .profile-detail {
      margin-bottom: 15px;
      padding: 10px;
      background: #fff8e1;
      border-radius: 5px;
      font-size: 1.1rem;
    }
    .detail-label {
      font-weight: bold;
      color: #e64a19;
    }
    .btn-edit {
      background: #ff5722;
      color: white;
      width: 100%;
    }
    .btn-edit:hover {
      background: #e64a19;
    }
    footer {
      background: #e64a19;
      color: white;
      padding: 15px 0;
      margin-top: 30px;
      text-align: center;
    }
  </style>
</head>
<body>

<header class="py-3">
  <div class="container d-flex justify-content-between align-items-center">
    <a href="views/user/home.jsp" class="logo text-decoration-none text-white">🏆 Shop Liên Quân</a>
    <nav>
      <ul class="nav">
        <li class="nav-item"><a href="#" class="nav-link">Nạp Tiền</a></li>
        <li class="nav-item"><a href="#" class="nav-link">Tài Khoản Game</a></li>
      </ul>
    </nav>
  </div>
</header>

<div class="profile-container">
  <h2 class="profile-header">Thông Tin Cá Nhân</h2>

  <div class="profile-detail"><span class="detail-label">👤 Username:</span> <%= session.getAttribute("username") %></div>
  <div class="profile-detail"><span class="detail-label">📧 Email:</span> <%= session.getAttribute("email") %></div>
  <div class="profile-detail"><span class="detail-label">📞 Số Điện Thoại:</span> <%= session.getAttribute("phoneNumber") %></div>
  <div class="profile-detail"><span class="detail-label">🔰 Loại Tài Khoản:</span> <%= session.getAttribute("type") %></div>

  <a href="edit_profile.jsp" class="btn btn-edit mt-3">✏️ Chỉnh Sửa Thông Tin</a>
  <a href="index.jsp" class="btn btn-outline-secondary mt-2 w-100">🏠 Quay Lại Trang Chủ</a>
</div>

<footer>
  <p>&copy; 2025 Shop Liên Quân.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>