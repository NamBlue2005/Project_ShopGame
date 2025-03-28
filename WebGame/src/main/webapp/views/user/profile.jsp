<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - Game Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar .nav-link.active { font-weight: bold; }
        .main-content {
            flex: 1;
            padding-top: 1.5rem;
            padding-bottom: 3rem;
        }
        footer { background-color: #e9ecef; } /* Footer màu sáng hơn */
        .profile-card { max-width: 700px; margin: auto; } /* Giới hạn chiều rộng form */
        .form-control:disabled, .form-control[readonly] {
            background-color: #e9ecef; /* Nền xám cho trường chỉ đọc */
            opacity: 1;
        }
        .validation-error-list { padding-left: 1.5rem; margin-bottom: 0; font-size: 0.9em; }
    </style>
</head>
<body>


<jsp:include page="/views/public/navbar_public.jsp" />

<div class="container mt-4 mb-5 main-content">
    <h2 class="text-center mb-4">Thông tin tài khoản</h2>

    <div class="card shadow-sm profile-card">
        <div class="card-header bg-light">
            <h5 class="mb-0">Chi tiết tài khoản</h5>
        </div>
        <div class="card-body p-4">

            <%-- Hiển thị thông báo thành công (từ redirect) --%>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <%-- Hiển thị lỗi chung (từ forward) --%>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger small py-2 px-3" role="alert">
                    <i class="fas fa-times-circle me-1"></i> ${errorMessage}
                </div>
            </c:if>

            <%-- Hiển thị danh sách lỗi validation (từ forward) --%>
            <c:if test="${not empty errors}">
                <div class="alert alert-warning small py-2 px-3" role="alert">
                    <strong class="d-block mb-1"><i class="fas fa-exclamation-triangle me-1"></i> Vui lòng sửa các lỗi sau:</strong>
                    <ul class="mb-0 validation-error-list">
                        <c:forEach var="errMsg" items="${errors}">
                            <li>${errMsg}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>


            <%-- Form hiển thị và sửa thông tin --%>
            <%-- Dữ liệu được lấy từ request attribute "userInfo" do servlet đặt --%>
            <c:if test="${not empty userInfo}">
                <form action="${pageContext.request.contextPath}/profile" method="POST">
                        <%-- User ID (Chỉ hiển thị, không sửa) --%>
                    <div class="row mb-3">
                        <label for="userId" class="col-sm-4 col-form-label">User ID:</label>
                        <div class="col-sm-8">
                            <input type="text" readonly class="form-control-plaintext ps-0" id="userId" value="${userInfo.userId}">
                                <%-- Hoặc dùng input disabled:
                                <input type="text" disabled class="form-control form-control-sm" id="userId" value="${userInfo.userId}">
                                --%>
                        </div>
                    </div>

                        <%-- Username (Chỉ hiển thị, không sửa - nếu muốn sửa cần logic khác) --%>
                    <div class="row mb-3">
                        <label for="username" class="col-sm-4 col-form-label">Tên đăng nhập:</label>
                        <div class="col-sm-8">
                            <input type="text" readonly class="form-control-plaintext ps-0 fw-bold" id="username" value="<c:out value='${userInfo.username}'/>">
                        </div>
                    </div>

                        <%-- Email (Cho phép sửa) --%>
                    <div class="row mb-3">
                        <label for="email" class="col-sm-4 col-form-label">Địa chỉ Email: <span class="text-danger">*</span></label>
                        <div class="col-sm-8">
                                <%-- Giá trị lấy từ userInfo do servlet gửi sang --%>
                            <input type="email" class="form-control form-control-sm" id="email" name="email" value="<c:out value='${userInfo.email}'/>" required>
                        </div>
                    </div>

                        <%-- Số điện thoại (Cho phép sửa) --%>
                    <div class="row mb-3">
                        <label for="phoneNumber" class="col-sm-4 col-form-label">Số điện thoại:</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control form-control-sm" id="phoneNumber" name="phoneNumber" value="<c:out value='${userInfo.phoneNumber}'/>">
                        </div>
                    </div>

                        <%-- Loại tài khoản (Chỉ hiển thị) --%>
                    <div class="row mb-3">
                        <label for="userType" class="col-sm-4 col-form-label">Loại tài khoản:</label>
                        <div class="col-sm-8">
                            <input type="text" readonly class="form-control-plaintext ps-0" id="userType" value="${userInfo.type}">
                        </div>
                    </div>

                    <hr> <%-- Đường kẻ ngang --%>

                    <div class="row mb-3">
                        <div class="col-sm-8 offset-sm-4">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i> Lưu thay đổi
                            </button>
                                <%-- Link đến trang đổi mật khẩu (nếu có) --%>
                                <%-- <a href="${pageContext.request.contextPath}/change-password" class="btn btn-outline-secondary ms-2">Đổi mật khẩu</a> --%>
                        </div>
                    </div>
                </form>
            </c:if>
            <c:if test="${empty userInfo and empty errorMessage}"> <%-- Trường hợp không có thông tin user mà cũng không có lỗi --%>
                <p class="text-center text-muted">Không thể tải thông tin người dùng.</p>
            </c:if>
        </div> <%-- End card-body --%>
    </div> <%-- End card --%>

</div> <%-- End container --%>

<%-- Footer --%>
<footer class="py-3 mt-auto bg-light">
    <div class="container text-center">
        <small class="text-muted">&copy; ${currentYear} Game Store. All Rights Reserved.</small>
    </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>