<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Guest Feedbacks"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<c:set var="totalReviews" value="${fn:length(feedbackList)}"/>
<c:set var="sentimentScore" value="${totalReviews > 0 ? (positiveCount * 100) / totalReviews : 0}"/>
<c:set var="rating5" value="0"/>
<c:set var="rating4" value="0"/>
<c:set var="rating3" value="0"/>
<c:set var="rating2" value="0"/>
<c:set var="rating1" value="0"/>
<c:forEach items="${feedbackList}" var="fb">
  <c:choose>
    <c:when test="${fb.overallRating == 5}"><c:set var="rating5" value="${rating5 + 1}"/></c:when>
    <c:when test="${fb.overallRating == 4}"><c:set var="rating4" value="${rating4 + 1}"/></c:when>
    <c:when test="${fb.overallRating == 3}"><c:set var="rating3" value="${rating3 + 1}"/></c:when>
    <c:when test="${fb.overallRating == 2}"><c:set var="rating2" value="${rating2 + 1}"/></c:when>
    <c:otherwise><c:set var="rating1" value="${rating1 + 1}"/></c:otherwise>
  </c:choose>
</c:forEach>

<style>
  .feedback-chip {
    border: 1px solid rgba(0,0,0,0.05);
    border-radius: 999px;
    padding: 6px 16px;
    font-size: 13px;
    font-weight: 500;
    color: #374151;
    background: transparent;
    transition: all 0.2s;
  }
  .feedback-chip.active {
    color: #111827;
    background: #f4f5f5;
    border-color: transparent;
    font-weight: 600;
  }
  .keyword-good {
    background: #eef8f4;
    border: 1px solid #d1efe3;
    color: #114b3e;
    font-size: 11px;
    font-weight: 600;
    padding: 6px 12px;
    border-radius: 6px;
  }
  .keyword-bad {
    background: #fdf2f2;
    border: 1px solid #f9dcdc;
    color: #9b1c1c;
    font-size: 11px;
    font-weight: 600;
    padding: 6px 12px;
    border-radius: 6px;
  }
</style>

