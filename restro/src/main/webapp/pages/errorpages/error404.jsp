<%-- ═══ 404 ERROR PAGE ═══ --%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Page Not Found"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<nav class="h-16 flex items-center px-12 bg-white/96 border-b border-black/10">
  <a href="${pageContext.request.contextPath}/" class="font-serif text-xl font-bold text-ink">Gokyo Bistro</a>
</nav>
<div class="min-h-[calc(100vh-64px)] flex flex-col items-center justify-center text-center px-4">
  <div class="font-serif text-8xl font-normal text-black/10 mb-4">404</div>
  <h1 class="font-serif text-3xl font-normal text-ink mb-3">Page Not Found</h1>
  <p class="text-sm font-light text-muted mb-8 max-w-sm leading-relaxed">
    The page you're looking for doesn't exist or has been moved.
  </p>
  <a href="${pageContext.request.contextPath}/"
     class="bg-forest text-white px-7 py-3 rounded text-sm font-medium hover:bg-forest-md transition-colors">
    ← Back to Home
  </a>
</div>
</body></html>


