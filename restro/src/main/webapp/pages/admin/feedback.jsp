<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Guest Feedbacks"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<c:set var="totalReviews" value="${feedbackList.size()}"/>
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
  .feedback-card {
    background: #fff;
    border: 1px solid #dedbd5;
    border-radius: 18px;
    box-shadow: 0 2px 8px rgba(26, 26, 24, .04);
  }
  .feedback-chip {
    border: 1px solid #dedbd5;
    border-radius: 999px;
    padding: 9px 20px;
    font-weight: 600;
    color: #56524e;
    background: #fbfaf8;
  }
  .feedback-chip.active {
    color: #0f4d3f;
    background: #e7f2ee;
    border-color: #d6e8e1;
  }
  .review-card {
    background: #fff;
    border: 1px solid #dedbd5;
    border-radius: 18px;
    box-shadow: 0 2px 8px rgba(26, 26, 24, .04);
  }
  .keyword-good {
    background: #e9fff4;
    border: 1px solid #bdebd5;
    color: #007a55;
  }
  .keyword-bad {
    background: #fff0f2;
    border: 1px solid #f3cbd0;
    color: #c21845;
  }
</style>

<div class="ml-60 min-h-screen bg-[#fbfaf8]">
  <div class="h-20 bg-white border-b border-black/10 flex items-center justify-between px-8 sticky top-0 z-20">
    <div class="relative">
      <span class="absolute left-4 top-1/2 -translate-y-1/2 text-3xl text-muted2 leading-none">S</span>
      <input id="feedbackSearch" type="search" placeholder="Search reviews, guests or keywords..."
             class="gk-field w-[460px] rounded-full bg-[#f1f0ee] border border-transparent py-3 pl-14 pr-5 text-lg text-muted outline-none focus:bg-white">
    </div>
    <div class="flex items-center gap-3">
      <button onclick="openFeedbackModal()"
              class="bg-forest text-white px-5 py-3 rounded text-sm font-semibold hover:bg-forest-md transition-colors">
        Add Feedback
      </button>
      <button onclick="showFeedbackMessage('No new feedback alerts.')" class="w-11 h-11 rounded-full border border-black/10 text-muted hover:text-forest hover:bg-paper transition-colors" aria-label="Notifications">!</button>
      <button onclick="showFeedbackMessage('Feedback settings are available in Settings.')" class="w-11 h-11 rounded-full border border-black/10 text-muted hover:text-forest hover:bg-paper transition-colors" aria-label="Settings">O</button>
    </div>
  </div>

  <main class="px-8 py-10">
    <c:if test="${not empty sessionScope.flashSuccess}">
      <div class="bg-green-50 border border-green-200 text-green-800 text-sm px-4 py-3 rounded mb-6">
        <c:out value="${sessionScope.flashSuccess}"/>
        <c:remove var="flashSuccess" scope="session"/>
      </div>
    </c:if>
    <c:if test="${not empty sessionScope.flashError}">
      <div class="bg-red-50 border border-red-200 text-red-800 text-sm px-4 py-3 rounded mb-6">
        <c:out value="${sessionScope.flashError}"/>
        <c:remove var="flashError" scope="session"/>
      </div>
    </c:if>

    <section class="mb-10">
      <h1 class="font-serif text-5xl leading-tight font-bold text-forest mb-3">Guest Feedbacks &amp; Sentiment</h1>
      <p class="text-2xl text-muted">Monitor real-time guest experiences and brand perception across Gokyo Bistro.</p>
    </section>

    <section class="grid grid-cols-1 xl:grid-cols-3 gap-6 mb-10">
      <div class="feedback-card p-8">
        <div class="text-[17px] uppercase tracking-[0.22em] font-semibold text-muted mb-7">Average Rating</div>
        <div class="flex items-end gap-1 mb-6">
          <span class="font-serif text-6xl font-bold text-forest leading-none">
            <fmt:formatNumber value="${averageRating}" pattern="0.0"/>
          </span>
          <span class="font-serif text-3xl font-bold text-muted2 leading-none">/5.0</span>
        </div>
        <div class="flex items-center gap-5">
          <span class="text-gold text-2xl tracking-wide">&#9733;&#9733;&#9733;&#9733;&#9734;</span>
          <span class="text-lg text-muted2 font-semibold">${totalReviews} submitted reviews</span>
        </div>
      </div>

      <div class="feedback-card p-8">
        <div class="text-[17px] uppercase tracking-[0.22em] font-semibold text-muted mb-7">Total Reviews</div>
        <div class="font-serif text-6xl font-bold text-forest leading-none mb-8">${totalReviews}</div>
        <div class="flex items-center gap-3 text-forest font-semibold text-lg">
          <span class="inline-flex -space-x-2">
            <span class="w-8 h-8 rounded-full bg-forest text-white border-2 border-white flex items-center justify-center text-xs">G</span>
            <span class="w-8 h-8 rounded-full bg-ink text-white border-2 border-white flex items-center justify-center text-xs">B</span>
            <span class="w-8 h-8 rounded-full bg-muted text-white border-2 border-white flex items-center justify-center text-xs">R</span>
          </span>
          <span>${positiveCount} positive reviews</span>
        </div>
      </div>

      <div class="rounded-[18px] bg-[#114f43] text-white p-8 shadow-2xl shadow-black/15">
        <div class="text-[17px] uppercase tracking-[0.22em] font-semibold text-white/80 mb-7">Sentiment Score</div>
        <div class="flex items-end gap-4 mb-8">
          <span class="font-serif text-6xl font-bold leading-none"><fmt:formatNumber value="${sentimentScore}" pattern="0"/>%</span>
          <span class="font-serif text-3xl leading-none">Positive</span>
        </div>
        <div class="h-3 rounded-full bg-white/10 overflow-hidden">
          <div class="h-full rounded-full bg-[#39d69c]" style="width: <fmt:formatNumber value="${sentimentScore}" pattern="0"/>%"></div>
        </div>
      </div>
    </section>

    <section class="grid grid-cols-[1.8fr_0.9fr] gap-7">
      <div>
        <div class="feedback-card p-5 mb-7 flex items-center justify-between">
          <div class="flex items-center gap-3">
            <button class="feedback-chip active" data-filter="all">All</button>
            <button class="feedback-chip" data-filter="positive">Positive</button>
            <button class="feedback-chip" data-filter="neutral">Neutral</button>
            <button class="feedback-chip" data-filter="critical">Critical</button>
          </div>
          <div class="flex items-center gap-5 text-lg">
            <span class="text-muted2">Sort by:</span>
            <select class="gk-field bg-transparent font-semibold text-ink outline-none">
              <option>Newest First</option>
              <option>Highest Rating</option>
              <option>Needs Attention</option>
            </select>
          </div>
        </div>

        <div class="space-y-7" id="reviewList">
          <c:choose>
            <c:when test="${empty feedbackList}">
              <div class="feedback-card p-10 text-center">
                <div class="font-serif text-3xl text-forest mb-3">No feedback yet</div>
                <p class="text-muted mb-6">Add a guest review and it will appear here in the same card layout.</p>
                <button onclick="openFeedbackModal()" class="bg-forest text-white px-6 py-3 rounded font-semibold">Add Feedback</button>
              </div>
            </c:when>
            <c:otherwise>
              <c:forEach items="${feedbackList}" var="fb">
                <c:set var="searchText" value="${fb.guestName} ${fb.tableNumber} ${fb.comments}"/>
                <article class="review-card p-7 review-item"
                         data-sentiment="${fb.sentiment}"
                         data-search="${fn:toLowerCase(searchText)}">
                  <div class="flex items-start justify-between gap-6">
                    <div class="flex gap-5">
                      <div class="w-16 h-16 rounded-full bg-forest text-white flex items-center justify-center text-xl font-serif">${fb.initials}</div>
                      <div>
                        <h2 class="text-2xl font-bold text-ink"><c:out value="${fb.guestName}"/></h2>
                        <div class="text-lg text-muted mt-1">
                          <c:choose>
                            <c:when test="${not empty fb.createdAt}">${fn:substring(fb.createdAt.toString(), 0, 10)}</c:when>
                            <c:otherwise>Today</c:otherwise>
                          </c:choose>
                          <c:if test="${not empty fb.tableNumber}">&nbsp;&nbsp; Table #<c:out value="${fb.tableNumber}"/></c:if>
                        </div>
                      </div>
                    </div>
                    <div class="rounded-full ${fb.overallRating >= 4 ? 'bg-[#fff6d8] text-gold' : fb.overallRating == 3 ? 'bg-[#f1f0ee] text-muted2' : 'bg-red-50 text-red-700'} px-5 py-2 text-xl font-bold">
                      ${fb.overallRating}.0 &#9733;
                    </div>
                  </div>
                  <div class="grid grid-cols-3 gap-5 border-y border-black/10 my-6 py-5 text-center">
                    <div><div class="text-sm uppercase tracking-widest text-muted2 font-bold mb-2">Cuisine</div><div class="text-gold text-lg">${fb.cuisineRating}/5</div></div>
                    <div class="border-x border-black/10"><div class="text-sm uppercase tracking-widest text-muted2 font-bold mb-2">Service</div><div class="text-gold text-lg">${fb.serviceRating}/5</div></div>
                    <div><div class="text-sm uppercase tracking-widest text-muted2 font-bold mb-2">Ambience</div><div class="text-gold text-lg">${fb.ambienceRating}/5</div></div>
                  </div>
                  <p class="text-xl italic leading-relaxed text-[#4b4742] mb-7">"<c:out value="${fb.comments}"/>"</p>
                  <div class="flex items-center justify-between">
                    <div class="flex gap-3">
                      <button class="bg-forest text-white px-8 py-3 rounded text-lg font-semibold hover:bg-forest-md">Respond</button>
                      <button class="bg-[#f1f0ee] text-ink2 px-8 py-3 rounded text-lg font-semibold hover:bg-paper3">Internal Note</button>
                    </div>
                    <c:if test="${fb.overallRating <= 3}">
                      <span class="bg-[#fff0c7] text-[#a65300] px-5 py-2 rounded font-bold">Needs Attention</span>
                    </c:if>
                  </div>
                </article>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <aside class="space-y-7">
        <div class="feedback-card p-7">
          <h2 class="text-2xl font-bold text-ink mb-8">Sentiment Analysis</h2>
          <div class="mb-8">
            <div class="text-sm uppercase tracking-[0.22em] text-[#007a55] font-bold mb-5">Positive Keywords</div>
            <div class="flex flex-wrap gap-3">
              <span class="keyword-good rounded px-5 py-3 font-semibold">Friendly Staff</span>
              <span class="keyword-good rounded px-5 py-3 font-semibold">Great Ambience</span>
              <span class="keyword-good rounded px-5 py-3 font-semibold">Authentic Taste</span>
              <span class="keyword-good rounded px-5 py-3 font-semibold">Cleanliness</span>
            </div>
          </div>
          <div class="mb-8">
            <div class="text-sm uppercase tracking-[0.22em] text-[#c21845] font-bold mb-5">Pain Points</div>
            <div class="flex flex-wrap gap-3">
              <span class="keyword-bad rounded px-5 py-3 font-semibold">Wait Time</span>
              <span class="keyword-bad rounded px-5 py-3 font-semibold">Weekend Noise</span>
              <span class="keyword-bad rounded px-5 py-3 font-semibold">Parking Space</span>
            </div>
          </div>
          <div class="border-t border-black/10 pt-7">
            <div class="text-sm uppercase tracking-[0.22em] text-muted font-bold mb-6">Rating Distribution</div>
            <div class="space-y-4">
              <c:set var="p5" value="${totalReviews > 0 ? (rating5 * 100) / totalReviews : 0}"/>
              <c:set var="p4" value="${totalReviews > 0 ? (rating4 * 100) / totalReviews : 0}"/>
              <c:set var="p3" value="${totalReviews > 0 ? (rating3 * 100) / totalReviews : 0}"/>
              <c:set var="p2" value="${totalReviews > 0 ? (rating2 * 100) / totalReviews : 0}"/>
              <div class="grid grid-cols-[20px_1fr_42px] gap-4 items-center"><span class="font-bold">5</span><div class="h-3 bg-[#f1f0ee] rounded-full overflow-hidden"><div class="h-full bg-forest" style="width:${p5}%"></div></div><span class="text-muted2 font-semibold"><fmt:formatNumber value="${p5}" pattern="0"/>%</span></div>
              <div class="grid grid-cols-[20px_1fr_42px] gap-4 items-center"><span class="font-bold">4</span><div class="h-3 bg-[#f1f0ee] rounded-full overflow-hidden"><div class="h-full bg-forest" style="width:${p4}%"></div></div><span class="text-muted2 font-semibold"><fmt:formatNumber value="${p4}" pattern="0"/>%</span></div>
              <div class="grid grid-cols-[20px_1fr_42px] gap-4 items-center"><span class="font-bold">3</span><div class="h-3 bg-[#f1f0ee] rounded-full overflow-hidden"><div class="h-full bg-gold" style="width:${p3}%"></div></div><span class="text-muted2 font-semibold"><fmt:formatNumber value="${p3}" pattern="0"/>%</span></div>
              <div class="grid grid-cols-[20px_1fr_42px] gap-4 items-center"><span class="font-bold">2</span><div class="h-3 bg-[#f1f0ee] rounded-full overflow-hidden"><div class="h-full bg-rose-400" style="width:${p2}%"></div></div><span class="text-muted2 font-semibold"><fmt:formatNumber value="${p2}" pattern="0"/>%</span></div>
            </div>
          </div>
        </div>

        <div class="rounded-[18px] bg-[#4a4641] text-white p-8 shadow-2xl shadow-black/15">
          <h2 class="font-serif text-3xl font-bold mb-6">Smart Action</h2>
          <p class="text-lg leading-relaxed text-white/70 mb-8">Reviews rated 3 or lower are marked as needs attention so the team can follow up quickly.</p>
          <button class="w-full bg-white text-ink font-bold py-4 rounded text-lg hover:bg-paper">Apply Suggestion</button>
        </div>
      </aside>
    </section>
  </main>
