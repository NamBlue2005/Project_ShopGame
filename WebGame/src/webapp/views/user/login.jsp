<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #fff8e1; }
        .form-container {
            max-width: 400px;
            margin: auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        header { background: linear-gradient(to right, #ff5722, #ffc107); color: white; }
        footer { background: #e64a19; color: white; }
    </style>
</head>
<body>
<header class="py-3 text-center">
    <h2>Shop Liên Quân</h2>
</header>
<div class="container mt-5">
    <div class="form-container">
        <h3 class="text-center">Đăng Nhập</h3>
        <form action="login" method="POST">
            <div class="mb-3">
                <label class="form-label">Email hoặc Số điện thoại</label>
                <input type="text" class="form-control" name="email" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password" class="form-control" name="password" required>
            </div>
            <button type="submit" class="btn btn-dark w-100">Đăng Nhập</button>
        </form>
        <p class="text-center mt-3">Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a></p>
    </div>
</div>
<footer class="py-3 text-center mt-5">
    <p>&copy; 2025 Shop Liên Quân. All rights reserved.</p>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
