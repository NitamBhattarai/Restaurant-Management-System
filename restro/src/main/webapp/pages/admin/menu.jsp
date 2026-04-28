<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Menu Management"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-16 bg-white border-b border-black/10 flex items-center px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Menu Management</span>
  </div>
  <div class="p-8">

    <!-- Toolbar -->
    <div class="flex gap-3 mb-6 flex-wrap items-center">
      <button onclick="openAddModal()"
              class="inline-flex items-center gap-2 bg-forest text-white px-5 py-2 rounded text-sm font-medium
                     hover:bg-forest-md transition-colors">
        + Add New Item
      </button>
      <input type="text" id="menuSearch" placeholder="Search items…" oninput="filterMenu()"
             class="gk-field px-4 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none w-52">
      <select id="catFilter" onchange="filterMenu()"
              class="gk-field px-4 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none">
        <option value="">All Categories</option>
        <c:forEach items="${categories}" var="cat">
          <option value="${cat.name}">${cat.name}</option>
        </c:forEach>
      </select>
    </div>

    <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-black/10">
        <span class="text-[13.5px] font-semibold text-ink">
          Menu Items <span class="text-xs font-normal text-muted">${menuItems.size()} items</span>
        </span>
      </div>
      <table class="w-full text-[13px]" id="menuTable">
        <thead>
          <tr class="border-b border-black/10">
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Item</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Category</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Price</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Status</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${menuItems}" var="item">
            <tr class="border-b border-black/5 hover:bg-paper transition-colors"
                data-name="${item.name}" data-cat="${item.categoryName}">
              <td class="px-4 py-3">
                <span class="mr-2">${item.emoji}</span>
                <strong class="font-medium text-ink">${item.name}</strong>
              </td>
              <td class="px-4 py-3 text-xs text-muted">${item.categoryName}</td>
              <td class="px-4 py-3 font-semibold">
                Rs <fmt:formatNumber value="${item.price}" pattern="#,##0.00"/>
              </td>
              <td class="px-4 py-3">
                <span class="badge ${item.available ? 'badge-paid' : 'badge-cancelled'}">
                  ${item.available ? 'Available' : 'Unavailable'}
                </span>
              </td>
              <td class="px-4 py-3">
                <div class="flex gap-2">
                  <button onclick="openEditModal(${item.id},'${item.name}',${item.categoryId},${item.price},'${item.emoji}',${item.available},'${item.description}')"
                          class="text-xs border border-black/16 px-3 py-1.5 rounded hover:border-forest hover:text-forest transition-all">Edit</button>
                  <form method="POST" action="${pageContext.request.contextPath}/admin/menu"
                        onsubmit="return confirm('Remove this item?')" style="display:inline">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${item.id}">
                    <button type="submit"
                            class="text-xs bg-red-50 border border-red-200 text-red-700 px-3 py-1.5 rounded
                                   hover:bg-red-600 hover:text-white transition-all">Remove</button>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- EDIT ITEM MODAL -->
<div id="editModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center">
  <div class="bg-white rounded-2xl p-8 max-w-md w-full mx-4 shadow-xl">
    <div class="flex items-center justify-between mb-6">
      <h3 class="font-serif text-2xl font-normal">Edit Menu Item</h3>
      <button onclick="document.getElementById('editModal').classList.add('hidden')" class="text-muted hover:text-ink text-xl">✕</button>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/admin/menu">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="id" id="editId">
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Item Name</label>
          <input name="name" id="editName" type="text" placeholder="e.g. Truffle Risotto" required
                 class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Category</label>
          <select name="categoryId" id="editCategoryId" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none">
            <c:forEach items="${categories}" var="cat">
              <option value="${cat.id}">${cat.name}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Price (Rs)</label>
          <input name="price" id="editPrice" type="number" step="0.01" placeholder="480" required
                 class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Emoji</label>
          <input name="emoji" id="editEmoji" type="text" placeholder="🍝"
                 class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
        </div>
      </div>
      <div class="mb-4">
        <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Description</label>
        <textarea name="description" id="editDescription" rows="2" placeholder="Brief tasting note…"
                  class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none resize-y"></textarea>
      </div>
      <div class="mb-6">
        <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Available</label>
        <input type="checkbox" name="available" id="editAvailable" value="1" checked>
      </div>
      <div class="flex gap-3 justify-end">
        <button type="button" onclick="document.getElementById('editModal').classList.add('hidden')"
                class="text-sm border border-black/16 px-5 py-2 rounded hover:border-forest hover:text-forest transition-all">Cancel</button>
        <button type="submit"
                class="text-sm bg-forest text-white px-5 py-2 rounded hover:bg-forest-md transition-colors">Update Item</button>
      </div>
    </form>
  </div>
</div>
<div id="addModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center">
  <div class="bg-white rounded-2xl p-8 max-w-md w-full mx-4 shadow-xl">
    <div class="flex items-center justify-between mb-6">
      <h3 class="font-serif text-2xl font-normal">Add Menu Item</h3>
      <button onclick="document.getElementById('addModal').classList.add('hidden')" class="text-muted hover:text-ink text-xl">✕</button>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/admin/menu">
      <input type="hidden" name="action" value="create">
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Item Name</label>
          <input name="name" type="text" placeholder="e.g. Truffle Risotto" required
                 class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Category</label>
          <select name="categoryId" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none">
            <c:forEach items="${categories}" var="cat">
              <option value="${cat.id}">${cat.name}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Price (Rs)</label>
          <input name="price" type="number" step="0.01" placeholder="480" required
                 class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Emoji</label>
          <input name="emoji" type="text" placeholder="🍝"
                 class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
        </div>
      </div>
      <div class="mb-6">
        <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Description</label>
        <textarea name="description" rows="2" placeholder="Brief tasting note…"
                  class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none resize-y"></textarea>
      </div>
      <div class="flex gap-3 justify-end">
        <button type="button" onclick="document.getElementById('addModal').classList.add('hidden')"
                class="text-sm border border-black/16 px-5 py-2 rounded hover:border-forest hover:text-forest transition-all">Cancel</button>
        <button type="submit"
                class="text-sm bg-forest text-white px-5 py-2 rounded hover:bg-forest-md transition-colors">Save Item</button>
      </div>
    </form>
  </div>
</div>

<script>
function openAddModal() { document.getElementById('addModal').classList.remove('hidden'); }
function openEditModal(id, name, catId, price, emoji, available, description) {
  document.getElementById('editId').value = id;
  document.getElementById('editName').value = name;
  document.getElementById('editCategoryId').value = catId;
  document.getElementById('editPrice').value = price;
  document.getElementById('editEmoji').value = emoji;
  document.getElementById('editDescription').value = description;
  document.getElementById('editAvailable').checked = available;
  document.getElementById('editModal').classList.remove('hidden');
}
function filterMenu() {
  const s = document.getElementById('menuSearch').value.toLowerCase();
  const c = document.getElementById('catFilter').value.toLowerCase();
  document.querySelectorAll('#menuTable tbody tr[data-name]').forEach(row => {
    const mn = row.dataset.name.toLowerCase().includes(s);
    const mc = !c || row.dataset.cat.toLowerCase().includes(c);
    row.style.display = mn && mc ? '' : 'none';
  });
}
</script>
</body>
</html>


