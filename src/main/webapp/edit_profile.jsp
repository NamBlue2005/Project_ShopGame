<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Hồ Sơ</title>
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
        <a href="index.jsp" class="logo text-decoration-none text-white">Shop Liên Quân</a>
        <nav>
            <ul class="nav">
                <li class="nav-item">
                    <a href="profile.jsp" class="nav-link">Thông Tin</a>
                </li>
                <li class="nav-item">
                    <a href="LogoutServlet" class="nav-link">Đăng Xuất</a>
                </li>
            </ul>
        </nav>
    </div>
</header>

<div class="profile-container">
    <h2 class="profile-header">Chỉnh Sửa Hồ Sơ</h2>

    <% String message = request.getParameter("message"); %>
    <% if (message != null) { %>
    <div class="alert alert-success text-center"><%= message %></div>
    <% } %>

    <form action="ProfileServlet" method="post">
        <div class="profile-detail">
            <label for="email" class="detail-label">📧 Email:</label>
            <input type="email" id="email" name="email" class="form-control" value="<%= session.getAttribute("email") %>" required>
        </div>

        <div class="profile-detail">
            <label for="phoneNumber" class="detail-label">📞 Số Điện Thoại:</label>
            <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" value="<%= session.getAttribute("phoneNumber") %>" required>
        </div>

        <button type="submit" class="btn btn-edit mt-3">💾 Lưu Thay Đổi</button>
        <a href="profile.jsp" class="btn btn-outline-secondary mt-2 w-100">❌ Hủy</a>
    </form>
</div>


<footer>
    <p>&copy; 2025 Shop Liên Quân.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
