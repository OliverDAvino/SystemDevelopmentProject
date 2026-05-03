import { getProducts, createProduct, updateProduct, deleteProduct } from './api.js';
import { clearSession, requireAuth, getUser } from './auth.js';
import { openAddModal, openUpdateModal, openDeleteModal, showToast } from './components.js';
import { SVG } from './svg.js';

requireAuth();

const isSecretary = getUser()?.role === 'secretary';

/* ── State ─────────────────────────────────────────────── */
let products      = [];
let searchQuery   = '';
let activeFilter  = 'all';
let currentSort   = 'id';
let sortAsc       = true;
let currentPage   = 1;
const PAGE_SIZE   = 10;

/* ── Status config ─────────────────────────────────────── */
const STATUS = {
  'in-stock':  { label: 'In Stock'  },
  'low-stock': { label: 'Low Stock' },
  'critical':  { label: 'Critical'  },
};

/* ── DOM refs ──────────────────────────────────────────── */
const logoutBtn    = document.getElementById('logout-btn');
const searchInput  = document.getElementById('search-input');
const filterBtns   = document.querySelectorAll('.filter-btn');
const addBtn       = document.getElementById('add-btn');
const tableBody    = document.getElementById('table-body');
const footerCount  = document.getElementById('footer-count');
const pagination   = document.getElementById('pagination');

/* ── Role-based UI ─────────────────────────────────────── */
if (isSecretary) addBtn.classList.add('hidden');

/* ── Delegated table button clicks ─────────────────────── */
tableBody.addEventListener('click', e => {
  const editBtn   = e.target.closest('.edit-btn');
  const deleteBtn = e.target.closest('.delete-btn');
  if (editBtn)   handleEdit(Number(editBtn.dataset.id));
  if (deleteBtn) handleDelete(Number(deleteBtn.dataset.id));
});

/* ── Init ──────────────────────────────────────────────── */
init();

async function init() {
  try {
    products = await getProducts();
    renderTable();
  } catch (err) {
    showToast('Failed to load products.', 'error');
  }
}

/* ── Events ────────────────────────────────────────────── */
logoutBtn.addEventListener('click', () => {
  clearSession();
  window.location.href = 'index.html';
});

searchInput.addEventListener('input', e => {
  searchQuery = e.target.value;
  currentPage = 1;
  renderTable();
});

filterBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    activeFilter = btn.dataset.filter;
    currentPage = 1;
    filterBtns.forEach(b => b.classList.toggle('active', b === btn));
    renderTable();
  });
});

document.addEventListener('sort-change', e => {
  currentSort = e.detail.sort;
  currentPage = 1;
  renderTable();
});

document.addEventListener('sort-direction', e => {
  sortAsc = e.detail.asc;
  currentPage = 1;
  renderTable();
});

addBtn.addEventListener('click', () => {
  openAddModal(
    async (data) => {
      const product = await createProduct(data);
      products.unshift(product);
      renderTable();
      showToast('Product added successfully.');
    },
    () => {}
  );
});

/* ── Render ────────────────────────────────────────────── */
function getFiltered() {
  const list = products.filter(p => {
    const matchesFilter = activeFilter === 'all' || p.status === activeFilter;
    const matchesSearch = !searchQuery.trim()
      || p.name.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  list.sort((a, b) => {
    let cmp;
    switch (currentSort) {
      case 'name': cmp = a.name.localeCompare(b.name); break;
      case 'size': {
        const an = parseFloat(a.size) || 0, bn = parseFloat(b.size) || 0;
        cmp = an !== bn ? an - bn : (a.size || '').localeCompare(b.size || '');
        break;
      }
      case 'qty':  cmp = a.quantity - b.quantity; break;
      default:     cmp = a.id - b.id;
    }
    return sortAsc ? cmp : -cmp;
  });

  return list;
}

function renderTable() {
  const list       = getFiltered();
  const totalPages = Math.max(1, Math.ceil(list.length / PAGE_SIZE));
  if (currentPage > totalPages) currentPage = totalPages;

  const start = (currentPage - 1) * PAGE_SIZE;
  const page  = list.slice(start, start + PAGE_SIZE);

  footerCount.textContent = list.length === 0
    ? `Showing 0 of ${products.length} products`
    : `Showing ${start + 1}–${start + page.length} of ${list.length} products`;

  if (list.length === 0) {
    tableBody.innerHTML = `<tr><td colspan="6" class="table-empty">No products found.</td></tr>`;
    pagination.innerHTML = '';
    return;
  }

  tableBody.innerHTML = page.map(p => buildRow(p)).join('');

  pagination.innerHTML = `
    <button class="page-btn" id="page-prev" ${currentPage === 1 ? 'disabled' : ''}>&#8592;</button>
    <span class="page-indicator">${currentPage} / ${totalPages}</span>
    <button class="page-btn" id="page-next" ${currentPage === totalPages ? 'disabled' : ''}>&#8594;</button>
  `;
  document.getElementById('page-prev').addEventListener('click', () => { currentPage--; renderTable(); });
  document.getElementById('page-next').addEventListener('click', () => { currentPage++; renderTable(); });
}

function buildRow(p) {
  const s = STATUS[p.status] || { label: p.status };
  const rowClass = '';

  return `
    <tr class="${rowClass}">
      <td class="cell-num">${p.id}</td>
      <td class="cell-name">${escHtml(p.name)}</td>
      <td class="cell-size">${escHtml(p.size || '')}</td>
      <td class="cell-qty">${p.quantity}</td>
      <td>
        <div class="cell-actions">
          <button class="icon-btn icon-btn-edit edit-btn" data-id="${p.id}" title="Edit">
            ${SVG.edit}
          </button>
          ${isSecretary ? '' : `<button class="icon-btn icon-btn-delete delete-btn" data-id="${p.id}" title="Delete">${SVG.trash}</button>`}
        </div>
      </td>
      <td>
        <span class="status-badge status-${p.status}" title="Product has ${p.quantity} item${p.quantity === 1 ? '' : 's'}">
          ${s.label}
        </span>
      </td>
    </tr>
  `;
}

/* ── Action handlers ───────────────────────────────────── */
function handleEdit(id) {
  const product = products.find(p => p.id == id);
  if (!product) { console.error('Edit: product not found for id', id, products.map(p => p.id)); return; }

  openUpdateModal(
    product,
    async (productId, data) => {
      const updated = await updateProduct(productId, data);
      products = products.map(p => p.id === productId ? updated : p);
      renderTable();
      showToast('Product updated successfully.');
    },
    () => {}
  );
}

function handleDelete(id) {
  const product = products.find(p => p.id == id);
  if (!product) return;

  openDeleteModal(
    product,
    async () => {
      await deleteProduct(product.id);
      products = products.filter(p => p.id !== product.id);
      renderTable();
      showToast('Product deleted.', 'error');
    },
    () => {}
  );
}

/* ── Helpers ───────────────────────────────────────────── */
function escHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
