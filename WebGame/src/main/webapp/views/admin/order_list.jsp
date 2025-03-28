<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Quản lý Đơn hàng</title>
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
        .table th, .table td { vertical-align: middle; font-size: 0.9rem; }
        .action-buttons .btn { margin-right: 0.25rem;}
        .card-header-button { text-decoration: none; color: inherit; }
        .card-header-button:hover { color: #0d6efd; } /* Primary color */
        footer { background-color: #e9ecef; }
        .badge { min-width: 80px; display: inline-block; } /* Rộng hơn chút cho status */
    </style>
</head>
<body>

<%-- Include Navbar từ file riêng --%>
<jsp:include page="navbar.jsp" />

<div class="container-xl main-content">

    <%-- Tiêu đề trang --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Quản lý Đơn hàng</h2>
        <%-- Không có nút Thêm ở đây (theo code gốc) --%>
    </div>

    <%-- Thông báo (Giữ nguyên logic, sửa messageType nếu cần) --%>
    <c:if test="${not empty message}">
        <div class="alert alert-${not empty messageType ? messageType : 'info'} alert-dismissible fade show" role="alert">
            <c:out value="${message}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <c:out value="${error}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <%-- Lỗi validation (nếu có) --%>
    <c:if test="${not empty errors}">
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i><strong>Vui lòng kiểm tra lại thông tin nhập:</strong>
            <ul class="mb-0 mt-2" style="padding-left: 1.5rem;">
                <c:forEach var="errMsg" items="${errors}">
                    <li>${errMsg}</li>
                </c:forEach>
            </ul>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>


    <%-- Form tìm kiếm - Card có thể thu gọn --%>
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-light">
            <a class="card-header-button d-flex justify-content-between align-items-center"
               data-bs-toggle="collapse" href="#collapseSearch" role="button" aria-expanded="false" aria-controls="collapseSearch">
                <h5 class="mb-0"><i class="fas fa-filter me-2"></i>Bộ lọc / Tìm kiếm Đơn hàng</h5>
                <i class="fas fa-chevron-down collapse-icon"></i>
            </a>
        </div>
        <div class="collapse" id="collapseSearch">
            <div class="card-body p-3">
                <form action="${pageContext.request.contextPath}/admin/orders" method="get">
                    <div class="row g-2 align-items-center">
                        <div class="col-lg col-md-3 col-sm-6">
                            <label for="searchOrderId" class="form-label visually-hidden">ID Đơn hàng</label>
                            <input type="number" class="form-control form-control-sm" name="orderId" id="searchOrderId" placeholder="ID Đơn hàng" value="${param.orderId}">
                        </div>
                        <div class="col-lg col-md-3 col-sm-6">
                            <label for="searchUserId" class="form-label visually-hidden">ID User</label>
                            <input type="number" class="form-control form-control-sm" name="userId" id="searchUserId" placeholder="ID Người dùng" value="${param.userId}">
                        </div>
                        <div class="col-lg col-md-3 col-sm-6">
                            <label for="searchGameAccountId" class="form-label visually-hidden">ID Game Acc</label>
                            <input type="number" class="form-control form-control-sm" name="gameAccountId" id="searchGameAccountId" placeholder="ID Tài khoản Game"  value="${param.gameAccountId}">
                        </div>
                        <div class="col-lg col-md-3 col-sm-6">
                            <label for="searchOrderStatus" class="form-label visually-hidden">Trạng thái</label>
                            <select class="form-select form-select-sm" name="orderStatus" id="searchOrderStatus">
                                <option value="" ${empty param.orderStatus ? 'selected' : ''}>-- Trạng thái --</option>
                                <option value="pending" ${param.orderStatus == 'pending' ? 'selected' : ''}>Pending</option>
                                <option value="completed" ${param.orderStatus == 'completed' ? 'selected' : ''}>Completed</option>
                                <option value="cancelled" ${param.orderStatus == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                            </select>
                        </div>
                        <div class="col-lg-auto col-md-12 ms-auto text-end">
                            <button type="submit" class="btn btn-primary btn-sm">
                                <i class="fas fa-search me-1"></i> Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary btn-sm ms-1" title="Xóa bộ lọc">
                                <i class="fas fa-times"></i>
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div> <%-- End Search Card --%>


    <%-- Bảng hiển thị danh sách --%>
    <div class="card shadow-sm">
        <div class="card-header bg-light">
            <h5 class="mb-0">Danh sách Đơn hàng</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover table-sm mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th class="text-center">ID</th>
                        <th class="text-center">User ID</th>
                        <th class="text-center">Game Acc ID</th>
                        <th>Ngày đặt</th>
                        <th class="text-center">Trạng thái</th>
                        <th class="text-end">Tổng tiền</th>
                        <th>PT Thanh toán</th>
                        <th class="text-center">Discount ID</th>
                        <%-- Không có cột Hành động --%>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach items="${orders}" var="order">
                                <tr>
                                    <td class="text-center">${order.orderId}</td>
                                    <td class="text-center">${order.userId}</td>
                                    <td class="text-center">${order.gameAccountId}</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="HH:mm dd/MM/yy"/></td> <%-- Format ngắn gọn --%>
                                    <td class="text-center">
                                        <span class="badge rounded-pill
                                            <c:choose>
                                                <c:when test="${order.orderStatus == 'pending'}">text-bg-warning</c:when>
                                                <c:when test="${order.orderStatus == 'completed'}">text-bg-success</c:when>
                                                <c:when test="${order.orderStatus == 'cancelled'}">text-bg-danger</c:when>
                                                <c:otherwise>text-bg-secondary</c:otherwise>
                                            </c:choose>
                                        ">${order.orderStatus}</span>
                                    </td>
                                    <td class="text-end pe-3 fw-bold"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td> <%-- Thêm fw-bold --%>
                                    <td><c:out value="${order.paymentMethod}"/></td>
                                    <td class="text-center">${order.discountId == null ? '-' : order.discountId}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="text-center fst-italic p-4">Không tìm thấy đơn hàng nào phù hợp.</td> <%-- Colspan = 8 --%>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div> <%-- End card-body --%>
        <%-- Optional: Phân trang --%>
        <%-- <div class="card-footer"> ... </div> --%>
    </div> <%-- End Table Card --%>

</div> <%-- End container --%>


<%-- Footer (Giữ nguyên) --%>
<footer class="py-3 mt-auto bg-light">
    <div class="container text-center">
        <small class="text-muted">&copy; ${currentYear} Game Store Admin Panel. All Rights Reserved.</small>
    </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%-- Script Collapse (Giữ nguyên) --%>
<script>
    const collapseElement = document.getElementById('collapseSearch');
    const collapseIcon = document.querySelector('a[href="#collapseSearch"] .collapse-icon');
    if (collapseElement && collapseIcon) {
        collapseElement.addEventListener('show.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); });
        collapseElement.addEventListener('hide.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-up','fa-chevron-down'); });
        if (collapseElement.classList.contains('show')) { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); }
    }
</script>
</body>
</html>