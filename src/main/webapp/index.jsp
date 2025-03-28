<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.GameAccount" %>
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
            padding: 10px 0;
            text-align: center;
        }

        .logo {
            font-size: 2rem;
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
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            margin: 10px;
        }

        .card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }

        footer {
            background: #e64a19;
            color: white;
            text-align: center;
            padding: 10px 0;
        }
    </style>
</head>
<body>

<header class="py-3">
    <div class="container d-flex justify-content-between align-items-center">
        <a href="index.jsp" class="logo text-decoration-none text-white">Shop Liên Quân</a>
        <nav>
            <ul class="nav">
                <% if (session.getAttribute("username") == null) { %>
                <li class="nav-item"><a href="login.jsp" class="nav-link">Đăng Nhập</a></li>
                <li class="nav-item"><a href=register.jsp" class="nav-link">Đăng Ký</a></li>
                <% } else { %>
                <li class="nav-item">
                    <a href="#" class="nav-link">Xin chào, <%= session.getAttribute("username") %>!</a>
                </li>
                <li class="nav-item">
                    <a href="profile.jsp" class="nav-link">Thông Tin</a>
                </li>
                <li class="nav-item">
                    <a href="LogoutServlet" class="nav-link">Đăng Xuất</a>
                </li>
                <% } %>
            </ul>
        </nav>
    </div>
</header>


<section class="py-5">
    <div class="container">
        <h2 class="text-center text-warning mb-4">Danh Sách Tài Khoản Liên Quân</h2>
        <div class="row justify-content-center g-4">
            <%
                List<GameAccount> accounts = (List<GameAccount>) request.getAttribute("accounts");
                if (accounts != null && !accounts.isEmpty()) {
                    for (GameAccount acc : accounts) {
            %>
            <div class="col-md-3">
                <div class="card border-0 shadow">
                    <img src="https://via.placeholder.com/150" class="card-img-top" alt="Game Account">
                    <div class="card-body text-center">
                        <h5 class="card-title"><%= acc.getGameRank() %></h5>
                        <form action="PurchaseServlet" method="post">
                            <input type="hidden" name="accountId" value="<%= acc.getGameAccountId() %>">
                            <button type="submit" class="btn btn-dark w-100">Mua Ngay</button>
                        </form>
                    </div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <p class="text-center">Không có tài khoản nào được hiển thị.</p>
            <% } %>
        </div>
    </div>
</section>


<footer>
    <p>&copy; 2025 Shop Liên Quân</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>