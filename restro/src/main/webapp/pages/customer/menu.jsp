<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*,java.util.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Menu" />
<%@ include file="/pages/errorpages/header.jsp" %>
<c:set var="menuHeroImg" value="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1200&auto=format&fit=crop" />
<%
  java.util.Map<Integer, String> uniqueImages = new java.util.HashMap<>();
  uniqueImages.put(1, "https://images.unsplash.com/photo-1544025162-8111142154ea?w=600&auto=format&fit=crop");
  uniqueImages.put(2, "https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=600&auto=format&fit=crop");
  uniqueImages.put(3, "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600&auto=format&fit=crop");
  uniqueImages.put(4, "https://images.unsplash.com/photo-1496116218417-1a781b1c416c?w=600&auto=format&fit=crop");
  uniqueImages.put(5, "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600&auto=format&fit=crop");
  uniqueImages.put(6, "https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=600&auto=format&fit=crop");
  uniqueImages.put(7, "https://images.unsplash.com/photo-1485921325833-c519f76c4927?w=600&auto=format&fit=crop");
  uniqueImages.put(8, "https://images.unsplash.com/photo-1626776876729-bab4369a5a5a?w=600&auto=format&fit=crop");
  uniqueImages.put(9, "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop");
  uniqueImages.put(10, "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop");
  uniqueImages.put(11, "https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=600&auto=format&fit=crop");
  uniqueImages.put(12, "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600&auto=format&fit=crop");
  uniqueImages.put(13, "https://images.unsplash.com/photo-1546852199-0d32cb9622d1?w=600&auto=format&fit=crop");
  uniqueImages.put(14, "https://images.unsplash.com/photo-1561336313-0bd5e0b27ec8?w=600&auto=format&fit=crop");
  uniqueImages.put(15, "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&auto=format&fit=crop");
  uniqueImages.put(16, "https://images.unsplash.com/photo-1551538827-9c037cb4f32a?w=600&auto=format&fit=crop");
  uniqueImages.put(17, "https://images.unsplash.com/photo-1506377247377-2a5b3b417ebb?w=600&auto=format&fit=crop");
  uniqueImages.put(18, "https://images.unsplash.com/photo-1511381939415-e440c064a101?w=600&auto=format&fit=crop");
  uniqueImages.put(19, "https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop");
  uniqueImages.put(20, "https://images.unsplash.com/photo-1563805042-7684c8a9e9ce?w=600&auto=format&fit=crop");
  uniqueImages.put(21, "https://images.unsplash.com/photo-1519869325930-281384150729?w=600&auto=format&fit=crop");
  request.setAttribute("uniqueImages", uniqueImages);
%>

