<?php
define('CAFE_FANTINI', true);

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/token.php';

/* ── CORS ───────────────────────────────────────────────── */
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

/* ── Auth ───────────────────────────────────────────────── */
$tokenData = requireToken();
$userId    = (int) $tokenData['uid'];

/* ── Route ──────────────────────────────────────────────── */
$method = $_SERVER['REQUEST_METHOD'];

$db = null;
try {
    $db = getDB();

    switch ($method) {

        /* ── GET all products ─────────────────────────── */
        case 'GET':
            $stmt = $db->query(
                'SELECT product_id AS id,
                        product_name AS name,
                        quantity,
                        size,
                        category_id,
                        category_name,
                        status
                 FROM v_products
                 ORDER BY product_id ASC'
            );
            echo json_encode($stmt->fetchAll());
            break;

        /* ── POST create product ──────────────────────── */
        case 'POST':
            $body       = json_decode(file_get_contents('php://input'), true);
            $name       = trim($body['name']          ?? '');
            $size       = trim($body['size']          ?? '');
            $quantity   = (int) ($body['quantity']    ?? 0);
            $categoryId = (int) ($body['category_id'] ?? 1);

            if (!$name) {
                http_response_code(400);
                echo json_encode(['message' => 'Product name is required.']);
                exit;
            }

            $db->beginTransaction();

            /*
             * Insert with quantity = 0.
             * The trigger on STOCK_UPDATES will apply quantity_change
             * and set the final quantity automatically.
             */
            $stmt = $db->prepare(
                'INSERT INTO PRODUCTS (product_name, quantity, size, category_id)
                 VALUES (?, 0, ?, ?)'
            );
            $stmt->execute([$name, $size ?: null, $categoryId]);
            $productId = (int) $db->lastInsertId();

            /* Trigger fires here and sets quantity = 0 + quantity_change */
            $db->prepare(
                'INSERT INTO STOCK_UPDATES (quantity_change, updated_at, product_id, user_id)
                 VALUES (?, CURDATE(), ?, ?)'
            )->execute([$quantity, $productId, $userId]);

            $db->commit();

            $row = $db->prepare(
                'SELECT product_id AS id, product_name AS name, quantity, size,
                        category_id, category_name, status
                 FROM v_products WHERE product_id = ?'
            );
            $row->execute([$productId]);

            http_response_code(201);
            echo json_encode($row->fetch());
            break;

        /* ── PUT update product ───────────────────────── */
        case 'PUT':
            $productId = (int) ($_GET['id'] ?? 0);
            if (!$productId) {
                http_response_code(400);
                echo json_encode(['message' => 'Product ID is required.']);
                exit;
            }

            $body     = json_decode(file_get_contents('php://input'), true);
            $name     = trim($body['name']       ?? '');
            $size     = trim($body['size']       ?? '');
            $quantity = (int) ($body['quantity'] ?? 0);

            if (!$name) {
                http_response_code(400);
                echo json_encode(['message' => 'Product name is required.']);
                exit;
            }

            /* Get current quantity to compute the delta for STOCK_UPDATES */
            $current = $db->prepare('SELECT quantity FROM PRODUCTS WHERE product_id = ?');
            $current->execute([$productId]);
            $old = $current->fetch();
            if (!$old) {
                http_response_code(404);
                echo json_encode(['message' => 'Product not found.']);
                exit;
            }
            $delta = $quantity - (int) $old['quantity'];

            $db->beginTransaction();

            /*
             * Update name and size directly (not quantity —
             * the trigger on STOCK_UPDATES handles that).
             */
            $db->prepare(
                'UPDATE PRODUCTS SET product_name = ?, size = ? WHERE product_id = ?'
            )->execute([$name, $size ?: null, $productId]);

            /* Trigger fires here and adjusts quantity by delta */
            $db->prepare(
                'INSERT INTO STOCK_UPDATES (quantity_change, updated_at, product_id, user_id)
                 VALUES (?, CURDATE(), ?, ?)'
            )->execute([$delta, $productId, $userId]);

            $db->commit();

            $row = $db->prepare(
                'SELECT product_id AS id, product_name AS name, quantity, size,
                        category_id, category_name, status
                 FROM v_products WHERE product_id = ?'
            );
            $row->execute([$productId]);
            echo json_encode($row->fetch());
            break;

        /* ── DELETE product ───────────────────────────── */
        case 'DELETE':
            $productId = (int) ($_GET['id'] ?? 0);
            if (!$productId) {
                http_response_code(400);
                echo json_encode(['message' => 'Product ID is required.']);
                exit;
            }

            $check = $db->prepare('SELECT product_id FROM PRODUCTS WHERE product_id = ?');
            $check->execute([$productId]);
            if (!$check->fetch()) {
                http_response_code(404);
                echo json_encode(['message' => 'Product not found.']);
                exit;
            }

            $db->beginTransaction();

            /* Remove stock history first (FK RESTRICT blocks delete otherwise) */
            $db->prepare('DELETE FROM STOCK_UPDATES WHERE product_id = ?')
               ->execute([$productId]);

            $db->prepare('DELETE FROM PRODUCTS WHERE product_id = ?')
               ->execute([$productId]);

            $db->commit();

            http_response_code(200);
            echo json_encode(['message' => 'Product deleted.']);
            break;

        default:
            http_response_code(405);
            echo json_encode(['message' => 'Method not allowed.']);
    }

} catch (PDOException $e) {
    if ($db && $db->inTransaction()) $db->rollBack();
    http_response_code(500);
    echo json_encode(['message' => 'Database error: ' . $e->getMessage()]);
}
