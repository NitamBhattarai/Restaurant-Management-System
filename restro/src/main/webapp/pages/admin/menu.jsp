<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Menu Catalog"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<style>
  .admin-image-drop {
    border: 1px dashed rgba(17, 75, 62, 0.25);
    background: rgba(17, 75, 62, 0.04);
  }
  .toggle-checkbox:checked {
    right: 0;
    border-color: #114b3e;
  }
  .toggle-checkbox:checked + .toggle-label {
    background-color: #114b3e;
  }
</style>

<c:set var="liveCount" value="0"/>
<c:set var="draftCount" value="0"/>
<c:forEach items="${menuItems}" var="item">
  <c:choose>
    <c:when test="${item.available}"><c:set var="liveCount" value="${liveCount + 1}"/></c:when>
    <c:otherwise><c:set var="draftCount" value="${draftCount + 1}"/></c:otherwise>
  </c:choose>
</c:forEach>

<div class="ml-48 min-h-screen bg-[#fbfbfb]">
  <div class="h-16 bg-white border-b border-black/5 flex items-center justify-between px-8 sticky top-0 z-20">
    <div class="relative">
      <span class="absolute left-3 top-1/2 -translate-y-1/2 text-muted text-sm">🔍</span>
      <input id="menuSearch" type="search" placeholder="Search dishes or categories" oninput="filterMenu()"
             class="w-80 pl-9 pr-4 py-1.5 rounded-full bg-[#f4f5f5] text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20 transition-all">
    </div>
    <div class="flex items-center gap-4">
      <button class="w-8 h-8 flex items-center justify-center text-muted hover:text-ink transition-colors">🔔</button>
      <button class="w-8 h-8 flex items-center justify-center text-muted hover:text-ink transition-colors">⚙️</button>
      <div class="w-7 h-7 rounded-full bg-ink text-white flex items-center justify-center text-[11px] font-bold">
        <c:choose><c:when test="${not empty currentUser.initials}">${currentUser.initials}</c:when><c:otherwise>AU</c:otherwise></c:choose>
      </div>
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
      <h1 class="font-serif text-[28px] font-bold text-[#114b3e] mb-1">Menu Catalog</h1>
      <p class="text-[14px] text-muted">Manage your culinary offerings, categorize dishes, and control pricing.</p>
    </section>

    <div class="flex items-start gap-8">
      <!-- Left Sidebar (Categories) -->
      <aside class="w-56 shrink-0">
        <div class="text-[10px] uppercase tracking-widest font-bold text-muted mb-4 px-3">Categories</div>
        <nav class="space-y-1" id="categoryNav">
          <button class="w-full text-left px-4 py-2.5 rounded-lg text-[13px] font-bold bg-[#114b3e] text-white transition-colors" data-filter="">
            All Items
          </button>
          <c:forEach items="${categories}" var="cat">
            <button class="w-full text-left px-4 py-2.5 rounded-lg text-[13px] font-semibold text-muted hover:bg-[#f4f5f5] hover:text-ink transition-colors" data-filter="${fn:escapeXml(cat.name)}">
              ${cat.name}
            </button>
          </c:forEach>
        </nav>
      </aside>

      <!-- Right Content -->
      <div class="flex-1">
        <!-- Top Stats & Action -->
        <div class="flex items-center justify-between mb-8">
          <div class="flex gap-6">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-[#eef8f4] text-[#114b3e] flex items-center justify-center text-lg">🍽</div>
              <div>
                <div class="text-[9px] uppercase tracking-widest font-bold text-muted">Total Items</div>
                <div class="text-[18px] font-bold text-ink">${menuItems.size()} <span class="text-[11px] font-semibold text-green-600 bg-green-50 px-1.5 py-0.5 rounded ml-1">8 New</span></div>
              </div>
            </div>
            <div class="w-[1px] h-8 bg-black/5"></div>
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-red-50 text-red-600 flex items-center justify-center text-lg">⚠️</div>
              <div>
                <div class="text-[9px] uppercase tracking-widest font-bold text-muted">Out of Stock</div>
                <div class="text-[18px] font-bold text-ink"><fmt:formatNumber value="${draftCount}" minIntegerDigits="2"/> <span class="text-[11px] font-semibold text-red-600 bg-red-50 px-1.5 py-0.5 rounded ml-1">Review</span></div>
              </div>
            </div>
            <div class="w-[1px] h-8 bg-black/5"></div>
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-[#fbf5eb] text-gold flex items-center justify-center text-lg">⭐</div>
              <div>
                <div class="text-[9px] uppercase tracking-widest font-bold text-muted">Best Seller</div>
                <div class="text-[14px] font-bold text-ink mt-0.5">Chicken Momo</div>
              </div>
            </div>
          </div>
          <button onclick="openAddModal()" class="bg-[#114b3e] text-white px-5 py-2.5 rounded-lg text-[13px] font-bold hover:bg-[#0e3b31] transition-colors flex items-center gap-2">
            <span class="text-white/70 text-lg leading-none">+</span> Add New Item
          </button>
        </div>

        <!-- Menu Grid -->
        <div id="menuGrid" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">
          <c:forEach items="${menuItems}" var="item">
            <article class="bg-white border border-black/5 rounded-xl shadow-sm hover:shadow-md transition-shadow overflow-hidden menu-item-row"
                     data-name="${fn:escapeXml(item.name)}"
                     data-cat="${fn:escapeXml(item.categoryName)}"
                     data-search="${fn:toLowerCase(item.name)} ${fn:toLowerCase(item.categoryName)}">
              <!-- Image -->
              <div class="h-40 bg-[#f4f5f5] relative flex items-center justify-center">
                <c:choose>
                  <c:when test="${not empty item.imageUrl}">
                    <c:url value="${item.imageUrl}" var="itemImage"/>
                    <img src="${itemImage}" alt="${item.name}" class="w-full h-full object-cover">
                  </c:when>
                  <c:otherwise>
                    <span class="text-4xl text-black/10">📷</span>
                  </c:otherwise>
                </c:choose>
                <div class="absolute top-3 right-3 bg-white px-2 py-1 rounded text-[11px] font-bold text-ink shadow-sm">
                  रू <fmt:formatNumber value="${item.price}" pattern="#,##0"/>
                </div>
              </div>

              <!-- Body -->
              <div class="p-5">
                <h3 class="text-[15px] font-bold text-ink leading-tight mb-1"><c:out value="${item.name}"/></h3>
                <div class="text-[10px] uppercase tracking-widest font-semibold text-muted mb-4"><c:out value="${item.categoryName}"/></div>
                
                <div class="flex items-center gap-1.5 text-[11px] font-semibold text-muted mb-5">
                  <span class="text-ink font-bold">4.9</span> <span class="text-gold">★</span> (128 reviews)
                </div>

                <!-- Footer / Actions -->
                <div class="flex items-center justify-between border-t border-black/5 pt-4">
                  <!-- Toggle Switch Mockup -->
                  <div class="flex items-center gap-2">
                    <div class="relative inline-block w-8 mr-2 align-middle select-none transition duration-200 ease-in">
                      <input type="checkbox" disabled ${item.available ? 'checked' : ''} class="toggle-checkbox absolute block w-4 h-4 rounded-full bg-white border-4 appearance-none cursor-pointer border-[#f4f5f5]"/>
                      <label class="toggle-label block overflow-hidden h-4 rounded-full bg-[#f4f5f5] cursor-pointer"></label>
                    </div>
                    <span class="text-[11px] font-bold ${item.available ? 'text-[#114b3e]' : 'text-muted'}">${item.available ? 'Active' : 'Inactive'}</span>
                  </div>
                  
                  <div class="flex gap-3">
                    <button type="button"
                            class="edit-menu-btn text-[11px] font-bold text-muted hover:text-[#114b3e] transition-colors uppercase tracking-widest"
                            data-id="${item.id}"
                            data-name="${fn:escapeXml(item.name)}"
                            data-category-id="${item.categoryId}"
                            data-price="${item.price}"
                            data-emoji="${fn:escapeXml(item.emoji)}"
                            data-available="${item.available}"
                            data-description="${fn:escapeXml(item.description)}"
                            data-image-url="${fn:escapeXml(item.imageUrl)}">
                      Edit
                    </button>
                    <form method="POST" action="${pageContext.request.contextPath}/admin/menu" onsubmit="return confirm('Remove this item?')" class="inline-block">
                      <input type="hidden" name="action" value="delete">
                      <input type="hidden" name="id" value="${item.id}">
                      <button type="submit" class="text-[11px] font-bold text-red-400 hover:text-red-600 transition-colors uppercase tracking-widest">
                        Del
                      </button>
                    </form>
                  </div>
                </div>
              </div>
            </article>
          </c:forEach>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Edit Modal -->
<div id="editModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center p-4">
  <div class="bg-white rounded-2xl max-w-2xl w-full shadow-2xl overflow-hidden">
    <div class="px-8 py-6 border-b border-black/5 flex items-center justify-between">
      <div>
        <h3 class="font-serif text-[22px] font-bold text-[#114b3e]">Edit Menu Item</h3>
        <p class="text-[13px] text-muted mt-1">Update details, availability, and menu photo.</p>
      </div>
      <button onclick="closeModal('editModal')" class="w-8 h-8 flex items-center justify-center rounded-full border border-black/10 text-muted hover:text-ink hover:bg-[#f4f5f5]">✕</button>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/admin/menu" enctype="multipart/form-data" class="p-8">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="id" id="editId">
      <div class="grid grid-cols-[1fr_200px] gap-6">
        <div>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Item Name</label>
              <input name="name" id="editName" type="text" required class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20">
            </div>
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Category</label>
              <select name="categoryId" id="editCategoryId" class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20">
                <c:forEach items="${categories}" var="cat">
                  <option value="${cat.id}">${cat.name}</option>
                </c:forEach>
              </select>
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Price (रू)</label>
              <input name="price" id="editPrice" type="number" step="0.01" required class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20">
            </div>
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Emoji</label>
              <input name="emoji" id="editEmoji" type="text" placeholder="Food" class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20">
            </div>
          </div>
          <div class="mb-4">
            <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Description</label>
            <textarea name="description" id="editDescription" rows="4" class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none resize-none focus:ring-1 focus:ring-[#114b3e]/20"></textarea>
          </div>
          <label class="inline-flex items-center gap-2 text-[13px] font-semibold text-ink">
            <input type="checkbox" name="available" id="editAvailable" value="1" checked class="w-4 h-4 accent-[#114b3e]">
            Available on customer menu
          </label>
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Menu Image</label>
          <label class="admin-image-drop rounded-xl p-4 h-48 flex flex-col items-center justify-center text-center cursor-pointer hover:bg-[#114b3e]/5 transition-colors">
            <img id="editImagePreview" alt="" class="hidden w-full h-full object-cover rounded mb-2">
            <span class="text-[11px] font-bold text-[#114b3e]">Upload image</span>
            <span class="text-[10px] text-muted mt-1">Max 5MB</span>
            <input name="imageFile" type="file" accept="image/*" class="hidden" onchange="previewImage(this, 'editImagePreview')">
          </label>
        </div>
      </div>
      <div class="flex gap-3 justify-end mt-8">
        <button type="button" onclick="closeModal('editModal')" class="text-[13px] font-bold border border-black/10 px-6 py-2.5 rounded hover:bg-[#f4f5f5] transition-colors">Cancel</button>
        <button type="submit" class="text-[13px] font-bold bg-[#114b3e] text-white px-6 py-2.5 rounded hover:bg-[#0e3b31] transition-colors">Save Changes</button>
      </div>
    </form>
  </div>
</div>

<!-- Add Modal -->
<div id="addModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center p-4">
  <div class="bg-white rounded-2xl max-w-2xl w-full shadow-2xl overflow-hidden">
    <div class="px-8 py-6 border-b border-black/5 flex items-center justify-between">
      <div>
        <h3 class="font-serif text-[22px] font-bold text-[#114b3e]">Add Menu Item</h3>
        <p class="text-[13px] text-muted mt-1">Create a new dish with category, pricing, and image.</p>
      </div>
      <button onclick="closeModal('addModal')" class="w-8 h-8 flex items-center justify-center rounded-full border border-black/10 text-muted hover:text-ink hover:bg-[#f4f5f5]">✕</button>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/admin/menu" enctype="multipart/form-data" class="p-8">
      <input type="hidden" name="action" value="create">
      <div class="grid grid-cols-[1fr_200px] gap-6">
        <div>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Item Name</label>
              <input name="name" type="text" required placeholder="e.g. Himalayan Herb Salad" class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20">
            </div>
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Category</label>
              <select name="categoryId" class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20">
                <c:forEach items="${categories}" var="cat">
                  <option value="${cat.id}">${cat.name}</option>
                </c:forEach>
              </select>
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Price (रू)</label>
              <input name="price" type="number" step="0.01" required placeholder="850" class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20">
            </div>
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Emoji</label>
              <input name="emoji" type="text" placeholder="Food" class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none focus:ring-1 focus:ring-[#114b3e]/20">
            </div>
          </div>
          <div class="mb-4">
            <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Description</label>
            <textarea name="description" rows="4" placeholder="Brief tasting note" class="w-full px-3 py-2 bg-[#f4f5f5] rounded text-[13px] text-ink outline-none resize-none focus:ring-1 focus:ring-[#114b3e]/20"></textarea>
          </div>
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-bold text-muted mb-2">Menu Image</label>
          <label class="admin-image-drop rounded-xl p-4 h-48 flex flex-col items-center justify-center text-center cursor-pointer hover:bg-[#114b3e]/5 transition-colors">
            <img id="addImagePreview" alt="" class="hidden w-full h-full object-cover rounded mb-2">
            <span class="text-[11px] font-bold text-[#114b3e]">Upload image</span>
            <span class="text-[10px] text-muted mt-1">Max 5MB</span>
            <input name="imageFile" type="file" accept="image/*" class="hidden" onchange="previewImage(this, 'addImagePreview')">
          </label>
        </div>
      </div>
      <div class="flex gap-3 justify-end mt-8">
        <button type="button" onclick="closeModal('addModal')" class="text-[13px] font-bold border border-black/10 px-6 py-2.5 rounded hover:bg-[#f4f5f5] transition-colors">Cancel</button>
        <button type="submit" class="text-[13px] font-bold bg-[#114b3e] text-white px-6 py-2.5 rounded hover:bg-[#0e3b31] transition-colors">Create Item</button>
      </div>
    </form>
  </div>
</div>

<script>
let currentCategory = '';

// Category nav logic
const categoryBtns = document.querySelectorAll('#categoryNav button');
categoryBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    categoryBtns.forEach(b => {
      b.className = "w-full text-left px-4 py-2.5 rounded-lg text-[13px] font-semibold text-muted hover:bg-[#f4f5f5] hover:text-ink transition-colors";
    });
    btn.className = "w-full text-left px-4 py-2.5 rounded-lg text-[13px] font-bold bg-[#114b3e] text-white transition-colors";
    currentCategory = btn.dataset.filter.toLowerCase();
    filterMenu();
  });
});

