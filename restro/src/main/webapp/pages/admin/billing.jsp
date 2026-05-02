<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Billing"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-16 bg-white border-b border-black/10 flex items-center px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Billing &amp; Payments</span>
  </div>
  <div class="p-8">
    <div class="grid grid-cols-1 gap-6">

      <!-- Orders to bill -->
      <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
        <div class="px-6 py-4 border-b border-black/10">
          <span class="text-[13.5px] font-semibold text-ink">Orders Awaiting Payment</span>
        </div>
        <table id="billingOrdersTable" class="w-full text-[13px]">
          <thead>
          <tr class="border-b border-black/10">
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Order</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Table</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Status</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Action</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${orders}" var="o">
            <c:if test="${o.status.name() != 'CANCELLED'}">
              <tr data-table="${o.tableNumber}" class="border-b border-black/5 hover:bg-paper transition-colors">
                <td class="px-4 py-3 font-mono text-[11px] text-muted">${o.orderCode}</td>
                <td class="px-4 py-3 font-semibold text-ink">${o.tableNumber}</td>
                <td class="px-4 py-3"><span class="badge badge-${o.status.name().toLowerCase()}">${o.status}</span></td>
                <td class="px-4 py-3">
                  <button onclick="loadBill(${o.id}, '${o.orderCode}', '${o.tableNumber}')"
                          class="text-xs bg-forest text-white px-3 py-1.5 rounded hover:bg-forest-md transition-colors">
                    Generate Bill
                  </button>
                </td>
              </tr>
            </c:if>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Bill detail card + Payment panel (full width, stacked) -->
    <div id="billDetailCard" class="hidden bg-white border border-black/10 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-black/10 flex items-center justify-between">
        <span class="text-[13.5px] font-semibold text-ink" id="billCardTitle">Bill — </span>
        <span class="badge badge-preparing" id="billCardStatus"></span>
      </div>

      <!-- Items table — full width -->
      <div class="border-b border-black/10">
        <table class="w-full text-[13px]">
          <thead>
          <tr class="border-b border-black/10">
            <th class="px-6 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Item</th>
            <th class="px-6 py-2.5 text-right text-[10px] uppercase tracking-widest font-semibold text-muted">Qty</th>
            <th class="px-6 py-2.5 text-right text-[10px] uppercase tracking-widest font-semibold text-muted">Amount</th>
          </tr>
          </thead>
          <tbody id="billItemsBody">
          <tr><td colspan="3" class="px-6 py-8 text-center text-sm text-muted font-light">Select an order above to generate a bill</td></tr>
          </tbody>
        </table>
      </div>

      <!-- Payment summary — full width below items -->
      <div class="p-6">
        <div class="text-[13.5px] font-semibold text-ink mb-4">Payment Summary</div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

          <!-- Left: totals + discount -->
          <div>
            <div id="billTotals" class="mb-5 space-y-2">
              <div class="flex justify-between text-sm text-muted font-light"><span>Subtotal</span><span id="subtotalVal">Rs 0.00</span></div>
              <div class="flex justify-between text-sm text-muted font-light"><span>VAT (13%)</span><span id="vatVal">Rs 0.00</span></div>
              <div class="flex justify-between text-sm text-muted font-light"><span>Service (10%)</span><span id="svcVal">Rs 0.00</span></div>
              <div id="discountRow" class="hidden flex justify-between text-sm text-green-700 font-light"><span>Discount</span><span id="discountVal">−Rs 0.00</span></div>
            </div>
            <div class="flex justify-between items-baseline border-t border-black/18 pt-4">
              <span class="text-sm font-semibold">Grand Total</span>
              <span class="font-serif text-2xl font-normal text-forest" id="grandTotal">Rs 0.00</span>
            </div>
            <div class="mt-4">
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Apply Discount (%)</label>
              <input type="number" id="discountPct" min="0" max="50" placeholder="0"
                     class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none"
                     oninput="recalc()">
            </div>
          </div>

          <!-- Right: payment method + process -->
          <div>
            <div class="mb-4">
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-3">Payment Method</label>
              <div class="grid grid-cols-3 gap-2">
                <div onclick="selPay(this,'CASH')"
                     class="pay-opt selected p-3 rounded border border-forest bg-forest/8 text-center cursor-pointer transition-all">
                  <div class="text-xl mb-1">💵</div>
                  <div class="text-xs font-medium text-forest">Cash</div>
                </div>
                <div onclick="selPay(this,'ESEWA')"
                     class="pay-opt p-3 rounded border border-black/16 bg-transparent text-center cursor-pointer transition-all">
                  <div class="text-xl mb-1">📱</div>
                  <div class="text-xs font-normal text-muted">eSewa</div>
                </div>
                <div onclick="selPay(this,'KHALTI')"
                     class="pay-opt p-3 rounded border border-black/16 bg-transparent text-center cursor-pointer transition-all">
                  <div class="text-xl mb-1">💜</div>
                  <div class="text-xs font-normal text-muted">Khalti</div>
                </div>
              </div>
              <input type="hidden" id="selectedMethod" value="CASH">
            </div>
            <button id="processBtn" onclick="processPayment()"
                    class="w-full py-3 bg-forest text-white text-sm font-medium rounded hover:bg-forest-md transition-all"
                    disabled>
              Process Payment
            </button>
            <div id="paySuccess" class="hidden mt-4 bg-green-50 border border-green-200 text-green-800 text-sm px-4 py-3 rounded text-center">
              ✓ Payment processed successfully!
            </div>
          </div>

        </div>
      </div>
    </div>

  </div>