</div>

<div id="feedbackModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center p-4">
  <div class="bg-white rounded-3xl max-w-3xl w-full shadow-2xl overflow-hidden">
    <div class="px-8 py-6 border-b border-black/10 flex items-center justify-between">
      <div>
        <h3 class="font-serif text-3xl text-ink">Add Guest Feedback</h3>
        <p class="text-sm text-muted mt-1">This feedback will immediately appear on the admin feedback page.</p>
      </div>
      <button onclick="closeFeedbackModal()" class="w-10 h-10 rounded-full border border-black/10 text-muted hover:text-ink hover:bg-paper">x</button>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/admin/feedback" class="p-8">
      <input type="hidden" name="action" value="create">
      <div class="grid grid-cols-3 gap-4 mb-4">
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Guest Name</label>
          <input name="guestName" required class="gk-field w-full px-4 py-3 border border-black/10 rounded text-sm outline-none" placeholder="Anjali Sharma">
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Email</label>
          <input name="guestEmail" type="email" class="gk-field w-full px-4 py-3 border border-black/10 rounded text-sm outline-none" placeholder="guest@email.com">
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Table</label>
          <input name="tableNumber" class="gk-field w-full px-4 py-3 border border-black/10 rounded text-sm outline-none" placeholder="12">
        </div>
      </div>
      <div class="grid grid-cols-4 gap-4 mb-4">
        <c:forEach items="${['overallRating','cuisineRating','serviceRating','ambienceRating']}" var="field">
          <div>
            <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">
              <c:choose>
                <c:when test="${field == 'overallRating'}">Overall</c:when>
                <c:when test="${field == 'cuisineRating'}">Cuisine</c:when>
                <c:when test="${field == 'serviceRating'}">Service</c:when>
                <c:otherwise>Ambience</c:otherwise>
              </c:choose>
            </label>
            <select name="${field}" class="gk-field w-full px-4 py-3 border border-black/10 rounded text-sm outline-none">
              <option value="5">5</option>
              <option value="4">4</option>
              <option value="3">3</option>
              <option value="2">2</option>
              <option value="1">1</option>
            </select>
          </div>
        </c:forEach>
      </div>
      <div class="mb-6">
        <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Feedback</label>
        <textarea name="comments" rows="5" required class="gk-field w-full px-4 py-3 border border-black/10 rounded text-sm outline-none resize-y" placeholder="Write the guest feedback here..."></textarea>
      </div>
      <div class="flex justify-end gap-3">
        <button type="button" onclick="closeFeedbackModal()" class="border border-black/16 px-5 py-2 rounded text-sm hover:border-forest hover:text-forest">Cancel</button>
        <button type="submit" class="bg-forest text-white px-5 py-2 rounded text-sm hover:bg-forest-md">Save Feedback</button>
      </div>
    </form>
  </div>
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

  function openFeedbackModal() {
    document.getElementById('feedbackModal').classList.remove('hidden');
  }

  function closeFeedbackModal() {
    document.getElementById('feedbackModal').classList.add('hidden');
  }

  function showFeedbackMessage(message) {
    window.alert(message);
  }
</script>
</body>
</html>
