<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Home - Gokyo Bistro" />
<%@ include file="/pages/errorpages/header.jsp" %>
<c:set var="heroFoodImg" value="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&auto=format&fit=crop" />
<c:set var="restaurantAmbienceImg" value="https://images.unsplash.com/photo-1528605248644-14dd04022da1?w=1200&auto=format&fit=crop" />
<c:set var="feedbackDiningImg" value="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1200&auto=format&fit=crop" />
<c:set var="lambRackImg" value="https://images.unsplash.com/photo-1604908176831-926c9bdc25bc?w=1200&auto=format&fit=crop" />
<c:set var="riverCrabImg" value="https://images.unsplash.com/photo-1543353071-873f17a7a088?w=1200&auto=format&fit=crop" />

<style>
  body {
    background: #fbfaf7;
    color: #16372d;
  }

  .home-shell {
    width: 100%;
    max-width: none;
    margin: 0;
    padding: 0 0 40px;
  }

  .topbar {
    min-height: 78px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 0;
    padding: 0 28px;
  }

  .brand {
    font-size: 20px;
    font-weight: 700;
    color: #16372d;
    text-decoration: none;
  }

  .nav-links,
  .nav-actions,
  .footer-columns,
  .contact-meta {
    display: flex;
    align-items: center;
    gap: 18px;
  }

  .nav-link {
    font-size: 15px;
    font-weight: 600;
    color: #7a867f;
    text-decoration: none;
    padding: 10px 0;
    border-bottom: 2px solid transparent;
  }

  .nav-link.active {
    color: #16372d;
    border-bottom-color: #2d8e69;
  }

  .nav-icon {
    width: 30px;
    height: 30px;
    border-radius: 999px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: #60776d;
    font-size: 14px;
  }

  .hero {
    position: relative;
    min-height: 76vh;
    overflow: hidden;
    background:
      linear-gradient(180deg, rgba(3, 48, 37, 0.72), rgba(2, 49, 38, 0.82)),
      #032e24;
    border-radius: 0;
    width: 100%;
  }

  .hero-bg-img {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center;
    z-index: 0;
    opacity: 0.55;
  }

  .hero::after {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(
      to right,
      rgba(2, 49, 38, 0.88) 45%,
      rgba(2, 49, 38, 0.3) 100%
    );
    z-index: 1;
    pointer-events: none;
  }

  .hero-copy {
    position: relative;
    z-index: 2;
    max-width: 560px;
    padding: 110px 0 110px 42px;
    color: #f2efe8;
  }

  .eyebrow {
    margin: 0 0 18px;
    font-size: 9px;
    font-weight: 700;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: #65b08f;
  }

  .hero h1 {
    margin: 0 0 18px;
    font-family: "Playfair Display", Georgia, serif;
    font-size: 108px;
    line-height: 0.9;
    font-weight: 500;
    letter-spacing: -0.03em;
  }

  .hero p {
    margin: 0 0 24px;
    max-width: 450px;
    font-size: 15px;
    line-height: 1.65;
    color: rgba(242, 239, 232, 0.7);
  }

  .hero-actions {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
  }

  .btn-primary,
  .btn-secondary,
  .newsletter-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 2px;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    text-decoration: none;
    cursor: pointer;
    transition: 0.18s ease;
  }

  .btn-primary {
    background: #2d8e69;
    color: #fff;
    padding: 15px 24px;
  }

  .btn-secondary {
    background: rgba(255, 255, 255, 0.08);
    color: #dce9e2;
    border: 1px solid rgba(255, 255, 255, 0.16);
    padding: 15px 24px;
  }

  .story-section,
  .curator-section,
  .newsletter-section,
  .footer-section {
    background: #fff;
  }

  .story-section {
    padding: 72px 34px 72px;
  }

  .story-grid {
    display: grid;
    grid-template-columns: 1.05fr 1.35fr;
    gap: 48px;
    align-items: center;
  }

  .story-visual {
    position: relative;
    height: 460px;
    overflow: hidden;
    background: #171210;
  }

  .story-visual img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center;
    display: block;
    opacity: 0.85;
  }

  .story-plate {
    position: absolute;
    left: 96px;
    bottom: 52px;
    width: 230px;
    height: 230px;
    border-radius: 50%;
    background-image: url("${restaurantAmbienceImg}");
  }

  .story-badge {
    position: absolute;
    right: 0;
    bottom: 18px;
    width: 118px;
    background: #0b5b44;
    color: #d8f0e6;
    padding: 18px 12px;
    font-size: 12px;
    line-height: 1.45;
    text-align: center;
  }

  .story-copy h2,
  .curator-heading,
  .newsletter-title {
    font-family: "Playfair Display", Georgia, serif;
    font-weight: 500;
    color: #215747;
  }

  .story-copy h2 {
    margin: 0 0 18px;
    font-size: 62px;
    line-height: 1.02;
  }

  .story-copy p {
    margin: 0 0 16px;
    max-width: 700px;
    color: #7a867f;
    font-size: 15px;
    line-height: 1.75;
  }

  .story-link {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-top: 10px;
    color: #215747;
    font-size: 11px;
    font-weight: 700;
    text-decoration: none;
  }

  .curator-section {
    padding: 62px 34px 82px;
  }

  .curator-heading {
    margin: 0 0 30px;
    text-align: center;
    font-size: 60px;
  }

  .curator-grid {
    display: grid;
    grid-template-columns: 1.05fr 1fr;
    gap: 22px;
  }

  .curator-left,
  .curator-right-top,
  .curator-right-bottom {
    position: relative;
    overflow: hidden;
    background: #17362d;
  }

  .curator-left {
    min-height: 620px;
    background: #101718;
  }

  .curator-left > img,
  .curator-right-top > img {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center;
    opacity: 0.72;
  }

  .curator-left::after,
  .curator-right-top::after,
  .curator-small::after {
    display: none;
  }

  .curator-caption {
    position: absolute;
    left: 18px;
    bottom: 18px;
    color: #fff;
    z-index: 2;
  }

  .curator-caption h3 {
    margin: 0 0 4px;
    font-family: "Playfair Display", Georgia, serif;
    font-size: 38px;
    font-weight: 500;
  }

  .price-chip {
    font-size: 14px;
    font-weight: 700;
    color: rgba(255, 255, 255, 0.78);
  }

  .curator-stack {
    display: grid;
    grid-template-rows: 1.1fr 0.9fr;
    gap: 16px;
  }

  .curator-right-top {
    min-height: 300px;
    background: #0d1012;
  }

  .curator-right-bottom {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
    background: transparent;
  }

  .curator-small {
    position: relative;
    min-height: 298px;
    overflow: hidden;
    background: linear-gradient(180deg, #321f1d, #13100f);
  }

  .curator-small.pink {
    background: linear-gradient(180deg, #f7d9da, #f1c5c5);
  }

  .curator-small.amber {
    background: linear-gradient(180deg, #57483b, #2a2018);
  }

  .curator-small.pink::after {
    content: "🍰";
    font-size: 108px;
    left: 50%;
    top: 48%;
    transform: translate(-50%, -50%);
  }

  .curator-small.amber::after {
    content: "🥃";
    font-size: 96px;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
  }

  .newsletter-section {
    position: relative;
    background: #063828;
    padding: 74px 34px 66px;
    text-align: center;
    color: #edf4ef;
    overflow: hidden;
  }

  .newsletter-section > img.newsletter-bg {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center 40%;
    opacity: 0.18;
    z-index: 0;
  }

  .newsletter-section > *:not(.newsletter-bg) {
    position: relative;
    z-index: 1;
  }

  .newsletter-mark {
    margin: 0 auto 16px;
    color: #52bf8e;
    font-size: 20px;
  }

  .newsletter-title {
    margin: 0 0 10px;
    font-size: 60px;
    color: #edf4ef;
  }

  .newsletter-copy {
    margin: 0 auto 22px;
    max-width: 760px;
    color: rgba(237, 244, 239, 0.64);
    font-size: 14px;
    line-height: 1.75;
  }

  .newsletter-form {
    display: inline-flex;
    gap: 10px;
    flex-wrap: wrap;
    justify-content: center;
  }

  .newsletter-form input {
    min-width: 420px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    background: rgba(255, 255, 255, 0.06);
    color: #edf4ef;
    padding: 16px 18px;
    font-size: 13px;
    outline: none;
  }

  .newsletter-btn {
    border: 0;
    background: #2d8e69;
    color: #fff;
    padding: 16px 22px;
  }

  .footer-section {
    padding: 34px 34px 22px;
    border-top: 1px solid #efe9df;
  }

  .footer-grid {
    display: grid;
    grid-template-columns: 1.3fr 0.8fr 1fr 0.9fr;
    gap: 34px;
    font-size: 12px;
    color: #88948d;
  }

  .footer-brand {
    color: #215747;
    font-weight: 700;
    margin-bottom: 8px;
  }

  .footer-title {
    margin-bottom: 8px;
    color: #16372d;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    font-size: 10px;
  }

  .footer-links-col {
    display: grid;
    gap: 6px;
  }

  .footer-links-col a,
  .contact-meta a {
    color: inherit;
    text-decoration: none;
  }

  .footer-bottom {
    margin-top: 18px;
    padding-top: 12px;
    border-top: 1px solid #f0ebe3;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 14px;
    color: #b1b8b3;
    font-size: 11px;
  }

  @media (max-width: 860px) {
    .topbar,
    .nav-links,
    .nav-actions,
    .story-grid,
    .curator-grid,
    .curator-right-bottom,
    .footer-grid,
    .footer-bottom {
      grid-template-columns: 1fr;
      flex-direction: column;
      align-items: flex-start;
    }

    .hero-copy {
      padding: 68px 22px 60px;
    }

    .hero h1 {
      font-size: 64px;
    }

    .hero::after,
    .hero::before,
    .hero-frame {
      display: none;
    }

    .story-section,
    .curator-section,
    .newsletter-section,
    .footer-section {
      padding-left: 16px;
      padding-right: 16px;
    }
  }
</style>

<div class="home-shell">
  <header class="topbar">
    <a href="${pageContext.request.contextPath}/" class="brand">Gokyo Bistro</a>
    <c:choose>
      <c:when test="${not empty sessionScope.currentUser}">
        <nav class="nav-links">
          <a
            href="${pageContext.request.contextPath}/admin/dashboard"
            class="nav-link active"
            >Dashboard</a
          >
        </nav>
        <div class="nav-actions">
          <span class="nav-icon">o</span>
          <span class="nav-icon">o</span>
          <form
            method="POST"
            action="${pageContext.request.contextPath}/admin/logout"
            style="display: inline"
          >
            <button
              type="submit"
              class="nav-link"
              style="background: none; border: none; cursor: pointer"
            >
              Logout
            </button>
          </form>
        </div>
      </c:when>
      <c:otherwise>
        <nav class="nav-links">
          <a href="${pageContext.request.contextPath}/" class="nav-link active"
            >Home</a
          >
          <a
            href="${pageContext.request.contextPath}/customer/menu"
            class="nav-link"
            >Menu</a
          >
          <a
            href="${pageContext.request.contextPath}/customer/scan"
            class="nav-link"
            >Scan QR</a
          >
          <a
            href="${pageContext.request.contextPath}/admin/login"
            class="nav-link"
            >Admin</a
          >
        </nav>
        <div class="nav-actions">
          <span class="nav-icon">o</span>
          <span class="nav-icon">o</span>
          <a
            href="${pageContext.request.contextPath}/admin/login"
            class="nav-link"
            >Login</a
          >
          <a
            href="${pageContext.request.contextPath}/customer/scan"
            class="btn-primary"
            style="padding: 12px 18px"
            >Scan QR</a
          >
        </div>
      </c:otherwise>
    </c:choose>
  </header>

  <section class="hero">
    <img
      src="${heroFoodImg}"
      alt="Gokyo Bistro signature dishes"
      class="hero-bg-img"
      loading="eager"
      onerror="this.onerror=null;this.src='${restaurantAmbienceImg}';"
    />
    <div class="hero-copy">
      <p class="eyebrow">Established in the Himalayas</p>
      <h1>Plated<br />Perfection</h1>
      <p>
        A culinary sanctuary where Himalayan ingredients meet avant garde
        technique. Experience the art of mindful gastronomy.
      </p>
      <div class="hero-actions">
        <a
          href="${pageContext.request.contextPath}/customer/menu"
          class="btn-primary"
          >Explore Menu</a
        >
        <a
          href="${pageContext.request.contextPath}/customer/scan"
          class="btn-secondary"
          >Scan QR</a
        >
      </div>
    </div>
  </section>

  <section class="story-section" id="philosophy">
    <div class="story-grid">
      <div class="story-visual">
        <img
          src="${restaurantAmbienceImg}"
          alt="Gokyo Bistro dining ambience"
          loading="eager"
          onerror="this.onerror=null;this.src='${heroFoodImg}';"
        />
        <div class="story-plate"></div>
        <div class="story-badge">The Gokyo Standard</div>
      </div>
      <div class="story-copy">
        <h2>The Philosophy of<br />Intentional Dining</h2>
        <p>
          At Gokyo Bistro, we believe that every ingredient carries a narrative.
          Our plating begins at the source, from peak mountain produce to
          heritage grains and clarified butter patiently prepared in house.
        </p>
        <p>
          Masterful design is our cornerstone. In the rhythm of the kitchen,
          every leaf is placed with care, every reduction balanced with
          restraint, and every course composed to feel generous, calm, and
          deeply memorable.
        </p>
        <a
          href="${pageContext.request.contextPath}/customer/scan"
          class="story-link"
          >Learn about our sourcing <span>→</span></a
        >
      </div>
    </div>
  </section>

  <section class="curator-section" id="curator">
    <h2 class="curator-heading">The Curator's Selection</h2>
    <div class="curator-grid">
      <article class="curator-left">
        <img
          src="${lambRackImg}"
          alt="Highland Lamb Rack"
          loading="eager"
          onerror="this.onerror=null;this.src='${heroFoodImg}';"
        />
        <div class="curator-caption">
          <h3>Highland Lamb Rack</h3>
          <div class="price-chip">Rs 4,200</div>
        </div>
      </article>
      <div class="curator-stack">
        <article class="curator-right-top">
          <img
            src="${riverCrabImg}"
            alt="River Crab Infusion"
            loading="eager"
            onerror="this.onerror=null;this.src='${heroFoodImg}';"
          />
          <div class="curator-caption">
            <h3 style="font-size: 24px">River Crab Infusion</h3>
            <div class="price-chip">Rs 3,300</div>
          </div>
        </article>
        <div class="curator-right-bottom">
          <article class="curator-small pink">
            <div class="curator-caption">
              <h3 style="font-size: 21px">Silken Torte</h3>
              <div class="price-chip">Rs 950</div>
            </div>
          </article>
          <article class="curator-small amber">
            <div class="curator-caption">
              <h3 style="font-size: 21px">Golden Highball</h3>
              <div class="price-chip">Rs 1,250</div>
            </div>
          </article>
        </div>
      </div>
    </div>
  </section>

  <section class="newsletter-section">
    <img
      src="${feedbackDiningImg}"
      alt="Restaurant dining table"
      class="newsletter-bg"
      loading="eager"
      onerror="this.onerror=null;this.src='${restaurantAmbienceImg}';"
    />
    <div class="newsletter-mark">✦</div>
    <h2 class="newsletter-title">Join the Inner Circle</h2>
    <p class="newsletter-copy">
      Receive early access to seasonal tasting menus, chef residencies, and
      exclusive cellar previews. Become part of Gokyo Bistro's culinary world.
    </p>
    <form
      class="newsletter-form"
      onsubmit="
        event.preventDefault();
        window.location = '${pageContext.request.contextPath}/customer/scan';
      "
    >
      <input type="email" placeholder="Enter your email" />
      <button type="submit" class="newsletter-btn">Subscribe</button>
    </form>
  </section>

  <footer class="footer-section">
    <div class="footer-grid">
      <div>
        <div class="footer-brand">Gokyo Bistro</div>
        <div>
          Elevating Himalayan ingredients through composed modern tasting menus
          and warm hospitality.
        </div>
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
        <div class="footer-title">Hours</div>
        <div class="footer-links-col">
          <span>Mon-Fri: 11:00 AM to 10:30 PM</span>
          <span>Sat-Sun: 10:00 AM to 11:00 PM</span>
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <span>&copy; 2026 Gokyo Bistro. All Rights Reserved.</span>
      <div class="contact-meta">
        <a href="${pageContext.request.contextPath}/customer/scan">Scan QR</a>
        <a href="${pageContext.request.contextPath}/admin/login">Login</a>
      </div>
    </div>
  </footer>
</div>

<%@ include file="/pages/errorpages/footer.jsp" %>
