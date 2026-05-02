<%@ page contentType="text/html;charset=UTF-8" import="java.util.*,com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Billing Central"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<div class="ml-48 flex flex-col min-h-screen bg-[#fbfbfb]">
  <div class="h-16 bg-white border-b border-black/5 flex items-center justify-between px-8 sticky top-0 z-20">
    <div class="flex items-center gap-4">
      <div class="text-[16px] font-bold text-[#114b3e]">Billing Central</div>
      <div class="w-[1px] h-4 bg-black/10"></div>
      <div class="text-[13px] text-muted"><fmt:formatDate value="<%=new java.util.Date()%>" pattern="EEEE, dd MMM yyyy" /></div>
    </div>
    <div class="flex items-center gap-4">
      <div class="relative">
        <span class="absolute left-3 top-1/2 -translate-y-1/2 text-muted text-sm">🔍</span>
        <input id="dashboardSearch" type="search" placeholder="Search orders..."
               class="w-64 pl-9 pr-4 py-1.5 rounded-full bg-[#f4f5f5] text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20 transition-all"/>
      </div>
      <button class="w-8 h-8 flex items-center justify-center text-muted hover:text-ink transition-colors">🔔</button>
      <button class="w-8 h-8 flex items-center justify-center text-muted hover:text-ink transition-colors">⚙️</button>
      <div class="w-7 h-7 rounded-full bg-ink text-white flex items-center justify-center text-[11px] font-bold">
        <c:choose><c:when test="${not empty currentUser.initials}">${currentUser.initials}</c:when><c:otherwise>AU</c:otherwise></c:choose>
      </div>
    </div>
  </div>

  <div class="p-8 max-w-[1400px]">
    
    <c:set var="occupiedCount" value="0"/>
    <c:set var="freeCount" value="0"/>
    <c:set var="reservedCount" value="0"/>
    <c:forEach items="${tables}" var="t">
      <c:choose>
        <c:when test="${t.status.name() == 'OCCUPIED'}"><c:set var="occupiedCount" value="${occupiedCount + 1}"/></c:when>
        <c:when test="${t.status.name() == 'FREE'}"><c:set var="freeCount" value="${freeCount + 1}"/></c:when>
        <c:when test="${t.status.name() == 'RESERVED'}"><c:set var="reservedCount" value="${reservedCount + 1}"/></c:when>
      </c:choose>
    </c:forEach>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
      <div class="bg-white border border-black/5 rounded-xl p-5 shadow-sm flex items-center justify-between">
        <div>
          <div class="text-[10px] uppercase tracking-widest text-muted font-bold mb-1">Active Tables</div>
          <div class="text-[26px] font-semibold text-[#114b3e]"><span class="text-ink">${occupiedCount}</span> / ${tables.size()}</div>
        </div>
        <div class="w-10 h-10 rounded-lg bg-[#eef8f4] text-[#114b3e] flex items-center justify-center text-xl">🪑</div>
      </div>
      
      <div class="bg-white border border-black/5 rounded-xl p-5 shadow-sm flex items-center justify-between">
        <div>
          <div class="text-[10px] uppercase tracking-widest text-muted font-bold mb-1">Total Sales (Today)</div>
          <div class="text-[26px] font-semibold text-ink"><span class="text-[16px] mr-1">रू</span><fmt:formatNumber value="${todayRevenue}" pattern="#,##0"/></div>
        </div>
        <div class="w-10 h-10 rounded-lg bg-[#eef8f4] text-[#114b3e] flex items-center justify-center text-xl">💵</div>
      </div>

      <div class="bg-white border border-black/5 rounded-xl p-5 shadow-sm flex items-center justify-between">
        <div>
          <div class="text-[10px] uppercase tracking-widest text-muted font-bold mb-1">Pending Bills</div>
          <div class="text-[26px] font-semibold text-ink">${pendingCount}</div>
        </div>
        <div class="w-10 h-10 rounded-lg bg-[#eef8f4] text-[#114b3e] flex items-center justify-center text-xl">📋</div>
      </div>

      <div class="bg-[#114b3e] rounded-xl p-5 shadow-sm flex items-center justify-between text-white">
        <div>
          <div class="text-[10px] uppercase tracking-widest text-white/70 font-bold mb-1">Server Status</div>
          <div class="text-[26px] font-semibold">Operational</div>
        </div>
        <div class="w-10 h-10 rounded-lg border border-white/20 flex items-center justify-center text-xl">☁️</div>
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-[1.5fr_1fr] gap-6">
      <!-- TABLE MANAGEMENT -->
      <div>
        <div class="flex justify-between items-center mb-5">
          <h2 class="text-[17px] font-bold text-[#114b3e]">Table Management</h2>
          <div class="flex bg-white rounded-full p-1 border border-black/5 shadow-sm text-[12px] font-medium text-muted">
            <button class="px-4 py-1 rounded-full bg-paper text-ink shadow-sm">Floor 1</button>
            <button class="px-4 py-1 rounded-full hover:text-ink">Patio</button>
            <button class="px-4 py-1 rounded-full hover:text-ink">VIP Lounge</button>
          </div>
        </div>

        <div class="grid grid-cols-3 gap-4">
          <c:forEach items="${tables}" var="t">
            <div class="table-card rounded-xl p-4 border transition hover:shadow-md
                        ${t.status.name() == 'FREE'     ? 'border-black/5 border-dashed bg-white' :
                          t.status.name() == 'OCCUPIED' ? 'border-[#114b3e]/30 bg-white shadow-sm' :
                                                          'border-orange-200 bg-white shadow-sm'}"
                 data-table="${t.tableNumber}">
              <div class="flex items-center justify-between mb-3">
                <div class="text-lg font-bold ${t.status.name() == 'FREE' ? 'text-muted2' : 'text-ink'}">${t.tableNumber}</div>
                <c:choose>
                  <c:when test="${t.status.name() == 'FREE'}">
                    <span class="text-[9px] uppercase tracking-widest font-bold text-muted2">Available</span>
                  </c:when>
                  <c:when test="${t.status.name() == 'OCCUPIED'}">
                    <span class="text-[9px] uppercase tracking-widest font-bold text-[#114b3e] bg-[#eef8f4] px-2 py-1 rounded">Occupied</span>
                  </c:when>
                  <c:otherwise>
                    <span class="text-[9px] uppercase tracking-widest font-bold text-orange-700 bg-orange-50 px-2 py-1 rounded">Bill Requested</span>
                  </c:otherwise>
                </c:choose>
              </div>
              
              <c:choose>
                <c:when test="${t.status.name() == 'FREE'}">
                   <div class="text-[12px] text-muted text-center mt-6 mb-2">
                     <a href="${pageContext.request.contextPath}/admin/orders?table=${t.tableNumber}" class="text-[#114b3e] font-semibold hover:underline flex items-center justify-center gap-1">
                       <span>⊕</span> Create Order
                     </a>
                   </div>
                </c:when>
                <c:otherwise>
                   <div class="text-[13px] font-semibold text-ink mb-1">${t.capacity} Guests</div>
                   <div class="text-[11px] text-muted mb-4">Started: 12:45 PM</div>
                   <div class="text-[14px] font-bold text-ink mb-4">रू 5,420.00</div>
                   <a href="${pageContext.request.contextPath}/admin/billing?table=${t.tableNumber}"
                      class="block text-center text-[12px] font-semibold py-2 rounded transition-colors
                             ${t.status.name() == 'OCCUPIED' ? 'bg-[#114b3e] text-white hover:bg-[#0e3b31]' : 'bg-orange-500 text-white hover:bg-orange-600'}">
                     ${t.status.name() == 'OCCUPIED' ? 'View Bill' : 'Finalize Bill'}
                   </a>
                </c:otherwise>
              </c:choose>
            </div>
          </c:forEach>
        </div>
      </div>

      <!-- RECEIPT / SNAPSHOT -->
      <div>
        <c:set var="selectedOrder" value="${null}" />
        <c:forEach items="${orders}" var="o" varStatus="status">
          <c:if test="${status.first}"><c:set var="selectedOrder" value="${o}" /></c:if>
        </c:forEach>

        <div class="bg-white rounded-2xl shadow-xl shadow-black/5 overflow-hidden border border-black/5 relative">
          <!-- Receipt Header -->
          <div class="bg-[#114b3e] text-white p-6 text-center relative overflow-hidden">
            <h3 class="font-serif text-[22px] tracking-wide mb-1">GOKYO BISTRO</h3>
            <p class="text-[9px] uppercase tracking-[0.2em] text-white/70 mb-5">Traditional & Contemporary Nepalese</p>
            <div class="flex justify-between text-left text-[10px] uppercase tracking-widest text-white/80 font-bold">
              <div>
                <div>Table</div>
                <div class="text-[16px] text-white mt-1"><c:out value="${not empty selectedOrder ? selectedOrder.tableNumber : 'T-04'}"/></div>
              </div>
              <div class="text-right">
                <div><c:out value="${not empty selectedOrder ? selectedOrder.orderCode : 'Order #8842'}"/></div>
                <div class="text-white mt-1">
                  <c:choose>
                    <c:when test="${not empty selectedOrder.orderedAt}">${fn:substring(selectedOrder.orderedAt.toString(), 0, 10)}</c:when>
                    <c:otherwise>24 May 2024</c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
            <!-- Decorative jagged edge -->
            <div class="absolute -bottom-2 left-0 right-0 h-4 bg-white" style="mask-image: radial-gradient(circle at 10px 0, transparent 10px, black 11px); mask-size: 20px 20px; mask-repeat: repeat-x;"></div>
          </div>

          <!-- Receipt Body -->
          <div class="p-6 bg-white pt-8">
            <div class="flex justify-between text-[9px] uppercase tracking-widest text-muted font-bold mb-4 pb-2 border-b border-black/5">
              <span>Item</span>
              <div class="flex gap-8"><span>Qty</span><span>Price</span></div>
            </div>

            <div class="space-y-4 mb-6">
              <c:set var="calcSubtotal" value="0"/>
              <c:choose>
                <c:when test="${not empty selectedOrder and not empty selectedOrder.items}">
                  <c:forEach items="${selectedOrder.items}" var="item">
                    <c:set var="calcSubtotal" value="${calcSubtotal + item.lineTotal}"/>
                    <div class="flex justify-between items-start text-[13px]">
                      <div>
                        <div class="font-bold text-[#114b3e]"><c:out value="${item.menuItemName}"/></div>
                        <div class="text-[11px] text-muted">Regular</div>
                      </div>
                      <div class="flex gap-8 font-medium text-ink">
                        <span><c:out value="${item.quantity}"/></span>
                        <span><fmt:formatNumber value="${item.lineTotal}" pattern="#,##0"/></span>
                      </div>
                    </div>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <c:set var="calcSubtotal" value="5420"/>
                  <div class="flex justify-between items-start text-[13px]">
                    <div>
                      <div class="font-bold text-[#114b3e]">Chicken Jhol Momo</div>
                      <div class="text-[11px] text-muted">Regular (10 pcs)</div>
                    </div>
                    <div class="flex gap-8 font-medium text-ink"><span>2</span><span>1,100</span></div>
                  </div>
                  <div class="flex justify-between items-start text-[13px]">
                    <div>
                      <div class="font-bold text-[#114b3e]">Newari Khaja Set</div>
                      <div class="text-[11px] text-muted">Spicy Buff</div>
                    </div>
                    <div class="flex gap-8 font-medium text-ink"><span>1</span><span>850</span></div>
                  </div>
                  <div class="flex justify-between items-start text-[13px]">
                    <div>
                      <div class="font-bold text-[#114b3e]">Mutton Thakali Set</div>
                      <div class="text-[11px] text-muted">Traditional</div>
                    </div>
                    <div class="flex gap-8 font-medium text-ink"><span>1</span><span>1,450</span></div>
                  </div>
                  <div class="flex justify-between items-start text-[13px]">
                    <div>
                      <div class="font-bold text-[#114b3e]">Gorkha Beer</div>
                      <div class="text-[11px] text-muted">650ml</div>
                    </div>
                    <div class="flex gap-8 font-medium text-ink"><span>3</span><span>1,800</span></div>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>

            <!-- Totals -->
            <c:set var="calcSvc" value="${calcSubtotal * 0.10}"/>
            <c:set var="calcVat" value="${calcSubtotal * 0.13}"/>
            <c:set var="calcTotal" value="${calcSubtotal + calcSvc + calcVat}"/>
            <div class="border-t border-black/10 pt-4 space-y-2 mb-6">
               <div class="flex justify-between text-[13px] text-muted font-medium">
                  <span>Subtotal</span><span><fmt:formatNumber value="${calcSubtotal}" pattern="#,##0.00"/></span>
               </div>
               <div class="flex justify-between text-[13px] text-muted font-medium">
                  <span>Service Charge (10%)</span><span><fmt:formatNumber value="${calcSvc}" pattern="#,##0.00"/></span>
               </div>
               <div class="flex justify-between text-[13px] text-muted font-medium">
                  <span>VAT (13%)</span><span><fmt:formatNumber value="${calcVat}" pattern="#,##0.00"/></span>
               </div>
               <div class="flex justify-between text-[15px] font-bold text-[#114b3e] pt-2 border-t border-black/5 mt-2">
                  <span>Total Amount</span><span><fmt:formatNumber value="${calcTotal}" pattern="#,##0.00"/></span>
               </div>
            </div>

            <!-- Actions -->
            <div class="grid grid-cols-2 gap-3">
               <button onclick="window.print()" class="py-2.5 rounded text-[13px] font-bold text-[#114b3e] border border-[#114b3e]/20 hover:bg-[#eef8f4] transition-colors flex items-center justify-center gap-2">
                  🖨 Print KOT
               </button>
               <button onclick="window.location.href='${pageContext.request.contextPath}/admin/billing<c:if test="${not empty selectedOrder}">?table=${selectedOrder.tableNumber}</c:if>'" class="py-2.5 rounded text-[13px] font-bold text-white bg-[#114b3e] hover:bg-[#0e3b31] transition-colors flex items-center justify-center gap-2 shadow-md shadow-[#114b3e]/20">
                  💵 Settle Bill
               </button>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
  const dashboardSearch = document.getElementById('dashboardSearch');
  if (dashboardSearch) {
    dashboardSearch.addEventListener('input', function() {
      const query = dashboardSearch.value.trim().toLowerCase();
      document.querySelectorAll('.table-card').forEach(card => {
        const table = card.dataset.table?.toLowerCase() || '';
        card.style.display = (!query || table.includes(query)) ? '' : 'none';
      });
    });
  }
</script>
</body>
</html>
