<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Admin Login"/>
<%@ include file="/pages/errorpages/header.jsp" %>

<!-- ╔═════════════════════════════════════════╗
     ║  VIEW: admin/login.jsp                  ║
     ║  Controller: AuthController.java        ║
     ║  POST → /admin/login → dashboard        ║
     ╚═════════════════════════════════════════╝ -->

<div class="min-h-screen grid grid-cols-2">

  <!-- LEFT: Forest green editorial panel -->
  <div class="bg-forest relative flex flex-col justify-between p-14 overflow-hidden">
    <div class="absolute -top-24 -right-16 w-72 h-72 rounded-full bg-white/4 pointer-events-none"></div>
    <div class="absolute -bottom-16 -left-10 w-52 h-52 rounded-full bg-white/3 pointer-events-none"></div>

    <div class="relative z-10">
      <a href="${pageContext.request.contextPath}/" class="flex items-baseline gap-2 mb-16">
        <span class="font-serif text-xl font-bold text-white">Gokyo Bistro</span>
        <span class="text-[9px] uppercase tracking-widest text-white/35 font-medium">Management Portal</span>
      </a>
      <div class="text-[10px] uppercase tracking-widest text-white/35 mb-10 font-semibold">Restaurant Management</div>
      <h1 class="font-serif text-6xl font-normal text-white leading-none mb-6">
        Complete<br><em class="italic text-white/60">Control</em><br>of Your Bistro.
      </h1>
      <p class="text-sm font-light text-white/45 leading-relaxed max-w-sm">
        Everything you need to run a modern restaurant — from seasonal menu curation to real-time
        order intelligence and financial reporting.
      </p>
    </div>

    <div class="relative z-10 space-y-4">
      <c:forEach items="${['Menu Curation — Add, price and schedule seasonal items',
                           'Live Order Tracking — Full visibility across all tables',
                           'Automated Billing — VAT (13%), service charges and discounts',
                           'Revenue Reports — Daily, weekly and monthly analytics',
                           'Role Management — Admin, staff and kitchen access control']}" var="f">
        <div class="flex items-start gap-3">
          <div class="w-1 h-1 rounded-full bg-white/30 flex-shrink-0 mt-2"></div>
          <span class="text-xs font-light text-white/40 leading-relaxed">${f}</span>
        </div>
      </c:forEach>
    </div>
  </div>

  <!-- RIGHT: Login form — same bg as site -->
  <div class="bg-paper flex items-center justify-center px-16">
    <div class="w-full max-w-sm">

      <!-- Role badge -->
      <div class="inline-flex items-center gap-2 bg-forest/8 border border-forest/14 text-forest
                  text-[10px] font-semibold uppercase tracking-widest px-4 py-1.5 rounded-full mb-7">
        <div class="w-1.5 h-1.5 rounded-full bg-forest"></div>
        Admin Access
      </div>

      <h2 class="font-serif text-4xl font-normal mb-1">Sign In</h2>
      <p class="text-sm font-light text-muted mb-8 leading-relaxed">
        Enter your administrator credentials to access the management dashboard.
      </p>

      <!-- Error message -->
      <c:if test="${not empty error}">
        <div class="bg-red-50 border border-red-200 text-red-800 text-sm px-4 py-3 rounded mb-5">
          <c:out value="${error}"/>
        </div>
      </c:if>

      <!-- LOGIN FORM — POST to AuthController -->
      <form action="${pageContext.request.contextPath}/admin/login" method="POST">
        <div class="mb-4">
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Username</label>
          <input name="username" type="text" placeholder="admin"
                 class="gk-field w-full px-4 py-2.5 bg-white border border-black/10 rounded text-sm text-ink
                        placeholder-muted2 outline-none transition-colors"
                 autocomplete="username" required>
        </div>
        <div class="mb-6">
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Password</label>
          <div class="relative">
            <input name="password" id="pwdField" type="password" placeholder="Your password"
                   class="gk-field w-full px-4 py-2.5 pr-12 bg-white border border-black/10 rounded text-sm text-ink
                          placeholder-muted2 outline-none transition-colors"
                   autocomplete="current-password" required>
            <button type="button" onclick="togglePwd()" class="absolute right-3 top-1/2 -translate-y-1/2 text-muted2 hover:text-forest text-base">
              👁
            </button>
          </div>
        </div>
        <div class="flex items-center justify-between mb-7">
          <label class="flex items-center gap-2 cursor-pointer">
            <input type="checkbox" class="accent-forest w-3.5 h-3.5">
            <span class="text-sm font-light text-muted">Keep me signed in</span>
          </label>
          <span class="text-sm text-muted font-light border-b border-black/10 pb-0.5 cursor-pointer hover:text-forest hover:border-forest transition-colors">
            Forgot password?
          </span>
        </div>
        <button type="submit"
                class="w-full py-3 bg-forest text-white text-sm font-medium tracking-wide rounded
                       hover:bg-forest-md transition-all hover:-translate-y-px">
          Sign In to Dashboard
        </button>
      </form>

      <div class="flex items-center gap-3 my-6">
        <div class="flex-1 h-px bg-black/10"></div>
        <span class="text-[10px] uppercase tracking-widest text-muted2">or</span>
        <div class="flex-1 h-px bg-black/10"></div>
      </div>

      <p class="text-center text-sm text-muted font-light">
        Kitchen staff?
        <a href="${pageContext.request.contextPath}/kitchen/login"
           class="text-forest font-medium border-b border-forest/30 hover:border-forest transition-colors">
          Use Kitchen Login →
        </a>
      </p>

      <!-- Demo credentials hint -->
      <div class="mt-8 p-4 bg-paper2 rounded-lg border border-black/10">
        <p class="text-[9px] uppercase tracking-widest font-bold text-muted2 mb-2">Demo Credentials</p>
        <div class="flex gap-4 text-xs text-muted font-mono">
          <span>user: admin</span>
          <span>pass: admin123</span>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
function togglePwd(){
  const f=document.getElementById('pwdField');
  f.type = f.type==='password' ? 'text' : 'password';
}
</script>
</body>
</html>


