<%-- ═══════════════════════════ SETTINGS JSP ═══ --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://xmlns.jcp.org/jsp/jstl/core" %>
<c:set var="pageTitle" value="Settings"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>
<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-16 bg-white border-b border-black/10 flex items-center px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Settings</span>
  </div>
  <div class="p-8">
    <div class="grid grid-cols-2 gap-6">
      <!-- Restaurant details -->
      <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
        <div class="px-6 py-4 border-b border-black/10"><span class="text-[13.5px] font-semibold text-ink">Restaurant Details</span></div>
        <div class="p-6">
          <form method="POST" action="${pageContext.request.contextPath}/admin/settings">
            <div class="mb-4"><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Restaurant Name</label>
              <input name="name" value="Gokyo Bistro" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"></div>
            <div class="mb-4"><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Address</label>
              <input name="address" value="Itahari, Sunsari, Nepal" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"></div>
            <div class="grid grid-cols-2 gap-4 mb-4">
              <div><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Phone</label>
                <input name="phone" value="+977 25-XXXXXX" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"></div>
              <div><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Email</label>
                <input name="email" type="email" value="hello@gokyo.com" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"></div>
            </div>
            <div class="grid grid-cols-2 gap-4 mb-6">
              <div><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">VAT Rate (%)</label>
                <input name="vatRate" type="number" value="13" min="0" max="100" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"></div>
              <div><label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Service Charge (%)</label>
                <input name="serviceRate" type="number" value="10" min="0" max="100" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none"></div>
            </div>
            <button type="submit" class="bg-forest text-white px-5 py-2 rounded text-sm font-medium hover:bg-forest-md transition-colors">Save Changes</button>
          </form>
        </div>
      </div>
      <!-- Business hours -->
      <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
        <div class="px-6 py-4 border-b border-black/10"><span class="text-[13.5px] font-semibold text-ink">Business Hours</span></div>
        <div class="p-6">
          <c:forEach items="${['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']}" var="day" varStatus="vs">
            <div class="flex items-center justify-between py-2.5 border-b border-black/8 last:border-0 text-sm">
              <span class="font-medium text-ink w-24">${day}</span>
              <c:choose>
                <c:when test="${vs.last}">
                  <span class="text-xs text-muted font-light">Closed</span>
                </c:when>
                <c:otherwise>
                  <div class="flex items-center gap-2">
                    <input value="11:00 AM" class="gk-field px-2 py-1 bg-white border border-black/10 rounded text-xs text-ink outline-none w-20">
                    <span class="text-muted">–</span>
                    <input value="10:00 PM" class="gk-field px-2 py-1 bg-white border border-black/10 rounded text-xs text-ink outline-none w-20">
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </c:forEach>
          <button class="mt-4 bg-forest text-white px-5 py-2 rounded text-sm font-medium hover:bg-forest-md transition-colors">Save Hours</button>
        </div>
      </div>
    </div>
  </div>
</div>
</body></html>


