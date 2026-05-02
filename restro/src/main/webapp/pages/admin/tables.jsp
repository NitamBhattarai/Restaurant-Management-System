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
          <button class="inline-flex items-center gap-2 bg-forest text-white px-4 py-2 rounded text-xs font-medium hover:bg-forest-md transition-colors">+ Add Table</button>
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
</body></html>


