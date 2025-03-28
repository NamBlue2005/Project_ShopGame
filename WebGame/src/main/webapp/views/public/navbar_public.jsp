<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- ======================================================= --%>
<%-- NAVBAR DÀNH CHO TRANG PUBLIC & USER THƯỜNG            --%>
<%-- ======================================================= --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fas fa-ghost me-2"></i>Acc Game Store
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#publicNavbar" aria-controls="publicNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="publicNavbar">
            <%-- Menu chính công khai --%>
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <c:set var="currentPath" value="${pageContext.request.servletPath}"/>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath == "/accounts" or currentPath == "/"}'>active fw-bold</c:if>" href="${pageContext.request.contextPath}/accounts">
                        <i class="fas fa-server me-1"></i> Tài khoản Game
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"> <%-- Link đến trang nạp tiền nếu có --%>
                        <i class="fas fa-dollar-sign me-1"></i>Nạp tiền
                    </a>
                </li>
                <%-- Thêm link công khai khác nếu cần --%>
            </ul>

            <%-- Menu User bên phải --%>
            <ul class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${not empty sessionScope.username}">
                        <%-- Đã đăng nhập --%>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarUserDropdownPublic" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle me-1"></i> ${sessionScope.username}
                                    <%-- Không hiển thị badge Admin ở đây --%>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarUserDropdownPublic">
                                    <%-- Link đến trang Profile user thường --%>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-id-card me-2"></i>Thông tin cá nhân
                                </a></li>
                                <li><a class="dropdown-item" href="#"><i class="fas fa-history me-2"></i>Lịch sử mua</a></li>
                                <li><hr class="dropdown-divider"></li>
                                    <%-- Link logout chung --%>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"> <%-- Giả sử có /logout servlet --%>
                                    <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                </a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <%-- Chưa đăng nhập --%>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt me-1"></i> Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-outline-warning btn-sm ms-2" href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus me-1"></i> Đăng ký</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
<%-- ======================================================= --%>