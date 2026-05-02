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

/* ── Role-based UI ─────────────────────────────────────── */
if (isSecretary) addBtn.classList.add('hidden');

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
  renderTable();
});

filterBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    activeFilter = btn.dataset.filter;
    filterBtns.forEach(b => b.classList.toggle('active', b === btn));
    renderTable();
  });
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
  return products.filter(p => {
    const matchesFilter = activeFilter === 'all' || p.status === activeFilter;
    const matchesSearch = !searchQuery.trim()
      || p.name.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesFilter && matchesSearch;
  });
}

function renderTable() {
  const list = getFiltered();
  footerCount.textContent = `Showing ${list.length} of ${products.length} products`;

  if (list.length === 0) {
    tableBody.innerHTML = `
      <tr>
        <td colspan="6" class="table-empty">No products found.</td>
      </tr>
    `;
    return;
  }

  tableBody.innerHTML = list.map((p, i) => buildRow(p, i)).join('');

  tableBody.querySelectorAll('.edit-btn').forEach(btn => {
    btn.addEventListener('click', () => handleEdit(Number(btn.dataset.id)));
  });

  tableBody.querySelectorAll('.delete-btn').forEach(btn => {
    btn.addEventListener('click', () => handleDelete(Number(btn.dataset.id)));
  });
}

function buildRow(p, index) {
  const s = STATUS[p.status] || { label: p.status };
  const rowClass = index % 2 === 1 ? 'row-alt' : '';

  return `
    <tr class="${rowClass}">
      <td class="cell-num">${index + 1}</td>
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
        <span class="status-badge status-${p.status}">
          ${s.label}
        </span>
      </td>
    </tr>
  `;
}

/* ── Action handlers ───────────────────────────────────── */
function handleEdit(id) {
  const product = products.find(p => p.id === id);
  if (!product) return;

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
  const product = products.find(p => p.id === id);
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
