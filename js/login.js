import { loginUser } from './api.js';
import { setSession, redirectIfAuthenticated } from './auth.js';

redirectIfAuthenticated();

const form      = document.getElementById('login-form');
const emailInput = document.getElementById('login-email');
const passInput  = document.getElementById('login-password');
const errorEl   = document.getElementById('login-error');
const submitBtn = document.getElementById('login-submit');

form.addEventListener('submit', async e => {
  e.preventDefault();
  errorEl.classList.add('hidden');

  const email    = emailInput.value.trim();
  const password = passInput.value;

  if (!email || !password) {
    showError('Please fill in all fields.');
    return;
  }

  setLoading(true);

  try {
    const { token, user } = await loginUser(email, password);
    setSession(token, user);
    window.location.href = 'dashboard.html';
  } catch (err) {
    showError(err.message);
    setLoading(false);
  }
});

function showError(msg) {
  errorEl.textContent = msg;
  errorEl.classList.remove('hidden');
}

function setLoading(loading) {
  submitBtn.disabled = loading;
  submitBtn.innerHTML = loading
    ? '<span class="spinner"></span>'
    : 'Log In';
}
