# Pharmacy System — Update Notes

This zip contains the pharmacy system with all requested bug fixes and feature
additions. Read this file in full before deploying.

---

## 1. Deployment steps

1. **Back up your existing database first.** Always.
2. **Back up your existing project folder.**
3. Unzip this archive into your web folder. The folder can be named anything
   (`pharmacy_system`, `pharmacy`, etc.) — paths now auto-detect.
4. **Run the SQL once.** Open phpMyAdmin (or your MySQL client) and import
   `hospital_management.sql`. If you already have data in the existing
   `*_pharm` tables and don't want to overwrite it, instead run only these
   three statements from the bottom of the file:
   - `CREATE TABLE IF NOT EXISTS customers_pharm ...`
   - `CREATE TABLE IF NOT EXISTS product_edit_log_pharm ...`
   - `ALTER TABLE sales_pharm ADD COLUMN IF NOT EXISTS customer_id ...`
     (If your MySQL is older than 8.0 / MariaDB 10.3, drop the `IF NOT EXISTS`
     from the ALTER and run it manually.)
5. Confirm `includes/db.php` credentials match your MySQL.
6. Open your project URL — it redirects to `login.php` and the rest of the
   app works the same.

---

## 2. SQL file

The SQL dump has been **trimmed**. Removed: every non-pharmacy table
(`accounts`, `beds`, `bills`, `doctors`, `patients`, `triage`, all the
hospital/insurance/lab tables, etc.).

**Kept (18 tables):**

- `categories_pharm`
- `credit_notes_pharm`, `credit_note_items_pharm`
- `expenditures_pharm`
- `invoices_pharm`
- `notifications_pharm`
- `pharmacy_details`
- `procurement_pharm`, `procurement_items_pharm`
- `products_pharm`
- `product_batches_pharm` *(now actively used as the receipts archive)*
- `sales_pharm` *(now has a `customer_id` column)*
- `sale_items_pharm`
- `stock_movements_pharm`
- `suppliers_pharm`
- `users_pharm`
- **`customers_pharm` (new)**
- **`product_edit_log_pharm` (new)**

Foreign-key constraints that pointed at removed tables have been stripped so
the file imports cleanly.

---

## 3. The bug fixes — what was wrong, and what was changed

### 3.1 Redirect loop (`ERR_TOO_MANY_REDIRECTS`)
Hardcoded `/pharmacy_system/...` paths in `auth.php`, `header.php`, and
`system/index.php` would 404 if the project was hosted under any other
folder name. Replaced with a runtime helper `base_url()` that detects the
install path from `$_SERVER['SCRIPT_NAME']`.

### 3.2 Recent-Sales dates wrong when offline
`system/invoice.php` showed the sale date by running `new Date()` in
**JavaScript** — that always shows the browser's current time, not the
saved sale date. When the browser was offline its clock might be wrong;
when online NTP corrected it. Now rendered server-side from PHP using the
actual `sales_pharm.date` value (`system/invoice.php`, `system/sales.php`).

### 3.3 Wrong sales time
PHP's timezone was inheriting from the server locale. Added
`date_default_timezone_set('Africa/Kampala')` at the top of
`includes/auth.php`, which loads on every page.

### 3.4 Edit invoice: change date, then "Add Product" stops working
`system/edit_invoice.php` had a **nested `<script>` tag** inside another
`<script>` (invalid HTML — the browser silently truncates everything
after the inner one). Removed the nested tag, rewrote the handlers using
**event delegation** so they survive any DOM mutation (including the
date input changing).

### 3.5 Mouse-wheel changes price inputs
Number inputs respond to wheel-scroll by incrementing. Added a global
listener on `sales.php`, `edit_invoice.php`, and `update_stock.php`:
when a number input has focus and the wheel fires, the input is blurred.
Individual inputs also carry `onwheel="this.blur()"` as belt-and-braces.

### 3.6 Some procurement receipts didn't save / weren't retrievable in `view_invoice.php`
Two problems:
- The finalize step was not transactional. If any step failed silently
  (a constraint, a NULL field) the loop carried on without rollback,
  leaving partial data.
- `view_invoice.php` queried `products_pharm.invoice_number`, but
  `products_pharm` only stores the **most recent** batch info — re-stocking
  a product later overwrote that field, making older receipts invisible.

Fixes:
- `update_stock.php` now wraps the whole finalize in
  `beginTransaction / commit / rollback`. If anything fails, the user
  sees the actual MySQL error and the in-progress invoice is preserved
  so they can correct and retry.
- Each finalize now **always** writes a row into `product_batches_pharm`
  (the audit/archive table) recording the batch number, prices, expiry,
  invoice id, invoice number, and product name.
- `view_invoice.php` now reads from `product_batches_pharm` first, with
  `products_pharm` as a fallback for very old receipts. Re-stocking can
  no longer hide older receipts.

### 3.7 Auto-calc buying price (Total ÷ Quantity, rounded to 2 dp)
`update_stock.php` got a new **Total Amount Paid** field. Type quantity
and total amount → buying price fills in automatically, rounded to 2
decimal places. Independently editable if needed. The PHP save also
rounds before inserting into `product_batches_pharm` / `products_pharm`.

