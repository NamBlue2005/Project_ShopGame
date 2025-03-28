<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <style>
        body {
            background-color: #f8f9fa;
            overflow-x: hidden;
        }

        #background-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100vh;
            background-image: url('https://thuthuatnhanh.com/wp-content/uploads/2020/09/anh-lien-quan-ishar-tieu-thu-gau-truc-scaled.jpg'); /* Ảnh nền duy nhất */
            background-size: cover;
            background-position: center;
            z-index: -1;
        }

        .navbar {
            background-color: #fff; /* Màu nền trắng cho navbar */
            box-shadow: 0 2px 4px rgba(0,0,0,.1); /* Đổ bóng */
            width: 100%;
            z-index: 1000;
        }
        .navbar-brand, .nav-link, .dropdown-toggle {
            color: #333 !important; /* Màu chữ đen (hoặc màu bạn muốn) */
        }
        .dropdown-menu{
            background-color: #fff;
        }

        .buttons-container {
            position: absolute; /* Quan trọng */
            top: 50%;
            left: 20px; /* Khoảng cách từ lề trái */
            transform: translateY(-50%); /* Căn giữa theo chiều dọc */
            background-color: rgba(255, 255, 255, 0.9);
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            /*margin-top: 80px;  Không cần margin-top nữa */
            width: 250px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Admin Panel</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="/admin/dashboard">Home</a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user"></i> ${sessionScope.username} (ID: ${sessionScope.userId}, Type: ${sessionScope.userType})
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="#">Profile</a></li>
                        <li><a class="dropdown-item" href="#">Settings</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="/adminLogin">Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div id="background-container"></div>

<div class="buttons-container">
    <div class="d-grid gap-2">
        <a href="admin/users" class="btn btn-primary" hidden="hidden">Users</a>
        <a href="/admin/game-accounts" class="btn btn-primary">Game Accounts</a>
        <a href="/admin/discounts" class="btn btn-primary">Discount Codes</a>
        <a href="/admin/orders" class="btn btn-primary">Orders</a>
        <a href="/admin/topup-transactions" class="btn btn-primary">Top-Up Transactions</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js" integrity="..." crossorigin="anonymous"></script> <%-- Thay đổi integrity và config nếu cần --%>

</body>
</html>