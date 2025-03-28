<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Shop Tài Khoản Game</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <style>
    body { background-color: #f8f9fa; display: flex; flex-direction: column; min-height: 100vh;}
    .main-content { flex: 1; }
    .card { transition: transform .2s ease-in-out, box-shadow .2s ease-in-out; border: none; }
    .card:hover { transform: translateY(-5px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.15); }
    .card-img-top { aspect-ratio: 16 / 10; object-fit: cover; background-color: #eee; }
    .price-tag { font-size: 1.2rem; font-weight: bold; color: #dc3545; }
    .info-list { font-size: 0.85rem; color: #555; }
    .info-list .list-group-item { padding: 0.4rem 0; border: none; background: none;}
    .info-list i { color: #888; width: 1.1em; }
    footer { background-color: #343a40; padding: 1rem 0; }
    .navbar .nav-link.active { font-weight: bold; }
    .login-prompt { border-left: 5px solid var(--bs-info); } /* Thêm đường viền trái cho đẹp */
  </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/">
      <i class="fas fa-ghost me-2"></i>Acc Game Store
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#publicNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="publicNavbar">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link ${pageContext.request.servletPath == '/accounts' ? 'active' : ''}" href="${pageContext.request.contextPath}/accounts">
            <i class="fas fa-server me-1"></i> Tài khoản Game
          </a>
        </li>
        <li class="nav-item"><a class="nav-link" href="#"> <i class="fas fa-dollar-sign me-1"></i>Nạp tiền</a></li>
      </ul>
      <ul class="navbar-nav ms-auto">
        <%-- Nút Login/User Info (Giữ nguyên) --%>
        <c:choose>
          <c:when test="${not empty sessionScope.username}">...</c:when> <%-- Phần user đã login giữ nguyên --%>
          <c:otherwise>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt me-1"></i> Đăng nhập</a></li>
            <li class="nav-item"><a class="btn btn-outline-warning btn-sm ms-2" href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus me-1"></i> Đăng ký</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<%-- Nội dung chính --%>
<div class="container mt-4 mb-5 main-content">

  <%-- === KHU VỰC MỚI: THÔNG BÁO ĐĂNG NHẬP/ĐĂNG KÝ === --%>
  <c:if test="${empty sessionScope.username}"> <%-- Chỉ hiển thị khi chưa đăng nhập --%>
    <div class="alert alert-info d-flex flex-column flex-sm-row justify-content-between align-items-center mb-4 shadow-sm login-prompt" role="alert">
      <div class="text-center text-sm-start mb-2 mb-sm-0">
        <i class="fas fa-info-circle me-2"></i>
        Bạn cần <a href="${pageContext.request.contextPath}/login" class="alert-link fw-bold">Đăng nhập</a> hoặc <a href="${pageContext.request.contextPath}/register" class="alert-link fw-bold">Đăng ký</a> để có thể mua tài khoản!
      </div>
      <div class="flex-shrink-0">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm me-2">
          <i class="fas fa-sign-in-alt me-1"></i> Đăng nhập
        </a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-success btn-sm">
          <i class="fas fa-user-plus me-1"></i> Đăng ký ngay
        </a>
      </div>
    </div>
  </c:if>
  <%-- ================================================ --%>


  <h2 class="mb-4 text-center display-6">Danh Sách Tài Khoản Game</h2>

  <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
    <%-- Phần hiển thị card tài khoản (Giữ nguyên) --%>
    <c:choose>
      <c:when test="${not empty accountList}">
        <c:forEach var="account" items="${accountList}">
          <div class="col">
            <div class="card h-100 shadow-sm overflow-hidden">
              <img src="https://phunugioi.com/wp-content/uploads/2022/07/Anh-Lien-Quan-hinh-nen-Lien-Quan.jpg" class="card-img-top" alt="Ảnh đại diện tài khoản game">
              <div class="card-body d-flex flex-column">
                <h5 class="card-title text-primary">Mã số: #${account.gameAccountId}</h5>
                <ul class="list-group list-group-flush info-list mb-3 flex-grow-1">
                  <c:if test="${not empty account.gameRank}"><li class="list-group-item"><i class="fas fa-medal"></i>Rank: <strong class="text-dark">${account.gameRank}</strong></li></c:if>
                  <c:if test="${account.numberOfChampions > 0}"><li class="list-group-item"><i class="fas fa-user-shield"></i>Tướng: <strong>${account.numberOfChampions}</strong></li></c:if>
                  <c:if test="${account.numberOfSkins > 0}"><li class="list-group-item"><i class="fas fa-mask"></i>Skin: <strong>${account.numberOfSkins}</strong></li></c:if>
                </ul>
                <div class="mt-auto border-top pt-3">
                  <div class="d-flex justify-content-between align-items-center">
                                        <span class="price-tag">
                                            <fmt:formatNumber value="${account.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </span>
                      <%-- Nút Mua Ngay (Giữ nguyên logic) --%>
                    <c:choose>
                      <c:when test="${not empty sessionScope.username}">
                        <a href="${pageContext.request.contextPath}/purchase?accountId=${account.gameAccountId}" class="btn btn-sm btn-danger">
                          <i class="fas fa-cart-plus me-1"></i> Mua ngay
                        </a>
                      </c:when>
                      <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login?redirect=purchase&accountId=${account.gameAccountId}" class="btn btn-sm btn-danger">
                          <i class="fas fa-cart-plus me-1"></i> Mua ngay
                        </a>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <%-- Thông báo không có tài khoản (Giữ nguyên) --%>
        <div class="col-12">
          <div class="alert alert-secondary text-center mt-4" role="alert">
            <i class="fas fa-info-circle me-2"></i> Hiện chưa có tài khoản nào được mở bán.
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div> <%-- End row --%>

</div> <%-- End container --%>

<%-- Footer (Giữ nguyên) --%>
<footer class="py-3 mt-auto bg-dark text-white-50">
  <div class="container text-center">
    <small>&copy; ${currentYear} Game Store. All Rights Reserved.</small>
  </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>