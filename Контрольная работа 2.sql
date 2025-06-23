CREATE TYPE transport_type AS ENUM ('bus', 'train', 'plane');

CREATE TABLE passengers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    passport_number VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE transport (
    id SERIAL PRIMARY KEY,
    type transport_type NOT NULL,
    model_or_route VARCHAR(100) NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    passenger_id INT NOT NULL REFERENCES passengers(id),
    transport_id INT NOT NULL REFERENCES transport(id),
    seat_number INT NOT NULL,
    travel_date DATE NOT NULL
);

INSERT INTO passengers (name, passport_number) VALUES
('Евгений Шустов', 'AA1234567'),
('Кирилл Лепкович', 'AA7654321'),
('Николай Шустов', 'AA1325467');

INSERT INTO transport (type, model_or_route, capacity) VALUES 
('bus', 'Минск - Москва', 50),
('train', 'Минск - Санкт-Петербург', 150),
('plane', 'Boeing 737', 180);

INSERT INTO bookings (passenger_id, transport_id, seat_number, travel_date) VALUES
(1, 1, 5, '2025-06-05'),
(1, 2, 8, '2025-06-08'),
(2, 1, 7, '2025-06-12'),
(2, 3, 2, '2025-06-15'),
(3, 2, 15, '2025-06-20'),
(3, 3, 20, '2025-06-25');


SELECT DISTINCT passengers.id, passengers.name, passengers.passport_number FROM passengers
JOIN bookings ON passengers.id = bookings.passenger_id;

SELECT transport.id, transport.type, COUNT(bookings.id) AS seats_booked FROM transport
LEFT JOIN bookings ON transport.id = bookings.transport_id
GROUP BY transport.id, transport.type;

SELECT DISTINCT passengers.id, passengers.name, passengers.passport_number FROM passengers
JOIN bookings ON passengers.id = bookings.passenger_id
WHERE EXTRACT (YEAR FROM bookings.travel_date) = 2025
  AND EXTRACT (MONTH FROM bookings.travel_date) = 5;

SELECT transport.type, COUNT(bookings.id) AS total_bookings FROM bookings 
JOIN transport ON bookings.transport_id = transport.
GROUP BY transport.type
ORDER BY total.bookings DESC LIMIT 1;

SELECT 40 - COUNT (bookings.id) AS free_seats FROM bookings 
WHERE bookings.transport_id = 1;

SELECT passengers.name, passengers.passport_number, transport.type, bookings.seat_number
FROM bookings
JOIN passengers ON bookings.passenger_id = passengers.id
JOIN transport ON bookings.transport_id = transport.id;

SELECT passengers.id, passengers.name, passengers.passport_number
FROM passengers
WHERE NOT EXISTS (
    SELECT 1 FROM bookings
    JOIN transport ON bookings.transport_id = transport.id
    WHERE bookings.passenger_id = passengers.id
      AND transport.type <> 'train'
)
AND EXISTS (
    SELECT 1 FROM bookings
    JOIN transport ON bookings.transport_id = transport.id
    WHERE bookings.passenger_id = passengers.id
      AND transport.type = 'train'
);

SELECT passengers.id, passengers.name, COUNT(DISTINCT transport.type) AS transport_type_count FROM passengers
JOIN bookings ON passengers.id = bookings.passenger_id
JOIN transport ON bookings.transport_id = transport.id
GROUP BY passengers.id, passengers.name
HAVING COUNT(DISTINCT transport.type) > 1;








