/**
 * Reusable UI components.
 * Each factory function returns a DOM element that can be appended to the page.
 */

import { SVG } from './svg.js';

/* ── Toast ─────────────────────────────────────────────── */

let _toastTimeout = null;

/**
 * Show a toast notification.
 * @param {string} message
 * @param {'success'|'error'} type
 */
export function showToast(message, type = 'success') {
  const existing = document.getElementById('toast');
  if (existing) existing.remove();
  if (_toastTimeout) clearTimeout(_toastTimeout);

  const toast = document.createElement('div');
  toast.id = 'toast';
  toast.className = `toast toast-${type}`;

  if (type === 'success') {
    toast.innerHTML = SVG.check + `<span>${message}</span>`;
  } else {
    toast.textContent = message;
  }

  document.body.appendChild(toast);

  _toastTimeout = setTimeout(() => {
    toast.classList.add('toast-hiding');
    setTimeout(() => toast.remove(), 300);
  }, 2800);
}

/* ── Modal helpers ─────────────────────────────────────── */

function createOverlay(onClose) {
  const overlay = document.createElement('div');
  overlay.className = 'overlay';
  overlay.addEventListener('click', e => {
    if (e.target === overlay) onClose();
  });
  return overlay;
}

function closeModal(overlay) {
  overlay.remove();
}

/* ── Add Product Modal ─────────────────────────────────── */

/**
 * @param {function(data: object): void} onAdd
 * @param {function(): void} onClose
 */
export function openAddModal(onAdd, onClose) {
  const overlay = createOverlay(() => { onClose(); closeModal(overlay); });

  overlay.innerHTML = `
    <div class="modal-card" id="modal-inner">
      <h2>Add Product</h2>
      <form id="add-form" novalidate>
        <div class="form-group">
          <label for="add-name">Product Name</label>
          <input id="add-name" type="text" placeholder="e.g. Red Running Shoes" />
        </div>
        <div class="form-group">
          <label for="add-link">Item Link</label>
          <input id="add-link" type="url" placeholder="https://..." />
        </div>
        <div class="form-group">
          <label for="add-qty">Quantity</label>
          <input id="add-qty" type="number" min="0" placeholder="0" />
        </div>
        <div class="form-group">
          <label for="add-status">Status</label>
          <select id="add-status">
            <option value="in-stock">In Stock</option>
            <option value="low-stock">Low Stock</option>
            <option value="out-stock">Out of Stock</option>
          </select>
        </div>
        <p class="form-error hidden" id="add-error"></p>
        <div class="modal-actions">
          <button type="button" class="btn btn-secondary" id="add-cancel">Cancel</button>
          <button type="submit" class="btn btn-primary" id="add-submit">Add Product</button>
        </div>
      </form>
    </div>
  `;

  document.body.appendChild(overlay);
  overlay.querySelector('#modal-inner').addEventListener('click', e => e.stopPropagation());
  overlay.querySelector('#add-cancel').addEventListener('click', () => { onClose(); closeModal(overlay); });
  overlay.querySelector('#add-name').focus();

  overlay.querySelector('#add-form').addEventListener('submit', async e => {
    e.preventDefault();
    const name     = overlay.querySelector('#add-name').value.trim();
    const link     = overlay.querySelector('#add-link').value.trim();
    const quantity = overlay.querySelector('#add-qty').value;
    const status   = overlay.querySelector('#add-status').value;
    const errEl    = overlay.querySelector('#add-error');
    const submitBtn = overlay.querySelector('#add-submit');

    if (!name) { showError(errEl, 'Product name is required.'); return; }
    if (quantity === '' || isNaN(Number(quantity))) { showError(errEl, 'Valid quantity is required.'); return; }

    errEl.classList.add('hidden');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner"></span>';

    try {
      await onAdd({ name, link, quantity: Number(quantity), status });
      closeModal(overlay);
    } catch (err) {
      showError(errEl, err.message);
      submitBtn.disabled = false;
      submitBtn.textContent = 'Add Product';
    }
  });
}

/* ── Update Product Modal ──────────────────────────────── */

/**
 * @param {object} product
 * @param {function(data: object): void} onUpdate
 * @param {function(): void} onClose
 */
