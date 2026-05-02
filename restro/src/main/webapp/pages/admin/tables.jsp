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
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">QR Token</th>
          </tr></thead>
          <tbody>
            <c:forEach items="${tables}" var="t">
              <tr class="border-b border-black/5 hover:bg-paper transition-colors">
                <td class="px-4 py-3 font-semibold text-ink">${t.tableNumber}</td>
                <td class="px-4 py-3 text-muted">${t.capacity} guests</td>
                <td class="px-4 py-3">
                  <span class="badge ${t.status.name() == 'FREE' ? 'badge-paid' : t.status.name() == 'OCCUPIED' ? 'badge-preparing' : 'badge-pending'}">${t.status}</span>
                </td>
                <td class="px-4 py-3 font-mono text-[10px] text-muted2">${t.qrToken}</td>
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
</div>
</body></html>


