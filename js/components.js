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
 * Matches Figma "Create Product" modal.
 * Fields: Product Name, Size, Quantity.
 * Status is auto-computed from quantity thresholds:
 *   < 10  → critical | 10–49 → low-stock | ≥ 50 → in-stock
 *
 * @param {function(data: object): void} onAdd
 * @param {function(): void} onClose
 */
export function openAddModal(onAdd, onClose) {
  const overlay = createOverlay(() => { onClose(); closeModal(overlay); });

  overlay.innerHTML = `
    <div class="modal-card" id="modal-inner">
      <h2>Create Product</h2>
      <form id="add-form" novalidate>
        <div class="form-group">
          <label for="add-name">Product Name</label>
          <input id="add-name" type="text" placeholder="Value" />
        </div>
        <div class="form-group">
          <label for="add-size">Size</label>
          <input id="add-size" type="text" placeholder="i.e 5 kg" />
        </div>
        <div class="form-group">
          <label for="add-qty">Quantity</label>
          <input id="add-qty" type="number" min="0" placeholder="Value" />
        </div>
        <p class="form-error hidden" id="add-error"></p>
        <div class="modal-actions">
          <button type="button" class="btn btn-cancel modal-cancel-btn" id="add-cancel">Cancel</button>
          <button type="submit" class="btn btn-primary modal-submit-btn" id="add-submit">Add Product</button>
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
    const name        = overlay.querySelector('#add-name').value.trim();
    const size        = overlay.querySelector('#add-size').value.trim();
    const quantityStr = overlay.querySelector('#add-qty').value;
    const errEl       = overlay.querySelector('#add-error');
    const submitBtn   = overlay.querySelector('#add-submit');

    if (!name) { showError(errEl, 'Product name is required.'); return; }
    if (quantityStr === '' || isNaN(Number(quantityStr))) {
      showError(errEl, 'Valid quantity is required.');
      return;
    }

    const qty    = Number(quantityStr);
    const status = qty < 10 ? 'critical' : qty < 50 ? 'low-stock' : 'in-stock';

    errEl.classList.add('hidden');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner"></span>';

    try {
      await onAdd({ name, size, quantity: qty, status });
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
 * Matches Figma "Update product" modal.
 * Fields: New name, New size, New quantity.
 * Status is auto-computed from quantity.
 *
 * @param {object} product
 * @param {function(id: number, data: object): void} onUpdate
 * @param {function(): void} onClose
 */
export function openUpdateModal(product, onUpdate, onClose) {
  const overlay = createOverlay(() => { onClose(); closeModal(overlay); });

  overlay.innerHTML = `
    <div class="modal-card" id="modal-inner">
      <h2>Update product</h2>
      <form id="update-form" novalidate>
        <div class="form-group">
          <label for="upd-name">New name</label>
          <input id="upd-name" type="text" value="${escHtml(product.name)}" />
        </div>
        <div class="form-group">
          <label for="upd-size">New size</label>
          <input id="upd-size" type="text" value="${escHtml(product.size || '')}" />
        </div>
        <div class="form-group">
          <label for="upd-qty">New quantity</label>
          <input id="upd-qty" type="number" min="0" value="${product.quantity}" />
        </div>
        <p class="form-error hidden" id="upd-error"></p>
        <div class="modal-actions">
          <button type="button" class="btn btn-cancel modal-cancel-btn" id="upd-cancel">Cancel</button>
          <button type="submit" class="btn btn-primary modal-submit-btn" id="upd-submit">Apply Now</button>
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
    const name        = overlay.querySelector('#upd-name').value.trim();
    const size        = overlay.querySelector('#upd-size').value.trim();
    const quantityStr = overlay.querySelector('#upd-qty').value;
    const errEl       = overlay.querySelector('#upd-error');
    const submitBtn   = overlay.querySelector('#upd-submit');

    if (!name) { showError(errEl, 'Product name is required.'); return; }
    if (quantityStr === '' || isNaN(Number(quantityStr))) {
      showError(errEl, 'Valid quantity is required.');
      return;
    }

    const qty    = Number(quantityStr);
    const status = qty < 10 ? 'critical' : qty < 50 ? 'low-stock' : 'in-stock';

    errEl.classList.add('hidden');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner"></span>';

    try {
      await onUpdate(product.id, { name, size, quantity: qty, status });
      closeModal(overlay);
    } catch (err) {
      showError(errEl, err.message);
      submitBtn.disabled = false;
      submitBtn.textContent = 'Apply Now';
    }
  });
}

/* ── Delete Confirmation Modal ─────────────────────────── */

/**
 * Matches Figma "Delete" confirmation modal.
 *
 * @param {object} product
 * @param {function(): void} onConfirm
 * @param {function(): void} onClose
 */
export function openDeleteModal(product, onConfirm, onClose) {
  const overlay = createOverlay(() => { onClose(); closeModal(overlay); });

  overlay.innerHTML = `
    <div class="modal-card modal-delete" id="modal-inner">
      <h2>Delete</h2>
      <p class="delete-confirm-text">Are you sure you want to delete <strong>${escHtml(product.name)}</strong> ?</p>
      <div class="modal-actions delete-actions">
        <button class="btn btn-cancel" id="del-cancel">Cancel</button>
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
