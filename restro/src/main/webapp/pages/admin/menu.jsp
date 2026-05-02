<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Menu Management"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<style>
  .admin-menu-card {
    background: #fff;
    border: 1px solid #efe8df;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 1px 0 rgba(27, 47, 39, .02);
    transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
  }
  .admin-menu-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 16px 28px rgba(20, 43, 35, .08);
    border-color: #ded4c7;
  }
  .admin-menu-visual {
    position: relative;
    height: 150px;
    overflow: hidden;
    background: radial-gradient(circle at 50% 45%, rgba(155, 224, 170, .78), rgba(30, 101, 76, .92) 48%, rgba(8, 46, 38, 1) 82%), linear-gradient(160deg, #10493b, #06261f);
  }
  .admin-menu-visual.image {
    background-size: cover;
    background-position: center;
  }
  .admin-menu-plate {
    position: absolute;
    inset: 20px;
    border-radius: 50%;
    background: radial-gradient(circle at 50% 44%, #fff 0 28%, #eee7dc 29% 53%, #d6c9b8 54% 66%, rgba(92, 71, 48, .25) 67% 100%);
    box-shadow: 0 18px 28px rgba(0,0,0,.2);
  }
  .admin-menu-plate::after {
    content: attr(data-emoji);
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 42px;
  }
  .admin-menu-body {
    padding: 18px;
  }
  .admin-menu-title {
    margin: 0 0 6px;
    font-size: 17px;
    line-height: 1.25;
    font-weight: 700;
    color: #1a1a18;
  }
  .admin-menu-desc {
    color: #7a7870;
    font-size: 12px;
    line-height: 1.55;
    height: 56px;
    overflow: hidden;
  }
  .admin-image-drop {
    border: 1px dashed rgba(26,58,46,.25);
    background: rgba(26,58,46,.04);
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

<div class="ml-60 min-h-screen bg-paper2">
  <div class="h-20 bg-white border-b border-black/10 flex items-center justify-between px-8 sticky top-0 z-20">
    <div>
      <div class="text-[10px] uppercase tracking-[0.28em] text-muted font-semibold">Menu Management</div>
      <div class="text-2xl font-serif font-normal text-ink mt-2">Cuisine catalog</div>
    </div>
    <div class="flex items-center gap-3">
      <input type="search" id="menuSearch" placeholder="Search dishes or categories" oninput="filterMenu()"
             class="gk-field w-80 px-4 py-2 rounded-full border border-black/10 bg-paper text-sm text-ink outline-none focus:border-forest">
      <select id="catFilter" onchange="filterMenu()"
              class="gk-field px-4 py-2 bg-paper border border-black/10 rounded-full text-sm text-ink outline-none">
        <option value="">All Categories</option>
        <c:forEach items="${categories}" var="cat">
          <option value="${cat.name}">${cat.name}</option>
        </c:forEach>
      </select>
      <button onclick="openAddModal()"
              class="inline-flex items-center gap-2 bg-forest text-white px-5 py-2 rounded text-sm font-medium hover:bg-forest-md transition-colors">
        <span>+</span>
        <span>Add New Menu</span>
      </button>
    </div>
  </div>

  <main class="p-8">
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

    <div class="grid grid-cols-3 gap-4 mb-8">
      <div class="bg-white border border-black/10 rounded-3xl p-6 shadow-sm">
        <div class="text-[10px] uppercase tracking-widest text-muted font-semibold mb-4">Total Items</div>
        <div class="text-4xl font-serif text-forest">${menuItems.size()}</div>
      </div>
      <div class="bg-white border border-black/10 rounded-3xl p-6 shadow-sm">
        <div class="text-[10px] uppercase tracking-widest text-muted font-semibold mb-4">Available</div>
        <div class="text-4xl font-serif text-forest">${liveCount}</div>
      </div>
      <div class="bg-white border border-black/10 rounded-3xl p-6 shadow-sm">
        <div class="text-[10px] uppercase tracking-widest text-muted font-semibold mb-4">Unavailable</div>
        <div class="text-4xl font-serif text-ink">${draftCount}</div>
      </div>
    </div>

    <div id="menuGrid" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">
      <c:forEach items="${menuItems}" var="item">
        <article class="admin-menu-card menu-item-row"
                 data-name="${fn:escapeXml(item.name)}"
                 data-cat="${fn:escapeXml(item.categoryName)}"
                 data-search="${fn:toLowerCase(item.name)} ${fn:toLowerCase(item.categoryName)}">
          <c:choose>
            <c:when test="${not empty item.imageUrl}">
              <c:url value="${item.imageUrl}" var="itemImage"/>
              <div class="admin-menu-visual image" style="background-image: linear-gradient(180deg, rgba(0,0,0,.05), rgba(0,0,0,.28)), url('${itemImage}');">
                <span class="absolute left-4 top-4 badge ${item.available ? 'badge-paid' : 'badge-cancelled'}">${item.available ? 'Available' : 'Unavailable'}</span>
              </div>
            </c:when>
            <c:otherwise>
              <div class="admin-menu-visual">
                <span class="absolute left-4 top-4 badge ${item.available ? 'badge-paid' : 'badge-cancelled'}">${item.available ? 'Available' : 'Unavailable'}</span>
                <div class="admin-menu-plate" data-emoji="${empty item.emoji ? 'M' : item.emoji}"></div>
              </div>
            </c:otherwise>
          </c:choose>
          <div class="admin-menu-body">
            <div class="flex items-start justify-between gap-4 mb-3">
              <div>
                <h3 class="admin-menu-title"><c:out value="${item.name}"/></h3>
                <div class="text-[11px] uppercase tracking-[0.18em] text-muted2 font-semibold"><c:out value="${item.categoryName}"/></div>
              </div>
              <div class="text-right font-serif text-2xl text-forest whitespace-nowrap">
                Rs <fmt:formatNumber value="${item.price}" pattern="#,##0"/>
              </div>
            </div>
            <p class="admin-menu-desc mb-5">
              <c:choose>
                <c:when test="${not empty item.description}"><c:out value="${item.description}"/></c:when>
                <c:otherwise>No tasting note has been added for this menu item.</c:otherwise>
              </c:choose>
            </p>
            <div class="flex items-center gap-2">
              <button type="button"
                      class="edit-menu-btn flex-1 bg-paper border border-black/10 rounded px-4 py-2 text-sm font-medium text-ink hover:border-forest hover:text-forest transition-all"
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
              <form method="POST" action="${pageContext.request.contextPath}/admin/menu" onsubmit="return confirm('Remove this item?')" class="shrink-0">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="${item.id}">
                <button type="submit" class="bg-red-50 border border-red-200 text-red-700 rounded px-4 py-2 text-sm font-medium hover:bg-red-600 hover:text-white transition-all">
                  Remove
                </button>
              </form>
            </div>
          </div>
        </article>
      </c:forEach>
    </div>
  </main>
</div>

<div id="editModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center p-4">
  <div class="bg-white rounded-3xl max-w-3xl w-full shadow-2xl overflow-hidden">
    <div class="px-8 py-6 border-b border-black/10 flex items-center justify-between">
      <div>
        <h3 class="font-serif text-3xl text-ink">Edit Menu Item</h3>
        <p class="text-sm text-muted mt-1">Update details, availability, and menu photo.</p>
      </div>
      <button onclick="closeModal('editModal')" class="w-10 h-10 rounded-full border border-black/10 text-muted hover:text-ink hover:bg-paper">x</button>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/admin/menu" enctype="multipart/form-data" class="p-8">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="id" id="editId">
      <div class="grid grid-cols-[1.1fr_0.9fr] gap-6">
        <div>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Item Name</label>
              <input name="name" id="editName" type="text" required class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none">
            </div>
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Category</label>
              <select name="categoryId" id="editCategoryId" class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none">
                <c:forEach items="${categories}" var="cat">
                  <option value="${cat.id}">${cat.name}</option>
                </c:forEach>
              </select>
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Price (Rs)</label>
              <input name="price" id="editPrice" type="number" step="0.01" required class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none">
            </div>
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Emoji</label>
              <input name="emoji" id="editEmoji" type="text" placeholder="Food" class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none">
            </div>
          </div>
          <div class="mb-4">
            <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Description</label>
            <textarea name="description" id="editDescription" rows="5" class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none resize-y"></textarea>
          </div>
          <label class="inline-flex items-center gap-2 text-sm text-ink">
            <input type="checkbox" name="available" id="editAvailable" value="1" checked>
            Available on customer menu
          </label>
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Menu Image</label>
          <label class="admin-image-drop rounded-2xl p-4 min-h-[258px] flex flex-col items-center justify-center text-center cursor-pointer hover:bg-forest/5 transition-colors">
            <img id="editImagePreview" alt="" class="hidden w-full h-44 object-cover rounded-xl mb-4">
            <span class="text-sm font-semibold text-forest">Browse image from device</span>
            <span class="text-xs text-muted mt-2">JPG, PNG, GIF, or WEBP up to 5 MB</span>
            <input name="imageFile" type="file" accept="image/*" class="hidden" onchange="previewImage(this, 'editImagePreview')">
          </label>
        </div>
      </div>
      <div class="flex gap-3 justify-end mt-8">
        <button type="button" onclick="closeModal('editModal')" class="text-sm border border-black/16 px-5 py-2 rounded hover:border-forest hover:text-forest transition-all">Cancel</button>
        <button type="submit" class="text-sm bg-forest text-white px-5 py-2 rounded hover:bg-forest-md transition-colors">Update Item</button>
      </div>
    </form>
  </div>
</div>

<div id="addModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center p-4">
  <div class="bg-white rounded-3xl max-w-3xl w-full shadow-2xl overflow-hidden">
    <div class="px-8 py-6 border-b border-black/10 flex items-center justify-between">
      <div>
        <h3 class="font-serif text-3xl text-ink">Add Menu Item</h3>
        <p class="text-sm text-muted mt-1">Create a new dish with category, pricing, and image.</p>
      </div>
      <button onclick="closeModal('addModal')" class="w-10 h-10 rounded-full border border-black/10 text-muted hover:text-ink hover:bg-paper">x</button>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/admin/menu" enctype="multipart/form-data" class="p-8">
      <input type="hidden" name="action" value="create">
      <div class="grid grid-cols-[1.1fr_0.9fr] gap-6">
        <div>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Item Name</label>
              <input name="name" type="text" placeholder="e.g. Himalayan Herb Salad" required class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none">
            </div>
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Category</label>
              <select name="categoryId" class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none">
                <c:forEach items="${categories}" var="cat">
                  <option value="${cat.id}">${cat.name}</option>
                </c:forEach>
              </select>
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Price (Rs)</label>
              <input name="price" type="number" step="0.01" placeholder="850" required class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none">
            </div>
            <div>
              <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Emoji</label>
              <input name="emoji" type="text" placeholder="Food" class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none">
            </div>
          </div>
          <div>
            <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Description</label>
            <textarea name="description" rows="5" placeholder="Brief tasting note" class="gk-field w-full px-4 py-3 bg-white border border-black/10 rounded text-sm text-ink outline-none resize-y"></textarea>
          </div>
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Menu Image</label>
          <label class="admin-image-drop rounded-2xl p-4 min-h-[258px] flex flex-col items-center justify-center text-center cursor-pointer hover:bg-forest/5 transition-colors">
            <img id="addImagePreview" alt="" class="hidden w-full h-44 object-cover rounded-xl mb-4">
            <span class="text-sm font-semibold text-forest">Browse image from device</span>
            <span class="text-xs text-muted mt-2">JPG, PNG, GIF, or WEBP up to 5 MB</span>
            <input name="imageFile" type="file" accept="image/*" class="hidden" onchange="previewImage(this, 'addImagePreview')">
          </label>
        </div>
      </div>
      <div class="flex gap-3 justify-end mt-8">
        <button type="button" onclick="closeModal('addModal')" class="text-sm border border-black/16 px-5 py-2 rounded hover:border-forest hover:text-forest transition-all">Cancel</button>
        <button type="submit" class="text-sm bg-forest text-white px-5 py-2 rounded hover:bg-forest-md transition-colors">Save Item</button>
      </div>
    </form>
  </div>
</div>

<script>
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
  const category = document.getElementById('catFilter').value.trim().toLowerCase();
  document.querySelectorAll('.menu-item-row').forEach(card => {
    const haystack = (card.dataset.search || '').toLowerCase();
    const cat = (card.dataset.cat || '').toLowerCase();
    const matchesSearch = !search || haystack.includes(search);
    const matchesCategory = !category || cat.includes(category);
    card.style.display = matchesSearch && matchesCategory ? '' : 'none';
  });
}
</script>
</body>
</html>
