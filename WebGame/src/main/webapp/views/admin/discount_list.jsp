<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin - Quản lý mã giảm giá</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <style>
    body { padding-top: 20px; }
    .table th, .table td { vertical-align: middle; }
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
            <li><a class="dropdown-item" href="#">Profile</a></li>
            <li><a class="dropdown-item" href="#">Settings</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="/admin/logout">Logout</a></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>
<div class="container">
  <h1>Quản lý mã giảm giá</h1>

  <%-- Thông báo --%>
  <c:if test="${not empty message}">
    <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
        ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addDiscountModal">
    Thêm mã giảm giá
  </button>

  <div class="card mb-3">
    <div class="card-header">Tìm kiếm</div>
    <div class="card-body">
      <form action="${pageContext.request.contextPath}/admin/discounts" method="get">
        <div class="row g-3">
          <div class="col-md-4">
            <label for="discountId" class="form-label">ID:</label>
            <input type="number" class="form-control" id="discountId" name="discountId" value="${param.discountId}">
          </div>
          <div class="col-md-4">
            <label for="code" class="form-label">Mã:</label>
            <input type="text" class="form-control" id="code" name="code" value="${param.code}">
          </div>
          <div class="col-md-4">
            <label for="discountType" class="form-label">Loại:</label>
            <select class="form-select" id="discountType" name="discountType">
              <option value="" ${empty param.discountType ? 'selected' : ''}>Tất cả</option>
              <option value="percentage" ${param.discountType == 'percentage' ? 'selected' : ''}>Phần trăm</option>
              <option value="fixed" ${param.discountType == 'fixed' ? 'selected' : ''}>Số tiền cố định</option>
            </select>
          </div>
          <div class="col-md-4">
            <label for="validFrom" class="form-label">Có hiệu lực từ:</label>
            <input type="date" class="form-control" id="validFrom" name="validFrom" value="${param.validFrom}">
          </div>
          <div class="col-md-4">
            <label for="validTo" class="form-label">Có hiệu lực đến:</label>
            <input type="date" class="form-control" id="validTo" name="validTo" value="${param.validTo}">
          </div>

          <div class="col-md-12">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            <a href="${pageContext.request.contextPath}/admin/discounts" class="btn btn-secondary">Xóa lọc</a>
          </div>
        </div>
      </form>
    </div>
  </div>


  <table class="table table-striped table-bordered">
    <thead class="table-dark">
    <tr>
      <th>ID</th>
      <th>Mã</th>
      <th>Loại</th>
      <th>Giá trị</th>
      <th>Hiệu lực từ</th>
      <th>Hiệu lực đến</th>
      <th>Giới hạn</th>
      <th>Đã dùng</th>
      <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
      <c:when test="${empty discountCodes}">
        <tr>
          <td colspan="9" class="text-center">Không có mã giảm giá nào.</td>
        </tr>
      </c:when>
      <c:otherwise>
        <c:forEach var="discountCode" items="${discountCodes}">
          <tr>
            <td>${discountCode.discountId}</td>
            <td>${discountCode.code}</td>
            <td>${discountCode.discountType eq 'percentage' ? 'Phần trăm' : 'Số tiền cố định'}</td>
            <td>
              <c:choose>
                <c:when test="${discountCode.discountType eq 'percentage'}">
                  <fmt:formatNumber value="${discountCode.discountValue}" type="percent" maxFractionDigits="0"/>
                </c:when>
                <c:otherwise>
                  <fmt:formatNumber value="${discountCode.discountValue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                </c:otherwise>
              </c:choose>
            </td>
            <td><fmt:formatDate value="${discountCode.validFrom}" pattern="dd/MM/yyyy"/></td>
            <td><fmt:formatDate value="${discountCode.validTo}" pattern="dd/MM/yyyy"/></td>
            <td>${discountCode.usageLimit}</td>
            <td>${discountCode.timesUsed}</td>
            <td>
              <button type="button" class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editDiscountModal"
                      data-discount-id="${discountCode.discountId}"
                      data-code="${discountCode.code}"
                      data-discount-type="${discountCode.discountType}"
                      data-discount-value="${discountCode.discountValue}"
                      data-valid-from="<fmt:formatDate value='${discountCode.validFrom}' pattern='yyyy-MM-dd' />"
                      data-valid-to="<fmt:formatDate value='${discountCode.validTo}' pattern='yyyy-MM-dd' />"
                      data-usage-limit="${discountCode.usageLimit}"
                      data-times-used="${discountCode.timesUsed}">
                Sửa
              </button>

              <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteConfirmModal" data-discount-id="${discountCode.discountId}">
                Xóa
              </button>
            </td>
          </tr>
        </c:forEach>
      </c:otherwise>
    </c:choose>

    </tbody>
  </table>

  <%-- Add Discount Modal --%>
  <div class="modal fade" id="addDiscountModal" tabindex="-1" aria-labelledby="addDiscountModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="addDiscountModalLabel">Thêm mã giảm giá</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form action="${pageContext.request.contextPath}/admin/discounts/add" method="post">
            <div class="mb-3">
              <label for="addCode" class="form-label">Mã giảm giá <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="addCode" name="code" required>
            </div>
            <div class="mb-3">
              <label for="addDiscountType" class="form-label">Loại giảm giá <span class="text-danger">*</span></label>
              <select class="form-select" id="addDiscountType" name="discountType" required>
                <option value="percentage">Phần trăm</option>
                <option value="fixed">Số tiền cố định</option>
              </select>
            </div>
            <div class="mb-3">
              <label for="addDiscountValue" class="form-label">Giá trị giảm <span class="text-danger">*</span></label>
              <input type="number" step="0.01" class="form-control" id="addDiscountValue" name="discountValue" required>
            </div>
            <div class="mb-3">
              <label for="addValidFrom" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
              <input type="date" class="form-control" id="addValidFrom" name="validFrom" required>
            </div>
            <div class="mb-3">
              <label for="addValidTo" class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
              <input type="date" class="form-control" id="addValidTo" name="validTo" required>
            </div>
            <div class="mb-3">
              <label for="addUsageLimit" class="form-label">Giới hạn sử dụng <span class="text-danger">*</span></label>
              <input type="number" class="form-control" id="addUsageLimit" name="usageLimit" required>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
              <button type="submit" class="btn btn-primary">Thêm</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <%-- Edit Discount Modal --%>
  <div class="modal fade" id="editDiscountModal" tabindex="-1" aria-labelledby="editDiscountModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="editDiscountModalLabel">Sửa mã giảm giá</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form action="${pageContext.request.contextPath}/admin/discounts/update" method="post">
            <input type="hidden" id="editDiscountId" name="discountId">
            <div class="mb-3">
              <label for="editCode" class="form-label">Mã giảm giá <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="editCode" name="code" required>
            </div>
            <div class="mb-3">
              <label for="editDiscountType" class="form-label">Loại giảm giá <span class="text-danger">*</span></label>
              <select class="form-select" id="editDiscountType" name="discountType" required>
                <option value="percentage">Phần trăm</option>
                <option value="fixed">Số tiền cố định</option>
              </select>
            </div>
            <div class="mb-3">
              <label for="editDiscountValue" class="form-label">Giá trị giảm <span class="text-danger">*</span></label>
              <input type="number" step="0.01" class="form-control" id="editDiscountValue" name="discountValue" required>
            </div>
            <div class="mb-3">
              <label for="editValidFrom" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
              <input type="date" class="form-control" id="editValidFrom" name="validFrom" required>
            </div>
            <div class="mb-3">
              <label for="editValidTo" class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
              <input type="date" class="form-control" id="editValidTo" name="validTo" required>
            </div>
            <div class="mb-3">
              <label for="editUsageLimit" class="form-label">Giới hạn sử dụng <span class="text-danger">*</span></label>
              <input type="number" class="form-control" id="editUsageLimit" name="usageLimit" required>
            </div>
            <%-- Không hiển thị trường timesUsed --%>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
              <button type="submit" class="btn btn-primary">Cập nhật</button>
            </div>
          </form>
        </div>

      </div>
    </div>
  </div>

  <%-- Delete Confirmation Modal --%>
  <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="deleteConfirmModalLabel">Xác nhận xóa</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          Bạn có chắc chắn muốn xóa mã giảm giá này?
        </div>
        <div class="modal-footer">
          <form action="${pageContext.request.contextPath}/admin/discounts/delete" method="get">
            <input type="hidden" name="discountId" id="deleteDiscountId" value="">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-danger">Xóa</button>
          </form>
        </div>
      </div>
    </div>
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  //Edit modal
  const editDiscountModal = document.getElementById('editDiscountModal')
  if(editDiscountModal){
    editDiscountModal.addEventListener('show.bs.modal', event => {
      //Button that triggered the modal
      const button = event.relatedTarget
      //Extract info from data-bs-* attributes
      const discountId = button.getAttribute('data-discount-id')
      const code = button.getAttribute('data-code')
      const discountType = button.getAttribute('data-discount-type')
      const discountValue = button.getAttribute('data-discount-value')
      const validFrom = button.getAttribute('data-valid-from')
      const validTo = button.getAttribute('data-valid-to')
      const usageLimit = button.getAttribute('data-usage-limit')
      const timeUsed = button.getAttribute('data-times-used')
      //Update modal
      document.getElementById('editDiscountId').value = discountId;
      document.getElementById('editCode').value = code
      document.getElementById('editDiscountType').value = discountType;
      document.getElementById('editDiscountValue').value = discountValue;
      document.getElementById('editValidFrom').value = validFrom
      document.getElementById('editValidTo').value = validTo
      document.getElementById('editUsageLimit').value = usageLimit

    })
  }

  //Delete
  const deleteConfirmModal = document.getElementById('deleteConfirmModal');
  if(deleteConfirmModal){
    deleteConfirmModal.addEventListener('show.bs.modal', event => {
      const button = event.relatedTarget;
      const discountId = button.getAttribute('data-discount-id');
      document.getElementById('deleteDiscountId').value = discountId; // id trong form delete

    })
  }

</script>
</body>
</html>