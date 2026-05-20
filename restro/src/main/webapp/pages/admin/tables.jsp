<%-- ═══════════════════════════════════════════ TABLES JSP ═══ --%>
<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Tables"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>
<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-16 bg-white border-b border-black/10 flex items-center px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Table Management</span>
  </div>
  <div class="p-8">
    <!-- Flash messages -->
    <c:if test="${not empty sessionScope.flashError}">
      <div class="bg-red-50 border border-red-200 text-red-800 text-sm px-4 py-3 rounded mb-5">
        <c:out value="${sessionScope.flashError}"/>
        <c:remove var="flashError" scope="session"/>
      </div>
    </c:if>
    <c:if test="${not empty sessionScope.flashSuccess}">
      <div class="bg-green-50 border border-green-200 text-green-800 text-sm px-4 py-3 rounded mb-5">
        <c:out value="${sessionScope.flashSuccess}"/>
        <c:remove var="flashSuccess" scope="session"/>
      </div>
    </c:if>

    <div class="grid grid-cols-2 gap-6">
      <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
        <div class="px-6 py-4 border-b border-black/10 flex items-center justify-between">
          <span class="text-[13.5px] font-semibold text-ink">Table Map</span>
          <button onclick="document.getElementById('addTableModal').classList.remove('hidden')" class="inline-flex items-center gap-2 bg-forest text-white px-4 py-2 rounded text-xs font-medium hover:bg-forest-md transition-colors">+ Add Table</button>
        </div>
        <div class="p-5 grid grid-cols-5 gap-2">
          <c:forEach items="${tables}" var="t">
            <div class="rounded border text-center py-3 cursor-pointer transition-all hover:-translate-y-0.5
                        ${t.status.name() == 'FREE'     ? 'border-green-300/60 bg-green-500/4' :
                          t.status.name() == 'OCCUPIED' ? 'border-red-300/50 bg-red-500/4' :
                                                           'border-amber-300/60 bg-amber-500/4'}">
              <div class="font-serif text-lg font-medium ${t.status.name() == 'FREE' ? 'text-green-700' : t.status.name() == 'OCCUPIED' ? 'text-red-700' : 'text-amber-700'}">
                ${t.tableNumber}
              </div>
              <div class="text-[9px] uppercase tracking-widest text-muted mt-0.5">${t.status}</div>
            </div>
          </c:forEach>
        </div>
        <div class="px-5 pb-4 flex gap-4 text-xs">
          <span class="text-green-700">● Free</span>
          <span class="text-red-700">● Occupied</span>
          <span class="text-amber-700">● Reserved</span>
        </div>
      </div>
      <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
        <div class="px-6 py-4 border-b border-black/10">
          <span class="text-[13.5px] font-semibold text-ink">Table Details</span>
        </div>
        <table class="w-full text-[13px]">
          <thead><tr class="border-b border-black/10">
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Table</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Capacity</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Status</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">QR Code</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Menu Link</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Actions</th>
          </tr></thead>
          <tbody>
            <c:forEach items="${tables}" var="t">
              <tr class="border-b border-black/5 hover:bg-paper transition-colors">
                <td class="px-4 py-3 font-semibold text-ink">${t.tableNumber}</td>
                <td class="px-4 py-3 text-muted">${t.capacity} guests</td>
                <td class="px-4 py-3">
                  <span class="badge ${t.status.name() == 'FREE' ? 'badge-paid' : t.status.name() == 'OCCUPIED' ? 'badge-preparing' : 'badge-pending'}">${t.status}</span>
                </td>
                <td class="px-4 py-3">
                  <div class="flex items-center gap-3">
                    <img src="${pageContext.request.contextPath}/table-qr?token=${t.qrToken}&size=120"
                         alt="QR code for ${t.tableNumber}"
                         class="w-20 h-20 border border-black/10 rounded bg-white p-1 cursor-pointer hover:opacity-80"
                         onclick="showQrModal('${t.tableNumber}', '${t.qrToken}')"
                         title="Click to zoom">
                    <button type="button" onclick="showQrModal('${t.tableNumber}', '${t.qrToken}')" class="text-forest hover:text-forest-md transition-colors" title="View QR Code">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z"></path>
                      </svg>
                    </button>
                  </div>
                  <div class="font-mono text-[10px] text-muted2 mt-2">${t.qrToken}</div>
                </td>
                <td class="px-4 py-3">
                  <a class="text-forest text-xs font-semibold hover:underline"
                     href="${pageContext.request.contextPath}/customer/menu?table=${t.qrToken}"
                     target="_blank" rel="noopener">
                    Open menu
                  </a>
                </td>
                <td class="px-4 py-3">
                  <form method="POST" action="${pageContext.request.contextPath}/admin/tables"
                        onsubmit="return confirm('Are you sure you want to delete table ${t.tableNumber}?');"
                        style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="tableId" value="${t.id}">
                    <button type="submit" class="text-xs bg-red-50 border border-red-200 text-red-700 px-3 py-1.5 rounded hover:bg-red-600 hover:text-white transition-all">
                      Delete
                    </button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<div id="addTableModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center p-4">
  <div class="bg-white rounded-2xl p-8 max-w-sm w-full shadow-xl">
    <div class="flex items-center justify-between mb-6">
      <h3 class="font-serif text-2xl font-normal">Add Table</h3>
      <button onclick="document.getElementById('addTableModal').classList.add('hidden')" class="text-muted hover:text-ink text-xl">✕</button>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/admin/tables">
      <input type="hidden" name="action" value="create">
      <div class="mb-4">
        <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Table Number (e.g. T-10)</label>
        <input type="text" name="tableNumber" required class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none">
      </div>
      <div class="mb-6">
        <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Capacity</label>
        <input type="number" name="capacity" required min="1" max="20" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none">
      </div>
      <div class="flex gap-3 justify-end">
        <button type="button" onclick="document.getElementById('addTableModal').classList.add('hidden')" class="text-sm border border-black/16 px-5 py-2 rounded">Cancel</button>
        <button type="submit" class="text-sm bg-forest text-white px-5 py-2 rounded">Add Table</button>
      </div>
    </form>
  </div>
