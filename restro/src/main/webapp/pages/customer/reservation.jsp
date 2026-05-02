<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Reserve a Table"/>
<%@ include file="/pages/errorpages/header.jsp" %>

<div class="min-h-[calc(100vh-64px)] bg-paper py-12 px-4">
  <div class="mx-auto max-w-3xl">
    <div class="bg-white border border-black/10 rounded-3xl overflow-hidden shadow-sm">
      <div class="px-8 pt-10 pb-6 border-b border-black/10 bg-paper2 text-center">
        <div class="w-16 h-16 rounded-full bg-forest/8 flex items-center justify-center mx-auto mb-5 text-3xl border border-forest/14">🪑</div>
        <div class="text-[10px] uppercase tracking-widest font-semibold text-forest mb-2">Guest Reservation</div>
        <h1 class="font-serif text-4xl font-normal leading-tight mb-2">Reserve your table</h1>
        <p class="text-sm font-light text-muted leading-relaxed">Book a table in advance and we’ll prepare your seat.</p>
      </div>

      <div class="px-8 py-6">
        <c:if test="${not empty error}">
          <div class="mb-4 bg-red-50 border border-red-200 text-red-800 text-sm px-4 py-3 rounded">
            <c:out value="${error}"/>
          </div>
        </c:if>
        <c:if test="${not empty success}">
          <div class="mb-4 bg-forest/10 border border-forest/20 text-forest text-sm px-4 py-3 rounded">
            <c:out value="${success}"/>
          </div>
        </c:if>

        <form method="POST" action="${pageContext.request.contextPath}/customer/reservation">
          <div class="grid grid-cols-1 gap-5">
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Party Size</label>
              <input name="partySize" type="number" min="1" max="20" value="2" required
                     class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"/>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Date</label>
                <input name="date" type="date" required
                       class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"/>
              </div>
              <div>
                <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Time</label>
                <input name="time" type="time" required
                       class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"/>
              </div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Preferred Table</label>
                <select name="tableId" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none">
                  <option value="">Any available table</option>
                  <c:forEach items="${tables}" var="t">
                    <option value="${t.id}">${t.tableNumber} — ${t.capacity} seats (${t.status})</option>
                  </c:forEach>
                </select>
              </div>
              <div>
                <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Notes</label>
                <textarea name="notes" rows="3" placeholder="Special requests or allergies"
                          class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none resize-y"></textarea>
              </div>
            </div>
          </div>
          <div class="mt-8 flex flex-col gap-3 sm:flex-row sm:justify-end">
            <a href="${pageContext.request.contextPath}/customer/scan"
               class="text-sm border border-black/16 px-5 py-3 rounded text-ink hover:border-forest hover:text-forest transition-all text-center">Back to scan</a>
            <button type="submit"
                    class="text-sm bg-forest text-white px-5 py-3 rounded hover:bg-forest-md transition-colors">Confirm Reservation</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
</body>
</html>
