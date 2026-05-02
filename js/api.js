/**
 * API Service Layer
 *
 * All data operations go through this module.
 * Backend: PHP + MySQL running on XAMPP at localhost/cafe-fantini
 */

const API_BASE = '/cafe-fantini/api';

/* ── Request helper ────────────────────────────────────── */
async function request(method, path, body = null) {
  const token = sessionStorage.getItem('auth_token');
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers['Authorization'] = `Bearer ${token}`;

  const res = await fetch(`${API_BASE}${path}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : null,
  });

  if (!res.ok) {
    const err = await res.json().catch(() => ({ message: 'Request failed' }));
    throw new Error(err.message || `HTTP ${res.status}`);
  }

  return res.status === 204 ? null : res.json();
}

/* ═══════════════════════════════════════════════════════════
   AUTH
   ═══════════════════════════════════════════════════════════ */

/**
 * Authenticate a user.
 * @param {string} email
 * @param {string} password
 * @returns {Promise<{ token: string, user: object }>}
 */
export async function loginUser(email, password) {
  return request('POST', '/auth.php', { email, password });
}

/* ═══════════════════════════════════════════════════════════
   PRODUCTS
   ═══════════════════════════════════════════════════════════ */

/**
 * Fetch all products.
 * @returns {Promise<Product[]>}
 */
export async function getProducts() {
  return request('GET', '/products.php');
}

/**
 * Create a new product.
 * @param {{ name: string, size: string, quantity: number }} data
 * @returns {Promise<Product>}
 */
export async function createProduct(data) {
  return request('POST', '/products.php', data);
}

/**
 * Update an existing product.
 * @param {number} id
 * @param {{ name: string, size: string, quantity: number }} data
 * @returns {Promise<Product>}
 */
export async function updateProduct(id, data) {
  return request('PUT', `/products.php?id=${id}`, data);
}

/**
 * Delete a product by ID.
 * @param {number} id
 * @returns {Promise<void>}
 */
export async function deleteProduct(id) {
  return request('DELETE', `/products.php?id=${id}`);
}
