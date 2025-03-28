<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin - Quản lý Mã giảm giá</title>
  <%-- Bootstrap CSS --%>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <%-- Font Awesome --%>
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
    .table th, .table td { vertical-align: middle; font-size: 0.9rem; } /* Hơi nhỏ chữ bảng */
    .action-buttons .btn { margin-right: 0.25rem;} /* Khoảng cách nút nhỏ hơn */
    .card-header-button { text-decoration: none; color: inherit; }
    .card-header-button:hover { color: var(--bs-primary); } /* Giữ lại var() ở đây hoặc đổi màu hex #0d6efd */
    footer { background-color: #e9ecef; }
    .form-label { margin-bottom: 0.25rem; font-size: 0.85rem;} /* Label nhỏ hơn */
    .modal-body .form-control, .modal-body .form-select { margin-bottom: 0.75rem; }
    .text-percent { color: #198754; font-weight: bold;} /* Màu cho % */
    .text-currency { color: #dc3545; font-weight: bold;} /* Màu cho tiền tệ */
  </style>
</head>
<body>

<%-- Include Navbar từ file riêng --%>
<jsp:include page="navbar.jsp" />

<div class="container-xl main-content">

  <%-- Tiêu đề trang và nút Thêm --%>
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="mb-0">Quản lý Mã giảm giá</h2>
    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addDiscountModal">
      <i class="fas fa-plus me-1"></i> Thêm Mã Mới
    </button>
  </div>

  <%-- Thông báo (Giữ nguyên logic) --%>
  <c:if test="${not empty message}">
    <div class="alert alert-success alert-dismissible fade show" role="alert"> <%-- Luôn dùng success nếu là message thông thường --%>
        ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${error}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>
  <%-- Hiển thị lỗi validation nếu có --%>
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
        <h5 class="mb-0"><i class="fas fa-search me-2"></i>Bộ lọc / Tìm kiếm Mã</h5>
        <i class="fas fa-chevron-down collapse-icon"></i>
      </a>
    </div>
    <div class="collapse" id="collapseSearch">
      <div class="card-body p-3">
        <form action="${pageContext.request.contextPath}/admin/discounts" method="get">
          <div class="row g-2 align-items-center">
            <div class="col-md-2 col-sm-6">
              <label for="discountId" class="form-label visually-hidden">ID</label>
              <input type="number" class="form-control form-control-sm" id="discountId" name="discountId" placeholder="ID" value="${param.discountId}">
            </div>
            <div class="col-md-3 col-sm-6">
              <label for="code" class="form-label visually-hidden">Mã</label>
              <input type="text" class="form-control form-control-sm" id="code" name="code" placeholder="Mã code" value="${param.code}">
            </div>
            <div class="col-md-2 col-sm-6">
              <label for="discountType" class="form-label visually-hidden">Loại</label>
              <select class="form-select form-select-sm" id="discountType" name="discountType">
                <option value="" ${empty param.discountType ? 'selected' : ''}>-- Loại --</option>
                <option value="percentage" ${param.discountType == 'percentage' ? 'selected' : ''}>Phần trăm</option>
                <option value="fixed" ${param.discountType == 'fixed' ? 'selected' : ''}>Cố định</option>
              </select>
            </div>
            <div class="col-md-2 col-sm-6">
              <label for="validFrom" class="form-label visually-hidden">Từ ngày</label>
              <input type="date" class="form-control form-control-sm" id="validFrom" name="validFrom" title="Có hiệu lực từ" value="${param.validFrom}">
            </div>
            <div class="col-md-2 col-sm-6">
              <label for="validTo" class="form-label visually-hidden">Đến ngày</label>
              <input type="date" class="form-control form-control-sm" id="validTo" name="validTo" title="Có hiệu lực đến" value="${param.validTo}">
            </div>
            <div class="col-md-auto col-sm-6 ms-auto text-end"> <%-- Đẩy nút sang phải --%>
              <button type="submit" class="btn btn-primary btn-sm">
                <i class="fas fa-filter me-1"></i> Lọc
              </button>
              <a href="${pageContext.request.contextPath}/admin/discounts" class="btn btn-outline-secondary btn-sm ms-1" title="Xóa bộ lọc">
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
      <h5 class="mb-0">Danh sách Mã giảm giá</h5>
    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover table-sm mb-0">
          <thead class="table-dark">
          <tr>
            <th>ID</th>
            <th>Mã</th>
            <th>Loại</th>
            <th class="text-end">Giá trị</th>
            <th>Từ</th>
            <th>Đến</th>
            <th class="text-center">Giới hạn</th>
            <th class="text-center">Đã dùng</th>
            <th class="text-center">Hành động</th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty discountCodes}">
              <tr>
                <td colspan="9" class="text-center fst-italic p-4">Không có mã giảm giá nào.</td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="discountCode" items="${discountCodes}">
                <tr>
                  <td>${discountCode.discountId}</td>
                  <td><code><c:out value="${discountCode.code}"/></code></td> <%-- Dùng thẻ code cho mã --%>
                  <td>${discountCode.discountType eq 'percentage' ? 'Phần trăm' : 'Cố định'}</td>
                  <td class="text-end pe-3"> <%-- Căn phải giá trị --%>
                    <c:choose>
                      <c:when test="${discountCode.discountType eq 'percentage'}">
                        <span class="text-percent"><fmt:formatNumber value="${discountCode.discountValue}" type="number" maxFractionDigits="0"/>%</span> <%-- Format số và thêm % --%>
                      </c:when>
                      <c:otherwise>
                        <span class="text-currency"><fmt:formatNumber value="${discountCode.discountValue}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td><fmt:formatDate value="${discountCode.validFrom}" pattern="dd/MM/yy"/></td> <%-- Format ngắn gọn --%>
                  <td><fmt:formatDate value="${discountCode.validTo}" pattern="dd/MM/yy"/></td>
                  <td class="text-center">${discountCode.usageLimit}</td>
                  <td class="text-center">${discountCode.timesUsed}</td>
                  <td class="text-center action-buttons">
                      <%-- Nút Sửa với icon --%>
                    <button type="button" class="btn btn-outline-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editDiscountModal"
                            title="Sửa mã ${discountCode.code}"
                            data-discount-id="${discountCode.discountId}"
                            data-code="${discountCode.code}"
                            data-discount-type="${discountCode.discountType}"
                            data-discount-value="${discountCode.discountValue}"
                            data-valid-from="<fmt:formatDate value='${discountCode.validFrom}' pattern='yyyy-MM-dd' />"
                            data-valid-to="<fmt:formatDate value='${discountCode.validTo}' pattern='yyyy-MM-dd' />"
                            data-usage-limit="${discountCode.usageLimit}"
                            data-times-used="${discountCode.timesUsed}">
                      <i class="fas fa-edit"></i>
                    </button>
                      <%-- Nút Xóa với icon --%>
                    <button type="button" class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteConfirmModal"
                            title="Xóa mã ${discountCode.code}"
                            data-discount-id="${discountCode.discountId}">
                      <i class="fas fa-trash-alt"></i>
                    </button>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
    <%-- Optional: Phân trang --%>
    <%-- <div class="card-footer"> ... </div> --%>
  </div> <%-- End Table Card --%>

</div> <%-- End container --%>


<%-- ================================== MODALS ================================== --%>
<%-- Giữ nguyên cấu trúc và JS xử lý modal của bạn, chỉ thêm class modal-lg --%>

<%-- Add Discount Modal --%>
<div class="modal fade" id="addDiscountModal" tabindex="-1" aria-labelledby="addDiscountModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg"> <%-- Thêm modal-lg --%>
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/admin/discounts/add" method="post"> <%-- Đưa form ra ngoài cùng --%>
        <div class="modal-header">
          <h5 class="modal-title" id="addDiscountModalLabel">Thêm mã giảm giá</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <%-- Sử dụng row/col để căn chỉnh label/input đẹp hơn --%>
          <div class="row mb-3">
            <label for="addCode" class="col-sm-4 col-form-label">Mã giảm giá <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="text" class="form-control form-control-sm" id="addCode" name="code" required>
            </div>
          </div>
          <div class="row mb-3">
            <label for="addDiscountType" class="col-sm-4 col-form-label">Loại giảm giá <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <select class="form-select form-select-sm" id="addDiscountType" name="discountType" required>
                <option value="percentage">Phần trăm (%)</option>
                <option value="fixed">Số tiền cố định (₫)</option>
              </select>
            </div>
          </div>
          <div class="row mb-3">
            <label for="addDiscountValue" class="col-sm-4 col-form-label">Giá trị giảm <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="number" step="any" min="0" class="form-control form-control-sm" id="addDiscountValue" name="discountValue" required placeholder="Nhập số % hoặc số tiền">
              <small class="form-text text-muted">Nếu là %, nhập số (ví dụ: 10 cho 10%). Nếu là tiền, nhập số tiền (ví dụ: 50000).</small>
            </div>
          </div>
          <div class="row mb-3">
            <label for="addValidFrom" class="col-sm-4 col-form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="date" class="form-control form-control-sm" id="addValidFrom" name="validFrom" required>
            </div>
          </div>
          <div class="row mb-3">
            <label for="addValidTo" class="col-sm-4 col-form-label">Ngày kết thúc <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="date" class="form-control form-control-sm" id="addValidTo" name="validTo" required>
            </div>
          </div>
          <div class="row mb-3">
            <label for="addUsageLimit" class="col-sm-4 col-form-label">Giới hạn sử dụng <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="number" min="0" class="form-control form-control-sm" id="addUsageLimit" name="usageLimit" required placeholder="Số lần tối đa có thể dùng">
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Đóng</button>
          <button type="submit" class="btn btn-primary btn-sm">Thêm mã</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%-- Edit Discount Modal --%>
<div class="modal fade" id="editDiscountModal" tabindex="-1" aria-labelledby="editDiscountModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg"> <%-- Thêm modal-lg --%>
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/admin/discounts/update" method="post"> <%-- Đưa form ra ngoài --%>
        <div class="modal-header">
          <h5 class="modal-title" id="editDiscountModalLabel">Sửa mã giảm giá</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="editDiscountId" name="discountId">
          <div class="row mb-3">
            <label for="editCode" class="col-sm-4 col-form-label">Mã giảm giá <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="text" class="form-control form-control-sm" id="editCode" name="code" required>
            </div>
          </div>
          <div class="row mb-3">
            <label for="editDiscountType" class="col-sm-4 col-form-label">Loại giảm giá <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <select class="form-select form-select-sm" id="editDiscountType" name="discountType" required>
                <option value="percentage">Phần trăm (%)</option>
                <option value="fixed">Số tiền cố định (₫)</option>
              </select>
            </div>
          </div>
          <div class="row mb-3">
            <label for="editDiscountValue" class="col-sm-4 col-form-label">Giá trị giảm <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="number" step="any" min="0" class="form-control form-control-sm" id="editDiscountValue" name="discountValue" required>
            </div>
          </div>
          <div class="row mb-3">
            <label for="editValidFrom" class="col-sm-4 col-form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="date" class="form-control form-control-sm" id="editValidFrom" name="validFrom" required>
            </div>
          </div>
          <div class="row mb-3">
            <label for="editValidTo" class="col-sm-4 col-form-label">Ngày kết thúc <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="date" class="form-control form-control-sm" id="editValidTo" name="validTo" required>
            </div>
          </div>
          <div class="row mb-3">
            <label for="editUsageLimit" class="col-sm-4 col-form-label">Giới hạn sử dụng <span class="text-danger">*</span></label>
            <div class="col-sm-8">
              <input type="number" min="0" class="form-control form-control-sm" id="editUsageLimit" name="usageLimit" required>
            </div>
          </div>
          <%-- Không hiển thị trường timesUsed --%>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Đóng</button>
          <button type="submit" class="btn btn-primary btn-sm">Cập nhật</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%-- Delete Confirmation Modal --%>
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="deleteForm" action="${pageContext.request.contextPath}/admin/discounts/delete" method="get"> <%-- Đổi thành POST nếu servlet hỗ trợ --%>
        <div class="modal-header">
          <h5 class="modal-title" id="deleteConfirmModalLabel">Xác nhận xóa</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          Bạn có chắc chắn muốn xóa mã giảm giá có ID: <strong id="deleteDiscountIdDisplay"></strong>?
          <input type="hidden" name="discountId" id="deleteDiscountId" value="">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-danger btn-sm">Xác nhận Xóa</button>
        </div>
      </form>
    </div>
  </div>
</div>

<footer class="py-3 mt-auto">
  <div class="container text-center">
    <small class="text-muted">&copy; ${currentYear} Game Store Admin Panel. All Rights Reserved.</small>
  </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  const collapseElement = document.getElementById('collapseSearch');
  const collapseIcon = document.querySelector('a[href="#collapseSearch"] .collapse-icon');
  if (collapseElement && collapseIcon) {
    collapseElement.addEventListener('show.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); });
    collapseElement.addEventListener('hide.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-up','fa-chevron-down'); });
    if (collapseElement.classList.contains('show')) { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); }
  }
