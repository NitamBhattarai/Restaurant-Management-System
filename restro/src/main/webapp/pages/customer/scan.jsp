<%@ page contentType="text/html;charset=UTF-8" import="com.gokyo.model.*" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Scan & Order"/>
<%@ include file="/pages/errorpages/header.jsp" %>

<%--
  VIEW: customer/scan.jsp
  Controller: CustomerController.java  GET /customer/scan
  Model data: ${tables} - List<DiningTable> from TableDAO via controller
--%>

<nav class="sticky top-0 z-50 h-16 flex items-center justify-between px-6 bg-paper/96 backdrop-blur-md border-b border-black/10">
  <div class="flex items-center gap-4">
    <a href="${pageContext.request.contextPath}/" class="font-serif text-xl font-bold text-ink hover:text-forest transition-colors">Gokyo Bistro</a>
    <a href="${pageContext.request.contextPath}/" class="text-sm text-muted hover:text-ink transition-colors">← Back</a>
  </div>
  <span class="text-xs font-semibold uppercase tracking-widest bg-forest/8 border border-forest/14 text-forest px-3 py-1.5 rounded-full">Guest Portal</span>
</nav>

<div class="min-h-[calc(100vh-64px)] flex items-center justify-center px-4 py-12 bg-paper">
  <div class="w-full max-w-md">
    <div class="bg-white border border-black/10 rounded-2xl overflow-hidden shadow-md">

      <div class="px-8 pt-10 pb-6 text-center border-b border-black/10 bg-paper2">
        <div class="w-16 h-16 rounded-full bg-forest/8 flex items-center justify-center mx-auto mb-5 text-3xl border border-forest/14">📱</div>
        <div class="text-[10px] uppercase tracking-widest font-semibold text-forest mb-2">Scan &amp; Order</div>
        <h1 class="font-serif text-4xl font-normal leading-tight mb-2">Welcome to<br>Gokyo Bistro</h1>
        <p class="text-sm font-light text-muted leading-relaxed">Select your table below. We'll open your menu instantly — no app or account required.</p>
      </div>

      <c:if test="${not empty error}">
        <div class="mx-6 mt-5 bg-red-50 border border-red-200 text-red-800 text-sm px-4 py-3 rounded">
          <c:out value="${error}"/>
        </div>
      </c:if>

      <div class="px-6 py-6">
        <div class="text-[10px] uppercase tracking-widest font-semibold text-muted mb-3">Select your table</div>
        <div class="grid grid-cols-5 gap-2 mb-5">
          <c:forEach items="${tables}" var="t">
            <c:choose>
              <c:when test="${t.status.name() == 'OCCUPIED'}">
                <div class="aspect-square rounded-lg border border-black/10 bg-paper2 flex flex-col items-center justify-center opacity-45 cursor-not-allowed">
                  <span class="text-xs font-semibold text-muted">${t.tableNumber}</span>
                  <span class="text-[8px] uppercase tracking-wide text-muted2 mt-0.5">Taken</span>
                </div>
              </c:when>
              <c:when test="${t.status.name() == 'RESERVED'}">
                <div class="aspect-square rounded-lg border border-amber-300/60 bg-amber-50/40 flex flex-col items-center justify-center opacity-55 cursor-not-allowed">
                  <span class="text-xs font-semibold text-amber-700">${t.tableNumber}</span>
                  <span class="text-[8px] uppercase tracking-wide text-amber-600/70 mt-0.5">Reserved</span>
                </div>
              </c:when>
              <c:otherwise>
                <a href="${pageContext.request.contextPath}/customer/menu?table=${t.qrToken}"
                   class="aspect-square rounded-lg border border-black/16 bg-white flex flex-col items-center justify-center hover:border-forest hover:bg-forest/5 active:scale-95 transition-all cursor-pointer group">
                  <span class="text-xs font-semibold text-ink group-hover:text-forest transition-colors">${t.tableNumber}</span>
                  <span class="text-[8px] uppercase tracking-wide text-muted2 mt-0.5">Free</span>
                </a>
              </c:otherwise>
            </c:choose>
          </c:forEach>
          <c:if test="${empty tables}">
            <div class="col-span-5 py-4 text-center text-sm text-muted font-light">No tables available. Please ask staff for assistance.</div>
          </c:if>
        </div>
        <div class="flex gap-4 text-[10px] text-muted justify-center">
          <span class="flex items-center gap-1.5"><span class="w-2 h-2 rounded border border-forest/30 bg-forest/10 inline-block"></span>Free</span>
          <span class="flex items-center gap-1.5"><span class="w-2 h-2 rounded border border-black/10 bg-paper3 inline-block opacity-50"></span>Occupied</span>
          <span class="flex items-center gap-1.5"><span class="w-2 h-2 rounded border border-amber-300/60 bg-amber-50 inline-block opacity-60"></span>Reserved</span>
        </div>
        <div class="mt-6 text-center">
          <a href="${pageContext.request.contextPath}/customer/reservation"
             class="inline-flex items-center justify-center rounded-full border border-black/10 bg-white px-4 py-2 text-sm font-medium text-ink hover:border-forest hover:text-forest transition-colors">
            Reserve a table in advance
          </a>
        </div>
      </div>

      <div class="px-6 pb-5 text-center text-xs text-muted font-light border-t border-black/8 pt-4">
        Tap a free table to open the digital menu &middot; No login required
      </div>
    </div>
  </div>
</div>
</body>
</html>


