<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Guest Feedback"/>
<%@ include file="/pages/errorpages/header.jsp" %>

<div class="min-h-[calc(100vh-64px)] bg-paper py-12 px-4">
  <div class="mx-auto max-w-6xl">
    <div class="grid gap-6 lg:grid-cols-[1.2fr_0.8fr]">
      <section class="bg-white border border-black/10 rounded-3xl p-10 shadow-sm">
        <div class="max-w-xl">
          <span class="text-[11px] uppercase tracking-[0.35em] text-forest font-semibold">Guest experience</span>
          <h1 class="mt-4 text-4xl font-semibold text-ink leading-tight">Share your visit to Gokyo Bistro</h1>
          <p class="mt-4 text-sm text-muted leading-relaxed">Tell us how your meal felt, from the cuisine to the hospitality. Your review helps us improve each table service.</p>

          <div class="mt-10 grid gap-4">
            <div class="rounded-3xl bg-[#f4f7f3] p-6">
              <div class="text-[11px] uppercase tracking-[0.35em] font-semibold text-forest mb-3">What mattered most</div>
              <div class="space-y-3 text-sm text-[#4a4a45]">
                <p>• Cuisine quality and flavor</p>
                <p>• Attentiveness and speed of service</p>
                <p>• Atmosphere and comfort</p>
              </div>
            </div>
            <div class="rounded-3xl overflow-hidden bg-black/5 h-[320px]"></div>
          </div>
        </div>
      </section>

      <section class="bg-white border border-black/10 rounded-3xl p-8 shadow-sm">
        <div class="mb-8">
          <h2 class="text-2xl font-semibold text-ink">Leave a review</h2>
          <p class="text-sm text-muted mt-2">We store your name and email so your feedback is traceable in the system.</p>
        </div>

        <c:if test="${not empty error}">
          <div class="mb-5 rounded-2xl bg-red-50 border border-red-200 p-4 text-sm text-red-800">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
          <div class="mb-5 rounded-2xl bg-forest/10 border border-forest/20 p-4 text-sm text-forest">${success}</div>
        </c:if>

        <form method="POST" action="${pageContext.request.contextPath}/customer/feedback" class="space-y-5">
          <div class="grid gap-4 sm:grid-cols-2">
            <label class="block">
              <div class="text-[10px] uppercase tracking-widest text-muted mb-2">Name</div>
              <input name="guestName" type="text" required placeholder="Your full name"
                     class="gk-field w-full px-4 py-3 rounded-2xl border border-black/10 bg-white text-sm outline-none"/>
            </label>
            <label class="block">
              <div class="text-[10px] uppercase tracking-widest text-muted mb-2">Email</div>
              <input name="guestEmail" type="email" required placeholder="you@example.com"
                     class="gk-field w-full px-4 py-3 rounded-2xl border border-black/10 bg-white text-sm outline-none"/>
            </label>
          </div>

          <label class="block">
            <div class="text-[10px] uppercase tracking-widest text-muted mb-2">Table number (optional)</div>
            <input name="tableNumber" type="text" placeholder="T12"
                   class="gk-field w-full px-4 py-3 rounded-2xl border border-black/10 bg-white text-sm outline-none"/>
          </label>

          <div class="grid gap-4 sm:grid-cols-3">
            <label class="block">
              <div class="text-[10px] uppercase tracking-widest text-muted mb-2">Cuisine</div>
              <select name="cuisineRating" required class="gk-field w-full px-4 py-3 rounded-2xl border border-black/10 bg-white text-sm outline-none">
                <option value="">Rate cuisine</option>
                <option value="5">5 - Excellent</option>
                <option value="4">4 - Very Good</option>
                <option value="3">3 - Good</option>
                <option value="2">2 - Fair</option>
                <option value="1">1 - Poor</option>
              </select>
            </label>
            <label class="block">
              <div class="text-[10px] uppercase tracking-widest text-muted mb-2">Service</div>
              <select name="serviceRating" required class="gk-field w-full px-4 py-3 rounded-2xl border border-black/10 bg-white text-sm outline-none">
                <option value="">Rate service</option>
                <option value="5">5 - Excellent</option>
                <option value="4">4 - Very Good</option>
                <option value="3">3 - Good</option>
                <option value="2">2 - Fair</option>
                <option value="1">1 - Poor</option>
              </select>
            </label>
            <label class="block">
              <div class="text-[10px] uppercase tracking-widest text-muted mb-2">Atmosphere</div>
              <select name="ambienceRating" required class="gk-field w-full px-4 py-3 rounded-2xl border border-black/10 bg-white text-sm outline-none">
                <option value="">Rate atmosphere</option>
                <option value="5">5 - Excellent</option>
                <option value="4">4 - Very Good</option>
                <option value="3">3 - Good</option>
                <option value="2">2 - Fair</option>
                <option value="1">1 - Poor</option>
              </select>
            </label>
          </div>

          <label class="block">
            <div class="text-[10px] uppercase tracking-widest text-muted mb-2">Overall rating</div>
            <select name="overallRating" required class="gk-field w-full px-4 py-3 rounded-2xl border border-black/10 bg-white text-sm outline-none">
              <option value="">Rate overall experience</option>
              <option value="5">5 - Excellent</option>
              <option value="4">4 - Very Good</option>
              <option value="3">3 - Good</option>
              <option value="2">2 - Fair</option>
              <option value="1">1 - Poor</option>
            </select>
          </label>

          <label class="block">
            <div class="text-[10px] uppercase tracking-widest text-muted mb-2">Tell us your story</div>
            <textarea name="comments" rows="6" required placeholder="What made your visit memorable?"
                      class="gk-field w-full px-4 py-4 rounded-3xl border border-black/10 bg-white text-sm text-ink outline-none resize-y"></textarea>
          </label>

          <button type="submit" class="w-full bg-forest text-white rounded-3xl px-6 py-4 text-sm font-semibold hover:bg-forest-md transition-colors">Submit Review</button>
        </form>
      </section>
    </div>
  </div>
</div>
</body>
</html>
