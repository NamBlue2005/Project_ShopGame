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
        body { background-color: #f8f9fa; min-height: 100vh; display: flex; flex-direction: column; }
        .navbar .nav-link.active { font-weight: bold; }
        .main-content { flex: 1; padding-top: 1.5rem; padding-bottom: 3rem; }
        .table th, .table td { vertical-align: middle; font-size: 0.9rem; }
        .action-buttons .btn { margin-right: 0.25rem;}
        .card-header-button { text-decoration: none; color: inherit; }
        .card-header-button:hover { color: #0d6efd; }
        footer { background-color: #e9ecef; }
        .badge { min-width: 80px; display: inline-block; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container-xl main-content">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Quản lý Đơn hàng</h2>
    </div>

    <c:if test="${not empty param.message}">
        <div class="alert alert-${not empty param.messageType ? param.messageType : 'info'} alert-dismissible fade show" role="alert">
            <c:out value="${param.message}" />
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>



    <%-- Form tìm kiếm --%>
    <div class="card shadow-sm mb-4">
        <%-- ... code card tìm kiếm ... --%>
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
                            <input type="number" class="form-control form-control-sm" name="orderId" placeholder="ID Đơn hàng" value="${param.orderId}">
                        </div>
                        <div class="col-lg col-md-3 col-sm-6">
                            <input type="number" class="form-control form-control-sm" name="userId" placeholder="ID Người dùng" value="${param.userId}">
                        </div>
                        <div class="col-lg col-md-3 col-sm-6">
                            <input type="number" class="form-control form-control-sm" name="gameAccountId" placeholder="ID Tài khoản Game"  value="${param.gameAccountId}">
                        </div>
                        <div class="col-lg col-md-3 col-sm-6">
                            <select class="form-select form-select-sm" name="orderStatus">
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
    </div>

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
                        <th class="text-center">Hành động</th> <%-- THÊM CỘT NÀY --%>
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
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="HH:mm dd/MM/yy"/></td>
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
                                    <td class="text-end pe-3 fw-bold"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    <td><c:out value="${order.paymentMethod}"/></td>
                                    <td class="text-center">${order.discountId == null ? '-' : order.discountId}</td>
                                        <%-- THÊM NÚT SỬA VÀO ĐÂY --%>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-outline-warning btn-sm"
                                                data-bs-toggle="modal"
                                                data-bs-target="#editOrderStatusModal"
                                                data-order-id="${order.orderId}"
                                                data-current-status="${order.orderStatus}"
                                                title="Cập nhật trạng thái đơn hàng #${order.orderId}">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                            <%-- Có thể thêm nút xem chi tiết nếu muốn --%>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9" class="text-center fst-italic p-4">Không tìm thấy đơn hàng nào phù hợp.</td> <%-- Tăng colspan --%>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div> <%-- End container --%>

<%-- ==================== MODAL SỬA TRẠNG THÁI ======================= --%>
<div class="modal fade" id="editOrderStatusModal" tabindex="-1" aria-labelledby="editOrderStatusModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-sm"> <%-- Modal nhỏ thôi --%>
        <div class="modal-content">
            <%-- Form trỏ đến action mới /admin/orders/updateStatus --%>
            <form id="editOrderStatusForm" action="${pageContext.request.contextPath}/admin/orders/updateStatus" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title" id="editOrderStatusModalLabel">Cập nhật trạng thái</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <%-- Input ẩn chứa ID đơn hàng --%>
                    <input type="hidden" name="orderId" id="editOrderId" value="">

                    <p>Đơn hàng ID: <strong id="displayOrderId"></strong></p>

                    <div class="mb-3">
                        <label for="newOrderStatus" class="form-label">Chọn trạng thái mới:</label>
                        <select class="form-select form-select-sm" id="newOrderStatus" name="newOrderStatus" required>
                            <option value="pending">Pending</option>
                            <option value="completed">Completed</option>
                            <option value="cancelled">Cancelled</option>
                            <%-- Có thể thêm các trạng thái khác nếu cần --%>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary btn-sm">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%-- ==================== HẾT MODAL ======================= --%>


<%-- Footer --%>
<footer class="py-3 mt-auto bg-light">
    <div class="container text-center">
        <small class="text-muted">&copy; ${currentYear} Game Store Admin Panel. All Rights Reserved.</small>
    </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%-- Script cho Collapse Search (Giữ nguyên) --%>
<script>
    const collapseElement = document.getElementById('collapseSearch');
    const collapseIcon = document.querySelector('a[href="#collapseSearch"] .collapse-icon');
    if (collapseElement && collapseIcon) { /* ... code collapse ... */ }
    if (collapseElement && collapseIcon) {
        collapseElement.addEventListener('show.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); });
        collapseElement.addEventListener('hide.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-up','fa-chevron-down'); });
        if (collapseElement.classList.contains('show')) { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); }
    }
</script>
<%-- Script cho Modal Sửa Status --%>
<script>
    const editStatusModal = document.getElementById('editOrderStatusModal');
    if (editStatusModal) {
        editStatusModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget; // Button "Sửa" đã được click

            // Lấy dữ liệu từ thuộc tính data-* của button
            const orderId = button.getAttribute('data-order-id');
            const currentStatus = button.getAttribute('data-current-status');

            // Tìm các element trong modal
            const modalOrderIdInput = editStatusModal.querySelector('#editOrderId');
            const modalDisplayOrderId = editStatusModal.querySelector('#displayOrderId');
            const modalStatusSelect = editStatusModal.querySelector('#newOrderStatus');

            // Điền dữ liệu vào modal
            modalOrderIdInput.value = orderId;          // Set giá trị cho input ẩn
            modalDisplayOrderId.textContent = orderId; // Hiển thị ID cho admin xem
            modalStatusSelect.value = currentStatus;   // Chọn sẵn trạng thái hiện tại trong dropdown
        });
    }
</script>
</body>
</html>