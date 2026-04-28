<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Kitchen Login"/>
<%@ include file="/pages/errorpages/header.jsp" %>



<div class="min-h-screen grid grid-cols-2">

  <!-- LEFT: Same forest panel as admin login — consistent brand -->
  <div class="bg-forest relative flex flex-col justify-between p-14 overflow-hidden">
    <div class="absolute -top-24 -right-16 w-72 h-72 rounded-full bg-white/4 pointer-events-none"></div>
    <div class="absolute -bottom-16 -left-10 w-52 h-52 rounded-full bg-white/3 pointer-events-none"></div>
    <div class="relative z-10">
      <a href="${pageContext.request.contextPath}/" class="flex items-baseline gap-2 mb-16">
        <span class="font-serif text-xl font-bold text-white">Gokyo Bistro</span>
        <span class="text-[9px] uppercase tracking-widest text-white/35 font-medium">Kitchen Portal</span>
      </a>
      <div class="text-[10px] uppercase tracking-widest text-white/35 mb-10 font-semibold">Kitchen Access</div>
      <h1 class="font-serif text-6xl font-normal text-white leading-none mb-6">
        Kitchen<br><em class="italic text-white/60">Display</em><br>System
      </h1>
      <p class="text-sm font-light text-white/45 leading-relaxed max-w-sm">
        Enter your Staff ID and 4-digit PIN to access the live kitchen order board.
        Orders appear instantly as customers place them.
      </p>
    </div>
    <div class="relative z-10 space-y-4">
      <c:forEach items="${['Live Order Tickets — New orders appear the moment they are placed',
                           'Status Updates — Mark orders Pending, Preparing or Ready',
                           'Special Notes — Dietary and preparation instructions per item',
                           'Table Context — Each ticket shows table, waiter and time elapsed']}" var="f">
        <div class="flex items-start gap-3">
          <div class="w-1 h-1 rounded-full bg-white/30 flex-shrink-0 mt-2"></div>
          <span class="text-xs font-light text-white/40 leading-relaxed">${f}</span>
        </div>
      </c:forEach>
    </div>
  </div>

  <!-- RIGHT: Same light bg as rest of site -->
  <div class="bg-paper flex items-center justify-center px-14">
    <div class="w-full max-w-sm">

      <!-- Live indicator badge -->
      <div class="inline-flex items-center gap-2 bg-forest/8 border border-forest/14 text-forest
                  text-[10px] font-semibold uppercase tracking-widest px-4 py-1.5 rounded-full mb-7">
        <div class="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse"></div>
        Kitchen Staff Access
      </div>

      <h2 class="font-serif text-4xl font-normal mb-1">Kitchen<br>Sign In</h2>
      <p class="text-sm font-light text-muted mb-7 leading-relaxed">
        Enter your Staff ID and tap your PIN.
      </p>

      <c:if test="${not empty error}">
        <div class="bg-red-50 border border-red-200 text-red-800 text-sm px-4 py-3 rounded mb-5">
          <c:out value="${error}"/>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/kitchen/login" method="POST">
        <!-- Staff ID field -->
        <div class="mb-5">
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Staff ID</label>
          <input name="username" type="text" placeholder="e.g. sujal"
                 class="gk-field w-full px-4 py-2.5 bg-white border border-black/10 rounded text-sm text-ink
                        placeholder-muted2 outline-none transition-colors"
                 autocomplete="username" required>
        </div>

        <!-- PIN display dots — same card/border style as site -->
        <div class="mb-3">
          <div class="flex items-center justify-between mb-2">
            <label class="text-[10px] uppercase tracking-widest font-semibold text-muted">PIN</label>
            <button type="button" onclick="clearPin()"
                    class="text-[10px] uppercase tracking-widest font-medium text-muted
                           border-b border-black/10 hover:text-forest hover:border-forest transition-colors">
              Clear
            </button>
          </div>
          <div class="flex gap-2.5 justify-center mb-4">
            <c:forEach begin="0" end="3" var="i">
              <div id="pd${i}" class="w-14 h-14 bg-white border border-black/10 rounded-lg flex items-center
                                       justify-center font-serif text-2xl text-forest transition-all">—</div>
            </c:forEach>
          </div>
          <!-- Hidden input that holds actual PIN value -->
          <input type="hidden" name="password" id="pinValue">
        </div>

        <!-- PIN keypad — same white card style as site -->
        <div class="grid grid-cols-3 gap-2 mb-5">
          <c:forEach items="${[1,2,3,4,5,6,7,8,9]}" var="n">
            <button type="button" onclick="kp('${n}')"
                    class="py-3.5 bg-white border border-black/10 rounded text-lg font-normal text-ink
                           hover:border-forest hover:bg-forest/5 hover:text-forest active:scale-95 transition-all">
              ${n}
            </button>
          </c:forEach>
          <button type="button" onclick="clearPin()"
                  class="py-3.5 bg-white border border-black/10 rounded text-xs font-medium uppercase tracking-wide
                         text-muted hover:text-forest hover:border-forest transition-all">CLR</button>
          <button type="button" onclick="kp('0')"
                  class="py-3.5 bg-white border border-black/10 rounded text-lg font-normal text-ink
                         hover:border-forest hover:bg-forest/5 hover:text-forest active:scale-95 transition-all">0</button>
          <button type="button" onclick="backspace()"
                  class="py-3.5 bg-white border border-black/10 rounded text-sm font-medium text-muted
                         hover:text-forest hover:border-forest transition-all">⌫</button>
        </div>

        <!-- Divider -->
        <div class="flex items-center gap-3 mb-4">
          <div class="flex-1 h-px bg-black/10"></div>
          <span class="text-[10px] uppercase tracking-widest text-muted2">or use password</span>
          <div class="flex-1 h-px bg-black/10"></div>
        </div>

        <!-- Password field alternative -->
        <div class="mb-6">
          <input name="altpassword" type="password" placeholder="Staff password"
                 class="gk-field w-full px-4 py-2.5 bg-white border border-black/10 rounded text-sm text-ink
                        placeholder-muted2 outline-none transition-colors"
                 autocomplete="current-password">
        </div>

        <button type="submit"
                class="w-full py-3 bg-forest text-white text-sm font-medium tracking-wide rounded
                       hover:bg-forest-md transition-all hover:-translate-y-px">
          Access Kitchen Display
        </button>
      </form>

      <p class="text-center text-sm text-muted font-light mt-6">
        Administrator?
        <a href="${pageContext.request.contextPath}/admin/login"
           class="text-forest font-medium border-b border-forest/30 hover:border-forest transition-colors">
          Use Admin Login →
        </a>
      </p>

      <!-- Demo credentials -->
      <div class="mt-6 p-4 bg-paper2 rounded-lg border border-black/10">
        <p class="text-[9px] uppercase tracking-widest font-bold text-muted2 mb-2">Demo Credentials</p>
        <div class="flex flex-wrap gap-4 text-xs text-muted font-mono">
          <span>ID: sujal</span><span>PIN: (use keypad or password field)</span><span>pass: kitchen123</span>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
let pin = [];
function kp(k) {
  if (pin.length >= 9) return;
  pin.push(k);
  updateDisplay();
}
function backspace() {
  pin.pop();
  updateDisplay();
}
function clearPin() {
  pin = [];
  updateDisplay();
}
function updateDisplay() {
  for (let i = 0; i < 9; i++) {
    const d = document.getElementById('pd' + i);
    if (pin[i] !== undefined) {
      d.textContent = '●';
      d.classList.add('bg-forest/8', 'border-forest/25');
      d.classList.remove('border-black/10');
    } else {
      d.textContent = '—';
      d.classList.remove('bg-forest/8', 'border-forest/25');
      d.classList.add('border-black/10');
    }
    d.classList.toggle('border-forest', i === pin.length);
    d.classList.toggle('ring-2', i === pin.length);
    d.classList.toggle('ring-forest/20', i === pin.length);
  }
  document.getElementById('pinValue').value = pin.join('');
}
// Allow keyboard entry
document.addEventListener('keydown', e => {
  const active = document.activeElement;
  if (active && (active.name === 'username' || active.name === 'altpassword')) return;
  if (/^[0-9]$/.test(e.key)) kp(e.key);
  else if (e.key === 'Backspace') backspace();
});
</script>
</body>
</html>


