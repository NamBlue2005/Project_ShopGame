<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi"> <%-- Changed lang to vi --%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <%-- Bootstrap CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    <%-- Font Awesome (ensure you have internet or download locally) --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <style>
        body {
            background-color: #f8f9fa; /* Fallback background */
            overflow-x: hidden; /* Prevent horizontal scroll */
            min-height: 100vh;
            position: relative;
        }

        #background-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%; /* Changed to 100% for potential resizing issues */
            background-image: url('https://thuthuatnhanh.com/wp-content/uploads/2020/09/anh-lien-quan-ishar-tieu-thu-gau-truc-scaled.jpg');
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            z-index: -1; /* Behind everything */
        }

        .navbar {
            background-color: rgba(255, 255, 255, 0.9); /* Slightly transparent white navbar */
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
            position: sticky; /* Make navbar sticky */
            top: 0;
            z-index: 1030; /* Ensure navbar is above other content */
        }
        .navbar-brand, .nav-link, .dropdown-toggle {
            color: #333 !important; /* Dark text for readability on light background */
        }
        .dropdown-menu {
            background-color: #fff; /* Solid white dropdown */
        }

        .buttons-container {
            /* Center the button box */
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);

            /* Styling */
            background-color: rgba(255, 255, 255, 0.9);
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            width: 90%; /* Responsive width */
            max-width: 300px; /* Max width for the button box */
            margin-top: 20px; /* Add some margin from navbar if needed */
        }
        /* Adjust button container position for smaller screens if needed */
        @media (max-width: 768px) {
            .buttons-container {
                width: 80%;
                /* Adjust position or styling for mobile */
            }
        }

    </style>
</head>
<body>

<%-- Background Image Container --%>
<div id="background-container"></div>

<%-- Navigation Bar --%>
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container-fluid">
        <%-- Brand/Logo Link --%>
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">Admin Panel</a>

        <%-- Toggler/collapsible Button --%>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <%-- Navbar links --%>
        <div class="collapse navbar-collapse" id="navbarNav">
            <%-- Left side nav items --%>
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="${pageContext.request.contextPath}/admin/dashboard">Home</a>
                </li>
                <%-- Add other nav links here if needed --%>
            </ul>

            <%-- Right side user info and dropdown --%>
            <ul class="navbar-nav">
                <c:if test="${not empty sessionScope.username}"> <%-- Check if user is logged in --%>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownUser" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user me-1"></i> ${sessionScope.username}
                                <%-- Optionally display ID and Type, but might be verbose --%>
                                <%-- (ID: ${sessionScope.userId}, Type: ${sessionScope.userType}) --%>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdownUser">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">
                                <i class="fas fa-user-circle me-2"></i>Profile
                            </a></li>
                            <li><a class="dropdown-item" href="#"> <%-- Add link for settings if implemented --%>
                                <i class="fas fa-cog me-2"></i>Settings
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/adminLogin?action=logout"> <%-- Assumes logout handled by adminLogin servlet/path --%>
                                <i class="fas fa-sign-out-alt me-2"></i>Logout
                            </a></li>
                        </ul>
                    </li>
                </c:if>
                <c:if test="${empty sessionScope.username}"> <%-- Show login link if not logged in --%>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/adminLogin">Login</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<%-- Main Content Area (Button Links) --%>
<div class="container"> <%-- Wrap button container for better alignment potentially --%>
    <div class="buttons-container">
        <h4 class="text-center mb-3">Management</h4> <%-- Added a title --%>
        <div class="d-grid gap-3"> <%-- Increased gap --%>
            <%-- Link to User Management (if applicable) --%>
            <%-- <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary"><i class="fas fa-users me-2"></i>Users</a> --%>

            <%-- Link to Game Account Management --%>
            <a href="${pageContext.request.contextPath}/admin/game-accounts" class="btn btn-primary">
                <i class="fas fa-gamepad me-2"></i>Game Accounts
            </a>

            <%-- Link to Discount Code Management --%>
            <a href="${pageContext.request.contextPath}/admin/discounts" class="btn btn-primary">
                <i class="fas fa-tags me-2"></i>Discount Codes
            </a>

            <%-- Link to Order Management --%>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-primary">
                <i class="fas fa-shopping-cart me-2"></i>Orders
            </a>

            <%-- Link to Top-Up Transaction Management --%>
            <a href="${pageContext.request.contextPath}/admin/topup-transactions" class="btn btn-primary">
                <i class="fas fa-money-check-alt me-2"></i>Top-Up Transactions
            </a>
        </div>
    </div>
</div>


<%-- Bootstrap Bundle JS (includes Popper) --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
<%-- Font Awesome JS (optional, if you need JS features) --%>
<%-- <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js" integrity="sha512-..." crossorigin="anonymous"></script> --%>

</body>
</html>