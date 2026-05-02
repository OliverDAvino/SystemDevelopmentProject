-- =============================================================
--  Café Fantini Canada Inc. — Inventory Management Database
--  Database : cafe_fantini
--  MySQL 8.0+
-- =============================================================

CREATE DATABASE IF NOT EXISTS cafe_fantini
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE cafe_fantini;

-- =============================================================
--  TABLE: CATEGORIES
-- =============================================================

CREATE TABLE CATEGORIES (
  category_id   INT          NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(255) NOT NULL,
  PRIMARY KEY (category_id),
  UNIQUE INDEX uq_category_name (category_name)
);

-- =============================================================
--  TABLE: USERS
-- =============================================================

CREATE TABLE USERS (
  user_id  INT          NOT NULL AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role     VARCHAR(255) NOT NULL,
  email    VARCHAR(255) NOT NULL,
  PRIMARY KEY (user_id),
  UNIQUE INDEX uq_username (username)
);

-- =============================================================
--  TABLE: PRODUCTS
--  NOTE: No status column — status is derived from quantity
--        via get_product_status() and exposed in v_products.
-- =============================================================

CREATE TABLE PRODUCTS (
  product_id   INT          NOT NULL AUTO_INCREMENT,
  product_name VARCHAR(255) NOT NULL,
  quantity     INT          NOT NULL DEFAULT 0,
  size         VARCHAR(50)  NULL,
  category_id  INT          NOT NULL,
  PRIMARY KEY (product_id),
  FULLTEXT INDEX ft_product_name (product_name),
  INDEX idx_category_id (category_id),
  INDEX idx_quantity    (quantity),
  INDEX idx_product_id  (product_id),
  CONSTRAINT fk_products_category
    FOREIGN KEY (category_id) REFERENCES CATEGORIES (category_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- =============================================================
--  TABLE: STOCK_UPDATES  (referred to as UPDATE TABLE in docs)
-- =============================================================

CREATE TABLE STOCK_UPDATES (
  update_id       INT  NOT NULL AUTO_INCREMENT,
  quantity_change INT  NOT NULL,
  updated_at      DATE NOT NULL,
  product_id      INT  NOT NULL,
  user_id         INT  NOT NULL,
  PRIMARY KEY (update_id),
  CONSTRAINT fk_stock_product
    FOREIGN KEY (product_id) REFERENCES PRODUCTS (product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_stock_user
    FOREIGN KEY (user_id) REFERENCES USERS (user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- =============================================================
--  FUNCTION: get_product_status
--  Returns a display-only status label derived from quantity.
--    quantity < 10  → 'critical'
--    quantity < 50  → 'low-stock'
--    quantity >= 50 → 'in-stock'
-- =============================================================

-- =============================================================
--  VIEW: v_products
--  Joins PRODUCTS with CATEGORIES and surfaces the computed
--  status so application queries never need inline CASE logic.
-- =============================================================

CREATE VIEW v_products AS
SELECT
  p.product_id,
  p.product_name,
  p.quantity,
  p.size,
  p.category_id,
  c.category_name,
  CASE
    WHEN p.quantity < 10 THEN 'critical'
    WHEN p.quantity < 50 THEN 'low-stock'
    ELSE 'in-stock'
  END AS status
FROM PRODUCTS  p
JOIN CATEGORIES c ON c.category_id = p.category_id;

-- =============================================================
--  TRIGGER: trg_after_stock_insert
--  After a STOCK_UPDATES row is inserted, apply the
--  quantity_change to PRODUCTS.quantity so the table stays
--  current and the derived status updates automatically.
-- =============================================================

DELIMITER $$

CREATE TRIGGER trg_after_stock_insert
AFTER INSERT ON STOCK_UPDATES
FOR EACH ROW
BEGIN
  UPDATE PRODUCTS
  SET    quantity = quantity + NEW.quantity_change
  WHERE  product_id = NEW.product_id;
END$$

DELIMITER ;

-- =============================================================
--  SEED DATA — CATEGORIES
-- =============================================================

INSERT INTO CATEGORIES (category_name) VALUES
  ('Coffee Beans'),
  ('Capsules'),
  ('Juices'),
  ('Accessories'),
  ('Syrups');

-- =============================================================
--  SEED DATA — USERS
--  Passwords are bcrypt-hashed (cost 12, $2y$ PHP-compatible
--  variant — functionally identical to $2b$ used by Node.js).
--    Adamo     → Admin1234!
--    Secretary → Secretary1!
-- =============================================================

INSERT INTO USERS (username, password, role, email) VALUES
  ('Adamo',
   '$2y$12$.pX5tw0One/DeksnA5KFUeigVRh8cejRPt6WxCI0O6FsVo8rnZQha',
   'admin',
   'admin@cafefantini.com'),
  ('Secretary',
   '$2y$12$/SFUbMn2ca5AwtG3VVHM0ezI1KJSS1ePjgXv1/U8HQ6v1sHPPEP96',
   'secretary',
   'secretary@cafefantini.com');

-- =============================================================
--  SEED DATA — PRODUCTS
--  All 9 seed products belong to category 1 (Coffee Beans).
--  Quantities match the application mock store exactly.
-- =============================================================

INSERT INTO PRODUCTS (product_name, quantity, size, category_id) VALUES
  ('Musetti Gold Blend',       165, '3 kg',   1),
  ('Musetti Blue Espresso',     37, '3.5 kg', 1),
  ('Musetti Decaffeinato',       3, '7 kg',   1),
  ('Musetti Arabica Superior', 116, '6 kg',   1),
  ('Musetti Gran Riserva',     117, '9 kg',   1),
  ('Fantini House Blend',      101, '2 kg',   1),
  ('Fantini Dark Roast',         5, '9 kg',   1),
  ('Musetti Organic',           45, '4 kg',   1),
  ('Musetti Classico',          50, '3 kg',   1);

-- =============================================================
--  SEED DATA — STOCK_UPDATES
--  5 sample rows showing realistic restocks and adjustments.
--  Quantities reflect movements prior to the seed inventory
--  levels above (inserted directly — trigger fires going
--  forward on live data, not against seed rows).
-- =============================================================

INSERT INTO STOCK_UPDATES (quantity_change, updated_at, product_id, user_id) VALUES
  ( 50, '2025-01-15', 1, 1),   -- Admin restocked Musetti Gold Blend
  (-10, '2025-02-03', 2, 1),   -- Admin adjusted Musetti Blue Espresso (damage)
  ( 20, '2025-02-20', 3, 2),   -- Secretary recorded Musetti Decaffeinato restock
  ( 30, '2025-03-10', 7, 1),   -- Admin restocked Fantini Dark Roast
  (-5,  '2025-04-01', 8, 2);   -- Secretary recorded Musetti Organic adjustment