<!-- QR CODE MODAL -->
<div id="qrModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center p-4">
  <div class="bg-white rounded-2xl p-8 max-w-sm w-full shadow-xl text-center">
    <div class="flex items-center justify-between mb-4 border-b border-black/10 pb-2">
      <h3 id="qrModalTitle" class="font-serif text-xl font-normal text-ink">Table QR Code</h3>
      <button onclick="document.getElementById('qrModal').classList.add('hidden')" class="text-muted hover:text-ink text-xl">✕</button>
    </div>
    <div class="flex flex-col items-center justify-center my-4">
      <img id="qrModalImage" src="" alt="QR code" class="w-64 h-64 border border-black/10 rounded bg-white p-2">
      <div id="qrModalToken" class="font-mono text-sm text-ink font-semibold mt-4 bg-paper px-3 py-1.5 rounded border border-black/5 select-all"></div>
    </div>
    <div class="mt-4">
      <button onclick="document.getElementById('qrModal').classList.add('hidden')" class="text-sm bg-forest text-white px-5 py-2 rounded">Close</button>
    </div>
  </div>
</div>

<script>
  function showQrModal(tableNum, qrToken) {
    document.getElementById('qrModalTitle').innerText = 'Table ' + tableNum + ' QR Code';
    document.getElementById('qrModalImage').src = '${pageContext.request.contextPath}/table-qr?token=' + qrToken + '&size=300';
    document.getElementById('qrModalToken').innerText = qrToken;
    document.getElementById('qrModal').classList.remove('hidden');
  }
</script>
</body></html>

