<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">

    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .login-container {
            width: 100%;
            max-width: 400px;
            padding: 2rem;
            border-radius: 0.5rem;
            background-color: #fff;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }

        .form-label {
            font-weight: 500;
        }

        .btn-primary {
            background-color: #1a73e8;
            border-color: #1a73e8;
        }

        .btn-primary:hover,
        .btn-primary:focus {
            background-color: #1765cc;
            border-color: #1765cc;
        }

        .error-message {
            color: #dc3545;
            text-align: center;
            margin-top: 1rem;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2 class="text-center mb-4">Admin Login</h2>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
                ${errorMessage}
        </div>
    </c:if>

    <form action="adminLogin" method="post">
        <div class="mb-3">
            <label for="username" class="form-label">Username:</label>
            <input type="text" class="form-control" id="username" name="username" required autocomplete="off" placeholder="Enter your username"> <%-- Thêm autocomplete và placeholder --%>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password:</label>
            <input type="password" class="form-control" id="password" name="password" required autocomplete="off" placeholder="Enter your password"> <%-- Thêm autocomplete và placeholder --%>
        </div>
        <div class="d-grid gap-2">
            <button type="submit" class="btn btn-primary">Login</button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
</body>
</html>