<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    background: #fff;
    color: #1a1a1a;
    padding-bottom: 100px;
  }

  /* ── NAV ── */
  .m-nav {
    position: sticky;
    top: 0;
    z-index: 60;
    background: #fff;
    border-bottom: 1px solid #efefef;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 40px;
    height: 54px;
  }
  .m-brand {
    font-size: 14px;
    font-weight: 700;
    color: #1a1a1a;
    text-decoration: none;
    letter-spacing: -0.01em;
    white-space: nowrap;
  }
  .m-navlinks {
    display: flex;
    align-items: center;
    gap: 2px;
  }
  .m-navlink {
    font-size: 12.5px;
    font-weight: 600;
    color: #999;
    text-decoration: none;
    padding: 6px 14px;
    border-radius: 999px;
    transition: color .14s, background .14s;
    white-space: nowrap;
  }
  .m-navlink:hover { color: #1a1a1a; }
  .m-navlink.active { color: #1a1a1a; background: #f3f3f3; }
  .m-page-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    padding: 22px 40px 18px;
    background: #fff;
    border-bottom: 1px solid #efefef;
  }
  .m-page-header-start {
    display: flex;
    align-items: center;
    gap: 16px;
  }
  .m-back-link {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 14px;
    border-radius: 999px;
    border: 1px solid #e5e5e5;
    text-decoration: none;
    color: #1a1a1a;
    font-weight: 700;
    background: #fff;
    transition: background .14s, border-color .14s;
  }
  .m-back-link:hover { background: #f5f5f5; border-color: #d8d8d8; }
  .m-page-title {
    font-size: 18px;
    font-weight: 800;
    letter-spacing: -0.02em;
  }
  .m-iconbtn {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    border: 1px solid #e5e5e5;
    background: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    color: #555;
    text-decoration: none;
    transition: background .13s;
    position: relative;
  }
  .m-iconbtn:hover { background: #f5f5f5; }
  .m-cart-badge {
    position: absolute;
    top: -4px; right: -4px;
    width: 16px; height: 16px;
    background: #1a6b4a;
    color: #fff;
    border-radius: 50%;
    font-size: 9px;
    font-weight: 800;
    display: none;
    align-items: center;
    justify-content: center;
  }

  /* ── SEARCH ── */
  .m-search-wrap {
    display: flex;
    align-items: center;
    gap: 8px;
    background: #f5f5f5;
    border: 1px solid #eaeaea;
    border-radius: 999px;
    padding: 7px 14px;
    min-width: 200px;
  }
  .m-search-wrap svg { flex-shrink: 0; color: #aaa; }
  .m-search-wrap input {
    border: none;
    background: transparent;
    outline: none;
    font-size: 12px;
    color: #555;
    width: 100%;
  }

  /* ── HERO ── */
  .m-hero {
    position: relative;
    width: 100%;
    height: 500px;
    overflow: hidden;
    background: #182820;
  }
  .m-hero-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center 35%;
    display: block;
    opacity: 0.78;
  }
  .m-hero-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(to bottom, rgba(0,0,0,.08) 0%, rgba(0,0,0,.52) 100%);
  }
  .m-hero-copy {
    position: absolute;
    bottom: 0; left: 0; right: 0;
    padding: 28px 40px;
    color: #fff;
  }
  .m-hero-copy h1 {
    font-family: "Playfair Display", Georgia, "Times New Roman", serif;
    font-size: 38px;
    font-weight: 700;
    line-height: 1.1;
    letter-spacing: -0.02em;
    margin-bottom: 6px;
  }
  .m-hero-copy p {
    font-size: 12.5px;
    color: rgba(255,255,255,.75);
  }

  /* ── PREVIEW BANNER ── */
  .m-preview-banner {
    background: #eef6f1;
    border-bottom: 1px solid #d0e8db;
    padding: 10px 40px;
    font-size: 12px;
    font-weight: 600;
    color: #1f5c40;
    display: flex;
    align-items: center;
    gap: 10px;
  }
  .m-preview-banner a { color: #1a6b4a; text-decoration: underline; margin-left: 4px; }

  /* ── CHIP FILTER ROW ── */
  .m-chip-row {
    display: none;
  }

  /* ── CONTENT WRAP ── */
  .m-wrap {
    max-width: 1400px;
    margin: 0;
    padding: 0 0 60px;
    display: grid;
    grid-template-columns: 260px minmax(0, 1fr);
    gap: 28px;
  }

  .m-sidebar {
    position: sticky;
    top: 95px;
    align-self: start;
    border: 1px solid #eef0ee;
    border-radius: 24px;
    background: #fff;
    padding: 24px;
    box-shadow: 0 22px 40px rgba(15, 35, 30, .06);
  }
  .m-sidebar-title {
    font-size: 11px;
    letter-spacing: .18em;
    text-transform: uppercase;
    color: #6b766f;
    font-weight: 700;
    margin-bottom: 18px;
  }
  .m-category-list {
    display: grid;
    gap: 12px;
  }
  .m-category-btn {
    border: 1px solid #e5e5e5;
    background: #fff;
    color: #444;
    text-align: left;
    padding: 12px 16px;
    border-radius: 18px;
    cursor: pointer;
    font-size: 12px;
    font-weight: 700;
    transition: .16s ease;
    width: 100%;
  }
  .m-category-btn:hover { border-color: #c7d7ce; color: #1a1a1a; }
  .m-category-btn.active {
    background: #1a6b4a;
    border-color: #1a6b4a;
    color: #fff;
  }

  .m-sidebar-gallery {
    margin-top: 24px;
    display: grid;
    gap: 14px;
  }
  .m-gallery-item {
    display: grid;
    grid-template-columns: 56px minmax(0, 1fr);
    gap: 12px;
    align-items: center;
    background: #f9faf9;
    border-radius: 18px;
    padding: 10px 12px;
    border: 1px solid #edf2ee;
    color: #1a1a1a;
    text-decoration: none;
    cursor: pointer;
    transition: background .18s ease, border-color .18s ease;
  }
  .m-gallery-item:hover {
    background: #eef6f1;
    border-color: #d4e3d1;
  }
  .m-gallery-thumb {
    width: 56px;
    height: 56px;
    border-radius: 18px;
    overflow: hidden;
    background: #e8f3ea;
    display: grid;
    place-items: center;
    color: #1a1a1a;
    font-size: 18px;
    font-weight: 800;
    text-transform: uppercase;
  }
  .m-gallery-thumb img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }
  .m-gallery-thumb span {
    font-size: 20px;
  }
  .m-gallery-copy {
    display: grid;
    gap: 2px;
  }
  .m-gallery-title {
    font-size: 12px;
    font-weight: 700;
  }
  .m-gallery-subtitle {
    font-size: 11px;
    color: #6d766e;
  }

  .m-main-content {
    min-width: 0;
    padding-left: 14px;
  }

  .m-section-head {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    margin-bottom: 22px;
  }
  .m-section-name {
    font-size: 22px;
    font-weight: 800;
    color: #1a1a1a;
    letter-spacing: -0.02em;
  }
  .m-section-tag {
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: #9aa4a0;
  }

  .m-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 25px;
  }
  .m-card {
    background: #fff;
    border: 1px solid #eef0ee;
    border-radius: 24px;
    display: flex;
    flex-direction: column;
    transition: transform .18s ease, box-shadow .18s ease;
    overflow: hidden;
  }
  .m-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 22px 40px rgba(15, 35, 30, .08);
  }

  /* ── CARD ── */
  .m-card {
    background: #fff;
    border-right: 1px solid #efefef;
    border-bottom: 1px solid #efefef;
    display: flex;
    flex-direction: column;
    transition: background .12s;
  }
  .m-card:hover { background: #fafafa; }

  .m-card-img-wrap {
    width: 100%;
    aspect-ratio: 1 / 1;
    overflow: hidden;
    background: #f4f4f4;
    position: relative;
    flex-shrink: 0;
  }
  .m-card-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    transition: transform .22s ease;
  }
  .m-card:hover .m-card-img { transform: scale(1.04); }
  .m-card-fallback {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 52px;
    background: radial-gradient(circle at 50% 44%,
    rgba(255,218,150,.92),
    rgba(200,138,72,.76) 54%,
    rgba(88,52,22,.88) 88%);
  }

  .m-card-body {
    padding: 14px 16px 16px;
    display: flex;
    flex-direction: column;
    flex: 1;
    gap: 5px;
  }
  .m-card-name {
    font-size: 13.5px;
    font-weight: 700;
    color: #1a1a1a;
    line-height: 1.25;
  }
  .m-card-desc {
    font-size: 11.5px;
    color: #999;
    line-height: 1.52;
    flex: 1;
  }
  .m-card-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 12px;
    gap: 8px;
  }
  .m-price {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 13px;
    font-weight: 800;
    color: #1a1a1a;
  }
  .m-price-bar {
    width: 3px;
    height: 13px;
    border-radius: 2px;
    background: #1a6b4a;
    flex-shrink: 0;
  }

  /* ── QTY ── */
  .m-qty {
    display: flex;
    align-items: center;
    gap: 5px;
    background: #f3f3f3;
    border-radius: 999px;
    padding: 3px;
    flex-shrink: 0;
  }
  .m-qty-btn {
    width: 22px; height: 22px;
    border-radius: 50%;
    border: none;
    background: #fff;
    color: #1a1a1a;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    line-height: 1;
    box-shadow: 0 1px 2px rgba(0,0,0,.09);
    transition: background .11s;
    font-family: inherit;
  }
  .m-qty-btn:hover { background: #e5e5e5; }
  .m-qty-num {
    min-width: 16px;
    text-align: center;
    font-size: 12px;
    font-weight: 700;
    color: #1a1a1a;
  }

  /* ── EMPTY ── */
  .m-empty {
    padding: 80px 0;
    text-align: center;
    color: #bbb;
    font-size: 14px;
  }

  /* ── ORDER BAR ── */
  .m-orderbar {
    position: fixed;
    bottom: 22px;
    left: 50%;
    transform: translateX(-50%);
    width: min(92vw, 1120px);
    background: rgba(17, 48, 39, .96);
    color: #fff;
    border-radius: 10px;
    box-shadow: 0 22px 38px rgba(9, 29, 24, .18);
    padding: 14px 18px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 18px;
    z-index: 55;
    opacity: .45;
    pointer-events: none;
    transition: .18s ease;
  }
  .m-orderbar.ready { opacity: 1; pointer-events: auto; }
  .m-order-summary { display: flex; align-items: center; gap: 14px; }
  .m-order-kpi strong {
    display: block;
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: .14em;
    color: rgba(255,255,255,.64);
  }
  .m-order-kpi span { font-size: 22px; font-weight: 800; }
  .m-order-actions { display: flex; align-items: center; gap: 10px; }
  .m-ghost-btn {
    border: none;
    background: rgba(255,255,255,.1);
    color: #fff;
    border-radius: 999px;
    padding: 12px 18px;
    font-size: 12px;
    font-weight: 800;
    cursor: pointer;
    font-family: inherit;
  }
  .m-primary-btn {
    border: none;
    background: #36d191;
    color: #103128;
    border-radius: 999px;
    padding: 12px 18px;
    font-size: 12px;
    font-weight: 800;
    cursor: pointer;
    font-family: inherit;
  }

  /* ── BACKDROP ── */
  .m-backdrop {
    position: fixed;
    inset: 0;
    background: rgba(17, 33, 28, .35);
    backdrop-filter: blur(3px);
    z-index: 70;
    display: none;
  }
  .m-backdrop.show { display: block; }

  /* ── SHEET ── */
  .m-sheet {
    position: fixed;
    inset: auto 0 0 0;
    background: #fff;
    border-radius: 22px 22px 0 0;
    max-width: 720px;
    margin: 0 auto;
    max-height: 84vh;
    transform: translateY(105%);
    transition: transform .22s ease;
    z-index: 80;
    box-shadow: 0 -18px 30px rgba(15, 40, 33, .12);
    display: flex;
    flex-direction: column;
  }
  .m-sheet.open { transform: translateY(0); }
  .m-sheet-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 18px 22px;
    border-bottom: 1px solid #ede7dd;
  }
  .m-sheet-top h3 {
    margin: 0;
    font-family: "Playfair Display", Georgia, serif;
    font-size: 28px;
  }
  .m-sheet-close {
    border: none;
    background: transparent;
    color: #7b867f;
    font-size: 22px;
    cursor: pointer;
  }
  .m-sheet-body { padding: 0 22px; overflow: auto; flex: 1; }
  .m-sheet-foot {
    padding: 18px 22px 22px;
    border-top: 1px solid #ede7dd;
    background: #faf8f3;
  }
  .m-sheet-row {
    display: flex;
    justify-content: space-between;
    gap: 12px;
    padding: 14px 0;
    border-bottom: 1px solid #f0ebe4;
  }
  .m-sheet-row:last-child { border-bottom: none; }
  .m-sheet-item { display: flex; align-items: center; gap: 10px; }
  .m-sheet-emoji {
    width: 42px; height: 42px;
    border-radius: 50%;
    background: #f4efe7;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    flex-shrink: 0;
  }
  .m-sheet-name { font-size: 13px; font-weight: 700; color: #18342c; }
  .m-sheet-sub  { color: #839089; font-size: 11px; }
  .m-sheet-total { font-size: 13px; font-weight: 800; color: #18342c; white-space: nowrap; }

  /* ── FOOTER ── */
  .m-footer-row {
    display: grid;
    grid-template-columns: 1.45fr 0.9fr 1.05fr 0.95fr;
    gap: 40px;
    margin: 0 40px;
    max-width: 1180px;
    margin-left: auto;
    margin-right: auto;
    padding: 26px 40px 0;
    border-top: 1px solid #eee7dc;
    color: #8c968f;
    font-size: 12px;
  }
  .m-footer-brand { color: #215747; font-weight: 700; margin-bottom: 8px; }
  .m-footer-title {
    margin-bottom: 8px;
    color: #16372d;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    font-size: 9px;
  }
  .m-footer-col { display: grid; gap: 6px; }
  .m-footer-col a { color: inherit; text-decoration: none; }
  .m-footer-bottom {
    max-width: 1180px;
    margin: 0 auto;
    padding: 12px 40px 0;
    border-top: 1px solid #f0ebe3;
    margin-top: 18px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 14px;
    color: #b1b8b3;
    font-size: 10px;
  }
  .m-footer-meta { display: flex; align-items: center; gap: 18px; }
  .m-footer-meta a { color: inherit; text-decoration: none; }

  /* ── TOAST ── */
  .m-toast {
    position: fixed;
    top: 24px; left: 50%;
    transform: translate(-50%, -140%);
    background: #1f6b55;
    color: #fff;
    border-radius: 999px;
    padding: 12px 18px;
    font-size: 12px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: .1em;
    transition: .24s ease;
    z-index: 95;
    white-space: nowrap;
  }
  .m-toast.show { transform: translate(-50%, 0); }

  /* ── RESPONSIVE ── */
  @media (max-width: 960px) {
    .m-grid { grid-template-columns: repeat(3, 1fr); }
  }
  @media (max-width: 860px) {
    .m-wrap { grid-template-columns: 1fr; }
    .m-sidebar { position: static; top: auto; width: 100%; }
    .m-category-list { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  }
  @media (max-width: 680px) {
    .m-grid { grid-template-columns: repeat(2, 1fr); }
    .m-nav  { padding: 0 18px; }
    .m-navlinks { display: none; }
    .m-hero { height: 220px; }
    .m-hero-copy { padding: 20px 20px; }
    .m-hero-copy h1 { font-size: 26px; }
    .m-chip-row { padding: 14px 18px 0; }
    .m-wrap { padding: 0 18px 60px; }
    .m-sidebar { box-shadow: none; border: none; padding: 0; }
    .m-category-list { grid-template-columns: 1fr; gap: 10px; }
    .m-orderbar {
      width: calc(100vw - 20px);
      bottom: 10px;
      border-radius: 14px;
      padding: 14px;
      flex-direction: column;
      align-items: stretch;
    }
    .m-order-actions { width: 100%; }
    .m-ghost-btn, .m-primary-btn { flex: 1; }
    .m-preview-banner { padding: 10px 18px; }
    .m-footer-row { grid-template-columns: 1fr; gap: 18px; padding: 20px 18px 0; }
    .m-footer-bottom { padding: 12px 18px 0; flex-direction: column; align-items: flex-start; }
  }
</style>

<%-- Build ordered category entries (identical to original) --%>
<% Map<?, ?> rawMenuByCategory = (Map<?, ?>) request.getAttribute("menuByCategory");
  java.util.List<java.util.Map.Entry<?, ?>> categoryEntries = new java.util.ArrayList<>();
  if (rawMenuByCategory != null) categoryEntries.addAll(rawMenuByCategory.entrySet());
  request.setAttribute("categoryEntries", categoryEntries);
%>

<%-- Preserve all variables that downstream pages/links may need (identical to original) --%>
<c:set var="previewMode" value="${previewMode == true}" />
<c:choose>
  <c:when test="${not empty table}">
    <c:set var="menuHref"   value="${pageContext.request.contextPath}/customer/menu?table=${table.qrToken}" />
    <c:set var="billHref"   value="${pageContext.request.contextPath}/customer/bill?tableId=${table.id}" />
    <c:set var="tableLabel" value="${table.tableNumber}" />
  </c:when>
  <c:otherwise>
    <c:set var="menuHref"   value="${pageContext.request.contextPath}/customer/menu" />
    <c:set var="billHref"   value="${pageContext.request.contextPath}/customer/scan" />
    <c:set var="tableLabel" value="Preview" />
  </c:otherwise>
</c:choose>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<header class="m-page-header">
  <div class="m-page-header-start">
    <c:choose>
      <c:when test="${not previewMode}">
        <a href="${pageContext.request.contextPath}/customer/scan" class="m-back-link">← Back</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/" class="m-back-link">Home</a>
      </c:otherwise>
    </c:choose>
    <div class="m-page-title">Menu</div>
  </div>
  <button type="button" class="m-iconbtn" onclick="openSheet()" title="View cart">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
    <span class="m-cart-badge" id="cartBadge">0</span>
  </button>
</header>

<!-- ══ PREVIEW BANNER ════════════════════════════════════════════════ -->
<c:if test="${previewMode}">
  <div class="m-preview-banner">
    Browse mode: you can view the full menu without scanning a QR code, but you must scan a table QR before you can order.
    <a href="${pageContext.request.contextPath}/customer/scan">Scan QR</a>
  </div>
</c:if>

<!-- ══ HERO ══════════════════════════════════════════════════════════ -->
<section class="m-hero">
  <img src="${menuHeroImg}"
       alt="Himalayan Cuisine"
       class="m-hero-img"
       loading="eager"
       onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/hero-food.png';">
  <div class="m-hero-overlay"></div>
  <div class="m-hero-copy">
    <h1>The Art of Himalayan Craft</h1>
    <p>A curated selection of authentic flavors from Jhamsikhel, Lalitpur.</p>
  </div>
</section>

<!-- ══ MENU FILTER AND GRID ═════════════════════════════════════════ -->
<div class="m-wrap">
  <aside class="m-sidebar">
    <div class="m-sidebar-title">Filter Menu</div>
    <div class="m-category-list">
      <button type="button" class="m-category-btn active" data-category="">All Items</button>
      <c:forEach items="${categoryEntries}" var="entry">
        <button type="button" class="m-category-btn" data-category="${fn:toLowerCase(fn:escapeXml(entry.key))}">
          <c:out value="${entry.key}" />
        </button>
      </c:forEach>
    </div>
    <div class="m-sidebar-gallery">
      <c:forEach items="${categoryEntries}" var="entry" varStatus="catStat">
        <c:if test="${catStat.index < 4}">
          <button type="button" class="m-gallery-item" data-category="${fn:toLowerCase(fn:escapeXml(entry.key))}">
            <div class="m-gallery-thumb">
              <span>${fn:substring(entry.key, 0, 1)}</span>
            </div>
            <div class="m-gallery-copy">
              <div class="m-gallery-title"><c:out value="${entry.key}" /></div>
              <div class="m-gallery-subtitle"><c:out value="${fn:length(entry.value)}"/> items</div>
            </div>
          </button>
        </c:if>
      </c:forEach>
    </div>
  </aside>

  <main class="m-main-content">
    <div class="m-section-head">
      <span class="m-section-name">Menu Catalog</span>
      <span class="m-section-tag">Browse dishes by category</span>
    </div>

    <c:choose>
      <c:when test="${empty categoryEntries}">
        <div class="m-empty">No menu items are available right now.</div>
      </c:when>
      <c:otherwise>
        <div class="m-grid">
          <c:forEach items="${categoryEntries}" var="entry">
            <c:forEach items="${entry.value}" var="item">
              <article class="m-card menu-item"
                       data-item-id="${item.id}"
                       data-item-name="${fn:escapeXml(item.name)}"
                       data-item-price="${item.price}"
                       data-search-text="${fn:toLowerCase(item.name)} ${fn:toLowerCase(item.description)}"
                       data-category="${fn:toLowerCase(fn:escapeXml(entry.key))}">

                <div class="m-card-img-wrap">
                  <c:choose>
                    <c:when test="${fn:startsWith(item.imageUrl, 'http')}">
                      <%-- External URL pasted by admin — use as-is --%>
                      <c:set var="resolvedImg" value="${item.imageUrl}"/>
                    </c:when>
                    <c:when test="${fn:startsWith(item.imageUrl, '/menu-image')}">
                      <%-- Real upload served by ImageServlet — prepend context path --%>
                      <c:set var="resolvedImg" value="${ctx}${item.imageUrl}"/>
                    </c:when>
                    <c:otherwise>
                      <%-- No real upload (DAO default or empty) — use per-item Unsplash fallback --%>
                      <c:set var="resolvedImg" value="${not empty uniqueImages[item.id] ? uniqueImages[item.id] : ctx.concat('/assets/images/hero-food.png')}"/>
                    </c:otherwise>
                  </c:choose>
                  <img src="${resolvedImg}"
                       alt="${fn:escapeXml(item.name)}"
                       class="m-card-img"
                       loading="eager"
                       onerror="this.onerror=null;this.src='${ctx}/assets/images/hero-food.png';">
                </div>

                <div class="m-card-body">
                  <div class="m-card-name"><c:out value="${item.name}" /></div>
                  <div class="m-card-desc"><c:out value="${item.description}" /></div>
                  <div class="m-card-footer">
                    <div class="m-price">
                      <span class="m-price-bar"></span>
                      Rs <fmt:formatNumber value="${item.price}" pattern="#,##0" />
                    </div>
                    <div class="m-qty">
                      <button type="button" class="m-qty-btn" onclick="adjFromButton(this, -1)">&#8722;</button>
                      <span class="m-qty-num" id="q${item.id}">0</span>
                      <button type="button" class="m-qty-btn" onclick="adjFromButton(this, 1)">+</button>
                    </div>
                  </div>
                </div>

              </article>
            </c:forEach>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>

  </main>
</div><%-- /m-wrap --%>

<!-- ══ FOOTER (preserved from original) ═════════════════════════════ -->
<div class="m-footer-row">
  <div>
    <div class="m-footer-brand">Gokyo Bistro</div>
    <div>Elevating Himalayan ingredients through composed modern tasting menus and warm hospitality.</div>
  </div>
  <div>
    <div class="m-footer-title">Connect</div>
    <div class="m-footer-col">
      <a href="#">Instagram</a>
      <a href="#">Facebook</a>
      <a href="#">X / Twitter</a>
    </div>
  </div>
  <div>
    <div class="m-footer-title">Visit</div>
    <div class="m-footer-col">
      <span>Durbar Marg, Kathmandu, Nepal</span>
      <span>Open daily 11:00 AM – 11:00 PM</span>
      <span>+977 1 5555555</span>
    </div>
  </div>
  <div>
    <div class="m-footer-title">Access</div>
    <div class="m-footer-col">
      <a href="${pageContext.request.contextPath}/customer/menu">Menu</a>
      <a href="${pageContext.request.contextPath}/customer/scan">Scan QR</a>
      <a href="${pageContext.request.contextPath}/admin/login">Login</a>
    </div>
  </div>
</div>
<div class="m-footer-bottom">
  <span>&copy; 2026 Gokyo Bistro. All Rights Reserved.</span>
  <div class="m-footer-meta">
    <a href="${pageContext.request.contextPath}/customer/menu">Menu</a>
    <a href="${pageContext.request.contextPath}/customer/scan">Scan QR</a>
  </div>
</div>

<!-- ══ BACKDROP ══════════════════════════════════════════════════════ -->
<div id="backdrop" class="m-backdrop" onclick="closeSheet()"></div>

<!-- ══ ORDER SHEET ═══════════════════════════════════════════════════ -->
<div id="sheet" class="m-sheet">
  <div class="m-sheet-top">
    <h3>Your Order</h3>
    <button type="button" class="m-sheet-close" onclick="closeSheet()">&#10005;</button>
  </div>
  <div id="sheetBody" class="m-sheet-body"></div>
  <div id="sheetFoot" class="m-sheet-foot"></div>
</div>

<!-- ══ ORDER BAR ══════════════════════════════════════════════════════ -->
<div id="orderBar" class="m-orderbar">
  <div class="m-order-summary">
    <div class="m-order-kpi"><strong>Table</strong><span>${tableLabel}</span></div>
    <div class="m-order-kpi"><strong>Items</strong><span id="barCount">0</span></div>
    <div class="m-order-kpi"><strong>Total</strong><span id="barAmount">Rs 0</span></div>
  </div>
  <div class="m-order-actions">
    <button type="button" class="m-ghost-btn" onclick="openSheet()">Review Order</button>
    <button type="button" class="m-primary-btn" onclick="placeOrder()">${previewMode ? 'Scan QR to Order' : 'Place Order'}</button>
  </div>
</div>

<!-- ══ TOAST ══════════════════════════════════════════════════════════ -->
<div id="toast" class="m-toast">Order placed successfully</div>

<script>
  const cart     = {};
  const tableId  = '${not empty table ? table.id : ""}';
  const canOrder = ${ previewMode ? 'false' : 'true' };
  let currentCategory = '';

  /* ── filterMenu (original function name preserved) ── */
  function filterMenu(query) {
    const normalized = String(query || '').toLowerCase().trim();
    document.querySelectorAll('.menu-item').forEach(function(card) {
      const haystack = (card.dataset.searchText || '').toLowerCase();
      const category = (card.dataset.category || '').toLowerCase();
      const matchesSearch = !normalized || haystack.includes(normalized);
      const matchesCategory = !currentCategory || currentCategory === category;
      card.style.display = matchesSearch && matchesCategory ? '' : 'none';
    });
  }

  document.querySelectorAll('.m-category-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
      document.querySelectorAll('.m-category-btn').forEach(function(other) {
        other.classList.remove('active');
      });
      btn.classList.add('active');
      currentCategory = btn.dataset.category || '';
      const searchInput = document.querySelector('.m-search-wrap input');
      filterMenu(searchInput ? searchInput.value : '');
    });
  });

  document.querySelectorAll('.m-gallery-item').forEach(function(card) {
    card.addEventListener('click', function() {
      const category = card.dataset.category || '';
      document.querySelectorAll('.m-category-btn').forEach(function(other) {
        other.classList.remove('active');
      });
      const targetBtn = document.querySelector('.m-category-btn[data-category="' + category + '"]');
      if (targetBtn) targetBtn.classList.add('active');
      currentCategory = category;
      const searchInput = document.querySelector('.m-search-wrap input');
      filterMenu(searchInput ? searchInput.value : '');
    });
  });

  /* ── scrollToSection (original function name preserved) ── */
  function scrollToSection(sectionId, btn) {
    document.querySelectorAll('.m-chip').forEach(function(chip) { chip.classList.remove('active'); });
    if (btn) btn.classList.add('active');
    const target = document.getElementById(sectionId);
    if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  /* ── adj / adjFromButton (original function names and logic preserved exactly) ── */
  function adj(id, delta, price, name) {
    if (!canOrder) {
      window.location.href = '${pageContext.request.contextPath}/customer/scan';
      return;
    }
    if (!cart[id]) cart[id] = { qty: 0, price: price, name: name };
    cart[id].qty = Math.max(0, cart[id].qty + delta);
    if (cart[id].qty === 0) delete cart[id];
    const qtyNode = document.getElementById('q' + id);
    if (qtyNode) qtyNode.textContent = cart[id] ? cart[id].qty : 0;
    updateOrderBar();
  }

  function adjFromButton(btn, delta) {
    const card = btn.closest('.menu-item');
    if (!card) return;
    adj(Number(card.dataset.itemId), delta, Number(card.dataset.itemPrice), card.dataset.itemName || '');
  }

  /* ── updateOrderBar (original function name preserved, uses barAmount + ready class) ── */
  function updateOrderBar() {
    const values = Object.values(cart);
    const count  = values.reduce(function(sum, item) { return sum + item.qty; }, 0);
    const total  = values.reduce(function(sum, item) { return sum + (item.qty * item.price); }, 0);
    const bar    = document.getElementById('orderBar');
    document.getElementById('barCount').textContent  = count;
    document.getElementById('barAmount').textContent = 'Rs ' + total.toLocaleString();
    if (count > 0 && canOrder) bar.classList.add('ready'); else bar.classList.remove('ready');
    /* also update cart badge in nav */
    const badge = document.getElementById('cartBadge');
    if (badge) {
      badge.textContent = count;
      badge.style.display = count > 0 ? 'flex' : 'none';
    }
  }

  /* ── openSheet / closeSheet (original logic preserved) ── */
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

  /* ── renderSheet (original logic preserved exactly, including class names sheet-name/sheet-sub/sheet-total) ── */
  function renderSheet() {
    const entries = Object.entries(cart);
    const body    = document.getElementById('sheetBody');
    const foot    = document.getElementById('sheetFoot');
    if (!entries.length) {
      body.innerHTML = '<div style="padding:40px 0;text-align:center;color:#819088;font-size:13px;">Your order is empty.</div>';
      foot.innerHTML = '';
      return;
    }

    let subtotal = 0;
    body.innerHTML = entries.map(function(entry) {
      const id   = entry[0];
      const item = entry[1];
      subtotal += item.qty * item.price;
      return '<div class="m-sheet-row">'
              + '<div class="m-sheet-item">'
              + '<div><div class="m-sheet-name">' + escapeHtml(item.name) + '</div>'
              + '<div class="m-sheet-sub">Qty: ' + item.qty + '</div></div></div>'
              + '<div class="m-sheet-total">Rs ' + (item.qty * item.price).toLocaleString() + '</div>'
              + '</div>';
    }).join('');

    const vat     = Math.round(subtotal * 0.13 * 100) / 100;
    const service = Math.round(subtotal * 0.10 * 100) / 100;
    const total   = subtotal + vat + service;
    foot.innerHTML =
            '<div style="display:flex; justify-content:space-between; margin-bottom:8px; color:#7d8a84; font-size:12px;"><span>Subtotal</span><span>Rs ' + subtotal.toLocaleString() + '</span></div>'
            + '<div style="display:flex; justify-content:space-between; margin-bottom:8px; color:#7d8a84; font-size:12px;"><span>VAT (13%)</span><span>Rs ' + vat.toFixed(2) + '</span></div>'
            + '<div style="display:flex; justify-content:space-between; margin-bottom:14px; color:#7d8a84; font-size:12px;"><span>Service Charge (10%)</span><span>Rs ' + service.toFixed(2) + '</span></div>'
            + '<div style="display:flex; justify-content:space-between; align-items:center; font-size:18px; font-weight:800; color:#18342c; margin-bottom:16px;"><span>Total</span><span>Rs ' + total.toLocaleString(undefined, { minimumFractionDigits: 2 }) + '</span></div>'
            + '<button type="button" class="m-primary-btn" style="width:100%;" onclick="placeOrder()">Place Order</button>';
  }

  /* ── placeOrder (original POST logic preserved exactly) ── */
  function placeOrder() {
    if (!canOrder) {
      window.location.href = '${pageContext.request.contextPath}/customer/scan';
      return;
    }
    const entries = Object.entries(cart);
    if (!entries.length) return;
    const params = new URLSearchParams({ tableId: tableId });
    entries.forEach(function(entry) {
      const id   = entry[0];
      const item = entry[1];
      params.append('itemId[]',   id);
      params.append('quantity[]', item.qty);
      params.append('price[]',    item.price);
      params.append('note[]',     '');
    });

    fetch('${pageContext.request.contextPath}/customer/order', { method: 'POST', body: params })
            .then(function(response) { return response.json(); })
            .then(function(data) {
              if (!data.success) {
                alert('Could not place order: ' + (data.error || 'Unknown error'));
                return;
              }
              Object.keys(cart).forEach(function(key) { delete cart[key]; });
              document.querySelectorAll('[id^="q"]').forEach(function(node) { node.textContent = '0'; });
              updateOrderBar();
              closeSheet();
              showToast();
              window.setTimeout(function() {
                window.location.href = '${pageContext.request.contextPath}/customer/bill?tableId='
                        + encodeURIComponent(tableId) + '&orderId=' + encodeURIComponent(data.orderId);
              }, 700);
            })
            .catch(function() { alert('Could not place order.'); });
  }

  /* ── escapeHtml (original function name preserved) ── */
  function escapeHtml(value) {
    return String(value)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
  }

  /* ── showToast (original logic preserved) ── */
  function showToast() {
    const toast = document.getElementById('toast');
    toast.classList.add('show');
    window.setTimeout(function() { toast.classList.remove('show'); }, 2400);
  }
</script>

<%@ include file="/pages/errorpages/footer.jsp" %>