export function openUpdateModal(product, onUpdate, onClose) {
  const overlay = createOverlay(() => { onClose(); closeModal(overlay); });

  overlay.innerHTML = `
    <div class="modal-card" id="modal-inner">
      <h2>Update Product</h2>
      <form id="update-form" novalidate>
        <div class="form-group">
          <label for="upd-name">Item Name</label>
          <input id="upd-name" type="text" value="${escHtml(product.name)}" />
        </div>
        <div class="form-group">
          <label for="upd-link">Item Link</label>
          <input id="upd-link" type="url" value="${escHtml(product.link)}" />
        </div>
        <div class="form-group">
          <label for="upd-qty">Item Quantity</label>
          <input id="upd-qty" type="number" min="0" value="${product.quantity}" />
        </div>
        <div class="form-group">
          <label for="upd-status">Status</label>
          <select id="upd-status">
            <option value="in-stock" ${product.status === 'in-stock' ? 'selected' : ''}>In Stock</option>
            <option value="low-stock" ${product.status === 'low-stock' ? 'selected' : ''}>Low Stock</option>
            <option value="out-stock" ${product.status === 'out-stock' ? 'selected' : ''}>Out of Stock</option>
          </select>
        </div>
        <p class="form-error hidden" id="upd-error"></p>
        <div class="modal-actions">
          <button type="button" class="btn btn-secondary" id="upd-cancel">Cancel</button>
          <button type="submit" class="btn btn-primary" id="upd-submit">Update</button>
        </div>
      </form>
    </div>
  `;

  document.body.appendChild(overlay);
  overlay.querySelector('#modal-inner').addEventListener('click', e => e.stopPropagation());
  overlay.querySelector('#upd-cancel').addEventListener('click', () => { onClose(); closeModal(overlay); });
  overlay.querySelector('#upd-name').focus();

  overlay.querySelector('#update-form').addEventListener('submit', async e => {
    e.preventDefault();
    const name     = overlay.querySelector('#upd-name').value.trim();
    const link     = overlay.querySelector('#upd-link').value.trim();
    const quantity = overlay.querySelector('#upd-qty').value;
    const status   = overlay.querySelector('#upd-status').value;
    const errEl    = overlay.querySelector('#upd-error');
    const submitBtn = overlay.querySelector('#upd-submit');

    if (!name) { showError(errEl, 'Product name is required.'); return; }
    if (quantity === '' || isNaN(Number(quantity))) { showError(errEl, 'Valid quantity is required.'); return; }

    errEl.classList.add('hidden');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner"></span>';

    try {
      await onUpdate(product.id, { name, link, quantity: Number(quantity), status });
      closeModal(overlay);
    } catch (err) {
      showError(errEl, err.message);
      submitBtn.disabled = false;
      submitBtn.textContent = 'Update';
    }
  });
}

/* ── Delete Confirmation Modal ─────────────────────────── */

/**
 * @param {object} product
 * @param {function(): void} onConfirm
 * @param {function(): void} onClose
 */
export function openDeleteModal(product, onConfirm, onClose) {
  const overlay = createOverlay(() => { onClose(); closeModal(overlay); });

  overlay.innerHTML = `
    <div class="modal-card modal-center" id="modal-inner">
      <div class="delete-icon-wrap">${SVG.trash}</div>
      <h2>Delete Product?</h2>
      <p class="delete-product-label">Are you sure you want to delete</p>
      <p class="delete-product-name">"${escHtml(product.name)}"?</p>
      <div class="modal-actions">
        <button class="btn btn-secondary" id="del-cancel">Cancel</button>
        <button class="btn btn-danger" id="del-confirm">Delete</button>
      </div>
    </div>
  `;

  document.body.appendChild(overlay);
  overlay.querySelector('#modal-inner').addEventListener('click', e => e.stopPropagation());
  overlay.querySelector('#del-cancel').addEventListener('click', () => { onClose(); closeModal(overlay); });

  overlay.querySelector('#del-confirm').addEventListener('click', async () => {
    const btn = overlay.querySelector('#del-confirm');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner"></span>';
    try {
      await onConfirm();
      closeModal(overlay);
    } catch {
      btn.disabled = false;
      btn.textContent = 'Delete';
    }
  });
}

/* ── Helpers ───────────────────────────────────────────── */

function showError(el, msg) {
  el.textContent = msg;
  el.classList.remove('hidden');
}

function escHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
