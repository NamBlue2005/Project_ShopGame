<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Profile</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <%-- Thêm CSS tùy chỉnh nếu cần --%>
  <style>
    body { background-color: #f8f9fa; }
    .profile-container {
      max-width: 600px;
      margin: 50px auto;
      padding: 2rem;
      background-color: #fff;
      border-radius: 0.5rem;
      box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
    }
    .profile-field {
      margin-bottom: 1rem;
    }
    .profile-field label {
      font-weight: bold;
      color: #555;
    }
    .profile-field span {
      display: block;
      padding: 0.375rem 0.75rem;
      background-color: #e9ecef; /* Màu nền nhẹ cho dễ nhìn */
      border: 1px solid #ced4da;
      border-radius: 0.25rem;
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
            <li><a class="dropdown-item" href="$/admin/profile">Profile</a></li>
            <li><a class="dropdown-item" href="#">Settings</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/adminLogin">Logout</a></li> <%-- Cũng nên dùng contextPath --%>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>


<div class="container">
  <div class="profile-container">
    <h2 class="text-center mb-4">Admin Profile</h2>

    <c:if test="${not empty errorMessage}">
      <div class="alert alert-danger" role="alert">
        <c:out value="${errorMessage}" />
      </div>
    </c:if>

    <c:if test="${empty errorMessage && not empty userProfile}">
      <div class="profile-field">
        <label>User ID:</label>
        <span><c:out value="${userProfile.userId}" /></span>
      </div>
      <div class="profile-field">
        <label>Username:</label>
        <span><c:out value="${userProfile.username}" /></span>
      </div>
      <div class="profile-field">
        <label>Email:</label>
        <span><c:out value="${userProfile.email}" /></span>
      </div>
      <div class="profile-field">
        <label>Phone Number:</label>
        <span><c:out value="${userProfile.phoneNumber}" /></span>
      </div>
      <div class="profile-field">
        <label>Account Type:</label>
        <span><c:out value="${userProfile.type}" /></span>
      </div>

      <%-- Thêm nút Edit nếu muốn mở rộng chức năng --%>
      <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/admin/edit-profile" class="btn btn-secondary">Edit Profile</a>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">Back to Dashboard</a>
      </div>
    </c:if>

    <c:if test="${empty errorMessage && empty userProfile}">
      <div class="alert alert-warning" role="alert">
        User profile data not found.
      </div>
      <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">Back to Dashboard</a>
      </div>
    </c:if>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>