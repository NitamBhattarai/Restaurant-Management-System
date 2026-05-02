<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  String cp = request.getContextPath();
  String path = request.getServletPath();
%>

<aside class="w-48 bg-white border-r border-black/10 fixed top-0 bottom-0 left-0 z-30 flex flex-col overflow-y-auto">
  <div class="px-4 py-5 border-b border-black/10">
    <a href="<%=cp%>/admin/dashboard" class="flex items-center gap-3">
      <div class="w-9 h-9 rounded-lg bg-forest text-white flex items-center justify-center font-semibold text-sm">
        <span>G</span>
      </div>
      <div>
        <div class="font-serif text-[18px] font-bold text-ink leading-none">Gokyo Bistro</div>
        <div class="text-[10px] uppercase tracking-[0.18em] text-muted2 font-semibold mt-1">Admin Dashboard</div>
      </div>
    </a>
  </div>

  <nav class="flex-1 py-6">
    <a href="<%=cp%>/admin/dashboard"
       class="flex items-center gap-3 px-5 py-3 text-[15px] font-medium text-ink2 border-r-[3px] <%=path.equals("/admin/dashboard") || path.equals("/admin") ? "bg-[#eef8f4] border-forest text-forest" : "border-transparent hover:bg-paper2"%>">
      <span class="text-sm">H</span>
      <span>Dashboard</span>
    </a>
    <a href="<%=cp%>/admin/reports"
       class="flex items-center gap-3 px-5 py-3 text-[15px] font-medium text-ink2 border-r-[3px] <%=path.equals("/admin/reports") ? "bg-[#eef8f4] border-forest text-forest" : "border-transparent hover:bg-paper2"%>">
      <span class="text-sm">R</span>
      <span>Reports</span>
    </a>
    <a href="<%=cp%>/admin/menu"
       class="flex items-center gap-3 px-5 py-3 text-[15px] font-medium text-ink2 border-r-[3px] <%=path.equals("/admin/menu") ? "bg-[#eef8f4] border-forest text-forest" : "border-transparent hover:bg-paper2"%>">
      <span class="text-sm">M</span>
      <span>Menu Management</span>
    </a>
    <a href="<%=cp%>/admin/billing"
       class="flex items-center gap-3 px-5 py-3 text-[15px] font-medium text-ink2 border-r-[3px] <%=path.equals("/admin/billing") ? "bg-[#eef8f4] border-forest text-forest" : "border-transparent hover:bg-paper2"%>">
      <span class="text-sm">B</span>
      <span>Billing</span>
    </a>
    <a href="<%=cp%>/admin/payments"
       class="flex items-center gap-3 px-5 py-3 text-[15px] font-medium text-ink2 border-r-[3px] <%=path.equals("/admin/payments") ? "bg-[#eef8f4] border-forest text-forest" : "border-transparent hover:bg-paper2"%>">
      <span class="text-sm">P</span>
      <span>Payments</span>
    </a>
    <a href="<%=cp%>/admin/feedback"
       class="flex items-center gap-3 px-5 py-3 text-[15px] font-medium text-ink2 border-r-[3px] <%=path.equals("/admin/feedback") ? "bg-[#eef8f4] border-forest text-forest" : "border-transparent hover:bg-paper2"%>">
      <span class="text-sm">F</span>
      <span>Feedbacks</span>
    </a>
  </nav>

  <div class="mt-auto px-4 py-5 border-t border-black/10">
    <div class="flex items-center gap-3 mb-4">
      <div class="w-10 h-10 rounded-full bg-paper2 border border-black/10 flex items-center justify-center text-[12px] font-semibold text-forest">
        <c:choose>
          <c:when test="${not empty currentUser.initials}">${currentUser.initials}</c:when>
          <c:otherwise>AU</c:otherwise>
        </c:choose>
      </div>
      <div class="min-w-0">
        <div class="text-[13px] font-semibold text-ink leading-tight truncate">
          <c:choose>
            <c:when test="${not empty currentUser.fullName}">${currentUser.fullName}</c:when>
            <c:otherwise>Admin User</c:otherwise>
          </c:choose>
        </div>
        <div class="text-[11px] text-muted truncate">
          <c:choose>
            <c:when test="${not empty currentUser.email}">${currentUser.email}</c:when>
            <c:otherwise>Super Admin</c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
    <form method="POST" action="<%=cp%>/admin/logout" style="display:inline;">
      <button type="submit" class="w-full py-2 text-xs bg-red-50 border border-red-200 text-red-700 rounded hover:bg-red-100 transition-colors font-medium">
        Logout
      </button>
    </form>
  </div>
</aside>