</script>
<script>
  const editDiscountModal = document.getElementById('editDiscountModal')
  if(editDiscountModal){
    editDiscountModal.addEventListener('show.bs.modal', event => {
      const button = event.relatedTarget
      const discountId = button.getAttribute('data-discount-id')
      const code = button.getAttribute('data-code')
      const discountType = button.getAttribute('data-discount-type')
      const discountValue = button.getAttribute('data-discount-value')
      const validFrom = button.getAttribute('data-valid-from')
      const validTo = button.getAttribute('data-valid-to')
      const usageLimit = button.getAttribute('data-usage-limit')
      // Update modal's content.
      document.getElementById('editDiscountId').value = discountId;
      document.getElementById('editCode').value = code
      document.getElementById('editDiscountType').value = discountType;
      document.getElementById('editDiscountValue').value = discountValue;
      document.getElementById('editValidFrom').value = validFrom
      document.getElementById('editValidTo').value = validTo
      document.getElementById('editUsageLimit').value = usageLimit
    })
  }

  //Delete Modal
  const deleteConfirmModal = document.getElementById('deleteConfirmModal');
  if(deleteConfirmModal){
    deleteConfirmModal.addEventListener('show.bs.modal', event => {
      const button = event.relatedTarget;
      const discountId = button.getAttribute('data-discount-id');
      document.getElementById('deleteDiscountId').value = discountId; // Set giá trị cho input ẩn trong form xóa
      document.getElementById('deleteDiscountIdDisplay').textContent = discountId; // Hiển thị ID cho người dùng xem
    })
  }

</script>
</body>
</html>