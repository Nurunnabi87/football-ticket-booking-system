-- ============================================================
--  Football Ticket Booking System — SQL Queries
--  Database : PostgreSQL  (schema + data: setup.sql)
--  Run with : psql -d football_ticket_booking -f QUERY.sql
-- ============================================================

-- ------------------------------------------------------------
-- Query 1
-- Retrieve all upcoming football matches belonging to the
-- 'Champions League' where the match status is 'Available'.
-- Concepts used: WHERE, AND
-- ------------------------------------------------------------
SELECT
    match_id,
    fixture,
    base_ticket_price
FROM matches
WHERE tournament_category = 'Champions League'
  AND match_status = 'Available';

-- ------------------------------------------------------------
-- Query 2
-- Search for all users whose full names start with 'Tanvir'
-- or contain the phrase 'Haque' (case-insensitive).
-- Concepts used: LIKE, ILIKE
-- ------------------------------------------------------------
SELECT
    user_id,
    full_name,
    email
FROM users
WHERE full_name LIKE 'Tanvir%'      -- starts with 'Tanvir' (case-sensitive)
   OR full_name ILIKE '%haque%';    -- contains 'Haque' anywhere, ignoring case

-- ------------------------------------------------------------
-- Query 3
-- Retrieve all booking records where the payment status is
-- missing (NULL), replacing the empty result with
-- 'Action Required'.
-- Concepts used: IS NULL, COALESCE
-- ------------------------------------------------------------
SELECT
    booking_id,
    user_id,
    match_id,
    COALESCE(payment_status, 'Action Required') AS systematic_status
FROM bookings
WHERE payment_status IS NULL;

-- ------------------------------------------------------------
-- Query 4
-- Retrieve match booking details along with the User's full
-- name and the scheduled Match fixture teams.
-- Concepts used: INNER JOIN
-- ------------------------------------------------------------
SELECT
    b.booking_id,
    u.full_name,
    m.fixture,
    b.total_cost
FROM bookings AS b
INNER JOIN users   AS u ON b.user_id  = u.user_id
INNER JOIN matches AS m ON b.match_id = m.match_id
ORDER BY b.booking_id;
