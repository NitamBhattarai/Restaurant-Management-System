<%@ page contentType="text/html;charset=UTF-8" import="java.util.*,com.gokyo.model.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Dashboard"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<!-- Main content offset for sidebar -->
<div class="ml-60 flex flex-col min-h-screen bg-paper2">

  <!-- Top bar — same 64px height as site nav -->
  <div class="h-16 bg-white border-b border-black/10 flex items-center justify-between px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Dashboard Overview</span>
    <div class="flex items-center gap-3">
      <span class="text-xs text-muted bg-paper2 border border-black/10 px-3 py-1.5 rounded-full" id="todayDate"></span>
      <div class="relative w-8 h-8 rounded border border-black/10 bg-white flex items-center justify-center cursor-pointer hover:bg-paper transition-colors">
        🔔<div class="absolute top-1.5 right-1.5 w-1.5 h-1.5 rounded-full bg-orange-400 border border-white"></div>
      </div>
    </div>
  </div>

  <div class="p-8">

    <!-- Flash messages -->
    <c:if test="${not empty sessionScope.flashSuccess}">
      <div class="bg-green-50 border border-green-200 text-green-800 text-sm px-4 py-3 rounded mb-6">
        <c:out value="${sessionScope.flashSuccess}"/>
        <c:remove var="flashSuccess" scope="session"/>
      </div>
    </c:if>

    <!-- Pre-compute counts once — MVC: data prepared by controller, refined here -->
    <c:set var="occupiedCount" value="0"/>
    <c:forEach items="${tables}" var="t">
      <c:if test="${t.status.name() == 'OCCUPIED'}">
        <c:set var="occupiedCount" value="${occupiedCount + 1}"/>
      </c:if>
    </c:forEach>

    <!-- STAT CARDS -->
    <div class="grid grid-cols-4 gap-4 mb-8">
      <div class="bg-white border border-black/10 rounded-xl p-5 relative overflow-hidden hover:shadow-md transition-shadow">
        <div class="absolute top-0 left-0 right-0 h-[3px] bg-forest"></div>
        <div class="text-[10px] uppercase tracking-widest font-semibold text-muted mb-3">Today's Revenue</div>
        <div class="font-serif text-3xl font-normal text-forest mb-1">
          Rs <fmt:formatNumber value="${todayRevenue}" pattern="#,##0.00"/>
        </div>
        <div class="text-[11.5px] text-muted font-light">Live total from paid orders</div>
      </div>
      <div class="bg-white border border-black/10 rounded-xl p-5 relative overflow-hidden hover:shadow-md transition-shadow">
        <div class="absolute top-0 left-0 right-0 h-[3px] bg-orange-400"></div>
        <div class="text-[10px] uppercase tracking-widest font-semibold text-muted mb-3">Orders Today</div>
        <div class="font-serif text-3xl font-normal text-ink mb-1">${todayOrders}</div>
        <div class="text-[11.5px] text-muted font-light">All statuses combined</div>
      </div>
      <div class="bg-white border border-black/10 rounded-xl p-5 relative overflow-hidden hover:shadow-md transition-shadow">
        <div class="absolute top-0 left-0 right-0 h-[3px] bg-gold"></div>
        <div class="text-[10px] uppercase tracking-widest font-semibold text-muted mb-3">Tables Active</div>
        <div class="font-serif text-3xl font-normal text-ink mb-1">
          ${occupiedCount} <span class="text-xl text-muted">/ ${tables.size()}</span>
        </div>
        <div class="text-[11.5px] text-muted font-light">
          <fmt:formatNumber value="${occupiedCount * 100 / (tables.size() > 0 ? tables.size() : 1)}" maxFractionDigits="0"/>% occupancy
        </div>
      </div>
      <div class="bg-white border border-black/10 rounded-xl p-5 relative overflow-hidden hover:shadow-md transition-shadow">
        <div class="absolute top-0 left-0 right-0 h-[3px] bg-red-500"></div>
        <div class="text-[10px] uppercase tracking-widest font-semibold text-muted mb-3">Pending Orders</div>
        <div class="font-serif text-3xl font-normal text-ink mb-1">${pendingCount}</div>
        <div class="text-[11.5px] font-light ${pendingCount > 0 ? 'text-red-600' : 'text-muted'}">
          <c:choose>
            <c:when test="${pendingCount > 0}">Needs attention</c:when>
            <c:otherwise>All clear</c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <!-- LIVE ORDERS + TOP DISHES -->
    <div class="grid grid-cols-3 gap-6 mb-6">
      <!-- Live orders table (col-span-2) -->
      <div class="col-span-2 bg-white border border-black/10 rounded-xl overflow-hidden">
        <div class="px-6 py-4 border-b border-black/10 flex items-center justify-between">
          <span class="text-[13.5px] font-semibold text-ink">Live Orders</span>
          <a href="${pageContext.request.contextPath}/admin/orders"
             class="text-xs border border-black/16 text-ink2 px-3 py-1.5 rounded hover:border-forest hover:text-forest transition-all">
            View All
          </a>
        </div>
        <table class="w-full text-[13px]">
          <thead>
            <tr class="border-b border-black/10">
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">ID</th>
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Table</th>
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Waiter</th>
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Status</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${orders}" var="o" end="6">
              <tr class="border-b border-black/5 hover:bg-paper transition-colors">
                <td class="px-4 py-3 font-mono text-[11px] text-muted">${o.orderCode}</td>
                <td class="px-4 py-3 font-semibold text-ink">${o.tableNumber}</td>
                <td class="px-4 py-3 text-xs text-muted">${o.waiterName}</td>
                <td class="px-4 py-3">
                  <span class="badge badge-${o.status.name().toLowerCase()}">${o.status}</span>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty orders}">
              <tr><td colspan="4" class="px-4 py-8 text-center text-sm text-muted font-light">No active orders</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>

      <!-- Kitchen activity + quick stats -->
      <div class="flex flex-col gap-4">
        <div class="bg-white border border-black/10 rounded-xl overflow-hidden flex-1">
          <div class="px-5 py-4 border-b border-black/10">
            <span class="text-[13.5px] font-semibold text-ink">Kitchen Now</span>
          </div>
          <div class="p-4 space-y-3">
            <c:forEach items="${orders}" var="o" end="3">
              <div class="bg-paper border border-black/10 rounded-lg p-3
                          ${o.status.name() == 'PENDING' ? 'border-l-2 border-l-red-400' :
                            o.status.name() == 'PREPARING' ? 'border-l-2 border-l-orange-400' : ''}">
                <div class="flex justify-between items-center mb-1">
                  <span class="font-serif text-base font-medium">${o.tableNumber}</span>
                  <span class="badge badge-${o.status.name().toLowerCase()}">${o.status}</span>
                </div>
                <div class="text-xs text-muted font-light">${o.orderCode}</div>
              </div>
            </c:forEach>
            <c:if test="${empty orders}">
              <p class="text-sm text-muted font-light text-center py-4">Kitchen is clear</p>
            </c:if>
          </div>
        </div>
      </div>
    </div>

    <!-- TABLE MAP -->
    <c:set var="freeCount"     value="0"/>
    <c:set var="reservedCount" value="0"/>
    <c:forEach items="${tables}" var="t">
      <c:if test="${t.status.name() == 'FREE'}">    <c:set var="freeCount"     value="${freeCount + 1}"/></c:if>
      <c:if test="${t.status.name() == 'RESERVED'}"><c:set var="reservedCount" value="${reservedCount + 1}"/></c:if>
    </c:forEach>

    <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-black/10 flex items-center justify-between">
        <span class="text-[13.5px] font-semibold text-ink">Table Status</span>
        <div class="flex gap-4 text-xs">
          <span class="text-green-600">● Free (${freeCount})</span>
          <span class="text-red-600">● Occupied (${occupiedCount})</span>
          <span class="text-amber-600">● Reserved (${reservedCount})</span>
        </div>
      </div>
      <div class="p-5 grid grid-cols-5 gap-2">
        <c:forEach items="${tables}" var="t">
          <a href="${pageContext.request.contextPath}/admin/tables"
             class="rounded border text-center py-2.5 cursor-pointer transition-all hover:-translate-y-0.5 block
                    ${t.status.name() == 'FREE'     ? 'border-green-300/60 bg-green-500/4' :
                      t.status.name() == 'OCCUPIED' ? 'border-red-300/50 bg-red-500/4' :
                                                      'border-amber-300/60 bg-amber-500/4'}">
            <div class="font-serif text-lg font-medium
                        ${t.status.name() == 'FREE'     ? 'text-green-700' :
                          t.status.name() == 'OCCUPIED' ? 'text-red-700' : 'text-amber-700'}">
              ${t.tableNumber}
            </div>
            <div class="text-[9px] uppercase tracking-widest text-muted mt-0.5">${t.status}</div>
          </a>
        </c:forEach>
      </div>
    </div>

  </div>
</div>

<script>
document.getElementById('todayDate').textContent =
  new Date().toLocaleDateString('en-NP',{weekday:'short',day:'numeric',month:'short',year:'numeric'});
</script>
</body>
</html>


