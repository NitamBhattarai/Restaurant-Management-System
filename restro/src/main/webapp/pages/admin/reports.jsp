<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Financial Reports"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<div class="ml-48 min-h-screen bg-[#fbfaf7]">
  <div class="h-14 bg-white border-b border-black/10 flex items-center justify-between px-6 sticky top-0 z-20">
    <div class="flex items-center gap-3 text-[13px]">
      <span class="text-muted">Dashboard</span>
      <span class="text-black/20">/</span>
      <span class="font-semibold text-ink">Financial Reports</span>
    </div>
    <div class="flex items-center gap-4">
      <div class="w-64 bg-[#f7f5f1] border border-black/6 rounded-full px-4 py-2 text-[12px] text-muted">Search reports...</div>
      <span class="text-muted">◔</span>
      <span class="text-muted">⚙</span>
    </div>
  </div>

  <div class="p-6">
    <div class="grid grid-cols-[2fr_1fr] gap-5 mb-5">
      <div class="bg-[#184d3f] rounded-xl text-white p-6 shadow-sm">
        <div class="text-[10px] uppercase tracking-[0.18em] text-white/60 font-semibold mb-4">Total Monthly Revenue</div>
        <div class="flex items-end gap-3 mb-6">
          <div class="font-serif text-5xl leading-none">1,24,000</div>
          <div class="text-[12px] text-[#8ad0ae] font-semibold">+12.5%</div>
        </div>
        <div class="grid grid-cols-3 gap-6">
          <div>
            <div class="text-[10px] uppercase tracking-[0.16em] text-white/45 mb-2">Avg. Ticket</div>
            <div class="text-[24px] font-semibold">Rs 1,840</div>
          </div>
          <div>
            <div class="text-[10px] uppercase tracking-[0.16em] text-white/45 mb-2">Transactions</div>
            <div class="text-[24px] font-semibold">678</div>
          </div>
          <div>
            <div class="text-[10px] uppercase tracking-[0.16em] text-white/45 mb-2">Peak Hour</div>
            <div class="text-[24px] font-semibold">19:00 - 21:00</div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl border border-black/8 p-6">
        <div class="flex items-center gap-2 text-[13px] font-semibold text-ink mb-4">
          <span class="text-forest">✦</span>
          <span>AI Forecasting</span>
        </div>
        <div class="text-[11px] uppercase tracking-[0.14em] text-muted mb-2">Predicted Revenue (Next Month)</div>
        <div class="font-serif text-4xl text-ink leading-none mb-3">1,474,080</div>
        <div class="text-[#2f9b6d] font-semibold text-[14px] mb-5">+18.4% <span class="text-muted font-normal text-[11px]">vs this month</span></div>
        <div class="rounded-lg bg-[#faf7f2] border border-black/6 px-4 py-3 text-[11px] text-muted leading-relaxed">
          “Growth driven by upcoming holiday weekend and high demand for seasonal specials.”
        </div>
      </div>
    </div>

    <div class="grid grid-cols-[1fr_1fr_1fr] gap-5 mb-5">
      <div class="bg-white rounded-xl border border-black/8 p-5">
        <div class="text-[11px] font-semibold text-ink mb-4">Margin Drivers</div>
        <div class="space-y-4">
          <div>
            <div class="flex justify-between text-[12px] mb-2"><span class="text-muted">Beverages</span><span class="text-forest font-semibold">72% Margin</span></div>
            <div class="h-1.5 rounded-full bg-paper3"><div class="h-full w-[72%] bg-forest rounded-full"></div></div>
          </div>
          <div>
            <div class="flex justify-between text-[12px] mb-2"><span class="text-muted">Entrees</span><span class="text-forest font-semibold">38% Margin</span></div>
            <div class="h-1.5 rounded-full bg-paper3"><div class="h-full w-[38%] bg-forest rounded-full"></div></div>
          </div>
          <div>
            <div class="flex justify-between text-[12px] mb-2"><span class="text-muted">Desserts</span><span class="text-forest font-semibold">54% Margin</span></div>
            <div class="h-1.5 rounded-full bg-paper3"><div class="h-full w-[54%] bg-forest rounded-full"></div></div>
          </div>
        </div>
      </div>

      <div class="bg-[#1c1b1a] rounded-xl overflow-hidden relative min-h-[220px]">
        <div class="absolute inset-0 bg-[radial-gradient(circle_at_50%_50%,rgba(178,119,78,.45),transparent_45%)]"></div>
        <div class="absolute top-4 left-4 text-[#5ad29b] text-[11px] font-semibold">★ TOP PERFORMER</div>
        <div class="absolute left-5 bottom-5 text-white">
          <div class="font-serif text-4xl leading-none mb-2">Thakali Set Special</div>
          <div class="text-[11px] text-white/70 mb-3">452 units sold this month</div>
          <div class="text-[12px] text-white/70">Total Revenue <span class="text-white font-semibold ml-3">Rs 429,400</span></div>
        </div>
      </div>

      <div class="bg-white rounded-xl border border-black/8 p-5">
        <div class="text-[11px] font-semibold text-ink mb-4">Operating Costs</div>
        <div class="space-y-5 text-[13px]">
          <div class="flex items-center justify-between"><div class="flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-[#ffc44d]"></span><span class="text-muted">Inventory</span></div><strong>Rs 340,000</strong></div>
          <div class="flex items-center justify-between"><div class="flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-[#6ea8ff]"></span><span class="text-muted">Payroll</span></div><strong>Rs 210,000</strong></div>
          <div class="flex items-center justify-between"><div class="flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-[#ff6f6f]"></span><span class="text-muted">Utilities</span></div><strong>Rs 45,500</strong></div>
        </div>
      </div>
    </div>

    <div class="bg-white rounded-xl border border-black/8 p-5 mb-5">
      <div class="flex items-center justify-between mb-4">
        <div>
          <div class="text-[18px] font-semibold text-ink">Daily Revenue Trends</div>
          <div class="text-[12px] text-muted">Historical performance vs AI predictions</div>
        </div>
        <div class="flex gap-2 text-[11px]">
          <span class="px-3 py-1 rounded bg-paper2 text-muted">7D</span>
          <span class="px-3 py-1 rounded bg-forest text-white">30D</span>
          <span class="px-3 py-1 rounded bg-paper2 text-muted">90D</span>
        </div>
      </div>
      <div class="grid grid-cols-7 gap-3 items-end h-72">
        <div class="bg-[#f1f1ef] rounded-t h-[45%]"></div>
        <div class="bg-[#f1f1ef] rounded-t h-[58%]"></div>
        <div class="bg-[#f1f1ef] rounded-t h-[54%]"></div>
        <div class="bg-[#f1f1ef] rounded-t h-[64%]"></div>
        <div class="bg-[#184d3f] rounded-t h-[82%] relative"><span class="absolute -top-6 left-2 text-[10px] bg-[#1f1f1f] text-white rounded px-2 py-1">Today 11.7k</span></div>
        <div class="bg-[#d7efe4] rounded-t h-[88%] relative"><span class="absolute -top-6 left-2 text-[10px] bg-[#2c6b57] text-white rounded px-2 py-1">AI Forecast</span></div>
        <div class="bg-[#e4f5ee] rounded-t h-[78%]"></div>
      </div>
    </div>

    <div class="grid grid-cols-[2fr_1fr] gap-5">
      <div class="bg-white rounded-xl border border-black/8 overflow-hidden">
        <div class="px-5 py-4 border-b border-black/8 flex items-center justify-between">
          <div class="font-semibold text-ink">Recent Transactions</div>
          <div class="text-[12px] text-forest font-semibold">View All</div>
        </div>
        <table class="w-full text-[13px]">
          <thead>
            <tr class="text-[10px] uppercase tracking-[0.14em] text-muted border-b border-black/6">
              <th class="px-5 py-3 text-left">Order ID</th>
              <th class="px-5 py-3 text-left">Customer</th>
              <th class="px-5 py-3 text-left">Items</th>
              <th class="px-5 py-3 text-right">Amount</th>
            </tr>
          </thead>
          <tbody>
            <tr class="border-b border-black/6">
              <td class="px-5 py-4 text-muted">#GB - 9821</td>
              <td class="px-5 py-4 font-medium">Aryan S.</td>
              <td class="px-5 py-4 text-muted">Momo (2), Coke (1)</td>
              <td class="px-5 py-4 text-right font-semibold">Rs 1,250</td>
            </tr>
            <tr class="border-b border-black/6">
              <td class="px-5 py-4 text-muted">#GB - 9820</td>
              <td class="px-5 py-4 font-medium">Maya K.</td>
              <td class="px-5 py-4 text-muted">Thakali Set (4)</td>
              <td class="px-5 py-4 text-right font-semibold">Rs 4,800</td>
            </tr>
            <tr>
              <td class="px-5 py-4 text-muted">#GB - 9819</td>
              <td class="px-5 py-4 font-medium">Samir R.</td>
              <td class="px-5 py-4 text-muted">Chicken Curry, Naan (2)</td>
              <td class="px-5 py-4 text-right font-semibold">Rs 2,150</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="space-y-4">
        <div class="bg-[#eef8f4] rounded-xl p-5 border border-[#d8ece3]">
          <div class="font-semibold text-ink mb-2">Margin Alert</div>
          <div class="text-[12px] text-muted leading-relaxed">Lentil prices increased by 14%. Suggestion: adjust Dal Bhat menu item to maintain margin.</div>
        </div>
        <div class="bg-[#211f1c] rounded-xl p-5 text-white">
          <div class="font-semibold mb-2">Operational Risk</div>
          <div class="text-[12px] text-white/70 leading-relaxed mb-4">Projected high-volume traffic for Saturday evening. Recommend 2 floor staff to optimize service speed.</div>
          <button class="w-full rounded-lg bg-white/10 py-3 text-[11px] font-semibold uppercase tracking-[0.14em]">Review Schedule</button>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="/pages/errorpages/footer.jsp" %>
