/**
 * API Service Layer
 *
 * All data operations go through this module.
 * To connect a real database backend:
 *   1. Set API_BASE to your server's URL (e.g. 'https://api.yourapp.com')
 *   2. Replace each mock implementation below with the corresponding fetch() call
 *   3. Remove the mock data and _mockStore helpers at the bottom of this file
 */

const API_BASE = '/api';

/* ── Request helper (used when real backend is connected) ── */
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
 *
 * TODO — replace mock with:
 *   return request('POST', '/auth/login', { email, password });
 */
export async function loginUser(email, password) {
  await _delay(300);
  if (email === 'admin@store.com' && password === 'admin123') {
    return { token: 'mock-jwt-token', user: { id: 1, name: 'Admin', email } };
  }
  throw new Error('Invalid email or password.');
}

/* ═══════════════════════════════════════════════════════════
   PRODUCTS
   ═══════════════════════════════════════════════════════════ */

/**
 * Fetch all products.
 * @returns {Promise<Product[]>}
 *
 * TODO — replace mock with:
 *   return request('GET', '/products');
 */
export async function getProducts() {
  await _delay(200);
  return _mockStore.getAll();
}

/**
 * Create a new product.
 * @param {{ name: string, link: string, quantity: number, status: string }} data
 * @returns {Promise<Product>}
 *
 * TODO — replace mock with:
 *   return request('POST', '/products', data);
 */
export async function createProduct(data) {
  await _delay(250);
  return _mockStore.create(data);
}

/**
 * Update an existing product.
 * @param {number} id
 * @param {{ name: string, link: string, quantity: number, status: string }} data
 * @returns {Promise<Product>}
 *
 * TODO — replace mock with:
 *   return request('PUT', `/products/${id}`, data);
 */
export async function updateProduct(id, data) {
  await _delay(250);
  return _mockStore.update(id, data);
}

/**
 * Delete a product by ID.
 * @param {number} id
 * @returns {Promise<void>}
 *
 * TODO — replace mock with:
 *   return request('DELETE', `/products/${id}`);
 */
export async function deleteProduct(id) {
  await _delay(200);
  _mockStore.remove(id);
}

/* ═══════════════════════════════════════════════════════════
   MOCK DATA STORE
   Remove this entire section once a real backend is connected.
   ═══════════════════════════════════════════════════════════ */

const SEED_PRODUCTS = [
  { id: 1,  name: 'Red Running Shoes',    link: 'https://example.com/p1',  quantity: 142, status: 'in-stock'  },
  { id: 2,  name: 'Black Leather Jacket', link: 'https://example.com/p2',  quantity: 8,   status: 'low-stock' },
  { id: 3,  name: 'Classic White Tee',    link: 'https://example.com/p3',  quantity: 310, status: 'in-stock'  },
  { id: 4,  name: 'Slim Fit Jeans',       link: 'https://example.com/p4',  quantity: 0,   status: 'out-stock' },
  { id: 5,  name: 'Canvas Backpack',      link: 'https://example.com/p5',  quantity: 57,  status: 'in-stock'  },
  { id: 6,  name: 'Sports Cap',           link: 'https://example.com/p6',  quantity: 4,   status: 'low-stock' },
  { id: 7,  name: 'Wool Beanie',          link: 'https://example.com/p7',  quantity: 0,   status: 'out-stock' },
  { id: 8,  name: 'Cargo Shorts',         link: 'https://example.com/p8',  quantity: 88,  status: 'in-stock'  },
  { id: 9,  name: 'Zip-up Hoodie',        link: 'https://example.com/p9',  quantity: 11,  status: 'low-stock' },
  { id: 10, name: 'Leather Belt',         link: 'https://example.com/p10', quantity: 200, status: 'in-stock'  },
];

const _mockStore = (() => {
  const STORAGE_KEY = 'mock_products';
  let nextId = 100;

  function load() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      return raw ? JSON.parse(raw) : [...SEED_PRODUCTS];
    } catch {
      return [...SEED_PRODUCTS];
    }
  }

  function save(products) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(products));
  }

  return {
    getAll() {
      return load();
    },
    create(data) {
      const products = load();
      const product = { id: nextId++, ...data };
      products.unshift(product);
      save(products);
      return product;
    },
    update(id, data) {
      const products = load();
      const idx = products.findIndex(p => p.id === id);
      if (idx === -1) throw new Error('Product not found.');
      products[idx] = { ...products[idx], ...data };
      save(products);
      return products[idx];
    },
    remove(id) {
      const products = load().filter(p => p.id !== id);
      save(products);
    },
  };
})();

function _delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
