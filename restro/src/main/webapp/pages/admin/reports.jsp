<%-- ════════════════════════════════════════════════
     ADMIN REPORTS JSP
     ════════════════════════════════════════════════ --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Revenue Reports"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-16 bg-white border-b border-black/10 flex items-center px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Revenue Reports</span>
  </div>
  <div class="p-8">

    <!-- Stat summary -->
    <div class="grid grid-cols-4 gap-4 mb-8">
      <c:forEach items="${[['Today','Rs 12,480','↑ 18%','forest'],
                           ['This Week','Rs 78,280','↑ 22%','forest'],
                           ['This Month','Rs 3,12,450','↑ 15%','gold'],
                           ['Avg Order','Rs 564','34 today','muted']]}" var="s">
        <div class="bg-white border border-black/10 rounded-xl p-5 relative overflow-hidden">
          <div class="absolute top-0 left-0 right-0 h-[3px] bg-${s[3]}"></div>
          <div class="text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">${s[0]}</div>
          <div class="font-serif text-2xl font-normal text-ink mb-1">${s[1]}</div>
          <div class="text-[11.5px] text-green-700 font-light">${s[2]}</div>
        </div>
      </c:forEach>
    </div>

    <div class="grid grid-cols-2 gap-6">
      <!-- Daily revenue bar chart -->
      <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
        <div class="px-6 py-4 border-b border-black/10 flex items-center justify-between">
          <span class="text-[13.5px] font-semibold text-ink">Daily Revenue — This Week</span>
          <button class="text-xs border border-black/16 px-3 py-1.5 rounded hover:border-forest hover:text-forest transition-all">Export PDF</button>
        </div>
        <div class="p-5 space-y-3">
          <c:forEach items="${[['Monday',8200,165],['Tuesday',9400,165],['Wednesday',7800,165],
                               ['Thursday',11200,165],['Friday',13400,165],['Saturday',15800,165],['Today',12480,165]]}" var="d">
            <div class="flex items-center gap-3">
              <span class="w-24 text-right text-[11.5px] text-muted flex-shrink-0">${d[0]}</span>
              <div class="flex-1 h-2 bg-paper3 rounded-full overflow-hidden">
                <div class="h-full rounded-full bg-gradient-to-r from-forest/40 to-forest"
                     style="width:${d[1]/d[2]}%"></div>
              </div>
              <span class="w-24 text-right text-[11.5px] text-muted">Rs ${d[1]}</span>
            </div>
          </c:forEach>
        </div>
      </div>

      <!-- Category + payment method breakdown -->
      <div class="space-y-6">
        <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
          <div class="px-6 py-4 border-b border-black/10">
            <span class="text-[13.5px] font-semibold text-ink">Revenue by Category</span>
          </div>
          <div class="p-5 space-y-3">
            <c:forEach items="${[['Main Course',48],['Starters',26],['Drinks',16],['Desserts',10]]}" var="c">
              <div class="flex items-center gap-3">
                <span class="w-24 text-right text-[11.5px] text-muted flex-shrink-0">${c[0]}</span>
                <div class="flex-1 h-2 bg-paper3 rounded-full overflow-hidden">
                  <div class="h-full rounded-full bg-gradient-to-r from-forest/40 to-forest" style="width:${c[1]*2}%"></div>
                </div>
                <span class="w-10 text-right text-[11.5px] text-muted">${c[1]}%</span>
              </div>
            </c:forEach>
          </div>
        </div>
        <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
          <div class="px-6 py-4 border-b border-black/10">
            <span class="text-[13.5px] font-semibold text-ink">Payment Methods</span>
          </div>
          <div class="p-5 space-y-3">
            <c:forEach items="${[['Cash',52],['eSewa',32],['Khalti',16]]}" var="p">
              <div class="flex items-center gap-3">
                <span class="w-14 text-right text-[11.5px] text-muted flex-shrink-0">${p[0]}</span>
                <div class="flex-1 h-2 bg-paper3 rounded-full overflow-hidden">
                  <div class="h-full rounded-full bg-gradient-to-r from-forest/40 to-forest" style="width:${p[1]*2}%"></div>
                </div>
                <span class="w-10 text-right text-[11.5px] text-muted">${p[1]}%</span>
              </div>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>