### 3.8 Sticky invoice header on sales.php
The "invoice in progress" panel (customer, started-at, running total)
now appears as soon as you click **Start Invoice**, stays visible
(sticky to the top while scrolling), and only clears when you click
**End Invoice** or after a successful sale is processed.

### 3.9 Customer module (new)
- New table `customers_pharm` with name, contact, address, remarks.
- New page `system/customers.php` — list, add, edit, delete customers.
- New AJAX endpoint `system/ajax_search_customers.php`.
- On `system/sales.php`, the **Start Invoice** form now has a
  search-as-you-type box. Type a name or phone, suggestions appear,
  click one to bind that customer to the invoice. If no match exists,
  the typed text is used as a walk-in label and the invoice still
  proceeds — customer linkage is **optional**.
- `sales_pharm` now stores `customer_id` (nullable) alongside the
  existing `customer_name`.
- The sidebar now has a **Customers** link.

### 3.10 Product edits require a reason + audit log
On `system/products.php`'s edit form:
- A required "Reason for edit" textarea is now shown.
- Saving without a reason throws an error and the edit is rejected.
- Every field that actually changed gets one row in
  `product_edit_log_pharm` with `(product_id, user_id, field_name,
  old_value, new_value, reason, edited_at)`.

### 3.11 Multiple batches of the same product (FEFO)
The system already stored each batch as a separate row in
`products_pharm` (same name, different `batch_number`). The product
search and sales page were silently treating them as duplicates. Now:
- `system/product_search.php` returns one entry **per batch**, ordered
  by expiry date ascending (FEFO — First Expiry First Out).
- The sales page suggestions show the batch number and expiry date:
  `PARACETAMOL 500MG [Batch 5488] — UGX 50 — Stock: 425 exp 2027-10-10`.
- Each selectable suggestion is its own batch — adding it to the cart
  records that specific batch's `product_id` on the sale.
- The sales table now has a **Batch** column so the cashier sees which
  batch is being sold from.

> **About FEFO vs FIFO:** I picked **FEFO** (earliest-expiring batch
> shown first) because it's the right default for medicines — older
> expiry sells before newer expiry. If you prefer FIFO (oldest stock-in
> date first), change the `ORDER BY` in `product_search.php` from
> `expiry_date ASC` to `id ASC`.

---

## 4. Files added

- `system/customers.php` — Customer CRUD page.
- `system/ajax_search_customers.php` — JSON search endpoint used by sales.php.

## 5. Files modified

- `includes/auth.php` — timezone, `base_url()` helper, redirect fixes.
- `includes/header.php` — `base_url()` for all sidebar links, new Customers link.
- `system/index.php` — `base_url()` on two dashboard quick-links.
- `system/sales.php` — full rewrite: customer search, sticky invoice panel,
  scroll fix, server-rendered dates, batch display.
- `system/invoice.php` — JS-date bug fixed, customer_id saved, sticky panel
  cleared after successful sale.
- `system/edit_invoice.php` — nested `<script>` removed, handlers rewritten
  with event delegation, scroll fix.
- `system/update_stock.php` — transactional finalize, audit rows always
  written to `product_batches_pharm`, Total-Amount field + auto-calc buying
  price (2 dp), scroll fix, sticky in-progress panel.
- `system/view_invoice.php` — queries `product_batches_pharm` by
  `invoice_number`, with fallback to `products_pharm`.
- `system/products.php` — required "Reason for edit" + audit log writes.
- `system/product_search.php` — FEFO batch-aware results.
- `hospital_management.sql` — trimmed to pharmacy tables only; adds new
  tables and the `customer_id` column.

## 6. Files unchanged

Everything else — `classes/Pharmacy.php`, `classes/PDF.php`,
`includes/db.php`, `includes/encryption.php`, `includes/functions.php`,
`includes/footer.php`, `system/admin.php`, `system/expenditures.php`,
`system/reports.php`, `system/balance_sheet.php`, `system/closed_invoice.php`,
`system/product_lookup.php`, `system/mark_notification_read.php`, etc. —
was deliberately not touched.

---

## 7. Honest caveats

A few things I want to be straightforward about so you're not surprised:

- **I could not run this against your live MySQL database to verify
  end-to-end.** Every PHP file parses cleanly, every SQL statement is
  well-formed, and the logic is sound. But the first deployment will
  almost certainly need a tweak somewhere — usually a small one like a
  missing column or a strict-mode setting. Open the browser's developer
  console and PHP error log first if anything misbehaves.

- **The customer feature treats customers as optional.** If you want to
  *force* every sale to have a customer, change `customer_id` to `NOT NULL`
  in the SQL and reject saves without `customer_id` in `invoice.php`.

- **The FEFO ordering relies on the `expiry_date` column being correct.**
  A product with `0000-00-00` or a wrong date will sort to the top.
  Worth running a quick check after import:
  `SELECT id, name, expiry_date FROM products_pharm WHERE expiry_date < CURDATE() ORDER BY expiry_date LIMIT 20;`

- **The procurement audit table (`product_batches_pharm`) didn't have a
  `name` column in some older dumps.** Your dump does have one. If your
  live DB doesn't, run:
  `ALTER TABLE product_batches_pharm ADD COLUMN name VARCHAR(100) NULL;`
  before using `view_invoice.php`.

If anything breaks on first deploy, send me the exact error message —
PHP error, MySQL error, or screenshot — and I'll fix the specific cause.
