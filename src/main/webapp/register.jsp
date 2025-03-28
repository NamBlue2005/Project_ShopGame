<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, connect.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #fff8e1;
            font-family: 'Arial', sans-serif;
        }

        .form-container {
            max-width: 400px;
            margin: auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .form-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.25);
        }

        header {
            background: linear-gradient(to right, #ff5722, #ffc107);
            color: white;
        }

        footer {
            background: #e64a19;
            color: white;
        }

        input, select {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<header class="py-3 text-center">
    <h2>Shop Liên Quân</h2>
</header>

<% String error = request.getParameter("error");
   String success = request.getParameter("success");
   if ("failed".equals(error)) { %>
   <p style="color: red;">Đăng ký không thành công. Vui lòng thử lại.</p>
<% } else if ("database".equals(error)) { %>
   <p style="color: red;">Lỗi cơ sở dữ liệu. Vui lòng thử lại sau.</p>
<% } else if ("db_connection_failed".equals(error)) { %>
   <p style="color: red;">Không thể kết nối đến cơ sở dữ liệu. Vui lòng thử lại sau.</p>
<% } else if ("missing_fields".equals(error)) { %>
   <p style="color: red;">Vui lòng điền đầy đủ thông tin.</p>
<% } else if ("true".equals(success)) { %>
   <p style="color: green;">Đăng ký thành công! Vui lòng đăng nhập.</p>
<% } %>

<form action="RegisterServlet" method="post" class="form-container container mt-5">
    <input type="hidden" name="action" value="register">
    Tên đăng nhập: <input type="text" name="username" required class="form-control"><br>
    Email: <input type="email" name="email" required class="form-control"><br>
    Số điện thoại: <input type="text" name="phoneNumber" required class="form-control"><br>
    Mật khẩu: <input type="password" name="password" required class="form-control"><br>
    <input type="submit" value="Đăng ký" class="btn btn-danger w-100">
</form>

<p class="text-center mt-3">Đã có tài khoản? <a href="login.jsp" class="btn btn-success">Đăng nhập ngay</a></p>

<footer class="py-3 text-center mt-5">
    &copy; 2025 ShopGame. All rights reserved.
</footer>
</body>
</html>