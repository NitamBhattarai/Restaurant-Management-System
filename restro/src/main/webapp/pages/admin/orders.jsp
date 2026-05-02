<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Orders"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-16 bg-white border-b border-black/10 flex items-center px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Order Management</span>
  </div>
  <div class="p-8">

    <%-- Flash messages from session --%>
    <c:if test="${not empty sessionScope.flashSuccess}">
      <div class="bg-green-50 border border-green-200 text-green-800 text-sm px-4 py-3 rounded mb-5">
        <c:out value="${sessionScope.flashSuccess}"/>
        <c:remove var="flashSuccess" scope="session"/>
      </div>
    </c:if>
    <c:if test="${not empty sessionScope.flashError}">
      <div class="bg-red-50 border border-red-200 text-red-800 text-sm px-4 py-3 rounded mb-5">
        <c:out value="${sessionScope.flashError}"/>
        <c:remove var="flashError" scope="session"/>
      </div>
    </c:if>

    <!-- Filter bar -->
    <div class="flex gap-3 mb-6 flex-wrap">
      <input type="text" id="searchInput" placeholder="Search order ID or table…"
             class="gk-field px-4 py-2 bg-white border border-black/10 rounded text-sm text-ink
                    placeholder-muted2 outline-none w-60" oninput="filterTable()">
      <select id="statusFilter" onchange="filterTable()"
              class="gk-field px-4 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none">
        <option value="">All Status</option>
        <option value="PENDING">Pending</option>
        <option value="PREPARING">Preparing</option>
        <option value="READY">Ready</option>
        <option value="SERVED">Served</option>
        <option value="CANCELLED">Cancelled</option>
      </select>
    </div>

    <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-black/10 flex items-center justify-between">
        <span class="text-[13.5px] font-semibold text-ink">
          All Orders <span class="text-xs font-normal text-muted">${orders.size()} records</span>
        </span>
        <button class="text-xs border border-black/16 text-ink2 px-3 py-1.5 rounded hover:border-forest hover:text-forest transition-all">
          Export CSV
        </button>
      </div>
      <div class="overflow-x-auto">
        <table class="w-full text-[13px]" id="ordersTable">
          <thead>
            <tr class="border-b border-black/10">
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Order ID</th>
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Table</th>
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Waiter</th>
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Time</th>
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Status</th>
              <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${orders}" var="o">
              <tr class="border-b border-black/5 hover:bg-paper transition-colors"
                  data-id="${o.orderCode}" data-table="${o.tableNumber}" data-status="${o.status}">
                <td class="px-4 py-3 font-mono text-[11px] text-muted">${o.orderCode}</td>
                <td class="px-4 py-3 font-semibold text-ink">${o.tableNumber}</td>
                <td class="px-4 py-3 text-xs text-muted">${o.waiterName}</td>
                <td class="px-4 py-3 text-xs text-muted">
                  <%-- orderedAt is LocalDateTime — display as HH:mm from toString() --%>
                  <c:choose>
                    <c:when test="${not empty o.orderedAt}">
                      ${fn:substring(o.orderedAt.toString(), 11, 16)}
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </td>
                <td class="px-4 py-3">
                  <span class="badge badge-${o.status.name().toLowerCase()}">${o.status}</span>
                </td>
                <td class="px-4 py-3">
                  <div class="flex gap-2">
                    <button onclick="viewOrder(${o.id})"
                            class="text-xs border border-black/16 px-3 py-1.5 rounded hover:border-forest hover:text-forest transition-all">
                      View
                    </button>
                    <form method="POST" action="${pageContext.request.contextPath}/admin/orders" style="display:inline">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${o.id}">
                      <select name="status" onchange="this.form.submit()"
                              class="text-xs border border-black/16 px-2 py-1.5 rounded bg-white text-ink outline-none
                                     hover:border-forest transition-all cursor-pointer">
                        <c:forEach items="${['PENDING','PREPARING','READY','SERVED','CANCELLED']}" var="s">
                          <option value="${s}" ${o.status.name() == s ? 'selected' : ''}>${s}</option>
                        </c:forEach>
                      </select>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty orders}">
              <tr><td colspan="6" class="px-4 py-10 text-center text-sm text-muted font-light">No orders found</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- ORDER DETAIL MODAL -->
<div id="orderModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center">
  <div class="bg-white rounded-2xl p-8 max-w-lg w-full mx-4 shadow-xl" id="orderModalContent">
    <div class="flex items-center justify-between mb-6">
      <h3 class="font-serif text-2xl font-normal">Order Details</h3>
      <button onclick="closeModal()" class="text-muted hover:text-ink text-xl">✕</button>
    </div>
    <div id="orderDetailBody" class="text-sm text-muted font-light">Loading…</div>
  </div>
</div>

<script>
  const orderItemsData = {};
  <c:forEach items="${orders}" var="o">
    orderItemsData[${o.id}] = [
      <c:forEach items="${o.items}" var="i">
        { name: '<c:out value="${i.menuItemName}"/>', qty: ${i.quantity}, price: ${i.lineTotal} },
      </c:forEach>
    ];
  </c:forEach>

function filterTable() {
  const search = document.getElementById('searchInput').value.toLowerCase();
  const status = document.getElementById('statusFilter').value;
  document.querySelectorAll('#ordersTable tbody tr[data-id]').forEach(row => {
    const matchSearch = row.dataset.id.toLowerCase().includes(search) ||
                        row.dataset.table.toLowerCase().includes(search);
    const matchStatus = !status || row.dataset.status === status;
    row.style.display = matchSearch && matchStatus ? '' : 'none';
  });
}
function viewOrder(id) {
  document.getElementById('orderModal').classList.remove('hidden');
  const items = orderItemsData[id] || [];
  if (items.length === 0) {
    document.getElementById('orderDetailBody').innerHTML = '<p class="text-center py-4 text-muted">No items found for this order.</p>';
    return;
  }
  let html = '<table class="w-full text-left text-sm mb-4"><thead><tr><th class="border-b border-black/10 pb-2 text-muted uppercase text-[10px] tracking-widest font-semibold">Item</th><th class="border-b border-black/10 pb-2 text-right text-muted uppercase text-[10px] tracking-widest font-semibold">Qty</th><th class="border-b border-black/10 pb-2 text-right text-muted uppercase text-[10px] tracking-widest font-semibold">Total</th></tr></thead><tbody>';
  items.forEach(i => {
     html += `<tr><td class="py-2 text-ink font-medium">${i.name}</td><td class="py-2 text-right text-muted">${i.qty}</td><td class="py-2 text-right text-ink font-medium">Rs ${i.price}</td></tr>`;
  });
  html += '</tbody></table>';
  document.getElementById('orderDetailBody').innerHTML = html;
}
function closeModal() {
  document.getElementById('orderModal').classList.add('hidden');
}
</script>
</body>
</html>


