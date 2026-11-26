SET SQL DIALECT 3;

CREATE TABLE person (
    id INTEGER PRIMARY KEY,
    display_name VARCHAR(64) NOT NULL
);
CREATE TABLE computer (
    id INTEGER PRIMARY KEY,
    asset_tag VARCHAR(32) NOT NULL UNIQUE,
    owner_id INTEGER REFERENCES person(id)
);

CREATE TABLE parking_spot (
    id INTEGER PRIMARY KEY,
    label VARCHAR(12) NOT NULL UNIQUE
);
CREATE TABLE vehicle (
    id INTEGER PRIMARY KEY,
    plate VARCHAR(16) NOT NULL UNIQUE
);
CREATE TABLE parking_visit (
    id INTEGER PRIMARY KEY,
    spot_id INTEGER NOT NULL REFERENCES parking_spot(id),
    vehicle_id INTEGER NOT NULL REFERENCES vehicle(id),
    entered_at TIMESTAMP NOT NULL,
    left_at TIMESTAMP,
    CHECK (left_at IS NULL OR left_at >= entered_at)
);

CREATE TABLE sale_order (
    id INTEGER PRIMARY KEY,
    state VARCHAR(10) NOT NULL CHECK (state IN ('OPEN', 'CLOSED'))
);
CREATE TABLE order_line (
    id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES sale_order(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);
CREATE EXCEPTION closed_order 'Order is closed';
COMMIT;

SET TERM ^ ;
CREATE PROCEDURE parking_history (lookup_plate VARCHAR(16))
RETURNS (vehicle_plate VARCHAR(16), location_label VARCHAR(12), started TIMESTAMP,
         finished TIMESTAMP, visit_state VARCHAR(8))
AS
BEGIN
    FOR SELECT v.plate, s.label, p.entered_at, p.left_at,
        CASE WHEN p.left_at IS NULL THEN 'OPEN' ELSE 'FINISHED' END
        FROM parking_visit p
        JOIN vehicle v ON v.id = p.vehicle_id
        JOIN parking_spot s ON s.id = p.spot_id
        WHERE v.plate = :lookup_plate
        ORDER BY p.entered_at
        INTO :vehicle_plate, :location_label, :started, :finished, :visit_state
    DO SUSPEND;
END^

CREATE PROCEDURE invoice_total (sale_id INTEGER)
RETURNS (total NUMERIC(12,2))
AS
BEGIN
    SELECT COALESCE(SUM(quantity * unit_price), 0)
    FROM order_line WHERE order_id = :sale_id INTO :total;
    SUSPEND;
END^

CREATE TRIGGER protect_closed_order FOR order_line
ACTIVE BEFORE INSERT OR UPDATE OR DELETE POSITION 0
AS
    DECLARE VARIABLE order_state VARCHAR(10);
BEGIN
    IF (UPDATING OR DELETING) THEN
    BEGIN
        SELECT state FROM sale_order WHERE id = OLD.order_id INTO :order_state;
        IF (order_state = 'CLOSED') THEN EXCEPTION closed_order;
    END
    IF (INSERTING OR UPDATING) THEN
    BEGIN
        SELECT state FROM sale_order WHERE id = NEW.order_id INTO :order_state;
        IF (order_state = 'CLOSED') THEN EXCEPTION closed_order;
    END
END^
SET TERM ; ^
COMMIT;

INSERT INTO person VALUES (1, 'Demo user');
INSERT INTO computer VALUES (1, 'LAB-01', 1);
INSERT INTO computer VALUES (2, 'LAB-02', NULL);
INSERT INTO parking_spot VALUES (1, 'A01');
INSERT INTO parking_spot VALUES (2, 'A02');
INSERT INTO vehicle VALUES (1, 'DEMO-01');
INSERT INTO parking_visit VALUES (1, 1, 1, TIMESTAMP '2025-04-01 09:00:00',
                                  TIMESTAMP '2025-04-01 13:00:00');
INSERT INTO parking_visit VALUES (2, 2, 1, TIMESTAMP '2025-04-02 08:00:00', NULL);
INSERT INTO sale_order VALUES (1, 'OPEN');
INSERT INTO sale_order VALUES (2, 'OPEN');
INSERT INTO order_line VALUES (1, 1, 2, 4.25);
INSERT INTO order_line VALUES (2, 1, 1, 10.00);
INSERT INTO order_line VALUES (3, 2, 1, 3.00);
UPDATE sale_order SET state = 'CLOSED' WHERE id = 2;
COMMIT;

SELECT c.asset_tag, COALESCE(p.display_name, 'Unassigned') AS assigned_to
FROM computer c LEFT JOIN person p ON p.id = c.owner_id ORDER BY c.asset_tag;
SELECT * FROM parking_history('DEMO-01');
SELECT * FROM invoice_total(1);
