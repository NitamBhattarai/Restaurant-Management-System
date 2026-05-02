<%@ page contentType="text/html;charset=UTF-8" import="com.gokyo.model.*" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Kitchen Display"/>
<%@ include file="/pages/errorpages/header.jsp" %>

<!-- ╔═══════════════════════════════════════════════════════════╗
     ║  VIEW: kitchen/display.jsp                               ║
     ║  Controller: KitchenController.java                      ║
     ║  Model: Order.java, OrderItem.java                       ║
     ║  AJAX POST → /kitchen/update → JSON response            ║
     ╚═══════════════════════════════════════════════════════════╝ -->

<!-- TOP NAV — same brand, same height as every page -->
<nav class="bg-white/96 backdrop-blur-md border-b border-black/10 h-16 flex items-center justify-between px-8 sticky top-0 z-50">
  <div class="flex items-center gap-4">
    <a href="${pageContext.request.contextPath}/" class="font-serif text-xl font-bold text-ink">Gokyo Bistro</a>
    <div class="w-px h-5 bg-black/16"></div>
    <span class="text-xs uppercase tracking-widest font-medium text-muted">Kitchen Display</span>
  </div>
  <div class="flex items-center gap-4">
    <!-- Live indicator -->
    <div class="flex items-center gap-2 bg-forest/8 border border-forest/14 px-3 py-1.5 rounded-full">
      <div class="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse"></div>
      <span class="text-[10px] font-semibold uppercase tracking-widest text-forest">Live</span>
    </div>
    <span class="text-xs text-muted" id="staffName">${currentUser.fullName}</span>
    <span class="font-serif text-lg text-ink" id="clock">00:00</span>
    <a href="${pageContext.request.contextPath}/kitchen/logout"
       class="text-xs text-muted hover:text-forest transition-colors">Sign Out</a>
  </div>
</nav>

<!-- FILTER BAR — same pill button style as customer menu -->
<div class="bg-white border-b border-black/10 px-8 py-3 flex items-center gap-2.5 overflow-x-auto sticky top-16 z-40">
  <button class="flt-btn active px-5 py-1.5 rounded-full text-sm font-medium border border-black/16
                 bg-forest text-white transition-all" onclick="setFilter('ALL',this)">
    All <span class="bg-white/25 text-[10px] px-2 py-0.5 rounded-full ml-1" id="cnt-ALL">0</span>
  </button>
  <button class="flt-btn px-5 py-1.5 rounded-full text-sm font-medium border border-black/16
                 text-muted bg-transparent transition-all hover:text-ink" onclick="setFilter('PENDING',this)">
    Pending <span class="text-[10px] px-2 py-0.5 rounded-full ml-1 bg-black/8" id="cnt-PENDING">0</span>
  </button>
  <button class="flt-btn px-5 py-1.5 rounded-full text-sm font-medium border border-black/16
                 text-muted bg-transparent transition-all hover:text-ink" onclick="setFilter('PREPARING',this)">
    Preparing <span class="text-[10px] px-2 py-0.5 rounded-full ml-1 bg-black/8" id="cnt-PREPARING">0</span>
  </button>
  <button class="flt-btn px-5 py-1.5 rounded-full text-sm font-medium border border-black/16
                 text-muted bg-transparent transition-all hover:text-ink" onclick="setFilter('READY',this)">
    Ready <span class="text-[10px] px-2 py-0.5 rounded-full ml-1 bg-black/8" id="cnt-READY">0</span>
  </button>
</div>

<!-- ORDER TICKETS BOARD -->
<div class="p-6 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 min-h-screen bg-paper2" id="board">

  <c:choose>
    <c:when test="${empty orders}">
      <div class="col-span-full flex flex-col items-center justify-center py-24 text-muted">
        <div class="text-5xl mb-4 opacity-20">✓</div>
        <p class="text-sm font-light">No active orders. Kitchen is clear.</p>
      </div>
    </c:when>
    <c:otherwise>
      <c:forEach items="${orders}" var="o">
        <%-- Determine urgency class --%>
        <c:set var="ticketBorder" value="border-black/10"/>
        <c:set var="stripeColor"  value="#e8b44a"/>
        <c:if test="${o.status.name() == 'PREPARING'}">
          <c:set var="ticketBorder" value="border-orange-300/60"/>
          <c:set var="stripeColor"  value="#e8734a"/>
        </c:if>
        <c:if test="${o.status.name() == 'READY'}">
          <c:set var="ticketBorder" value="border-green-300/60"/>
          <c:set var="stripeColor"  value="#3aad6a"/>
        </c:if>

        <div class="ticket bg-white border ${ticketBorder} rounded-xl overflow-hidden flex flex-col
                    hover:shadow-md transition-all fade-up"
             data-status="${o.status.name()}" data-id="${o.id}">

          <!-- Top stripe — same 3px pattern as stat cards -->
          <div class="h-[3px] w-full" style="background:${stripeColor}"></div>

          <!-- Ticket header -->
          <div class="px-4 py-3 border-b border-black/8 flex items-start justify-between">
            <div>
              <div class="font-serif text-2xl font-medium text-ink
                          ${o.status.name() == 'READY' ? 'text-green-700' : ''}">
                ${o.tableNumber}
              </div>
              <span class="badge badge-${o.status.name().toLowerCase()} mt-1 inline-flex">${o.status}</span>
            </div>
            <div class="text-right">
              <div class="text-[11px] text-muted font-light">
                Placed ${not empty o.orderedAt ? fn:substring(o.orderedAt.toString(),11,16) : '—'}
              </div>
              <div class="text-sm font-semibold text-ink2 mt-0.5"
                   data-ordered="${o.orderedAt.toString()}">—</div>
              <div class="text-[10px] text-muted2 font-mono mt-0.5">${o.orderCode}</div>
            </div>
          </div>

          <!-- Items list -->
          <div class="px-4 py-3 flex-1">
            <c:forEach items="${o.items}" var="item">
              <div class="flex items-start justify-between py-1.5 border-b border-black/5 last:border-0">
                <div>
                  <div class="text-[13.5px] font-medium text-ink">${item.menuItemName}</div>
                  <c:if test="${not empty item.specialNote}">
                    <div class="text-[11px] text-muted font-light italic mt-0.5">${item.specialNote}</div>
                  </c:if>
                </div>
                <span class="font-serif text-lg font-medium text-forest ml-3 flex-shrink-0
                             ${o.status.name() == 'READY' ? '!text-green-700' : ''}">
                  ×${item.quantity}
                </span>
              </div>
            </c:forEach>
          </div>

          <!-- Action buttons -->
          <div class="px-4 py-3 border-t border-black/8 flex gap-2">
            <c:choose>
              <c:when test="${o.status.name() == 'PENDING'}">
                <button onclick="updateStatus(${o.id}, 'PREPARING', this)"
                        class="flex-1 py-2 text-xs font-medium rounded
                               bg-orange-50 border border-orange-300 text-orange-800
                               hover:bg-orange-500 hover:text-white hover:border-orange-500 transition-all">
                  Start Preparing
                </button>
              </c:when>
              <c:when test="${o.status.name() == 'PREPARING'}">
                <button onclick="updateStatus(${o.id}, 'READY', this)"
                        class="flex-1 py-2 text-xs font-medium rounded
                               bg-forest/8 border border-forest/20 text-forest
                               hover:bg-forest hover:text-white hover:border-forest transition-all">
                  Mark Ready
                </button>
              </c:when>
              <c:otherwise>
                <button class="flex-1 py-2 text-xs font-medium rounded bg-paper border border-black/10 text-muted cursor-default">
                  ✓ Ready to Serve
                </button>
              </c:otherwise>
            </c:choose>
          </div>

        </div>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</div>

