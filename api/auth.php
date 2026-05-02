<?php
define('CAFE_FANTINI', true);

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/token.php';

/* ── CORS ───────────────────────────────────────────────── */
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

/* ── Only POST is accepted ──────────────────────────────── */
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['message' => 'Method not allowed.']);
    exit;
}

/* ── Parse JSON body ────────────────────────────────────── */
$body     = json_decode(file_get_contents('php://input'), true);
$email    = trim($body['email']    ?? '');
$password = trim($body['password'] ?? '');

if (!$email || !$password) {
    http_response_code(400);
    echo json_encode(['message' => 'Email and password are required.']);
    exit;
}

/* ── Look up user by email ──────────────────────────────── */
try {
    $db   = getDB();
    $stmt = $db->prepare('SELECT user_id, username, password, role, email FROM USERS WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $user = $stmt->fetch();
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['message' => 'Database error.']);
    exit;
}

/* ── Verify password ────────────────────────────────────── */
if (!$user || !password_verify($password, $user['password'])) {
    http_response_code(401);
    echo json_encode(['message' => 'Invalid email or password.']);
    exit;
}

/* ── Issue token and return user object ─────────────────── */
$token = createToken($user);

echo json_encode([
    'token' => $token,
    'user'  => [
        'id'    => (int) $user['user_id'],
        'name'  => $user['username'],
        'email' => $user['email'],
        'role'  => $user['role'],
    ],
]);