<div class="ml-48 min-h-screen bg-[#fbfbfb]">
  <div class="h-16 bg-white border-b border-black/5 flex items-center justify-between px-8 sticky top-0 z-20">
    <div class="relative">
      <span class="absolute left-3 top-1/2 -translate-y-1/2 text-muted text-sm">🔍</span>
      <input id="feedbackSearch" type="search" placeholder="Search reviews, guests or keywords..."
             class="w-80 pl-9 pr-4 py-1.5 rounded-full bg-[#f4f5f5] text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20 transition-all">
    </div>
    <div class="flex items-center gap-4">
      <button class="w-8 h-8 flex items-center justify-center text-muted hover:text-ink transition-colors">🔔</button>
      <button class="w-8 h-8 flex items-center justify-center text-muted hover:text-ink transition-colors">⚙️</button>
    </div>
  </div>

  <main class="p-8 max-w-[1400px]">
    <c:if test="${not empty sessionScope.flashSuccess}">
      <div class="bg-green-50 border border-green-200 text-green-800 text-sm px-4 py-3 rounded mb-6">
        <c:out value="${sessionScope.flashSuccess}"/>
        <c:remove var="flashSuccess" scope="session"/>
      </div>
    </c:if>

    <section class="mb-8 border-b border-black/5 pb-6">
      <h1 class="font-serif text-[28px] font-bold text-[#114b3e] mb-1">Guest Feedbacks & Sentiment</h1>
      <p class="text-[14px] text-muted">Monitor real-time guest experiences and brand perception across Gokyo Bistro.</p>
    </section>

    <section class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
      <!-- Avg Rating -->
      <div class="bg-white border border-black/5 rounded-xl p-6 shadow-sm">
        <div class="text-[10px] uppercase tracking-widest font-bold text-muted mb-4">Average Rating</div>
        <div class="flex items-baseline gap-1 mb-2">
          <span class="text-[36px] font-semibold text-[#114b3e] leading-none">
            <fmt:formatNumber value="${averageRating > 0 ? averageRating : 4.8}" pattern="0.0"/>
          </span>
          <span class="text-[16px] font-bold text-muted2">/5.0</span>
        </div>
        <div class="flex items-center gap-2 text-[12px] font-medium text-muted">
          <span class="text-gold text-lg tracking-widest">★★★★★</span>
          <span class="text-green-600">+0.2 from last month</span>
        </div>
      </div>

      <!-- Total Reviews -->
      <div class="bg-white border border-black/5 rounded-xl p-6 shadow-sm">
        <div class="text-[10px] uppercase tracking-widest font-bold text-muted mb-4">Total Reviews</div>
        <div class="text-[36px] font-semibold text-[#114b3e] leading-none mb-4">${totalReviews > 0 ? totalReviews : '1,240'}</div>
        <div class="flex items-center gap-2 text-[12px] font-medium text-[#114b3e]">
          <span class="flex -space-x-1">
            <span class="w-6 h-6 rounded-full bg-[#114b3e] text-white border-2 border-white flex items-center justify-center text-[9px]">A</span>
            <span class="w-6 h-6 rounded-full bg-ink text-white border-2 border-white flex items-center justify-center text-[9px]">M</span>
            <span class="w-6 h-6 rounded-full bg-muted text-white border-2 border-white flex items-center justify-center text-[9px]">S</span>
          </span>
          <span>+48 new this week</span>
        </div>
      </div>

      <!-- Sentiment Score -->
      <div class="bg-[#114b3e] border border-[#114b3e] rounded-xl p-6 shadow-sm text-white">
        <div class="text-[10px] uppercase tracking-widest font-bold text-white/80 mb-4">Sentiment Score</div>
        <div class="flex items-baseline gap-2 mb-4">
          <span class="text-[36px] font-semibold leading-none"><fmt:formatNumber value="${sentimentScore > 0 ? sentimentScore : 92}" pattern="0"/>%</span>
          <span class="text-[16px] font-medium text-white/90">Positive</span>
        </div>
        <div class="h-2 rounded-full bg-white/20 overflow-hidden">
          <div class="h-full rounded-full bg-[#419c72]" style="width: <fmt:formatNumber value="${sentimentScore > 0 ? sentimentScore : 92}" pattern="0"/>%"></div>
        </div>
      </div>
    </section>

    <section class="grid grid-cols-1 lg:grid-cols-[1.8fr_1fr] gap-6">
      <!-- Left side (Reviews) -->
      <div>
        <!-- Filters -->
        <div class="flex items-center justify-between mb-6">
          <div class="flex items-center gap-2 bg-white rounded-full p-1 border border-black/5 shadow-sm">
            <button class="feedback-chip active" data-filter="all">All</button>
            <button class="feedback-chip" data-filter="positive">Positive</button>
            <button class="feedback-chip" data-filter="neutral">Neutral</button>
            <button class="feedback-chip" data-filter="critical">Critical</button>
          </div>
          <div class="flex items-center gap-2 text-[12px] text-muted font-medium">
            Sort by:
            <select class="bg-transparent font-bold text-ink outline-none">
              <option>Newest First</option>
              <option>Highest Rating</option>
              <option>Lowest Rating</option>
            </select>
          </div>
        </div>

        <!-- Review List -->
        <div class="space-y-4" id="reviewList">
          <c:choose>
            <c:when test="${not empty feedbackList}">
              <c:forEach items="${feedbackList}" var="fb">
                <c:set var="searchText" value="${fb.guestName} ${fb.tableNumber} ${fb.comments}"/>
                <article class="bg-white border border-black/5 rounded-xl p-6 shadow-sm review-item"
                         data-sentiment="${fb.sentiment}"
                         data-search="${fn:toLowerCase(searchText)}">
                  <div class="flex justify-between items-start mb-4">
                    <div class="flex gap-4">
                      <div class="w-10 h-10 rounded-full bg-[#114b3e] text-white flex items-center justify-center font-bold text-sm">${fb.initials}</div>
                      <div>
                        <div class="font-bold text-ink text-[15px]"><c:out value="${fb.guestName}"/></div>
                        <div class="text-[11px] text-muted flex items-center gap-2 mt-0.5">
                          <span>📅 <c:choose><c:when test="${not empty fb.createdAt}">${fn:substring(fb.createdAt.toString(), 0, 10)}</c:when><c:otherwise>Oct 24, 2023</c:otherwise></c:choose></span>
                          <c:if test="${not empty fb.tableNumber}"><span>🪑 Table #${fb.tableNumber}</span></c:if>
                        </div>
                      </div>
                    </div>
                    <div class="text-[12px] font-bold text-gold flex items-center gap-1">
                      ${fb.overallRating}.0 <span>★</span>
                    </div>
                  </div>

                  <!-- Category Ratings (Stars) -->
                  <div class="grid grid-cols-3 gap-4 border-y border-black/5 py-4 mb-4 text-center">
                    <div>
                      <div class="text-[9px] uppercase tracking-widest font-bold text-muted mb-1">Cuisine</div>
                      <div class="text-gold text-[12px]">
                        <c:forEach begin="1" end="${fb.cuisineRating}">★</c:forEach><c:forEach begin="${fb.cuisineRating + 1}" end="5"><span class="text-gray-200">★</span></c:forEach>
                      </div>
                    </div>
                    <div class="border-x border-black/5">
                      <div class="text-[9px] uppercase tracking-widest font-bold text-muted mb-1">Service</div>
                      <div class="text-gold text-[12px]">
                        <c:forEach begin="1" end="${fb.serviceRating}">★</c:forEach><c:forEach begin="${fb.serviceRating + 1}" end="5"><span class="text-gray-200">★</span></c:forEach>
                      </div>
                    </div>
                    <div>
                      <div class="text-[9px] uppercase tracking-widest font-bold text-muted mb-1">Ambience</div>
                      <div class="text-gold text-[12px]">
                        <c:forEach begin="1" end="${fb.ambienceRating}">★</c:forEach><c:forEach begin="${fb.ambienceRating + 1}" end="5"><span class="text-gray-200">★</span></c:forEach>
                      </div>
                    </div>
                  </div>

                  <p class="text-[13px] italic text-[#4b4742] mb-5 leading-relaxed">"<c:out value="${fb.comments}"/>"</p>

                  <div class="flex items-center justify-between">
                    <div class="flex gap-2">
                      <button class="bg-[#114b3e] text-white px-4 py-1.5 rounded text-[12px] font-bold hover:bg-[#0e3b31] transition-colors">Respond</button>
                      <button class="bg-[#f4f5f5] text-ink px-4 py-1.5 rounded text-[12px] font-bold hover:bg-[#eef0f0] transition-colors border border-black/5">Internal Note</button>
                    </div>
                    <div class="flex items-center gap-3">
                      <c:if test="${fb.overallRating <= 3}">
                        <span class="text-[9px] uppercase tracking-widest font-bold text-[#b45309] bg-[#fef3c7] px-2 py-1 rounded">Needs Attention</span>
                      </c:if>
                      <button class="text-muted hover:text-ink transition-colors text-sm">⚑ FLAG</button>
                    </div>
                  </div>
                </article>
              </c:forEach>
            </c:when>

            <c:otherwise>
              <!-- Mock Data if empty -->
              <article class="bg-white border border-black/5 rounded-xl p-6 shadow-sm review-item">
                <div class="flex justify-between items-start mb-4">
                  <div class="flex gap-4">
                    <div class="w-10 h-10 rounded-full bg-ink text-white flex items-center justify-center font-bold text-sm">AS</div>
                    <div>
                      <div class="font-bold text-ink text-[15px]">Anjali Sharma</div>
                      <div class="text-[11px] text-muted flex items-center gap-2 mt-0.5">
                        <span>📅 Oct 24, 2024</span>
                        <span>🪑 Table #12</span>
                      </div>
                    </div>
                  </div>
                  <div class="text-[12px] font-bold text-gold flex items-center gap-1">5.0 <span>★</span></div>
                </div>
                <div class="grid grid-cols-3 gap-4 border-y border-black/5 py-4 mb-4 text-center">
                  <div><div class="text-[9px] uppercase tracking-widest font-bold text-muted mb-1">Cuisine</div><div class="text-gold text-[12px]">★★★★★</div></div>
                  <div class="border-x border-black/5"><div class="text-[9px] uppercase tracking-widest font-bold text-muted mb-1">Service</div><div class="text-gold text-[12px]">★★★★★</div></div>
                  <div><div class="text-[9px] uppercase tracking-widest font-bold text-muted mb-1">Ambience</div><div class="text-gold text-[12px]">★★★★★</div></div>
                </div>
                <p class="text-[13px] italic text-[#4b4742] mb-5 leading-relaxed">"The Himalayan Trout was absolutely sublime. Authentic flavors that reminded me of home. The staff was incredibly attentive to our needs throughout the evening. Definitely coming back!"</p>
                <div class="flex items-center justify-between">
                  <div class="flex gap-2">
                    <button class="bg-[#114b3e] text-white px-4 py-1.5 rounded text-[12px] font-bold hover:bg-[#0e3b31]">Respond</button>
                    <button class="bg-[#f4f5f5] text-ink px-4 py-1.5 rounded text-[12px] font-bold border border-black/5">Internal Note</button>
                  </div>
                  <button class="text-muted hover:text-ink text-sm">⚑ FLAG</button>
                </div>
              </article>

              <article class="bg-white border border-black/5 rounded-xl p-6 shadow-sm review-item">
                <div class="flex justify-between items-start mb-4">
                  <div class="flex gap-4">
                    <div class="w-10 h-10 rounded-full bg-ink text-white flex items-center justify-center font-bold text-sm">DM</div>
                    <div>
                      <div class="font-bold text-ink text-[15px]">David Miller</div>
                      <div class="text-[11px] text-muted flex items-center gap-2 mt-0.5">
                        <span>📅 Oct 22, 2024</span>
                        <span>🪑 Table #04</span>
                      </div>
                    </div>
                  </div>
                  <div class="text-[12px] font-bold text-muted2 flex items-center gap-1">3.0 <span>★</span></div>
                </div>
                <div class="grid grid-cols-3 gap-4 border-y border-black/5 py-4 mb-4 text-center">
                  <div><div class="text-[9px] uppercase tracking-widest font-bold text-muted mb-1">Cuisine</div><div class="text-gold text-[12px]">★★★★★</div></div>
                  <div class="border-x border-black/5"><div class="text-[9px] uppercase tracking-widest font-bold text-muted mb-1">Service</div><div class="text-gold text-[12px]">★★★<span class="text-gray-200">★★</span></div></div>
                  <div><div class="text-[9px] uppercase tracking-widest font-bold text-muted mb-1">Ambience</div><div class="text-gold text-[12px]">★★★★★</div></div>
                </div>
                <p class="text-[13px] italic text-[#4b4742] mb-5 leading-relaxed">"Food was great as usual, but we had to wait 25 minutes for our drinks to arrive. It was a busy Friday night, but service could be slightly faster during peak hours. Great vibe though."</p>
                <div class="flex items-center justify-between">
                  <div class="flex gap-2">
                    <button class="bg-[#114b3e] text-white px-4 py-1.5 rounded text-[12px] font-bold hover:bg-[#0e3b31]">Respond</button>
                    <button class="bg-[#f4f5f5] text-ink px-4 py-1.5 rounded text-[12px] font-bold border border-black/5">Internal Note</button>
                  </div>
                  <div class="flex items-center gap-3">
                    <span class="text-[9px] uppercase tracking-widest font-bold text-[#b45309] bg-[#fef3c7] px-2 py-1 rounded">Needs Attention</span>
                    <button class="text-muted hover:text-ink text-sm">⚑</button>
                  </div>
                </div>
              </article>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- Right side -->
      <aside class="space-y-6">
        <div class="bg-white border border-black/5 rounded-xl p-6 shadow-sm">
          <h2 class="text-[15px] font-bold text-ink mb-6 flex items-center gap-2">📈 Sentiment Analysis</h2>
          
          <div class="mb-6">
            <div class="text-[9px] uppercase tracking-widest text-[#419c72] font-bold mb-3">Positive Keywords</div>
            <div class="flex flex-wrap gap-2">
              <span class="keyword-good">Friendly Staff</span>
              <span class="keyword-good">Great Ambience</span>
              <span class="keyword-good">Authentic Taste</span>
              <span class="keyword-good">Cleanliness</span>
              <span class="keyword-good">Yak Burger</span>
            </div>
          </div>
          
          <div class="mb-6">
            <div class="text-[9px] uppercase tracking-widest text-[#e02424] font-bold mb-3">Pain Points</div>
            <div class="flex flex-wrap gap-2">
              <span class="keyword-bad">Wait Time</span>
              <span class="keyword-bad">Weekend Noise</span>
              <span class="keyword-bad">Parking Space</span>
            </div>
          </div>

          <div class="border-t border-black/5 pt-6">
            <div class="text-[9px] uppercase tracking-widest text-muted font-bold mb-4">Rating Distribution</div>
            <div class="space-y-3">
              <div class="flex items-center gap-3 text-[11px] font-bold text-ink"><span class="w-2">5</span><div class="flex-1 h-2 bg-[#f4f5f5] rounded-full overflow-hidden"><div class="h-full bg-[#114b3e]" style="width:78%"></div></div><span class="text-muted w-6 text-right">78%</span></div>
              <div class="flex items-center gap-3 text-[11px] font-bold text-ink"><span class="w-2">4</span><div class="flex-1 h-2 bg-[#f4f5f5] rounded-full overflow-hidden"><div class="h-full bg-[#114b3e]" style="width:15%"></div></div><span class="text-muted w-6 text-right">15%</span></div>
              <div class="flex items-center gap-3 text-[11px] font-bold text-ink"><span class="w-2">3</span><div class="flex-1 h-2 bg-[#f4f5f5] rounded-full overflow-hidden"><div class="h-full bg-gold" style="width:5%"></div></div><span class="text-muted w-6 text-right">5%</span></div>
              <div class="flex items-center gap-3 text-[11px] font-bold text-ink"><span class="w-2">2</span><div class="flex-1 h-2 bg-[#f4f5f5] rounded-full overflow-hidden"><div class="h-full bg-red-400" style="width:2%"></div></div><span class="text-muted w-6 text-right">2%</span></div>
            </div>
          </div>
        </div>

        <div class="rounded-xl bg-ink text-white p-6 shadow-lg shadow-black/10">
          <h2 class="text-[15px] font-bold mb-2">Smart Action</h2>
          <p class="text-[12px] text-white/70 mb-5 leading-relaxed">3 recent reviews mentioned "Slow Service on Weekends". Consider adding a temporary runner for Friday evenings.</p>
          <button class="w-full bg-white text-ink font-bold py-2.5 rounded text-[12px] hover:bg-paper transition-colors">APPLY SUGGESTION</button>
        </div>
      </aside>
    </section>
  </main>
</div>

<script>
  const feedbackSearch = document.getElementById('feedbackSearch');
  const chips = Array.from(document.querySelectorAll('.feedback-chip'));

  feedbackSearch.addEventListener('input', filterFeedback);
  chips.forEach(chip => {
    chip.addEventListener('click', () => {
      chips.forEach(item => item.classList.remove('active'));
      chip.classList.add('active');
      filterFeedback();
    });
  });

  function filterFeedback() {
    const query = feedbackSearch.value.trim().toLowerCase();
    const active = document.querySelector('.feedback-chip.active').dataset.filter;
    document.querySelectorAll('.review-item').forEach(item => {
      const matchesSearch = !query || (item.dataset.search || '').includes(query);
      const matchesFilter = active === 'all' || (item.dataset.sentiment || '').includes(active);
      item.style.display = matchesSearch && matchesFilter ? '' : 'none';
    });
  }
</script>
</body>
</html>