<script>
// ── CONTROLLER: status updates (AJAX to KitchenController) ──
function updateStatus(orderId, newStatus, btn) {
  btn.disabled = true;
  btn.textContent = '…';
  fetch('${pageContext.request.contextPath}/kitchen/update', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'orderId=' + orderId + '&status=' + newStatus
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      // Update ticket visually
      const ticket = document.querySelector('[data-id="' + orderId + '"]');
      if (ticket) {
        ticket.dataset.status = newStatus;
        updateTicketVisuals(ticket, newStatus);
        updateCounts();
      }
    } else {
      btn.disabled = false;
      btn.textContent = 'Retry';
      alert('Update failed: ' + data.error);
    }
  })
  .catch(() => {
    btn.disabled = false;
    btn.textContent = 'Retry';
  });
}

function updateTicketVisuals(ticket, status) {
  const stripes = {PENDING:'#e8b44a', PREPARING:'#e8734a', READY:'#3aad6a', SERVED:'#4a80d0'};
  ticket.querySelector('.h-\\[3px\\]').style.background = stripes[status] || '#e8b44a';
  const actionDiv = ticket.querySelector('.px-4.py-3.border-t');
  if (status === 'READY') {
    actionDiv.innerHTML = `<button class="flex-1 py-2 text-xs font-medium rounded bg-paper border border-black/10 text-muted cursor-default">✓ Ready to Serve</button>`;
  }
  // Update badge
  const badge = ticket.querySelector('.badge');
  if (badge) {
    badge.className = 'badge badge-' + status.toLowerCase() + ' mt-1 inline-flex';
    badge.textContent = status;
  }
}

// ── Filter tickets ──
let currentFilter = 'ALL';
function setFilter(f, btn) {
  currentFilter = f;
  document.querySelectorAll('.flt-btn').forEach(b => {
    b.classList.remove('bg-forest','text-white','border-forest');
    b.classList.add('text-muted','border-black/16','bg-transparent');
  });
  btn.classList.remove('text-muted','border-black/16','bg-transparent');
  btn.classList.add('bg-forest','text-white','border-forest');
  document.querySelectorAll('.ticket').forEach(t => {
    t.style.display = (f === 'ALL' || t.dataset.status === f) ? '' : 'none';
  });
}

// ── Elapsed time display ──
function updateElapsed() {
  document.querySelectorAll('[data-ordered]').forEach(el => {
    const placed = new Date(el.dataset.ordered.replace('T',' '));
    const mins = Math.floor((Date.now() - placed.getTime()) / 60000);
    el.textContent = mins + 'm ago';
  });
}

// ── Count badges ──
function updateCounts() {
  const counts = {ALL:0, PENDING:0, PREPARING:0, READY:0};
  document.querySelectorAll('.ticket').forEach(t => {
    if (t.style.display !== 'none' || currentFilter === 'ALL') {
      counts.ALL++;
      counts[t.dataset.status] = (counts[t.dataset.status]||0) + 1;
    }
  });
  ['ALL','PENDING','PREPARING','READY'].forEach(k => {
    const el = document.getElementById('cnt-'+k);
    if (el) el.textContent = counts[k] || 0;
  });
}

// ── Live clock ──
function tick() {
  const n = new Date();
  document.getElementById('clock').textContent =
    n.toLocaleTimeString('en-US',{hour:'2-digit',minute:'2-digit',hour12:false});
}

setInterval(tick, 1000); tick();
setInterval(updateElapsed, 30000); updateElapsed();
updateCounts();
</script>
</body>
</html>


