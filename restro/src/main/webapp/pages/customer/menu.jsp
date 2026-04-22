<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*,java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Menu"/>
<%@ include file="/pages/errorpages/header.jsp" %>

<style>
  body { background: #fbfaf7; color: #18342c; padding-bottom: 72px; }
  .menu-shell { max-width: 1440px; margin: 0 auto; padding: 12px 12px 92px; }
  .topbar, .brand-row, .nav-row, .toolbar-row, .chip-row, .order-summary, .order-actions, .sheet-item, .footer-links { display: flex; align-items: center; gap: 14px; }
  .topbar { min-height: 78px; justify-content: space-between; margin-bottom: 10px; padding: 0 2px; }
  .brand-mark { font-size: 20px; font-weight: 700; color: #16372d; text-decoration: none; }
  .nav-link { font-size: 15px; font-weight: 600; color: #7a867f; text-decoration: none; padding: 10px 0; border-bottom: 2px solid transparent; }
  .nav-link.active { color: #18342c; border-bottom-color: #2a6d57; }
  .search-shell { display: flex; align-items: center; gap: 8px; background: #f4f3ef; border: 1px solid #ece8df; border-radius: 999px; padding: 10px 14px; min-width: 240px; }
  .search-shell input { border: 0; background: transparent; width: 100%; outline: none; font-size: 12px; color: #50635a; }
  .toolbar-icon, .avatar-dot { width: 30px; height: 30px; border-radius: 999px; display: inline-flex; align-items: center; justify-content: center; background: #f4f3ef; border: 1px solid #ece8df; color: #60776d; font-size: 14px; font-weight: 700; }
  .hero-panel { position: relative; min-height: 290px; border-radius: 8px; overflow: hidden; background: linear-gradient(90deg, rgba(19,27,24,.88) 0%, rgba(19,27,24,.52) 48%, rgba(19,27,24,.22) 100%), radial-gradient(circle at 18% 75%, rgba(248,230,194,.35), transparent 22%), radial-gradient(circle at 82% 25%, rgba(242,214,172,.28), transparent 18%), linear-gradient(135deg, #2d3c37 0%, #151d1a 100%); margin-bottom: 22px; }
  .hero-panel::before, .hero-panel::after { content: ""; position: absolute; bottom: 28px; width: 118px; height: 118px; border-radius: 50%; background: radial-gradient(circle at 50% 30%, #d2c7b4, #756e64 62%, #383632 100%); box-shadow: 0 18px 28px rgba(0,0,0,.24); }
  .hero-panel::before { left: 58px; }
  .hero-panel::after { right: 58px; }
  .hero-frame { position: absolute; inset: 22px auto auto 50%; transform: translateX(-50%); width: 210px; height: 112px; border: 6px solid #12443b; background: linear-gradient(180deg, rgba(214,162,101,.8), rgba(165,106,67,.4)), #c9854e; box-shadow: 0 10px 20px rgba(0,0,0,.18); }
  .hero-copy { position: absolute; left: 38px; bottom: 34px; max-width: 420px; color: #f9f7f0; }
  .hero-copy h1 { margin: 0 0 8px; font-family: "Playfair Display", Georgia, serif; font-size: 46px; font-weight: 700; line-height: 1; }
  .hero-copy p { margin: 0; font-size: 13px; line-height: 1.55; color: rgba(249,247,240,.78); max-width: 370px; }
  .chip-row { flex-wrap: wrap; margin-bottom: 28px; }
  .chip { appearance: none; border: 1px solid #e7e1d6; background: #fff; color: #7b867f; border-radius: 999px; padding: 10px 18px; font-size: 12px; font-weight: 600; cursor: pointer; transition: .18s ease; }
  .chip.active { background: #1f6b55; border-color: #1f6b55; color: #fff; }
  .menu-section { margin-bottom: 40px; }
  .section-head { display: flex; align-items: flex-end; justify-content: space-between; gap: 12px; margin-bottom: 18px; }
  .section-label { margin: 0 0 4px; color: #84a394; font-size: 10px; letter-spacing: .14em; text-transform: uppercase; font-weight: 700; }
  .section-title { margin: 0; font-family: "Playfair Display", Georgia, serif; font-size: 38px; line-height: 1; color: #1a4d3e; }
  .section-note { color: #b9c2bc; font-size: 11px; font-weight: 600; white-space: nowrap; }
  .feature-grid { display: grid; grid-template-columns: 1.3fr 1fr 1fr; gap: 14px; margin-bottom: 18px; }
  .mini-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 14px; }
  .split-grid { display: grid; grid-template-columns: 1.45fr .9fr; gap: 22px; align-items: start; }
  .menu-card { background: #fff; border: 1px solid #efe8df; border-radius: 6px; overflow: hidden; box-shadow: 0 1px 0 rgba(27,47,39,.02); transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease; }
  .menu-card:hover { transform: translateY(-2px); box-shadow: 0 16px 28px rgba(20,43,35,.08); border-color: #ded4c7; }
  .menu-card.dark { background: linear-gradient(180deg, #0f4e40 0%, #0d3d32 100%); border-color: #0f4e40; color: #fff; }
  .card-horizontal { display: grid; grid-template-columns: 1.05fr 1.4fr; min-height: 164px; }
  .card-visual, .card-visual-small { position: relative; overflow: hidden; }
  .card-visual { min-height: 100%; background: radial-gradient(circle at 50% 45%, rgba(255,210,132,.95), rgba(171,116,56,.85) 48%, rgba(74,48,22,.9) 78%), linear-gradient(180deg, #4c3520, #22160b); }
  .card-visual-small { height: 120px; background: radial-gradient(circle at 40% 35%, rgba(255,220,160,.92), rgba(201,145,84,.78) 50%, rgba(84,54,24,.95) 84%), linear-gradient(160deg, #4b3320, #18110c); }
  .card-visual-green { background: radial-gradient(circle at 50% 45%, rgba(155,224,170,.78), rgba(30,101,76,.92) 48%, rgba(8,46,38,1) 82%), linear-gradient(160deg, #10493b, #06261f); }
  .card-visual-pink { background: radial-gradient(circle at 50% 45%, rgba(255,232,230,.98), rgba(238,204,200,.92) 46%, rgba(207,145,133,.85) 74%), linear-gradient(180deg, #f6d7d2, #e5b6aa); }
  .card-visual-dark { background: radial-gradient(circle at 50% 40%, rgba(116,70,47,.85), rgba(49,24,14,.95) 55%, rgba(17,11,9,1) 82%), linear-gradient(180deg, #2b1b16, #110c0b); }
  .plate { position: absolute; inset: 18px; border-radius: 50%; background: radial-gradient(circle at 50% 48%, rgba(255,255,255,.98), rgba(221,216,208,.92) 56%, rgba(172,164,154,.76) 70%, rgba(85,77,71,.44) 100%); box-shadow: inset 0 0 0 10px rgba(255,255,255,.3); }
  .plate::after { content: attr(data-emoji); position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; font-size: 52px; filter: drop-shadow(0 8px 10px rgba(0,0,0,.14)); }
  .plate.small::after { font-size: 42px; }
  .card-body { display: flex; flex-direction: column; justify-content: space-between; gap: 10px; padding: 18px 18px 16px; }
  .card-title { margin: 0 0 6px; font-size: 16px; font-weight: 700; color: inherit; }
  .card-desc { margin: 0; color: #8e9892; font-size: 11px; line-height: 1.55; min-height: 34px; }
  .dark .card-desc { color: rgba(255,255,255,.72); }
  .card-meta { display: flex; align-items: center; justify-content: space-between; gap: 10px; }
  .price-tag { display: inline-flex; align-items: center; gap: 7px; color: #1f6b55; font-size: 12px; font-weight: 800; }
  .price-tag::before { content: ""; width: 4px; height: 16px; border-radius: 999px; background: #1f6b55; }
  .dark .price-tag { color: #fff; }
  .dark .price-tag::before { background: #8fe1b9; }
  .qty-shell { display: inline-flex; align-items: center; gap: 8px; background: #f5f1eb; border-radius: 999px; padding: 4px; }
  .dark .qty-shell { background: rgba(255,255,255,.08); }
  .qty-btn { width: 24px; height: 24px; border: 0; border-radius: 999px; background: #fff; color: #1b4738; font-weight: 800; cursor: pointer; }
  .dark .qty-btn { background: rgba(255,255,255,.18); color: #fff; }
  .qty-pill { min-width: 18px; text-align: center; font-size: 12px; font-weight: 700; }
  .wine-panel { background: linear-gradient(180deg, #0e4e40 0%, #0a3d32 100%); border-radius: 6px; padding: 18px; color: #fff; border: 1px solid #0f4e40; }
  .wine-item { display: flex; justify-content: space-between; gap: 12px; padding: 14px 0; border-bottom: 1px solid rgba(255,255,255,.08); }
  .wine-item:last-of-type { border-bottom: 0; }
  .wine-name { margin: 0 0 4px; font-size: 12px; font-weight: 700; }
  .wine-note { margin: 0; font-size: 10px; line-height: 1.5; color: rgba(255,255,255,.68); }
  .wine-price { font-size: 12px; font-weight: 800; white-space: nowrap; }
  .wine-btn { width: 100%; border: 0; background: #36d191; color: #103128; font-weight: 800; font-size: 12px; border-radius: 6px; padding: 14px 16px; margin-top: 16px; cursor: pointer; }
  .footer-row { display: grid; grid-template-columns: 1.45fr 0.9fr 1.05fr 0.95fr; gap: 40px; margin-top: 44px; padding: 26px 0 0; border-top: 1px solid #eee7dc; color: #8c968f; font-size: 12px; }
  .footer-brand { color: #215747; font-weight: 700; margin-bottom: 8px; }
  .footer-title { margin-bottom: 8px; color: #16372d; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; font-size: 9px; }
  .footer-links-col { display: grid; gap: 6px; }
  .footer-links-col a { color: inherit; text-decoration: none; }
  .footer-bottom { margin-top: 18px; padding: 12px 0 0; border-top: 1px solid #f0ebe3; display: flex; align-items: center; justify-content: space-between; gap: 14px; color: #b1b8b3; font-size: 10px; }
  .footer-meta { display: flex; align-items: center; gap: 18px; }
  .footer-meta a { color: inherit; text-decoration: none; }
  .order-bar { position: fixed; left: 50%; bottom: 22px; transform: translateX(-50%); width: min(92vw, 1120px); background: rgba(17,48,39,.96); color: #fff; border-radius: 10px; box-shadow: 0 22px 38px rgba(9,29,24,.18); padding: 14px 18px; display: flex; align-items: center; justify-content: space-between; gap: 18px; z-index: 55; opacity: .45; pointer-events: none; transition: .18s ease; }
  .order-bar.ready { opacity: 1; pointer-events: auto; }
  .order-kpi strong { display: block; font-size: 11px; text-transform: uppercase; letter-spacing: .14em; color: rgba(255,255,255,.64); }
  .order-kpi span { font-size: 22px; font-weight: 800; }
  .ghost-btn, .primary-btn { border: 0; border-radius: 999px; padding: 12px 18px; font-size: 12px; font-weight: 800; cursor: pointer; }
  .ghost-btn { background: rgba(255,255,255,.1); color: #fff; }
  .primary-btn { background: #36d191; color: #103128; }
  .sheet { position: fixed; inset: auto 0 0 0; background: #fff; border-radius: 22px 22px 0 0; max-width: 720px; margin: 0 auto; max-height: 84vh; transform: translateY(105%); transition: transform .22s ease; z-index: 80; box-shadow: 0 -18px 30px rgba(15,40,33,.12); display: flex; flex-direction: column; }
  .sheet.open { transform: translateY(0); }
  .sheet-top { display: flex; justify-content: space-between; align-items: center; padding: 18px 22px; border-bottom: 1px solid #ede7dd; }
  .sheet-top h3 { margin: 0; font-family: "Playfair Display", Georgia, serif; font-size: 28px; }
  .sheet-close { border: 0; background: transparent; color: #7b867f; font-size: 22px; cursor: pointer; }
  .sheet-body { padding: 0 22px; overflow: auto; }
  .sheet-foot { padding: 18px 22px 22px; border-top: 1px solid #ede7dd; background: #faf8f3; }
  .sheet-row { display: flex; justify-content: space-between; gap: 12px; padding: 14px 0; border-bottom: 1px solid #f0ebe4; }
  .sheet-row:last-child { border-bottom: 0; }
  .sheet-emoji { width: 42px; height: 42px; border-radius: 50%; background: #f4efe7; display: inline-flex; align-items: center; justify-content: center; font-size: 22px; }
  .sheet-name { font-size: 13px; font-weight: 700; color: #18342c; }
  .sheet-sub { color: #839089; font-size: 11px; }
  .sheet-total { font-size: 13px; font-weight: 800; color: #18342c; white-space: nowrap; }
  .backdrop { position: fixed; inset: 0; background: rgba(17,33,28,.35); backdrop-filter: blur(3px); z-index: 70; display: none; }
  .backdrop.show { display: block; }
  .empty-state { padding: 40px 0; text-align: center; color: #819088; font-size: 13px; }
  .toast { position: fixed; top: 24px; left: 50%; transform: translate(-50%, -140%); background: #1f6b55; color: #fff; border-radius: 999px; padding: 12px 18px; font-size: 12px; font-weight: 800; text-transform: uppercase; letter-spacing: .1em; transition: .24s ease; z-index: 95; }
  .toast.show { transform: translate(-50%, 0); }
  @media (max-width: 1024px) { .feature-grid, .mini-grid, .split-grid { grid-template-columns: 1fr; } .card-horizontal { grid-template-columns: 1fr; } .card-visual { min-height: 180px; } }
  @media (max-width: 760px) { .menu-shell { padding: 14px 10px 128px; } .topbar { flex-direction: column; align-items: stretch; padding: 0; } .brand-row, .nav-row, .toolbar-row { flex-wrap: wrap; } .hero-panel { min-height: 280px; } .hero-panel::before, .hero-panel::after, .hero-frame { display: none; } .hero-copy { left: 22px; right: 22px; bottom: 24px; max-width: none; } .hero-copy h1 { font-size: 34px; } .section-title { font-size: 32px; } .footer-row { grid-template-columns: 1fr; gap: 18px; } .footer-bottom { flex-direction: column; align-items: flex-start; } .order-bar { width: calc(100vw - 20px); bottom: 10px; border-radius: 14px; padding: 14px; flex-direction: column; align-items: stretch; } .order-actions { width: 100%; } .ghost-btn, .primary-btn { flex: 1; } }
</style>

<%
  Map<?, ?> rawMenuByCategory = (Map<?, ?>) request.getAttribute("menuByCategory");
  java.util.List<java.util.Map.Entry<?, ?>> categoryEntries = new java.util.ArrayList<>();
  if (rawMenuByCategory != null) categoryEntries.addAll(rawMenuByCategory.entrySet());
  request.setAttribute("categoryEntries", categoryEntries);
%>

<c:set var="previewMode" value="${previewMode == true}"/>
<c:choose>
  <c:when test="${not empty table}">
    <c:set var="menuHref" value="${pageContext.request.contextPath}/customer/menu?table=${table.qrToken}"/>
    <c:set var="billHref" value="${pageContext.request.contextPath}/customer/bill?tableId=${table.id}"/>
    <c:set var="tableLabel" value="${table.tableNumber}"/>
  </c:when>
  <c:otherwise>
    <c:set var="menuHref" value="${pageContext.request.contextPath}/customer/menu"/>
    <c:set var="billHref" value="${pageContext.request.contextPath}/customer/scan"/>
    <c:set var="tableLabel" value="Preview"/>
  </c:otherwise>
</c:choose>

<div class="menu-shell">
  <div class="topbar">
    <div class="brand-row">
      <a href="${pageContext.request.contextPath}/" class="brand-mark">Gokyo Bistro</a>
      <div class="nav-row">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
        <a href="${menuHref}" class="nav-link active">Menu</a>
        <a href="${pageContext.request.contextPath}/customer/scan" class="nav-link">Scan QR</a>
        <a href="${pageContext.request.contextPath}/admin/login" class="nav-link">Admin</a>
      </div>
    </div>
    <div class="toolbar-row">
      <div class="search-shell">
        <span>S</span>
        <input type="text" placeholder="Search menu..." oninput="filterMenu(this.value)">
      </div>
      <span class="toolbar-icon">o</span>
      <span class="toolbar-icon">o</span>
      <a href="${pageContext.request.contextPath}/admin/login" class="nav-link">Login</a>
      <a href="${pageContext.request.contextPath}/customer/scan" class="primary-btn" style="padding: 12px 18px; text-decoration:none;">Scan QR</a>
    </div>
  </div>

  <c:if test="${previewMode}">
    <div style="margin: 0 0 18px; padding: 14px 16px; background: #eef6f1; border: 1px solid #d4e9dd; color: #215747; font-size: 12px; font-weight: 600;">
      Browse mode: you can view the full menu without scanning a QR code, but you must scan a table QR before you can order.
      <a href="${pageContext.request.contextPath}/customer/scan" style="margin-left: 8px; text-decoration: underline; color: #1f6b55;">Scan QR</a>
    </div>
  </c:if>

  <section class="hero-panel">
    <div class="hero-frame"></div>
    <div class="hero-copy">
      <h1>Our Culinary Story</h1>
      <p>A harmonious blend of Himalayan heritage and contemporary fine dining. Each dish is a canvas of seasonal ingredients and ancestral craftsmanship.</p>
    </div>
  </section>

  <div class="chip-row">
    <button type="button" class="chip active" onclick="scrollToSection('section-0', this)">Full Menu</button>
    <c:forEach items="${categoryEntries}" var="entry" varStatus="status">
      <button type="button" class="chip" onclick="scrollToSection('section-${status.index}', this)"><c:out value="${entry.key}"/></button>
    </c:forEach>
  </div>

  <c:choose>
    <c:when test="${empty categoryEntries}">
      <div class="empty-state">No menu items are available right now.</div>
    </c:when>
    <c:otherwise>
      <c:forEach items="${categoryEntries}" var="entry" varStatus="sectionStatus">
        <c:set var="items" value="${entry.value}"/>
        <section class="menu-section" id="section-${sectionStatus.index}">
          <div class="section-head">
            <div>
              <p class="section-label">
                <c:choose>
                  <c:when test="${sectionStatus.index == 0}">Small Plates</c:when>
                  <c:when test="${sectionStatus.index == 1}">Entrees</c:when>
                  <c:when test="${sectionStatus.index == 2}">Sweet Finish</c:when>
                  <c:otherwise>Selections</c:otherwise>
                </c:choose>
              </p>
              <h2 class="section-title"><c:out value="${entry.key}"/></h2>
            </div>
            <div class="section-note">
              <c:choose>
                <c:when test="${sectionStatus.index == 0}">Starting from Rs 350</c:when>
                <c:when test="${sectionStatus.index == 1}">Signature Selections</c:when>
                <c:when test="${sectionStatus.index == 2}">Vintage Cellar</c:when>
                <c:otherwise>Chef Curated</c:otherwise>
              </c:choose>
            </div>
          </div>

          <c:choose>
            <c:when test="${sectionStatus.index == 0}">
              <div class="feature-grid">
                <c:forEach items="${items}" var="item" begin="0" end="2" varStatus="itemStatus">
                  <c:choose>
                    <c:when test="${itemStatus.index == 0}">
                      <article class="menu-card menu-item card-horizontal" data-item-id="${item.id}" data-item-name="${fn:escapeXml(item.name)}" data-item-price="${item.price}" data-item-emoji="${fn:escapeXml(item.emoji)}" data-search-text="${fn:toLowerCase(item.name)} ${fn:toLowerCase(item.description)}">
                        <div class="card-visual"><div class="plate" data-emoji="${empty item.emoji ? 'M' : item.emoji}"></div></div>
                        <div class="card-body">
                          <div><h3 class="card-title"><c:out value="${item.name}"/></h3><p class="card-desc"><c:out value="${item.description}"/></p></div>
                          <div class="card-meta"><span class="price-tag">Rs <fmt:formatNumber value="${item.price}" pattern="#,##0"/></span><div class="qty-shell"><button type="button" class="qty-btn" onclick="adjFromButton(this, -1)">-</button><span class="qty-pill" id="q${item.id}">0</span><button type="button" class="qty-btn" onclick="adjFromButton(this, 1)">+</button></div></div>
                        </div>
                      </article>
                    </c:when>
                    <c:otherwise>
                      <article class="menu-card menu-item ${itemStatus.index == 2 ? 'dark' : ''}" data-item-id="${item.id}" data-item-name="${fn:escapeXml(item.name)}" data-item-price="${item.price}" data-item-emoji="${fn:escapeXml(item.emoji)}" data-search-text="${fn:toLowerCase(item.name)} ${fn:toLowerCase(item.description)}">
                        <div class="card-visual-small ${itemStatus.index == 2 ? 'card-visual-green' : ''}"><div class="plate small" data-emoji="${empty item.emoji ? 'M' : item.emoji}"></div></div>
                        <div class="card-body">
                          <div><h3 class="card-title"><c:out value="${item.name}"/></h3><p class="card-desc"><c:out value="${item.description}"/></p></div>
                          <div class="card-meta"><span class="price-tag">Rs <fmt:formatNumber value="${item.price}" pattern="#,##0"/></span><div class="qty-shell"><button type="button" class="qty-btn" onclick="adjFromButton(this, -1)">-</button><span class="qty-pill" id="q${item.id}">0</span><button type="button" class="qty-btn" onclick="adjFromButton(this, 1)">+</button></div></div>
                        </div>
                      </article>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </div>
              <div class="mini-grid">
                <c:forEach items="${items}" var="item" begin="3">
                  <article class="menu-card menu-item" data-item-id="${item.id}" data-item-name="${fn:escapeXml(item.name)}" data-item-price="${item.price}" data-item-emoji="${fn:escapeXml(item.emoji)}" data-search-text="${fn:toLowerCase(item.name)} ${fn:toLowerCase(item.description)}">
                    <div class="card-visual-small"><div class="plate small" data-emoji="${empty item.emoji ? 'M' : item.emoji}"></div></div>
                    <div class="card-body">
                      <div><h3 class="card-title"><c:out value="${item.name}"/></h3><p class="card-desc"><c:out value="${item.description}"/></p></div>
                      <div class="card-meta"><span class="price-tag">Rs <fmt:formatNumber value="${item.price}" pattern="#,##0"/></span><div class="qty-shell"><button type="button" class="qty-btn" onclick="adjFromButton(this, -1)">-</button><span class="qty-pill" id="q${item.id}">0</span><button type="button" class="qty-btn" onclick="adjFromButton(this, 1)">+</button></div></div>
                    </div>
                  </article>
                </c:forEach>
              </div>
            </c:when>
            <c:when test="${sectionStatus.index == 1}">
              <div class="mini-grid">
                <c:forEach items="${items}" var="item">
                  <article class="menu-card menu-item" data-item-id="${item.id}" data-item-name="${fn:escapeXml(item.name)}" data-item-price="${item.price}" data-item-emoji="${fn:escapeXml(item.emoji)}" data-search-text="${fn:toLowerCase(item.name)} ${fn:toLowerCase(item.description)}">
                    <div class="card-horizontal">
                      <div class="card-visual-small card-visual-dark"><div class="plate small" data-emoji="${empty item.emoji ? 'M' : item.emoji}"></div></div>
                      <div class="card-body">
                        <div><h3 class="card-title"><c:out value="${item.name}"/></h3><p class="card-desc"><c:out value="${item.description}"/></p></div>
                        <div class="card-meta"><span class="price-tag">Rs <fmt:formatNumber value="${item.price}" pattern="#,##0"/></span><div class="qty-shell"><button type="button" class="qty-btn" onclick="adjFromButton(this, -1)">-</button><span class="qty-pill" id="q${item.id}">0</span><button type="button" class="qty-btn" onclick="adjFromButton(this, 1)">+</button></div></div>
                      </div>
                    </div>
                  </article>
                </c:forEach>
              </div>
            </c:when>
            <c:otherwise>
              <div class="split-grid">
                <div class="mini-grid">
                  <c:forEach items="${items}" var="item">
                    <article class="menu-card menu-item" data-item-id="${item.id}" data-item-name="${fn:escapeXml(item.name)}" data-item-price="${item.price}" data-item-emoji="${fn:escapeXml(item.emoji)}" data-search-text="${fn:toLowerCase(item.name)} ${fn:toLowerCase(item.description)}">
                      <div class="card-visual-small ${sectionStatus.index == 2 ? 'card-visual-pink' : ''}"><div class="plate small" data-emoji="${empty item.emoji ? 'D' : item.emoji}"></div></div>
                      <div class="card-body">
                        <div><h3 class="card-title"><c:out value="${item.name}"/></h3><p class="card-desc"><c:out value="${item.description}"/></p></div>
                        <div class="card-meta"><span class="price-tag">Rs <fmt:formatNumber value="${item.price}" pattern="#,##0"/></span><div class="qty-shell"><button type="button" class="qty-btn" onclick="adjFromButton(this, -1)">-</button><span class="qty-pill" id="q${item.id}">0</span><button type="button" class="qty-btn" onclick="adjFromButton(this, 1)">+</button></div></div>
                      </div>
                    </article>
                  </c:forEach>
                </div>
                <aside class="wine-panel">
                  <p class="section-label" style="color: rgba(255,255,255,.56); margin-top: 0;">Vintage</p>
                  <h3 style="margin: 0 0 10px; font-family: 'Playfair Display', Georgia, serif; font-size: 34px;">Cellar</h3>
                  <div class="wine-item"><div><p class="wine-name">Chianti Riserva 2015</p><p class="wine-note">Dark cherry, tobacco and polished tannins.</p></div><span class="wine-price">Rs 10,500</span></div>
                  <div class="wine-item"><div><p class="wine-name">Cloudy Bay Sauvignon Blanc</p><p class="wine-note">Citrus blossom with bright mineral lift.</p></div><span class="wine-price">Rs 8,400</span></div>
                  <div class="wine-item"><div><p class="wine-name">Dom Perignon Vintage</p><p class="wine-note">Fine mousse, brioche and orchard fruit.</p></div><span class="wine-price">Rs 35,000</span></div>
                  <div class="wine-item"><div><p class="wine-name">Gokyo Reserve Merlot</p><p class="wine-note">House cellar pick with soft cedar finish.</p></div><span class="wine-price">Rs 4,500</span></div>
                  <button type="button" class="wine-btn" onclick="openSheet()">View Full Wine List</button>
                </aside>
              </div>
            </c:otherwise>
          </c:choose>
        </section>
      </c:forEach>
    </c:otherwise>
  </c:choose>

  <div class="footer-row">
    <div>
      <div class="footer-brand">Gokyo Bistro</div>
      <div>Elevating Himalayan ingredients through composed modern tasting menus and warm hospitality.</div>
    </div>
    <div>
      <div class="footer-title">Connect</div>
      <div class="footer-links-col">
        <a href="#">Instagram</a>
        <a href="#">Facebook</a>
        <a href="#">X / Twitter</a>
      </div>
    </div>
    <div>
      <div class="footer-title">Visit</div>
      <div class="footer-links-col">
        <span>Durbar Marg, Kathmandu, Nepal</span>
        <span>Open daily 11:00 AM - 11:00 PM</span>
        <span>+977 1 5555555</span>
      </div>
    </div>
    <div>
      <div class="footer-title">Access</div>
      <div class="footer-links-col">
        <a href="${pageContext.request.contextPath}/customer/menu">Menu</a>
        <a href="${pageContext.request.contextPath}/customer/scan">Scan QR</a>
        <a href="${pageContext.request.contextPath}/admin/login">Login</a>
      </div>
    </div>
  </div>
  <div class="footer-bottom">
    <span>&copy; 2026 Gokyo Bistro. All Rights Reserved.</span>
    <div class="footer-meta">
      <a href="${pageContext.request.contextPath}/customer/menu">Menu</a>
      <a href="${pageContext.request.contextPath}/customer/scan">Scan QR</a>
    </div>
  </div>
</div>

<div id="backdrop" class="backdrop" onclick="closeSheet()"></div>
<div id="sheet" class="sheet">
  <div class="sheet-top"><h3>Your Order</h3><button type="button" class="sheet-close" onclick="closeSheet()">x</button></div>
  <div id="sheetBody" class="sheet-body"></div>
  <div id="sheetFoot" class="sheet-foot"></div>
</div>

<div id="orderBar" class="order-bar">
  <div class="order-summary">
    <div class="order-kpi"><strong>Table</strong><span>${tableLabel}</span></div>
    <div class="order-kpi"><strong>Items</strong><span id="barCount">0</span></div>
    <div class="order-kpi"><strong>Total</strong><span id="barAmount">Rs 0</span></div>
  </div>
  <div class="order-actions">
    <button type="button" class="ghost-btn" onclick="openSheet()">Review Order</button>
    <button type="button" class="primary-btn" onclick="placeOrder()">${previewMode ? 'Scan QR to Order' : 'Place Order'}</button>
  </div>
</div>

<div id="toast" class="toast">Order placed successfully</div>

<script>
const cart = {};
const tableId = '${not empty table ? table.id : ""}';
const canOrder = ${previewMode ? 'false' : 'true'};

function filterMenu(query) {
  const normalized = String(query || '').toLowerCase().trim();
  document.querySelectorAll('.menu-item').forEach((card) => {
    const haystack = (card.dataset.searchText || '').toLowerCase();
    card.style.display = !normalized || haystack.includes(normalized) ? '' : 'none';
  });
}

function scrollToSection(sectionId, btn) {
  document.querySelectorAll('.chip').forEach((chip) => chip.classList.remove('active'));
  if (btn) btn.classList.add('active');
  const target = document.getElementById(sectionId);
  if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function adj(id, delta, price, name, emoji) {
  if (!canOrder) {
    window.location.href = '${pageContext.request.contextPath}/customer/scan';
    return;
  }
  if (!cart[id]) cart[id] = { qty: 0, price, name, emoji };
  cart[id].qty = Math.max(0, cart[id].qty + delta);
  if (cart[id].qty === 0) delete cart[id];
  const qtyNode = document.getElementById('q' + id);
  if (qtyNode) qtyNode.textContent = cart[id] ? cart[id].qty : 0;
  updateOrderBar();
}

function adjFromButton(btn, delta) {
  const card = btn.closest('.menu-item');
  if (!card) return;
  adj(Number(card.dataset.itemId), delta, Number(card.dataset.itemPrice), card.dataset.itemName || '', card.dataset.itemEmoji || '');
}

function updateOrderBar() {
  const values = Object.values(cart);
  const count = values.reduce((sum, item) => sum + item.qty, 0);
  const total = values.reduce((sum, item) => sum + (item.qty * item.price), 0);
  const bar = document.getElementById('orderBar');
  document.getElementById('barCount').textContent = count;
  document.getElementById('barAmount').textContent = 'Rs ' + total.toLocaleString();
  if (count > 0 && canOrder) bar.classList.add('ready'); else bar.classList.remove('ready');
}

function openSheet() {
  if (!canOrder) {
    window.location.href = '${pageContext.request.contextPath}/customer/scan';
    return;
  }
  renderSheet();
  document.getElementById('sheet').classList.add('open');
  document.getElementById('backdrop').classList.add('show');
}

function closeSheet() {
  document.getElementById('sheet').classList.remove('open');
  document.getElementById('backdrop').classList.remove('show');
}

function renderSheet() {
  const entries = Object.entries(cart);
  const body = document.getElementById('sheetBody');
  const foot = document.getElementById('sheetFoot');
  if (!entries.length) {
    body.innerHTML = '<div class="empty-state">Your order is empty.</div>';
    foot.innerHTML = '';
    return;
  }

  let subtotal = 0;
  body.innerHTML = entries.map(([id, item]) => {
    subtotal += item.qty * item.price;
    return '<div class="sheet-row"><div class="sheet-item"><span class="sheet-emoji">' + escapeHtml(item.emoji || '') + '</span><div><div class="sheet-name">' + escapeHtml(item.name) + '</div><div class="sheet-sub">Qty: ' + item.qty + '</div></div></div><div class="sheet-total">Rs ' + (item.qty * item.price).toLocaleString() + '</div></div>';
  }).join('');

  const vat = Math.round(subtotal * 0.13 * 100) / 100;
  const service = Math.round(subtotal * 0.10 * 100) / 100;
  const total = subtotal + vat + service;
  foot.innerHTML = '<div style="display:flex; justify-content:space-between; margin-bottom:8px; color:#7d8a84; font-size:12px;"><span>Subtotal</span><span>Rs ' + subtotal.toLocaleString() + '</span></div>'
    + '<div style="display:flex; justify-content:space-between; margin-bottom:8px; color:#7d8a84; font-size:12px;"><span>VAT (13%)</span><span>Rs ' + vat.toFixed(2) + '</span></div>'
    + '<div style="display:flex; justify-content:space-between; margin-bottom:14px; color:#7d8a84; font-size:12px;"><span>Service Charge (10%)</span><span>Rs ' + service.toFixed(2) + '</span></div>'
    + '<div style="display:flex; justify-content:space-between; align-items:center; font-size:18px; font-weight:800; color:#18342c; margin-bottom:16px;"><span>Total</span><span>Rs ' + total.toLocaleString(undefined, { minimumFractionDigits: 2 }) + '</span></div>'
    + '<button type="button" class="primary-btn" style="width:100%;" onclick="placeOrder()">Place Order</button>';
}

function placeOrder() {
  if (!canOrder) {
    window.location.href = '${pageContext.request.contextPath}/customer/scan';
    return;
  }
  const entries = Object.entries(cart);
  if (!entries.length) return;
  const params = new URLSearchParams({ tableId });
  entries.forEach(([id, item]) => {
    params.append('itemId[]', id);
    params.append('quantity[]', item.qty);
    params.append('price[]', item.price);
    params.append('note[]', '');
  });

  fetch('${pageContext.request.contextPath}/customer/order', { method: 'POST', body: params })
    .then((response) => response.json())
    .then((data) => {
      if (!data.success) {
        alert('Could not place order: ' + (data.error || 'Unknown error'));
        return;
      }

      Object.keys(cart).forEach((key) => delete cart[key]);
      document.querySelectorAll('[id^="q"]').forEach((node) => { node.textContent = '0'; });
      updateOrderBar();
      closeSheet();
      showToast();
      window.setTimeout(() => {
        window.location.href = '${pageContext.request.contextPath}/customer/bill?tableId=' + encodeURIComponent(tableId) + '&orderId=' + encodeURIComponent(data.orderId);
      }, 700);
    })
    .catch(() => alert('Could not place order.'));
}

function escapeHtml(value) {
  return String(value).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}

function showToast() {
  const toast = document.getElementById('toast');
  toast.classList.add('show');
  window.setTimeout(() => toast.classList.remove('show'), 2400);
}
</script>

<%@ include file="/pages/errorpages/footer.jsp" %>
