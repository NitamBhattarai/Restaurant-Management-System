<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="http://xmlns.jcp.org/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Payments"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>
<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-16 bg-white border-b border-black/10 flex items-center px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Payment Tracking</span>
  </div>
  <div class="p-8">
    <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-black/10 flex items-center justify-between">
        <span class="text-[13.5px] font-semibold text-ink">Payment Records</span>
        <button class="text-xs border border-black/16 text-ink2 px-3 py-1.5 rounded hover:border-forest hover:text-forest transition-all">Export</button>
      </div>
      <div class="overflow-x-auto">
        <table class="w-full text-[13px]">
          <thead><tr class="border-b border-black/10">
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Order</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Table</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Amount</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Method</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Processed By</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Status</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Time</th>
          </tr></thead>
          <tbody>
            <c:forEach items="${payments}" var="p">
              <tr class="border-b border-black/5 hover:bg-paper transition-colors">
                <td class="px-4 py-3 font-mono text-[11px] text-muted">${p.orderCode}</td>
                <td class="px-4 py-3 font-semibold">${p.tableNumber}</td>
                <td class="px-4 py-3 font-medium">Rs <fmt:formatNumber value="${p.amountPaid}" pattern="#,##0.00"/></td>
                <td class="px-4 py-3 text-xs">${p.method}</td>
                <td class="px-4 py-3 text-xs text-muted">${p.processedByName}</td>
                <td class="px-4 py-3"><span class="badge badge-${p.status.name().toLowerCase()}">${p.status}</span></td>
                <td class="px-4 py-3 text-xs text-muted">
                  ${not empty p.paidAt ? fn:substring(p.paidAt.toString(),11,16) : "—"}
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty payments}">
              <tr><td colspan="7" class="px-4 py-10 text-center text-sm text-muted font-light">No payment records yet</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
</body></html>


