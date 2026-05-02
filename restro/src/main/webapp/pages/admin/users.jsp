<%@ page contentType="text/html;charset=UTF-8" import="com.restaurantManagementSystem.model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Users & Roles"/>
<%@ include file="/pages/errorpages/header.jsp" %>
<%@ include file="/pages/errorpages/admin-sidebar.jsp" %>

<div class="ml-60 flex flex-col min-h-screen bg-paper2">
  <div class="h-16 bg-white border-b border-black/10 flex items-center px-8 sticky top-0 z-20">
    <span class="text-[14.5px] font-medium text-ink">Users &amp; Roles</span>
  </div>
  <div class="p-8">

    <!-- Flash messages -->
    <c:if test="${not empty sessionScope.flashError}">
      <div class="bg-red-50 border border-red-200 text-red-800 text-sm px-4 py-3 rounded mb-5">
        <c:out value="${sessionScope.flashError}"/>
        <c:remove var="flashError" scope="session"/>
      </div>
    </c:if>
    <c:if test="${not empty sessionScope.flashSuccess}">
      <div class="bg-green-50 border border-green-200 text-green-800 text-sm px-4 py-3 rounded mb-5">
        <c:out value="${sessionScope.flashSuccess}"/>
        <c:remove var="flashSuccess" scope="session"/>
      </div>
    </c:if>

    <div class="mb-5">
      <button onclick="document.getElementById('addUserModal').classList.remove('hidden')"
              class="inline-flex items-center gap-2 bg-forest text-white px-5 py-2 rounded text-sm font-medium hover:bg-forest-md transition-colors">
        + Add Staff Member
      </button>
    </div>

    <div class="bg-white border border-black/10 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-black/10">
        <span class="text-[13.5px] font-semibold text-ink">Staff Accounts</span>
      </div>
      <table class="w-full text-[13px]">
        <thead>
          <tr class="border-b border-black/10">
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Staff Member</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Email</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Role</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Access Level</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Status</th>
            <th class="px-4 py-2.5 text-left text-[10px] uppercase tracking-widest font-semibold text-muted">Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${users}" var="u">
            <tr class="border-b border-black/5 hover:bg-paper transition-colors">
              <td class="px-4 py-3">
                <div class="flex items-center gap-2.5">
                  <div class="w-8 h-8 rounded-full bg-forest/12 border border-forest/20 flex items-center justify-center
                              text-[11px] font-semibold text-forest flex-shrink-0">
                    ${u.initials}
                  </div>
                  <span class="font-medium text-ink">${u.fullName}</span>
                </div>
              </td>
              <td class="px-4 py-3 text-xs text-muted">${u.email}</td>
              <td class="px-4 py-3">
                <span class="badge ${u.role.name() == 'ADMIN' ? 'badge-served' :
                                     u.role.name() == 'STAFF' ? 'badge-preparing' : 'badge-pending'}">
                  ${u.role}
                </span>
              </td>
              <td class="px-4 py-3 text-xs text-muted">
                ${u.role.name() == 'ADMIN' ? 'Full Access' :
                  u.role.name() == 'STAFF' ? 'Orders, Billing' : 'Kitchen Display'}
              </td>
              <td class="px-4 py-3">
                <span class="badge ${u.active ? 'badge-paid' : 'badge-cancelled'}">
                  ${u.active ? 'Active' : 'Inactive'}
                </span>
              </td>
              <td class="px-4 py-3">
                <div class="flex gap-2">
                  <button class="text-xs border border-black/16 px-3 py-1.5 rounded hover:border-forest hover:text-forest transition-all">Edit</button>
                  <c:if test="${u.id != currentUser.id}">
                    <form method="POST" action="${pageContext.request.contextPath}/admin/users"
                          onsubmit="return confirm('Deactivate ${u.fullName}?')" style="display:inline">
                      <input type="hidden" name="action" value="deactivate">
                      <input type="hidden" name="userId" value="${u.id}">
                      <button type="submit"
                              class="text-xs bg-red-50 border border-red-200 text-red-700 px-3 py-1.5 rounded hover:bg-red-600 hover:text-white transition-all">
                        ${u.active ? 'Deactivate' : 'Deleted'}
                      </button>
                    </form>
                  </c:if>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- ADD USER MODAL -->
<div id="addUserModal" class="hidden fixed inset-0 bg-ink/45 z-50 flex items-center justify-center">
  <div class="bg-white rounded-2xl p-8 max-w-md w-full mx-4 shadow-xl">
    <div class="flex items-center justify-between mb-6">
      <h3 class="font-serif text-2xl font-normal">Add Staff Member</h3>
      <button onclick="document.getElementById('addUserModal').classList.add('hidden')" class="text-muted hover:text-ink text-xl">✕</button>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/admin/users">
      <input type="hidden" name="action" value="create">
      <div class="mb-4">
        <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Full Name</label>
        <input name="fullName" type="text" placeholder="e.g. Hari Prasad Sharma" required
               class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
      </div>
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Username</label>
          <input name="username" type="text" placeholder="hari123" required
                 class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
        </div>
        <div>
          <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Role</label>
          <select name="role" class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink outline-none">
            <option value="STAFF">Staff</option>
            <option value="KITCHEN">Kitchen</option>
            <option value="ADMIN">Admin</option>
          </select>
        </div>
      </div>
      <div class="mb-4">
        <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Email</label>
        <input name="email" type="email" placeholder="hari@gokyo.com" required
               class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
      </div>
      <div class="mb-6">
        <label class="block text-[10px] uppercase tracking-widest font-semibold text-muted mb-2">Password</label>
        <input name="password" type="password" placeholder="Minimum 8 characters" required minlength="8"
               class="gk-field w-full px-3 py-2 bg-white border border-black/10 rounded text-sm text-ink placeholder-muted2 outline-none">
      </div>
      <div class="flex gap-3 justify-end">
        <button type="button" onclick="document.getElementById('addUserModal').classList.add('hidden')"
                class="text-sm border border-black/16 px-5 py-2 rounded hover:border-forest hover:text-forest transition-all">Cancel</button>
        <button type="submit"
                class="text-sm bg-forest text-white px-5 py-2 rounded hover:bg-forest-md transition-colors">Create User</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>


