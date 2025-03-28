<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Shop Tài Khoản Game Giá Rẻ</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <style>
    body { background-color: #f8f9fa; display: flex; flex-direction: column; min-height: 100vh;}
    .main-content { flex: 1; padding-bottom: 3rem;}
    .card { transition: transform .2s ease-in-out, box-shadow .2s ease-in-out; border: none; }
    .card:hover { transform: translateY(-5px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.15); }
    .card-img-top { aspect-ratio: 16 / 10; object-fit: cover; background-color: #eee; }
    .price-tag { font-size: 1.2rem; font-weight: bold; color: #dc3545; }
    .info-list { font-size: 0.85rem; color: #555; }
    .info-list .list-group-item { padding: 0.4rem 0; border: none; background: none;}
    .info-list i { color: #888; width: 1.1em; }
    footer { background-color: #343a40; padding: 1rem 0; }
    .navbar .nav-link.active { font-weight: bold; }
    .card-header-button { text-decoration: none; color: inherit; }
    .card-header-button:hover { color: #0d6efd; }
    .form-label-sm { font-size: 0.8rem; margin-bottom: 0.1rem; } /* Label nhỏ cho form search */
  </style>
</head>
<body>
<jsp:include page="navbar_public.jsp"></jsp:include>

<%-- Container chính --%>
<div class="container mt-4 main-content">

  <%-- Form Tìm Kiếm Công Khai - Card có thể thu gọn --%>
  <div class="card shadow-sm mb-4">
    <div class="card-header bg-light">
      <a class="card-header-button d-flex justify-content-between align-items-center"
         data-bs-toggle="collapse" href="#collapsePublicSearch" role="button" aria-expanded="false" aria-controls="collapsePublicSearch">
        <h5 class="mb-0"><i class="fas fa-search me-2"></i>Tìm kiếm Tài khoản</h5>
        <i class="fas fa-chevron-down collapse-icon"></i>
      </a>
    </div>
    <div class="collapse" id="collapsePublicSearch">
      <div class="card-body p-3">
        <form action="${pageContext.request.contextPath}/accounts" method="get">
          <div class="row g-2 align-items-end"> <%-- align-items-end để nút thẳng hàng --%>
            <div class="col-lg-2 col-md-4 col-sm-6">
              <label for="accountId" class="form-label form-label-sm">Mã số TK</label>
              <%-- Hiển thị lại giá trị đã tìm từ request attribute 'searchAccountId' --%>
              <input type="number" class="form-control form-control-sm" id="accountId" name="accountId" placeholder="Nhập ID" value="${searchAccountId}">
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
              <label for="rank" class="form-label form-label-sm">Rank</label>
              <input type="text" class="form-control form-control-sm" id="rank" name="rank" placeholder="Nhập rank..." value="${searchRank}">
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
              <label for="minPrice" class="form-label form-label-sm">Giá từ (₫)</label>
              <input type="number" min="0" step="1000" class="form-control form-control-sm" id="minPrice" name="minPrice" placeholder="VD: 50000" value="${searchMinPrice}">
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
              <label for="maxPrice" class="form-label form-label-sm">Giá đến (₫)</label>
              <input type="number" min="0" step="1000" class="form-control form-control-sm" id="maxPrice" name="maxPrice" placeholder="VD: 200000" value="${searchMaxPrice}">
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
              <label for="minChampions" class="form-label form-label-sm">Tướng từ</label>
              <input type="number" min="0" class="form-control form-control-sm" id="minChampions" name="minChampions" placeholder="Số tướng" value="${searchMinChampions}">
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
              <label for="minSkins" class="form-label form-label-sm">Skin từ</label>
              <input type="number" min="0" class="form-control form-control-sm" id="minSkins" name="minSkins" placeholder="Số skin" value="${searchMinSkins}">
            </div>

            <div class="col-lg-auto col-md-12 ms-auto text-end mt-2 mt-lg-0">
              <button type="submit" class="btn btn-primary btn-sm">
                <i class="fas fa-search me-1"></i> Tìm
              </button>
              <a href="${pageContext.request.contextPath}/accounts" class="btn btn-outline-secondary btn-sm ms-1" title="Xóa bộ lọc">
                <i class="fas fa-times"></i> Reset
              </a>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>

  <h2 class="mb-4 text-center display-6">Danh Sách Tài Khoản</h2>

  <%-- Grid hiển thị card tài khoản --%>
  <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
    <c:choose>
      <c:when test="${not empty accountList}">
        <c:forEach var="account" items="${accountList}">
          <div class="col">
            <div class="card h-100 shadow-sm overflow-hidden">
                <%-- !!! NHỚ THAY URL ẢNH NÀY !!! --%>
              <img src="https://phunugioi.com/wp-content/uploads/2022/07/Anh-Lien-Quan-hinh-nen-Lien-Quan.jpg" class="card-img-top" alt="Tài khoản ${account.gameAccountId}">
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
                      <%-- Nút Mua Ngay với logic kiểm tra đăng nhập --%>
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
        <%-- Hiển thị khi không có tài khoản nào --%>
        <div class="col-12">
          <div class="alert alert-secondary text-center mt-4" role="alert">
            <i class="fas fa-info-circle me-2"></i> Không tìm thấy tài khoản nào phù hợp với tìm kiếm của bạn.
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div> <%-- End row --%>

</div> <%-- End container --%>

<%-- Footer --%>
<footer class="py-3 mt-auto bg-dark text-white-50">
  <div class="container text-center">
    <small>&copy; ${currentYear} Game Store. All Rights Reserved.</small>
  </div>
</footer>
<c:set var="currentYear"><jsp:useBean id="date" class="java.util.Date" /><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%-- Script cho Collapse Search --%>
<script>
  const collapseElement = document.getElementById('collapsePublicSearch'); // Đổi ID nếu cần
  const collapseIcon = document.querySelector('a[href="#collapsePublicSearch"] .collapse-icon');
  if (collapseElement && collapseIcon) {
    collapseElement.addEventListener('show.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up'); });
    collapseElement.addEventListener('hide.bs.collapse', () => { collapseIcon.classList.replace('fa-chevron-up','fa-chevron-down'); });
    // Kiểm tra nếu có tham số tìm kiếm trên URL khi tải trang thì mở sẵn form
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('rank') || urlParams.has('minPrice') || urlParams.has('accountId') /* Thêm các param khác nếu cần */) {
      const bsCollapse = new bootstrap.Collapse(collapseElement, { toggle: false }); // Khởi tạo mà không toggle
      bsCollapse.show(); // Mở nó ra
      // Icon cũng cần đổi nếu mở sẵn
      collapseIcon.classList.replace('fa-chevron-down','fa-chevron-up');
    }
  }
</script>
</body>
</html>