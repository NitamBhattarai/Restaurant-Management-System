<%-- views/shared/admin-sidebar.jsp --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  String cp   = request.getContextPath();
  String path = request.getServletPath();
%>

<!-- SIDEBAR — same white/border style as site cards -->
<aside class="w-60 bg-white border-r border-black/10 fixed top-0 bottom-0 left-0 z-30 flex flex-col overflow-y-auto">

  <!-- Brand — same height 64px as site nav -->
  <div class="h-16 flex items-center px-5 border-b border-black/10 flex-shrink-0">
    <div>
      <div class="font-serif text-base font-bold text-ink">Gokyo Bistro</div>
      <div class="text-[9px] uppercase tracking-widest text-muted2 font-medium">Admin Dashboard</div>
    </div>
  </div>

  <!-- User badge -->
  <div class="mx-4 mt-4 p-2.5 bg-paper rounded-lg border border-black/10 flex items-center gap-2.5">
    <div class="w-8 h-8 rounded-full bg-forest/12 border border-forest/20 flex items-center justify-center
                text-xs font-semibold text-forest flex-shrink-0">
      ${currentUser.initials}
    </div>
    <div>
      <div class="text-[13px] font-medium text-ink2 leading-tight">${currentUser.fullName}</div>
      <div class="text-[10px] text-muted2">${currentUser.role}</div>
    </div>
  </div>

  <!-- Nav links -->
  <nav class="flex-1 py-3">

    <div class="px-4 pt-3 pb-1 text-[9px] font-semibold uppercase tracking-widest text-muted2">Overview</div>
    <a href="<%=cp%>/admin/dashboard"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/dashboard")?"sb-active":""%>">
      <span class="w-4 text-center">◈</span>Dashboard
    </a>

    <div class="px-4 pt-4 pb-1 text-[9px] font-semibold uppercase tracking-widest text-muted2">Restaurant</div>
    <a href="<%=cp%>/admin/orders"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/orders")?"sb-active":""%>">
      <span class="w-4 text-center text-sm">📋</span>Orders
    </a>
    <a href="<%=cp%>/admin/tables"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/tables")?"sb-active":""%>">
      <span class="w-4 text-center text-sm">🪑</span>Tables
    </a>
    <a href="<%=cp%>/admin/reservations"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/reservations")?"sb-active":""%>">
      <span class="w-4 text-center text-sm">📅</span>Reservations
    </a>

    <div class="px-4 pt-4 pb-1 text-[9px] font-semibold uppercase tracking-widest text-muted2">Menu</div>
    <a href="<%=cp%>/admin/menu"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/menu")?"sb-active":""%>">
      <span class="w-4 text-center text-sm">🍽️</span>Menu Management
    </a>

    <div class="px-4 pt-4 pb-1 text-[9px] font-semibold uppercase tracking-widest text-muted2">Finance</div>
    <a href="<%=cp%>/admin/billing"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/billing")?"sb-active":""%>">
      <span class="w-4 text-center text-sm">💰</span>Billing
    </a>
    <a href="<%=cp%>/admin/reports"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/reports")?"sb-active":""%>">
      <span class="w-4 text-center text-sm">📊</span>Revenue Reports
    </a>
    <a href="<%=cp%>/admin/payments"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/payments")?"sb-active":""%>">
      <span class="w-4 text-center text-sm">💳</span>Payments
    </a>

    <div class="px-4 pt-4 pb-1 text-[9px] font-semibold uppercase tracking-widest text-muted2">System</div>
    <a href="<%=cp%>/admin/users"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/users")?"sb-active":""%>">
      <span class="w-4 text-center text-sm">👥</span>Users &amp; Roles
    </a>
    <a href="<%=cp%>/admin/settings"
       class="flex items-center gap-2.5 px-5 py-2 text-[13px] text-muted border-l-2 border-transparent
              hover:text-ink2 hover:bg-paper transition-all <%=path.equals("/admin/settings")?"sb-active":""%>">
      <span class="w-4 text-center text-sm">⚙️</span>Settings
    </a>
  </nav>

  <div class="p-4 border-t border-black/10">
    <a href="<%=cp%>/admin/logout"
       class="flex items-center gap-2 text-[12.5px] text-muted hover:text-red-600 transition-colors">
      ← Sign Out
    </a>
  </div>
</aside>