</div>
</div>

<script>
  const orderItemsData = {};
  <c:forEach items="${orders}" var="o">
    orderItemsData[${o.id}] = [
      <c:forEach items="${o.items}" var="i">
        { name: '<c:out value="${i.menuItemName}"/>', qty: ${i.quantity}, price: ${i.lineTotal} },
      </c:forEach>
    ];
  </c:forEach>

  const orderBillData = {
    <c:forEach items="${billMap}" var="entry">
      ${entry.key}: ${entry.value},
    </c:forEach>
  };

  let currentOrderId = null;
  let currentBillId  = null;
  let subtotal = 0, vatAmt = 0, svcAmt = 0;

  function loadBill(orderId, code, tableNum) {
    currentOrderId = orderId;
    currentBillId = orderBillData[orderId];
    document.getElementById('billDetailCard').classList.remove('hidden');
    document.getElementById('billCardTitle').textContent = 'Bill — ' + code + ' · ' + tableNum;
    
    const items = orderItemsData[orderId] || [];
    subtotal = items.reduce((a,i)=>a+i.price,0);
    document.getElementById('billItemsBody').innerHTML = items.map(i=>
            `<tr class="border-b border-black/5">
       <td class="px-6 py-3">${i.name}</td>
       <td class="px-6 py-3 text-right text-muted">×${i.qty}</td>
       <td class="px-6 py-3 text-right font-medium">Rs ${i.price.toLocaleString()}.00</td>
     </tr>`
    ).join('');
    recalc();
    document.getElementById('processBtn').disabled = false;
    document.getElementById('processBtn').classList.remove('opacity-50','cursor-not-allowed');
    document.getElementById('billDetailCard').scrollIntoView({behavior:'smooth', block:'start'});
  }

  function recalc() {
    const discPct = parseFloat(document.getElementById('discountPct').value)||0;
    const discAmt = Math.round(subtotal * discPct/100 * 100)/100;
    const base = subtotal - discAmt;
    vatAmt = Math.round(base * 0.13 * 100)/100;
    svcAmt = Math.round(base * 0.10 * 100)/100;
    const total = base + vatAmt + svcAmt;
    document.getElementById('subtotalVal').textContent = 'Rs ' + subtotal.toLocaleString() + '.00';
    document.getElementById('vatVal').textContent     = 'Rs ' + vatAmt.toFixed(2);
    document.getElementById('svcVal').textContent     = 'Rs ' + svcAmt.toFixed(2);
    document.getElementById('grandTotal').textContent = 'Rs ' + total.toLocaleString(undefined,{minimumFractionDigits:2});
    if(discAmt > 0) {
      document.getElementById('discountRow').classList.remove('hidden');
      document.getElementById('discountVal').textContent = '−Rs ' + discAmt.toFixed(2);
    } else {
      document.getElementById('discountRow').classList.add('hidden');
    }
  }

  function selPay(el, method) {
    document.querySelectorAll('.pay-opt').forEach(e => {
      e.className = e.className.replace(/border-forest|bg-forest\/8/g,'');
      e.classList.add('border-black/16','bg-transparent');
      const lbl = e.querySelector('div:last-child');
      if(lbl) { lbl.className='text-xs font-normal text-muted'; }
    });
    el.classList.remove('border-black/16','bg-transparent');
    el.classList.add('border-forest','bg-forest/8');
    const lbl = el.querySelector('div:last-child');
    if(lbl) { lbl.className='text-xs font-medium text-forest'; }
    document.getElementById('selectedMethod').value = method;
  }

  function processPayment() {
    if(!currentOrderId || !currentBillId) return alert('Select an order first.');
    const btn = document.getElementById('processBtn');
    btn.textContent = 'Processing…'; btn.disabled=true;
    
    const method = document.getElementById('selectedMethod').value;
    const discount = document.getElementById('discountPct').value || 0;
    
    const fd = new URLSearchParams();
    fd.append('orderId', currentOrderId);
    fd.append('billId', currentBillId);
    fd.append('method', method);
    fd.append('discountPct', discount);
    
    fetch('${pageContext.request.contextPath}/admin/payment/process', {
      method: 'POST',
      body: fd,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'}
    }).then(res => res.json())
      .then(data => {
         if (data.success) {
           document.getElementById('paySuccess').classList.remove('hidden');
           btn.textContent = '✓ Paid'; 
           btn.classList.replace('bg-forest','bg-green-700');
           setTimeout(() => location.reload(), 1500);
         } else {
           alert('Payment failed: ' + data.error);
           btn.textContent = 'Process Payment'; btn.disabled=false;
         }
      }).catch(err => {
         alert('Error processing payment.');
         btn.textContent = 'Process Payment'; btn.disabled=false;
      });
  }

  function applyInitialBillingQuery() {
    const params = new URLSearchParams(window.location.search);
    const table = params.get('table');
    if (!table) return;
    const targetRow = document.querySelector(`#billingOrdersTable tbody tr[data-table="${table}"] button`);
    if (targetRow) {
      targetRow.click();
    }
  }

  window.addEventListener('DOMContentLoaded', applyInitialBillingQuery);
</script>
</body>
</html>


