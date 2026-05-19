<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Financial Reports" />
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<div class="ml-48 min-h-screen bg-[#fbfaf7]">
  <div
    class="h-14 bg-white border-b border-black/10 flex items-center justify-between px-6 sticky top-0 z-20"
  >
    <div class="flex items-center gap-3 text-[13px]">
      <span class="text-muted">Dashboard</span>
      <span class="text-black/20">/</span>
      <span class="font-semibold text-ink">Financial Reports</span>
    </div>
    <div class="flex items-center gap-4">
      <div class="text-[12px] text-muted font-medium">
        <fmt:formatDate value="<%=new java.util.Date()%>" pattern="EEEE, dd MMM yyyy" />
      </div>
      <span class="text-muted">◔</span>
      <span class="text-muted">⚙</span>
    </div>
  </div>

  <div class="p-6">
    <c:if test="${not empty reportWarning}">
      <div class="mb-5 bg-amber-50 border border-amber-200 text-amber-800 text-sm px-4 py-3 rounded-lg">
        <c:out value="${reportWarning}"/>
      </div>
    </c:if>
    <%-- ═══ TOP ROW: Revenue Hero + Quick Stats ═══ --%>
    <div class="grid grid-cols-[2fr_1fr] gap-5 mb-5">
      <div class="bg-[#184d3f] rounded-xl text-white p-6 shadow-sm">
        <div
          class="text-[10px] uppercase tracking-[0.18em] text-white/60 font-semibold mb-4"
        >
          Today's Revenue (Served Orders)
        </div>
        <div class="flex items-end gap-3 mb-6">
          <div class="font-serif text-5xl leading-none">
            रू <fmt:formatNumber value="${todayRevenue}" pattern="#,##0"/>
          </div>
        </div>
        <div class="grid grid-cols-3 gap-6">
          <div>
            <div
              class="text-[10px] uppercase tracking-[0.16em] text-white/45 mb-2"
            >
              Avg. Ticket
            </div>
            <div class="text-[24px] font-semibold">
              रू <fmt:formatNumber value="${avgTicket}" pattern="#,##0"/>
            </div>
          </div>
          <div>
            <div
              class="text-[10px] uppercase tracking-[0.16em] text-white/45 mb-2"
            >
              Transactions
            </div>
            <div class="text-[24px] font-semibold">${transactionCount}</div>
          </div>
          <div>
            <div
              class="text-[10px] uppercase tracking-[0.16em] text-white/45 mb-2"
            >
              Orders Today
            </div>
            <div class="text-[24px] font-semibold">${todayOrders}</div>
          </div>
        </div>
      </div>

      <%-- Paid Revenue Card --%>
      <div class="bg-white rounded-xl border border-black/8 p-6">
        <div
          class="flex items-center gap-2 text-[13px] font-semibold text-ink mb-4"
        >
          <span class="text-forest">✦</span>
          <span>Collected Revenue</span>
        </div>
        <div class="text-[11px] uppercase tracking-[0.14em] text-muted mb-2">
          Total Paid Amounts Today
        </div>
        <div class="font-serif text-4xl text-ink leading-none mb-3">
          रू <fmt:formatNumber value="${todayPaidRevenue}" pattern="#,##0"/>
        </div>
        <div class="text-[#2f9b6d] font-semibold text-[14px] mb-5">
          ${transactionCount} paid transactions
        </div>
        <div
          class="rounded-lg bg-[#faf7f2] border border-black/6 px-4 py-3 text-[11px] text-muted leading-relaxed"
        >
          "Collected revenue reflects only orders that have been fully paid. Served order total may differ if some bills are still pending."
        </div>
      </div>
    </div>

    <%-- ═══ MIDDLE ROW: Payment Methods + Top Item + Category Breakdown ═══ --%>
    <div class="grid grid-cols-[1fr_1fr_1fr] gap-5 mb-5">
      <%-- Payment Methods Breakdown --%>
      <div class="bg-white rounded-xl border border-black/8 p-5">
        <div class="text-[11px] font-semibold text-ink mb-4">
          Payment Methods
        </div>
        <div class="space-y-4">
          <c:choose>
            <c:when test="${not empty paymentMethods}">
              <c:forEach items="${paymentMethods}" var="entry">
                <c:set var="pct" value="${totalPayments > 0 ? (entry.value * 100) / totalPayments : 0}"/>
                <div>
                  <div class="flex justify-between text-[12px] mb-2">
                    <span class="text-muted">${entry.key}</span>
                    <span class="text-forest font-semibold">
                      <fmt:formatNumber value="${pct}" pattern="0"/>% (<c:out value="${entry.value}"/>)
                    </span>
                  </div>
                  <div class="h-1.5 rounded-full bg-paper3">
                    <div class="h-full bg-forest rounded-full" style="width:<fmt:formatNumber value="${pct}" pattern="0"/>%"></div>
                  </div>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="text-[12px] text-muted text-center py-6">No payment data yet</div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <%-- Top Selling Item --%>
      <div
        class="bg-[#1c1b1a] rounded-xl overflow-hidden relative min-h-[220px]"
      >
        <div
          class="absolute inset-0 bg-[radial-gradient(circle_at_50%_50%,rgba(178,119,78,.45),transparent_45%)]"
        ></div>
        <div
          class="absolute top-4 left-4 text-[#5ad29b] text-[11px] font-semibold"
        >
          ★ TOP PERFORMER TODAY
        </div>
        <div class="absolute left-5 bottom-5 text-white">
          <c:choose>
            <c:when test="${not empty topItem and not empty topItem.name}">
              <div class="font-serif text-4xl leading-none mb-2">
                <c:out value="${topItem.name}"/>
              </div>
              <div class="text-[11px] text-white/70 mb-3">
                <c:out value="${topItem.count}"/> units sold today
              </div>
              <div class="text-[12px] text-white/70">
                Total Revenue
                <span class="text-white font-semibold ml-3">रू <fmt:formatNumber value="${topItem.revenue}" pattern="#,##0"/></span>
              </div>
            </c:when>
            <c:otherwise>
              <div class="font-serif text-2xl leading-none mb-2">
                No orders yet today
              </div>
              <div class="text-[11px] text-white/70 mb-3">
                Top performer will appear once orders are placed.
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <%-- Revenue Summary --%>
      <div class="bg-white rounded-xl border border-black/8 p-5">
        <div class="text-[11px] font-semibold text-ink mb-4">
          Today's Summary
        </div>
        <div class="space-y-5 text-[13px]">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-[#184d3f]"></span>
              <span class="text-muted">Served Revenue</span>
            </div>
            <strong>रू <fmt:formatNumber value="${todayRevenue}" pattern="#,##0"/></strong>
          </div>
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-[#6ea8ff]"></span>
              <span class="text-muted">Paid Collections</span>
            </div>
            <strong>रू <fmt:formatNumber value="${todayPaidRevenue}" pattern="#,##0"/></strong>
          </div>
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-[#ffc44d]"></span>
              <span class="text-muted">Avg Ticket Size</span>
            </div>
            <strong>रू <fmt:formatNumber value="${avgTicket}" pattern="#,##0"/></strong>
          </div>
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-[#ff6f6f]"></span>
              <span class="text-muted">Total Orders</span>
            </div>
            <strong>${todayOrders}</strong>
          </div>
        </div>
      </div>
    </div>

    <%-- ═══ BOTTOM: Recent Transactions Table ═══ --%>
    <div class="grid grid-cols-[2fr_1fr] gap-5">
      <div class="bg-white rounded-xl border border-black/8 overflow-hidden">
        <div
          class="px-5 py-4 border-b border-black/8 flex items-center justify-between"
        >
          <div class="font-semibold text-ink">Recent Transactions</div>
          <a href="${pageContext.request.contextPath}/admin/payments" class="text-[12px] text-forest font-semibold hover:underline">View All</a>
        </div>
        <table class="w-full text-[13px]">
          <thead>
            <tr
              class="text-[10px] uppercase tracking-[0.14em] text-muted border-b border-black/6"
            >
              <th class="px-5 py-3 text-left">Order ID</th>
              <th class="px-5 py-3 text-left">Table</th>
              <th class="px-5 py-3 text-left">Method</th>
              <th class="px-5 py-3 text-right">Amount</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty recentTransactions}">
                <c:forEach items="${recentTransactions}" var="tx" varStatus="st">
                  <tr class="${!st.last ? 'border-b border-black/6' : ''}">
                    <td class="px-5 py-4 text-muted"><c:out value="${tx.orderCode}"/></td>
                    <td class="px-5 py-4 font-medium"><c:out value="${tx.tableNumber}"/></td>
                    <td class="px-5 py-4">
                      <c:choose>
                        <c:when test="${tx.method == 'CASH'}"><c:set var="methodClass" value="bg-green-50 text-green-700"/></c:when>
                        <c:when test="${tx.method == 'ESEWA'}"><c:set var="methodClass" value="bg-blue-50 text-blue-700"/></c:when>
                        <c:when test="${tx.method == 'KHALTI'}"><c:set var="methodClass" value="bg-purple-50 text-purple-700"/></c:when>
                        <c:otherwise><c:set var="methodClass" value="bg-orange-50 text-orange-700"/></c:otherwise>
                      </c:choose>
                      <span class="text-[10px] uppercase tracking-widest font-bold px-2 py-1 rounded ${methodClass}">
                        <c:out value="${tx.method}"/>
                      </span>
                    </td>
                    <td class="px-5 py-4 text-right font-semibold">रू <fmt:formatNumber value="${tx.amount}" pattern="#,##0"/></td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="4" class="px-5 py-8 text-center text-muted text-[13px]">
                    No transactions recorded yet. Payments will appear here once bills are settled.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <div class="space-y-4">
        <div class="bg-[#eef8f4] rounded-xl p-5 border border-[#d8ece3]">
          <div class="font-semibold text-ink mb-2">📊 Revenue Insight</div>
          <div class="text-[12px] text-muted leading-relaxed">
            <c:choose>
              <c:when test="${todayOrders > 0}">
                Today you've processed <strong>${todayOrders}</strong> orders with
                <strong>${transactionCount}</strong> paid transactions.
                <c:if test="${avgTicket > 0}">
                  Average ticket size is <strong>रू <fmt:formatNumber value="${avgTicket}" pattern="#,##0"/></strong>.
                </c:if>
              </c:when>
              <c:otherwise>
                No orders have been placed today yet. Revenue data will populate as customers place orders and bills are settled.
              </c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="bg-[#211f1c] rounded-xl p-5 text-white">
          <div class="font-semibold mb-2">💡 Quick Tip</div>
          <div class="text-[12px] text-white/70 leading-relaxed mb-4">
            All revenue figures on this page are computed in real-time from the database. 
            Served Revenue counts all orders marked as SERVED today. 
            Collected Revenue counts only paid bills.
          </div>
          <a href="${pageContext.request.contextPath}/admin/payments"
            class="block w-full text-center rounded-lg bg-white/10 py-3 text-[11px] font-semibold uppercase tracking-[0.14em] hover:bg-white/20 transition-colors"
          >
            View Payment History
          </a>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="/pages/errorpages/footer.jsp" %>
