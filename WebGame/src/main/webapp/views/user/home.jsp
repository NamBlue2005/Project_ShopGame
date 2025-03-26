<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop Liên Quân</title>
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

        .card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }

        footer {
            background: #e64a19;
            color: white;
        }
    </style>
</head>
<body>
<header class="py-3">
    <div class="container d-flex justify-content-between align-items-center">
        <a href="home.jsp" class="logo text-decoration-none text-white">Shop Liên Quân</a>
        <nav>
            <ul class="nav">
                <li class="nav-item"><a href="login.jsp" class="nav-link">Đăng Nhập</a></li>
                <li class="nav-item"><a href="register.jsp" class="nav-link">Đăng Ký</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Nạp Tiền</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Tài Khoản Game</a></li>
            </ul>
        </nav>
    </div>
</header>
<section class="py-5">
    <div class="container">
        <h2 class="text-center text-warning mb-4">Danh Sách Tài Khoản Liên Quân</h2>
        <div class="row justify-content-center g-4">
            <div class="col-md-3">
                <div class="card border-0 shadow">
                    <img src="https://via.placeholder.com/150" class="card-img-top" alt="Acc 1">
                    <div class="card-body text-center">
                        <h5 class="card-title">Rank Cao Thủ</h5>
                        <p class="card-text text-danger fw-bold">300,000 VNĐ</p>
                        <button class="btn btn-dark w-100">Mua Ngay</button>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow">
                    <img src="https://via.placeholder.com/150" class="card-img-top" alt="Acc 2">
                    <div class="card-body text-center">
                        <h5 class="card-title">Rank Kim Cương</h5>
                        <p class="card-text text-danger fw-bold">200,000 VNĐ</p>
                        <button class="btn btn-dark w-100">Mua Ngay</button>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow">
                    <img src="https://via.placeholder.com/150" class="card-img-top" alt="Acc 3">
                    <div class="card-body text-center">
                        <h5 class="card-title">Rank Bạch Kim</h5>
                        <p class="card-text text-danger fw-bold">150,000 VNĐ</p>
                        <button class="btn btn-dark w-100">Mua Ngay</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<footer class="py-3 text-center">
    <p>&copy; 2025 Shop Liên Quân. All rights reserved.</p>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
