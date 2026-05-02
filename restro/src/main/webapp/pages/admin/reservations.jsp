<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Reservations"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>
<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-16 bg-white border-b border-black/10 flex items-center px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Reservations</span>
  </div>
  <div class="p-8">
    <div class="mb-5">
      <button onclick="document.getElementById('addResModal').classList.remove('hidden')"
              class="inline-flex items-center gap-2 bg-forest text-white px-5 py-2 rounded text-sm font-medium hover:bg-forest-md transition-colors">
        + New Reservation
      </button>
    </div>
    <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-black/10">
        <span class="text-[13.5px] font-semibold text-ink">Upcoming Reservations</span>
      </div>
      <table class="w-full text-[13px]">
        <thead><tr class="border-b border-black/10">
          <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Guest Name</th>
          <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Date &amp; Time</th>
          <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Guests</th>
          <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Table</th>
          <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Contact</th>
          <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Status</th>
          <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Actions</th>
        </tr></thead>
        <tbody>
          <c:choose>
            <c:when test="${not empty reservations}">
              <c:forEach items="${reservations}" var="res">
                <tr class="border-b border-black/5 hover:bg-paper transition-colors">
                  <td class="px-4 py-3 font-medium text-ink"><c:out value="${res.guestName}"/></td>
                  <td class="px-4 py-3 text-sm">
                    ${not empty res.reservedAt ? fn:substring(res.reservedAt.toString(),0,16) : "—"}
                  </td>
                  <td class="px-4 py-3">${res.partySize}</td>
                  <td class="px-4 py-3 font-semibold">${not empty res.tableNumber ? res.tableNumber : '—'}</td>
                  <td class="px-4 py-3 text-xs text-muted"><c:out value="${res.guestPhone}"/></td>
                  <td class="px-4 py-3">
                    <span class="badge ${res.status.name() == 'CONFIRMED' ? 'badge-paid' :
                                         res.status.name() == 'PENDING'   ? 'badge-pending' :
                                         res.status.name() == 'CANCELLED' ? 'badge-cancelled' : 'badge-served'}">
                      ${res.status}
                    </span>
                  </td>
                  <td class="px-4 py-3">
                    <div class="flex gap-2">
                      <button class="text-xs border border-black/16 px-3 py-1.5 rounded hover:border-forest hover:text-forest transition-all">Edit</button>
                      <form method="POST" action="${pageContext.request.contextPath}/admin/reservations"
                            onsubmit="return confirm('Cancel this reservation?')" style="display:inline">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="id" value="${res.id}">
                        <button type="submit" class="text-xs bg-red-50 border border-red-200 text-red-700 px-3 py-1.5 rounded hover:bg-red-600 hover:text-white transition-all">Cancel</button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr><td colspan="7" class="px-4 py-10 text-center text-sm text-muted font-light">No upcoming reservations</td></tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- ADD RESERVATION MODAL -->
<div id="addResModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center">
  <div class="bg-white rounded-2xl p-8 max-w-md w-full mx-4 shadow-xl">
    <div class="flex items-center justify-between mb-6">
      <h3 class="font-serif text-2xl font-normal">New Reservation</h3>
      <button onclick="document.getElementById('addResModal').classList.add('hidden')" class="text-muted hover:text-ink text-xl">✕</button>
    </div>
    <div class="mb-4"><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Guest Name</label>
      <input type="text" placeholder="Full name" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none"></div>
    <div class="grid grid-cols-2 gap-4 mb-4">
      <div><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Phone</label>
        <input type="text" placeholder="98XXXXXXXX" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none"></div>
      <div><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Party Size</label>
        <input type="number" placeholder="2" min="1" max="20" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none"></div>
    </div>
    <div class="grid grid-cols-2 gap-4 mb-4">
      <div><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Date</label>
        <input type="date" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"></div>
      <div><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Time</label>
        <input type="time" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"></div>
    </div>
    <div class="mb-6"><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Notes</label>
      <textarea rows="2" placeholder="Special requests…" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none resize-y"></textarea></div>
    <div class="flex gap-3 justify-end">
      <button onclick="document.getElementById('addResModal').classList.add('hidden')"
              class="text-sm border border-black/16 px-5 py-2 rounded hover:border-forest hover:text-forest transition-all">Cancel</button>
      <button class="text-sm bg-forest text-white px-5 py-2 rounded hover:bg-forest-md transition-colors">Save Reservation</button>
    </div>
  </div>
</div>
</body></html>


