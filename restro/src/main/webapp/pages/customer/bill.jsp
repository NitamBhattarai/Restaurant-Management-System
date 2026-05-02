<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Your Bill"/>
<%@ include file="/pages/errorpages/header.jsp" %>

<c:choose>
  <c:when test="${not empty table.qrToken}">
    <c:set var="backToMenuUrl" value="${pageContext.request.contextPath}/customer/menu?table=${table.qrToken}"/>
  </c:when>
  <c:otherwise>
    <c:set var="backToMenuUrl" value="${pageContext.request.contextPath}/customer/scan"/>
  </c:otherwise>
</c:choose>

<nav class="sticky top-0 z-50 h-16 flex items-center justify-between px-5 bg-white/96 backdrop-blur-md border-b border-black/10">
  <a href="${pageContext.request.contextPath}/" class="font-serif text-xl font-bold text-ink">Gokyo Bistro</a>
  <a href="${backToMenuUrl}" class="text-sm text-muted hover:text-forest transition-colors">Back to Menu</a>
</nav>

<div class="max-w-lg mx-auto px-4 py-8">
  <div class="bg-white border border-black/10 rounded-2xl overflow-hidden shadow">
    <div class="px-6 py-8 text-center bg-paper2 border-b border-black/10">
      <h1 class="font-serif text-4xl font-normal mb-1">Your Bill</h1>
      <p class="text-sm font-light text-muted">
        ${table.tableNumber}
        <c:if test="${not empty order}">
          · <c:out value="${order.orderCode}"/>
        </c:if>
      </p>
    </div>

    <c:choose>
      <c:when test="${not empty order and not empty order.items}">
        <div class="px-6 py-4">
          <c:forEach items="${order.items}" var="item">
            <div class="flex items-center justify-between py-3 border-b border-black/6 text-sm">
              <span class="flex items-center gap-2">
                <span><c:out value="${item.menuItemEmoji}"/></span>
                <span><c:out value="${item.menuItemName}"/> x<c:out value="${item.quantity}"/></span>
              </span>
              <span class="font-medium">Rs <fmt:formatNumber value="${item.lineTotal}" pattern="#,##0.00"/></span>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="px-6 py-10 text-center text-sm text-muted">
          No active bill is available for this table yet.
        </div>
      </c:otherwise>
    </c:choose>

    <c:if test="${not empty bill}">
      <div class="px-6 py-5 bg-paper2 border-t border-black/10 space-y-2">
        <div class="flex justify-between text-sm text-muted font-light">
          <span>Subtotal</span>
          <span>Rs <fmt:formatNumber value="${bill.subtotal}" pattern="#,##0.00"/></span>
        </div>
        <div class="flex justify-between text-sm text-muted font-light">
          <span>VAT (${bill.vatRate}%)</span>
          <span>Rs <fmt:formatNumber value="${bill.vatAmount}" pattern="#,##0.00"/></span>
        </div>
        <div class="flex justify-between text-sm text-muted font-light">
          <span>Service Charge (${bill.serviceRate}%)</span>
          <span>Rs <fmt:formatNumber value="${bill.serviceAmount}" pattern="#,##0.00"/></span>
        </div>
        <c:if test="${bill.discountPct > 0}">
          <div class="flex justify-between text-sm text-green-700 font-light">
            <span>Discount (${bill.discountPct}%)</span>
            <span>-Rs <fmt:formatNumber value="${bill.discountAmt}" pattern="#,##0.00"/></span>
          </div>
        </c:if>
        <div class="flex justify-between font-semibold border-t border-black/16 pt-4 mt-2">
          <span>Total Amount</span>
          <span class="font-serif text-2xl text-forest">
            Rs <fmt:formatNumber value="${bill.total}" pattern="#,##0.00"/>
          </span>
        </div>
        <p class="text-xs text-muted font-light text-center pt-2">
          Payment will be processed at the counter by your server.
        </p>
      </div>
    </c:if>
  </div>
</div>

<%@ include file="/pages/errorpages/footer.jsp" %>
