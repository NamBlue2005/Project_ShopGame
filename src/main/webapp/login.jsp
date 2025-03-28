<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập - ShopGame</title>
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

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }
    </style>
</head>
<body>
<div class="form-container">
    <header class="py-3 text-center">
        <h2>Shop Liên Quân</h2>
    </header>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header text-center bg-primary text-white">
                        <h3>Đăng nhập</h3>
                    </div>
                    <div class="card-body">
                        <form action="LoginServlet" method="post">
                            <input type="hidden" name="action" value="login">
                            <div class="mb-3">
                                <label class="form-label">Tên đăng nhập</label>
                                <input type="text" class="form-control" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mật khẩu</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-danger w-100">Đăng nhập</button>
                        </form>
                        <% if ("1".equals(request.getParameter("error"))) { %>
                            <p class="text-danger text-center mt-3">Sai tên đăng nhập hoặc mật khẩu!</p>
                        <% } %>
                    </div>
                </div>
                <p class="text-center mt-3">Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a></p>
            </div>
        </div>
    </div>
    <footer class="py-3 text-center mt-5">
        &copy; 2025 Shop Liên Quân.
    </footer>
</div>
</body>
</html>