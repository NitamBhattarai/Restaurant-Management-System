<%@ page contentType="text/html;charset=UTF-8" import="java.util.*,com.gokyo.model.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Billing Central"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-20 bg-white border-b border-black/10 flex items-center justify-between px-8 sticky top-0 z-20">
    <div>
      <div class="text-[10px] uppercase tracking-[0.28em] text-muted font-semibold">Billing Central</div>
      <div class="text-2xl font-serif font-normal text-ink mt-2">Restaurant operations in one view</div>
    </div>
    <div class="flex items-center gap-3">
      <div class="relative">
        <input id="dashboardSearch" type="search" placeholder="Search tables, numbers or status"
               class="gk-field w-80 px-4 py-2 rounded-full border border-black/10 bg-paper text-sm text-ink outline-none focus:border-forest"/>
        <span class="absolute right-3 top-1/2 -translate-y-1/2 text-muted text-sm">🔍</span>
      </div>
      <button onclick="showDashboardMessage('No new notifications yet.')"
              class="w-11 h-11 rounded-full border border-black/10 bg-white flex items-center justify-center text-xl hover:bg-paper transition-colors">🔔</button>
      <button onclick="showDashboardMessage('Settings are available on the Settings page.')"
              class="w-11 h-11 rounded-full border border-black/10 bg-white flex items-center justify-center text-xl hover:bg-paper transition-colors">⚙️</button>
    </div>
  </div>

  <div class="p-8">
    <c:if test="${not empty sessionScope.flashSuccess}">
      <div class="bg-green-50 border border-green-200 text-green-800 text-sm px-4 py-3 rounded mb-6">
        <c:out value="${sessionScope.flashSuccess}"/>
        <c:remove var="flashSuccess" scope="session"/>
      </div>
    </c:if>

    <c:set var="occupiedCount" value="0"/>
    <c:set var="freeCount" value="0"/>
    <c:set var="reservedCount" value="0"/>
    <c:forEach items="${tables}" var="t">
      <c:choose>
        <c:when test="${t.status.name() == 'OCCUPIED'}"><c:set var="occupiedCount" value="${occupiedCount + 1}"/></c:when>
        <c:when test="${t.status.name() == 'FREE'}"><c:set var="freeCount" value="${freeCount + 1}"/></c:when>
        <c:when test="${t.status.name() == 'RESERVED'}"><c:set var="reservedCount" value="${reservedCount + 1}"/></c:when>
      </c:choose>
    </c:forEach>

    <div class="grid grid-cols-4 gap-4 mb-8">
      <div class="bg-white border border-black/10 rounded-3xl p-6 shadow-sm">
        <div class="flex items-center justify-between gap-3 mb-5">
          <span class="text-[10px] uppercase tracking-widest text-muted font-semibold">Active Tables</span>
          <span class="text-xs text-green-700 bg-green-50 border border-green-200 rounded-full px-3 py-1">${occupiedCount}/${tables.size()}</span>
        </div>
        <div class="text-4xl font-serif text-forest">${occupiedCount}</div>
        <div class="text-sm text-muted mt-2">${freeCount} available · ${reservedCount} reserved</div>
      </div>
      <div class="bg-white border border-black/10 rounded-3xl p-6 shadow-sm">
        <div class="flex items-center justify-between gap-3 mb-5">
          <span class="text-[10px] uppercase tracking-widest text-muted font-semibold">Total sales (today)</span>
          <span class="text-xs text-forest bg-forest/10 border border-forest/15 rounded-full px-3 py-1">Live</span>
        </div>
        <div class="text-4xl font-serif text-ink">Rs <fmt:formatNumber value="${todayRevenue}" pattern="#,##0.00"/></div>
        <div class="text-sm text-muted mt-2">${todayOrders} orders processed</div>
      </div>
      <div class="bg-white border border-black/10 rounded-3xl p-6 shadow-sm">
        <div class="flex items-center justify-between gap-3 mb-5">
          <span class="text-[10px] uppercase tracking-widest text-muted font-semibold">Pending bills</span>
          <span class="text-xs text-orange-700 bg-orange-50 border border-orange-200 rounded-full px-3 py-1">${pendingCount}</span>
        </div>
        <div class="text-4xl font-serif text-ink">${pendingCount}</div>
        <div class="text-sm text-muted mt-2">Requires settlement</div>
      </div>
      <div class="bg-white border border-black/10 rounded-3xl p-6 shadow-sm">
        <div class="flex items-center justify-between gap-3 mb-5">
          <span class="text-[10px] uppercase tracking-widest text-muted font-semibold">Server status</span>
          <span class="text-xs text-forest bg-forest/10 border border-forest/15 rounded-full px-3 py-1">Operational</span>
        </div>
        <div class="text-4xl font-serif text-forest">Up</div>
        <div class="text-sm text-muted mt-2">Kitchen and billing running</div>
      </div>
    </div>

    <div class="grid grid-cols-[1.7fr_1.3fr] gap-6 mb-6">
      <div class="bg-white border border-black/10 rounded-3xl overflow-hidden shadow-sm">
        <div class="px-6 py-5 border-b border-black/10 flex items-center justify-between">
          <div>
            <div class="text-[13.5px] font-semibold text-ink">Table Management</div>
            <div class="text-xs text-muted mt-1">Track occupancy and open orders</div>
          </div>
          <a href="${pageContext.request.contextPath}/admin/tables"
             class="text-xs border border-black/16 text-ink2 px-3 py-1.5 rounded hover:border-forest hover:text-forest transition-all">
             Manage Tables
          </a>
        </div>
        <div class="p-5 grid grid-cols-4 gap-3">
          <c:forEach items="${tables}" var="t">
            <div class="table-card rounded-3xl p-4 border transition hover:shadow-md
                        ${t.status.name() == 'FREE'     ? 'border-green-300/60 bg-green-50' :
                          t.status.name() == 'OCCUPIED' ? 'border-red-300/50 bg-red-50' :
                                                          'border-amber-300/60 bg-amber-50'}"
                 data-table="${t.tableNumber}" data-status="${t.status.name()}" data-capacity="${t.capacity}">
              <div class="flex items-center justify-between mb-4">
                <div class="font-serif text-xl font-semibold
                            ${t.status.name() == 'FREE'     ? 'text-green-700' :
                              t.status.name() == 'OCCUPIED' ? 'text-red-700' : 'text-amber-700'}">
                  ${t.tableNumber}
                </div>
                <span class="text-[10px] uppercase tracking-[0.2em] font-semibold ${t.status.name() == 'FREE' ? 'text-green-700' : t.status.name() == 'OCCUPIED' ? 'text-red-700' : 'text-amber-700'}">
                  ${t.status}
                </span>
              </div>
              <div class="text-sm text-muted mb-4">${t.capacity} guests</div>
              <div class="flex flex-col gap-2">
                <c:choose>
                  <c:when test="${t.status.name() == 'FREE'}">
                    <a href="${pageContext.request.contextPath}/admin/orders?table=${t.tableNumber}"
                       class="text-center text-xs bg-white border border-black/10 text-forest px-3 py-2 rounded hover:bg-forest hover:text-white transition-colors">
                      Create Order
                    </a>
                  </c:when>
                  <c:when test="${t.status.name() == 'OCCUPIED'}">
                    <a href="${pageContext.request.contextPath}/admin/billing?table=${t.tableNumber}"
                       class="text-center text-xs bg-forest text-white px-3 py-2 rounded hover:bg-forest-md transition-colors">
                      View Bill
                    </a>
                  </c:when>
                  <c:otherwise>
                    <button class="text-center text-xs border border-black/10 text-ink2 px-3 py-2 rounded bg-paper2 cursor-default">
                      Reserved
                    </button>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>

      <div class="bg-white border border-black/10 rounded-3xl overflow-hidden shadow-sm">
        <div class="px-6 py-5 border-b border-black/10">
          <div class="text-[13.5px] font-semibold text-ink">Order Snapshot</div>
          <div class="text-xs text-muted mt-1">Most recent occupied table</div>
        </div>

        <c:set var="selectedOrder" value="${null}" />
        <c:forEach items="${orders}" var="o" varStatus="status">
          <c:if test="${status.first}">
            <c:set var="selectedOrder" value="${o}" />
          </c:if>
        </c:forEach>

        <c:choose>
          <c:when test="${not empty selectedOrder}">
            <c:set var="orderSubtotal" value="0"/>
            <c:if test="${not empty selectedOrder.items}">
              <c:forEach items="${selectedOrder.items}" var="item">
                <c:set var="orderSubtotal" value="${orderSubtotal + item.lineTotal}"/>
              </c:forEach>
            </c:if>
            <c:set var="serviceCharge" value="${orderSubtotal * 0.10}"/>
            <c:set var="vatAmount" value="${orderSubtotal * 0.13}"/>
            <c:set var="orderTotal" value="${orderSubtotal + serviceCharge + vatAmount}"/>

            <div class="px-6 py-5 space-y-4">
              <div class="flex items-center justify-between">
                <div>
                  <div class="text-xs uppercase tracking-[0.24em] text-muted font-semibold">Table ${selectedOrder.tableNumber}</div>
                  <div class="text-lg font-semibold text-ink mt-1">Order ${selectedOrder.orderCode}</div>
                </div>
                <div class="text-right">
                  <div class="text-[10px] uppercase tracking-[0.24em] text-muted">Date</div>
                  <div class="text-sm text-ink">${fn:substring(selectedOrder.orderedAt.toString(), 0, 10)}</div>
                </div>
              </div>

              <div class="space-y-3">
                <c:if test="${not empty selectedOrder.items}">
                  <c:forEach items="${selectedOrder.items}" var="item">
                    <div class="flex items-center justify-between py-3 border-b border-black/10">
                      <div>
                        <div class="font-medium text-ink">${item.menuItemName}</div>
                        <div class="text-xs text-muted">Qty ${item.quantity}</div>
                      </div>
                      <div class="font-semibold text-ink">Rs <fmt:formatNumber value="${item.lineTotal}" pattern="#,##0.00"/></div>
                    </div>
                  </c:forEach>
                </c:if>
                <c:if test="${empty selectedOrder.items}">
                  <div class="text-sm text-muted">Order details are not available yet.</div>
                </c:if>
              </div>

              <div class="bg-paper2 rounded-3xl p-5">
                <div class="flex justify-between text-sm text-muted mb-2">
                  <span>Subtotal</span>
                  <span>Rs <fmt:formatNumber value="${orderSubtotal}" pattern="#,##0.00"/></span>
                </div>
                <div class="flex justify-between text-sm text-muted mb-2">
                  <span>Service Charge (10%)</span>
                  <span>Rs <fmt:formatNumber value="${serviceCharge}" pattern="#,##0.00"/></span>
                </div>
                <div class="flex justify-between text-sm text-muted mb-2">
                  <span>VAT (13%)</span>
                  <span>Rs <fmt:formatNumber value="${vatAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="flex justify-between text-lg font-semibold text-forest border-t border-black/10 pt-3 mt-3">
                  <span>Total</span>
                  <span>Rs <fmt:formatNumber value="${orderTotal}" pattern="#,##0.00"/></span>
                </div>
              </div>

              <div class="grid grid-cols-2 gap-3">
                <button class="text-sm bg-white border border-black/10 text-ink px-4 py-3 rounded hover:border-forest hover:text-forest transition-all">
                  Print KOT
                </button>
                <button class="text-sm bg-forest text-white px-4 py-3 rounded hover:bg-forest-md transition-colors">
                  Settle Bill
                </button>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <div class="px-6 py-8 text-center text-sm text-muted">
              No active order snapshot available. Use Table Management to open a bill or assign a new order.
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <div class="bg-white border border-black/10 rounded-3xl overflow-hidden">
      <div class="px-6 py-4 border-b border-black/10 flex items-center justify-between">
        <span class="text-[13.5px] font-semibold text-ink">Table Status</span>
        <div class="flex gap-4 text-xs">
          <span class="text-green-700">● Free (${freeCount})</span>
          <span class="text-red-700">● Occupied (${occupiedCount})</span>
          <span class="text-amber-700">● Reserved (${reservedCount})</span>
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
  const dashboardCards = Array.from(document.querySelectorAll('.table-card'));
  const dashboardSearch = document.getElementById('dashboardSearch');
  if (dashboardSearch) {
    dashboardSearch.addEventListener('input', filterDashboard);
  }

  function filterDashboard() {
    const query = dashboardSearch.value.trim().toLowerCase();
    dashboardCards.forEach(card => {
      const table = card.dataset.table?.toLowerCase() || '';
      const status = card.dataset.status?.toLowerCase() || '';
      const capacity = card.dataset.capacity?.toLowerCase() || '';
      const match = !query || table.includes(query) || status.includes(query) || capacity.includes(query);
      card.style.display = match ? '' : 'none';
    });
  }

  function showDashboardMessage(message) {
    window.alert(message);
  }
</script>
</body>
</html>


