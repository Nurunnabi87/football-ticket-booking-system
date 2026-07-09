-- ============================================================
--  Football Ticket Booking System — Schema & Sample Data
--  Database : PostgreSQL
--  Run with : psql -d football_ticket_booking -f setup.sql
-- ============================================================

-- Drop in reverse dependency order so the script is re-runnable.
-- Bookings must go first because it holds FKs to the other two.
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS users;

-- ============================================================
-- 1. Users — administrative staff and customers of the platform
-- ============================================================
CREATE TABLE users (
    user_id      SERIAL PRIMARY KEY,                -- unique id for each registered user
    full_name    VARCHAR(100) NOT NULL,             -- first + last name
    email        VARCHAR(100) NOT NULL UNIQUE,      -- login mail address (no duplicates)
    role         VARCHAR(20)  NOT NULL              -- access permission level
                 CHECK (role IN ('Ticket Manager', 'Football Fan')),
    phone_number VARCHAR(20)                        -- nullable: some fans don't share a number
);

-- ============================================================
-- 2. Matches — tournament events and baseline ticket pricing
-- ============================================================
CREATE TABLE matches (
    match_id            SERIAL PRIMARY KEY,          -- unique id for each football match
    fixture             VARCHAR(100) NOT NULL,       -- the two competing teams
    tournament_category VARCHAR(50)  NOT NULL,       -- league or cup title
    base_ticket_price   NUMERIC(10,2) NOT NULL       -- price of a standard entry seat
                        CHECK (base_ticket_price >= 0),
    match_status        VARCHAR(20)  NOT NULL DEFAULT 'Available'
                        CHECK (match_status IN
                              ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

-- ============================================================
-- 3. Bookings — transactional table linking users to matches
-- ============================================================
CREATE TABLE bookings (
    booking_id     SERIAL PRIMARY KEY,               -- unique ticket purchase transaction
    user_id        INT NOT NULL                      -- who made the purchase
                   REFERENCES users (user_id)
                   ON DELETE CASCADE,
    match_id       INT NOT NULL                      -- which match is being attended
                   REFERENCES matches (match_id)
                   ON DELETE CASCADE,
    seat_number    VARCHAR(10),                      -- nullable: seat may not be allocated yet
    payment_status VARCHAR(20)                       -- nullable: payment may not be resolved yet
                   CHECK (payment_status IN
                         ('Pending', 'Confirmed', 'Cancelled', 'Refunded')),
    total_cost     NUMERIC(10,2) NOT NULL
                   CHECK (total_cost >= 0)
);

-- ============================================================
-- Sample Data
-- ============================================================
INSERT INTO users (user_id, full_name, email, role, phone_number) VALUES
    (1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan',   '+8801711111111'),
    (2, 'Asif Haque',    'asif@mail.com',   'Football Fan',   '+8801722222222'),
    (3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
    (4, 'Jannat Ara',    'jannat@mail.com', 'Football Fan',   NULL);

INSERT INTO matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
    (101, 'Real Madrid vs Barcelona', 'Champions League', 150, 'Available'),
    (102, 'Man City vs Liverpool',    'Premier League',   120, 'Selling Fast'),
    (103, 'Bayern Munich vs PSG',     'Champions League', 130, 'Available'),
    (104, 'AC Milan vs Inter Milan',  'Serie A',           90, 'Sold Out'),
    (105, 'Juventus vs Roma',         'Serie A',           80, 'Available');

INSERT INTO bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
    (501, 1, 101, 'A-12', 'Confirmed', 150),
    (502, 1, 102, 'B-04', 'Confirmed', 120),
    (503, 2, 101, 'A-13', 'Confirmed', 150),
    (504, 2, 101, NULL,   NULL,        150),
    (505, 3, 102, 'C-20', 'Pending',   120);

-- Because ids were inserted explicitly, move each SERIAL sequence
-- past the highest used value so future inserts don't collide.
SELECT setval('users_user_id_seq',       (SELECT MAX(user_id)    FROM users));
SELECT setval('matches_match_id_seq',    (SELECT MAX(match_id)   FROM matches));
SELECT setval('bookings_booking_id_seq', (SELECT MAX(booking_id) FROM bookings));