function openAddModal() {
  document.getElementById('addModal').classList.remove('hidden');
}

function closeModal(id) {
  document.getElementById(id).classList.add('hidden');
}

function openEditModalFromButton(button) {
  const data = button.dataset;
  document.getElementById('editId').value = data.id || '';
  document.getElementById('editName').value = data.name || '';
  document.getElementById('editCategoryId').value = data.categoryId || '';
  document.getElementById('editPrice').value = data.price || '';
  document.getElementById('editEmoji').value = data.emoji || '';
  document.getElementById('editDescription').value = data.description || '';
  document.getElementById('editAvailable').checked = data.available === 'true';

  const preview = document.getElementById('editImagePreview');
  if (data.imageUrl) {
    preview.src = resolveImageUrl(data.imageUrl);
    preview.classList.remove('hidden');
  } else {
    preview.removeAttribute('src');
    preview.classList.add('hidden');
  }
  document.getElementById('editModal').classList.remove('hidden');
}

function resolveImageUrl(url) {
  if (!url) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  if (url.startsWith('${pageContext.request.contextPath}/')) return url;
  if (url.startsWith('/')) return '${pageContext.request.contextPath}' + url;
  return url;
}

document.querySelectorAll('.edit-menu-btn').forEach(button => {
  button.addEventListener('click', () => openEditModalFromButton(button));
});

function previewImage(input, previewId) {
  const preview = document.getElementById(previewId);
  const file = input.files && input.files[0];
  if (!file) {
    preview.classList.add('hidden');
    return;
  }
  preview.src = URL.createObjectURL(file);
  preview.classList.remove('hidden');
}

function filterMenu() {
  const search = document.getElementById('menuSearch').value.trim().toLowerCase();
  document.querySelectorAll('.menu-item-row').forEach(card => {
    const haystack = (card.dataset.search || '').toLowerCase();
    const cat = (card.dataset.cat || '').toLowerCase();
    const matchesSearch = !search || haystack.includes(search);
    const matchesCategory = !currentCategory || cat === currentCategory;
    card.style.display = matchesSearch && matchesCategory ? '' : 'none';
  });
}
</script>
</body>
</html>
