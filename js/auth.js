/**
 * Auth module — manages session state.
 * Token is stored in sessionStorage so it clears when the tab closes.
 * Swap sessionStorage for localStorage if you want persistent sessions.
 */

const TOKEN_KEY = 'auth_token';
const USER_KEY  = 'auth_user';

export function setSession(token, user) {
  sessionStorage.setItem(TOKEN_KEY, token);
  sessionStorage.setItem(USER_KEY, JSON.stringify(user));
}

export function getToken() {
  return sessionStorage.getItem(TOKEN_KEY);
}

export function getUser() {
  try {
    return JSON.parse(sessionStorage.getItem(USER_KEY));
  } catch {
    return null;
  }
}

export function clearSession() {
  sessionStorage.removeItem(TOKEN_KEY);
  sessionStorage.removeItem(USER_KEY);
}

export function isAuthenticated() {
  return Boolean(getToken());
}

/** Redirect to login if the user has no valid session. */
export function requireAuth() {
  if (!isAuthenticated()) {
    window.location.href = 'index.html';
  }
}

/** Redirect to dashboard if the user is already logged in. */
export function redirectIfAuthenticated() {
  if (isAuthenticated()) {
    window.location.href = 'dashboard.html';
  }
}
