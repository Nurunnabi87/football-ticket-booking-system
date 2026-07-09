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
