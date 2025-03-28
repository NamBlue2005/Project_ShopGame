<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top shadow-sm"> <%-- Thêm shadow-sm cho đổ bóng nhẹ --%>
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="fas fa-user-shield me-2"></i>Admin Panel
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation"> <%-- Đổi ID target --%>
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="adminNavbar"> <%-- Đổi ID --%>
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <c:set var="currentPath" value="${pageContext.request.servletPath}"/>

          <a class="nav-link <c:if test='${currentPath == "/admin/dashboard"}'>active</c:if>" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-home me-1"></i>Trang chủ
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link <c:if test='${currentPath == "/admin/users"}'>active</c:if>" href="${pageContext.request.contextPath}/admin/users">
            <i class="fas fa-users-cog me-1"></i>Quản lý User
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link <c:if test='${currentPath == "/admin/orders"}'>active</c:if>" href="${pageContext.request.contextPath}/admin/orders">
            <i class="fas fa-shopping-cart me-1"></i>Đơn hàng
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link <c:if test='${currentPath == "/admin/topup-transactions"}'>active</c:if>" href="${pageContext.request.contextPath}/admin/topup-transactions">
            <i class="fas fa-money-check-alt me-1"></i>Giao dịch Nạp
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link <c:if test='${currentPath == "/admin/game-accounts"}'>active</c:if>" href="${pageContext.request.contextPath}/admin/game-accounts">
            <i class="fas fa-gamepad me-1"></i>TK Game
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link <c:if test='${currentPath == "/admin/discounts"}'>active</c:if>" href="${pageContext.request.contextPath}/admin/discounts">
            <i class="fas fa-tags me-1"></i>Giảm giá
          </a>
        </li>

      </ul>

      <ul class="navbar-nav">

        <c:if test="${not empty sessionScope.username}">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownUser" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              <i class="fas fa-user me-1"></i> ${sessionScope.username}
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdownUser">
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">
                <i class="fas fa-user-circle me-2"></i>Thông tin cá nhân
              </a></li>
              <li><a class="dropdown-item" href="#">
                <i class="fas fa-cog me-2"></i>Cài đặt
              </a></li>
              <li><hr class="dropdown-divider"></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/adminLogin?action=logout">
                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
              </a></li>
            </ul>
          </li>
        </c:if>
        <c:if test="${empty sessionScope.username}">
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/adminLogin">
              <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
            </a>
          </li>
        </c:if>
      </ul>
    </div>
  </div>
</nav>
