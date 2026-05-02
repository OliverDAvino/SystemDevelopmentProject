<?php
defined('CAFE_FANTINI') or die('Direct access not permitted.');

define('TOKEN_SECRET', 'cf_inv_s3cr3t_2025_xK9pL2mQ');
define('TOKEN_TTL',    86400); // 24 hours

/**
 * Create a signed token encoding user_id and role.
 * Format: base64url(payload).hmac_sha256(payload)
 */
function createToken(array $user): string {
    $payload   = base64_encode(json_encode([
        'uid'  => (int) $user['user_id'],
        'role' => $user['role'],
        'exp'  => time() + TOKEN_TTL,
    ]));
    $signature = hash_hmac('sha256', $payload, TOKEN_SECRET);
    return $payload . '.' . $signature;
}

/**
 * Validate a token and return its payload array, or null if invalid/expired.
 */
function validateToken(string $token): ?array {
    $parts = explode('.', $token, 2);
    if (count($parts) !== 2) return null;

    [$payload, $sig] = $parts;
    $expected = hash_hmac('sha256', $payload, TOKEN_SECRET);
    if (!hash_equals($expected, $sig)) return null;

    $data = json_decode(base64_decode($payload), true);
    if (!$data || !isset($data['exp']) || $data['exp'] < time()) return null;

    return $data;
}

/**
 * Extract and validate the Bearer token from the Authorization header.
 * Returns the token payload or sends a 401 and exits.
 */
function requireToken(): array {
    $header = $_SERVER['HTTP_AUTHORIZATION']
           ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION']
           ?? (function_exists('getallheaders') ? (getallheaders()['Authorization'] ?? '') : '')
           ?? '';
    if (!str_starts_with($header, 'Bearer ')) {
        http_response_code(401);
        echo json_encode(['message' => 'Unauthorized.']);
        exit;
    }

    $token   = substr($header, 7);
    $payload = validateToken($token);
    if (!$payload) {
        http_response_code(401);
        echo json_encode(['message' => 'Token invalid or expired.']);
        exit;
    }

    return $payload;
}
