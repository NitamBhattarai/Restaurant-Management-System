<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Review Your Order"/>
<%@ include file="/pages/errorpages/header.jsp" %>

<div class="min-h-screen bg-paper flex flex-col items-center py-10 px-4 sm:px-6 lg:px-8">
  
  <div class="w-full max-w-5xl bg-white shadow-xl shadow-black/5 flex flex-col md:flex-row overflow-hidden" style="min-height: 80vh;">
    <!-- LEFT COLUMN: Review Your Order -->
    <div class="w-full md:w-[45%] bg-[#f4f5f5] p-10 md:p-14 flex flex-col">
      <div class="mb-10">
        <h1 class="font-serif text-2xl text-[#214a3f] mb-2">Review Your Order</h1>
        <p class="text-[13px] text-muted italic">Savoring the spirit of the Himalayas at Gokyo Bistro.</p>
      </div>

      <div class="flex-1 overflow-y-auto pr-2 space-y-6">
        <c:choose>
          <c:when test="${not empty order and not empty order.items}">
            <c:forEach items="${order.items}" var="item">
              <div class="flex items-center gap-4">
                <div class="w-14 h-14 bg-white rounded-lg flex items-center justify-center text-2xl shadow-sm border border-black/5">
                  <c:out value="${item.menuItemEmoji}"/>
                </div>
                <div class="flex-1">
                  <div class="flex justify-between items-start">
                    <div class="font-medium text-[#2f3e3a] text-[15px]"><c:out value="${item.menuItemName}"/></div>
                    <div class="font-medium text-[#2f3e3a] text-[14px]">
                      <span class="text-[11px]">रू</span> <fmt:formatNumber value="${item.lineTotal}" pattern="#,##0"/>
                    </div>
                  </div>
                  <div class="text-[12px] text-muted mt-0.5"><c:out value="${item.quantity}"/> × Fresh local prep</div>
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div class="text-sm text-muted">No items in your order yet.</div>
          </c:otherwise>
        </c:choose>
      </div>

      <c:if test="${not empty bill}">
        <div class="mt-10 border-t border-black/10 pt-6 space-y-3">
          <div class="flex justify-between text-[13px] text-muted font-medium">
            <span>Subtotal</span>
            <span><span class="text-[10px]">रू</span> <fmt:formatNumber value="${bill.subtotal}" pattern="#,##0"/></span>
          </div>
          <div class="flex justify-between text-[13px] text-muted font-medium">
            <span>Service Charge (${bill.serviceRate}%)</span>
            <span><span class="text-[10px]">रू</span> <fmt:formatNumber value="${bill.serviceAmount}" pattern="#,##0"/></span>
          </div>
          <div class="flex justify-between text-[13px] text-muted font-medium">
            <span>VAT (${bill.vatRate}%)</span>
            <span><span class="text-[10px]">रू</span> <fmt:formatNumber value="${bill.vatAmount}" pattern="#,##0"/></span>
          </div>
          <div class="flex justify-between items-baseline pt-4 mt-2">
            <span class="font-serif text-lg font-bold text-[#1a3a2e]">Total</span>
            <span class="font-serif text-[22px] font-bold text-[#1a3a2e]">
              <fmt:formatNumber value="${bill.total}" pattern="#,##0.0"/>
            </span>
          </div>
        </div>
      </c:if>
    </div>

    <!-- RIGHT COLUMN: Payment Instructions -->
    <div class="w-full md:w-[55%] bg-white p-10 md:p-14 flex flex-col items-center justify-center text-center relative">
      <div class="w-20 h-20 bg-[#eef8f4] rounded-full flex items-center justify-center text-4xl mb-6 shadow-sm border border-[#114b3e]/10">🛎️</div>
      <h2 class="font-serif text-[28px] text-[#214a3f] mb-3">Ready to settle up?</h2>
      <p class="text-[14px] text-muted mb-8 max-w-md leading-relaxed">
        Please proceed to the billing counter or ask your server to settle your bill. We accept Cash, eSewa, Khalti, and major Credit Cards.
      </p>
      
      <div class="flex gap-4 mb-auto">
        <div class="w-12 h-12 rounded bg-paper flex items-center justify-center text-xl border border-black/5" title="Cash">💵</div>
        <div class="w-12 h-12 rounded bg-paper flex items-center justify-center text-xl border border-black/5" title="eSewa">📱</div>
        <div class="w-12 h-12 rounded bg-paper flex items-center justify-center text-xl border border-black/5" title="Khalti">💜</div>
        <div class="w-12 h-12 rounded bg-paper flex items-center justify-center text-xl border border-black/5" title="Cards">💳</div>
      </div>

      <div class="mt-8 bg-[#f8f9f9] rounded-xl p-5 border border-black/5 w-full max-w-md flex items-center justify-between text-left">
        <div class="flex items-center gap-4">
          <div class="w-8 h-8 rounded-full bg-white flex items-center justify-center shadow-sm text-[#114b3e] text-sm">★</div>
          <div>
            <div class="text-[13px] font-bold text-ink">Earn 680 Bistro Points</div>
            <div class="text-[11px] text-muted">Mention your phone number at the counter.</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="w-full max-w-5xl mt-8 flex flex-col md:flex-row justify-between items-center text-[11px] text-muted2 font-medium px-4">
    <div class="font-serif italic text-[14px] text-muted">Gokyo Bistro</div>
    <div class="flex gap-6 mt-4 md:mt-0">
      <a href="#" class="hover:text-ink transition-colors">Privacy Policy</a>
      <a href="#" class="hover:text-ink transition-colors">Terms of Service</a>
      <a href="#" class="hover:text-ink transition-colors">Contact Us</a>
    </div>
    <div class="mt-4 md:mt-0">© 2026 Gokyo Bistro. All Rights Reserved.</div>
  </div>

</div>

<%@ include file="/pages/errorpages/footer.jsp" %>
