-- ============================================================
--   HOSPITAL MANAGEMENT SYSTEM
--   Complete Database Project
--   Includes: Schema, Data, Queries, CRUD, Transactions,
--             Stored Procedures, Triggers, Views
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE SETUP
-- ============================================================

DROP DATABASE IF EXISTS HospitalDB;
CREATE DATABASE HospitalDB;
USE HospitalDB;


-- ============================================================
-- SECTION 2: CREATE TABLES (Schema Design)
-- ============================================================

-- 2.1 Department
CREATE TABLE Department (
    dept_id     INT AUTO_INCREMENT PRIMARY KEY,
    dept_name   VARCHAR(100) NOT NULL UNIQUE
);

-- 2.2 Doctor
CREATE TABLE Doctor (
    doctor_id       INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    specialization  VARCHAR(100) NOT NULL,
    phone           VARCHAR(15)  NOT NULL UNIQUE,
    dept_id         INT          NOT NULL,
    CONSTRAINT fk_doctor_dept FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 2.3 Patient
CREATE TABLE Patient (
    patient_id  INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    age         INT          NOT NULL,
    gender      ENUM('Male','Female','Other') NOT NULL,
    phone       VARCHAR(15)  NOT NULL UNIQUE,
    address     TEXT,
    CONSTRAINT chk_age CHECK (age > 0 AND age < 150)
);

-- 2.4 Appointment
CREATE TABLE Appointment (
    appointment_id  INT AUTO_INCREMENT PRIMARY KEY,
    patient_id      INT  NOT NULL,
    doctor_id       INT  NOT NULL,
    appt_date       DATE NOT NULL,
    appt_time       TIME NOT NULL,
    status          ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
    CONSTRAINT fk_appt_patient FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_appt_doctor  FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 2.5 Treatment
CREATE TABLE Treatment (
    treatment_id        INT AUTO_INCREMENT PRIMARY KEY,
    patient_id          INT          NOT NULL,
    doctor_id           INT          NOT NULL,
    diagnosis           VARCHAR(255) NOT NULL,
    treatment_details   TEXT,
    treatment_date      DATE         NOT NULL,
    cost                DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT fk_treat_patient FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_treat_doctor  FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 2.6 Billing
CREATE TABLE Billing (
    bill_id         INT AUTO_INCREMENT PRIMARY KEY,
    patient_id      INT             NOT NULL,
    total_amount    DECIMAL(10,2)   DEFAULT 0.00,
    payment_status  ENUM('Pending','Paid','Partial') DEFAULT 'Pending',
    bill_date       DATE            NOT NULL,
    CONSTRAINT fk_bill_patient FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_amount CHECK (total_amount >= 0)
);


-- ============================================================
-- SECTION 3: INSERT SAMPLE DATA
-- ============================================================

-- 3.1 Departments (3)
INSERT INTO Department (dept_name) VALUES
    ('Cardiology'),
    ('Neurology'),
    ('Orthopedics');

-- 3.2 Doctors (5)
INSERT INTO Doctor (name, specialization, phone, dept_id) VALUES
    ('Dr. Arjun Mehta',    'Cardiologist',      '9876501001', 1),
    ('Dr. Priya Sharma',   'Neurologist',       '9876501002', 2),
    ('Dr. Rohan Kapoor',   'Orthopedic Surgeon','9876501003', 3),
    ('Dr. Sunita Rao',     'Cardiologist',      '9876501004', 1),
    ('Dr. Vikram Nair',    'Neurologist',       '9876501005', 2);

-- 3.3 Patients (5)
INSERT INTO Patient (name, age, gender, phone, address) VALUES
    ('Amit Desai',      34, 'Male',   '9123456001', '12 MG Road, Mumbai'),
    ('Rekha Joshi',     45, 'Female', '9123456002', '7 Andheri West, Mumbai'),
    ('Suresh Kumar',    58, 'Male',   '9123456003', '33 Bandra, Mumbai'),
    ('Pooja Agarwal',   27, 'Female', '9123456004', '5 Colaba, Mumbai'),
    ('Ravi Tiwari',     62, 'Male',   '9123456005', '19 Dadar, Mumbai');

-- 3.4 Appointments (10)
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, status) VALUES
    (1, 1, '2025-06-01', '09:00:00', 'Completed'),
    (2, 2, '2025-06-02', '10:30:00', 'Completed'),
    (3, 3, '2025-06-03', '11:00:00', 'Completed'),
    (4, 4, '2025-06-04', '14:00:00', 'Scheduled'),
    (5, 5, '2025-06-05', '15:30:00', 'Scheduled'),
    (1, 2, '2025-06-06', '09:30:00', 'Cancelled'),
    (2, 3, '2025-06-07', '10:00:00', 'Completed'),
    (3, 1, '2025-06-08', '13:00:00', 'Scheduled'),
    (4, 5, '2025-06-09', '16:00:00', 'Scheduled'),
    (5, 4, '2025-06-10', '11:30:00', 'Completed');

-- 3.5 Treatments (6)
INSERT INTO Treatment (patient_id, doctor_id, diagnosis, treatment_details, treatment_date, cost) VALUES
    (1, 1, 'Hypertension',         'Prescribed Amlodipine 5mg',     '2025-06-01', 800.00),
    (2, 2, 'Migraine',             'Prescribed Sumatriptan',         '2025-06-02', 600.00),
    (3, 3, 'Knee Arthritis',       'Physiotherapy + Pain relief',    '2025-06-03', 1200.00),
    (2, 3, 'Fracture - Left Arm',  'Cast applied, follow up 4 wks',  '2025-06-07', 1500.00),
    (5, 4, 'Chest Pain',           'ECG, Aspirin prescribed',        '2025-06-10', 950.00),
    (1, 1, 'Arrhythmia',           'Holter monitor prescribed',      '2025-06-12', 1100.00);

-- 3.6 Billing (5)
INSERT INTO Billing (patient_id, total_amount, payment_status, bill_date) VALUES
    (1, 1900.00, 'Paid',    '2025-06-12'),
    (2, 2100.00, 'Partial', '2025-06-07'),
    (3, 1200.00, 'Paid',    '2025-06-03'),
    (4, 0.00,    'Pending', '2025-06-04'),
    (5, 950.00,  'Paid',    '2025-06-10');


-- ============================================================
-- SECTION 4: SELECT QUERIES
-- ============================================================

-- 4.1 View all patients
SELECT * FROM Patient;

-- 4.2 View all doctors with their department name
SELECT d.doctor_id, d.name AS doctor_name, d.specialization, dp.dept_name
FROM Doctor d
JOIN Department dp ON d.dept_id = dp.dept_id;

-- 4.3 All appointments with patient and doctor names
SELECT
    a.appointment_id,
    p.name  AS patient_name,
    d.name  AS doctor_name,
    a.appt_date,
    a.appt_time,
    a.status
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Doctor  d ON a.doctor_id  = d.doctor_id;

-- 4.4 Treatments with full details
SELECT
    t.treatment_id,
    p.name  AS patient_name,
    d.name  AS doctor_name,
    t.diagnosis,
    t.treatment_details,
    t.treatment_date,
    t.cost
FROM Treatment t
JOIN Patient p ON t.patient_id = p.patient_id
JOIN Doctor  d ON t.doctor_id  = d.doctor_id;

-- 4.5 Billing summary per patient
SELECT
    p.name AS patient_name,
    b.total_amount,
    b.payment_status,
    b.bill_date
FROM Billing b
JOIN Patient p ON b.patient_id = p.patient_id;


-- ============================================================
-- SECTION 5: AGGREGATE QUERIES
-- ============================================================

-- 5.1 Total number of appointments
SELECT COUNT(*) AS total_appointments FROM Appointment;

-- 5.2 Appointments by status
SELECT status, COUNT(*) AS count
FROM Appointment
GROUP BY status;

-- 5.3 Total revenue collected
SELECT SUM(total_amount) AS total_revenue FROM Billing;

-- 5.4 Total billing per patient
SELECT p.name, SUM(b.total_amount) AS total_billed
FROM Billing b
JOIN Patient p ON b.patient_id = p.patient_id
GROUP BY p.name;

-- 5.5 Number of doctors per department
SELECT dp.dept_name, COUNT(d.doctor_id) AS num_doctors
FROM Department dp
LEFT JOIN Doctor d ON dp.dept_id = d.dept_id
GROUP BY dp.dept_name;

-- 5.6 Average patient age
SELECT AVG(age) AS avg_patient_age FROM Patient;

-- 5.7 Most expensive treatment
SELECT diagnosis, cost
FROM Treatment
ORDER BY cost DESC
LIMIT 1;


-- ============================================================
-- SECTION 6: CRUD OPERATIONS
-- ============================================================

-- 6.1 INSERT — Add a new patient
INSERT INTO Patient (name, age, gender, phone, address)
VALUES ('Nisha Patel', 30, 'Female', '9988776655', '8 Juhu Beach Rd, Mumbai');

-- 6.2 UPDATE — Change a doctor's phone number
UPDATE Doctor
SET phone = '9876599999'
WHERE doctor_id = 3;

-- 6.3 UPDATE — Mark appointment as Cancelled
UPDATE Appointment
SET status = 'Cancelled'
WHERE appointment_id = 9;

-- 6.4 DELETE — Remove a cancelled appointment
DELETE FROM Appointment
WHERE status = 'Cancelled' AND appointment_id = 6;

-- 6.5 SELECT — Search patient by name
SELECT * FROM Patient
WHERE name LIKE '%Rekha%';


-- ============================================================
-- SECTION 7: TRANSACTIONS
-- ============================================================

-- 7.1 Book appointment + create bill atomically
START TRANSACTION;

    INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, status)
    VALUES (6, 1, '2025-07-01', '10:00:00', 'Scheduled');

    INSERT INTO Billing (patient_id, total_amount, payment_status, bill_date)
    VALUES (6, 500.00, 'Pending', '2025-07-01');

COMMIT;

-- 7.2 Rollback example (demonstrates safety)
START TRANSACTION;

    UPDATE Billing SET total_amount = total_amount + 300
    WHERE patient_id = 2;

ROLLBACK;   -- Change is undone


-- ============================================================
-- SECTION 8: VIEWS
-- ============================================================

-- 8.1 Patient appointment history view
CREATE OR REPLACE VIEW vw_patient_appointments AS
SELECT
    p.patient_id,
    p.name          AS patient_name,
    d.name          AS doctor_name,
    dp.dept_name,
    a.appt_date,
    a.appt_time,
    a.status
FROM Appointment a
JOIN Patient    p  ON a.patient_id = p.patient_id
JOIN Doctor     d  ON a.doctor_id  = d.doctor_id
JOIN Department dp ON d.dept_id    = dp.dept_id;

-- Use the view
SELECT * FROM vw_patient_appointments;

-- 8.2 Pending bills view
CREATE OR REPLACE VIEW vw_pending_bills AS
SELECT
    p.name          AS patient_name,
    b.total_amount,
    b.bill_date
FROM Billing b
JOIN Patient p ON b.patient_id = p.patient_id
WHERE b.payment_status IN ('Pending','Partial');

SELECT * FROM vw_pending_bills;


-- ============================================================
-- SECTION 9: STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- 9.1 Add a new patient
CREATE PROCEDURE sp_add_patient(
    IN p_name    VARCHAR(100),
    IN p_age     INT,
    IN p_gender  ENUM('Male','Female','Other'),
    IN p_phone   VARCHAR(15),
    IN p_address TEXT
)
BEGIN
    INSERT INTO Patient (name, age, gender, phone, address)
    VALUES (p_name, p_age, p_gender, p_phone, p_address);
    SELECT LAST_INSERT_ID() AS new_patient_id;
END$$

-- 9.2 Book an appointment
CREATE PROCEDURE sp_book_appointment(
    IN p_patient_id INT,
    IN p_doctor_id  INT,
    IN p_date       DATE,
    IN p_time       TIME
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Booking failed. Transaction rolled back.';
    END;

    START TRANSACTION;
        INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time)
        VALUES (p_patient_id, p_doctor_id, p_date, p_time);

        INSERT INTO Billing (patient_id, total_amount, payment_status, bill_date)
        VALUES (p_patient_id, 500.00, 'Pending', p_date);
    COMMIT;
    SELECT 'Appointment booked successfully.' AS message;
END$$

-- 9.3 Get full patient report
CREATE PROCEDURE sp_patient_report(IN p_patient_id INT)
BEGIN
    SELECT 'Patient Info' AS section;
    SELECT * FROM Patient WHERE patient_id = p_patient_id;

    SELECT 'Appointments' AS section;
    SELECT a.appt_date, a.appt_time, a.status, d.name AS doctor
    FROM Appointment a
    JOIN Doctor d ON a.doctor_id = d.doctor_id
    WHERE a.patient_id = p_patient_id;

    SELECT 'Treatments' AS section;
    SELECT t.diagnosis, t.treatment_details, t.treatment_date, t.cost
    FROM Treatment t
    WHERE t.patient_id = p_patient_id;

    SELECT 'Billing' AS section;
    SELECT b.total_amount, b.payment_status, b.bill_date
    FROM Billing b
    WHERE b.patient_id = p_patient_id;
END$$

DELIMITER ;

-- Call the stored procedures
CALL sp_add_patient('Dev Malhotra', 40, 'Male', '9001122334', 'Powai, Mumbai');
CALL sp_book_appointment(7, 2, '2025-07-05', '09:00:00');
CALL sp_patient_report(1);


-- ============================================================
-- SECTION 10: TRIGGERS
-- ============================================================

DELIMITER $$

-- 10.1 Auto-update billing when a treatment is added
CREATE TRIGGER trg_update_bill_on_treatment
AFTER INSERT ON Treatment
FOR EACH ROW
BEGIN
    -- If a bill exists for this patient, add the treatment cost
    IF EXISTS (SELECT 1 FROM Billing WHERE patient_id = NEW.patient_id) THEN
        UPDATE Billing
        SET total_amount = total_amount + NEW.cost
        WHERE patient_id = NEW.patient_id;
    ELSE
        -- Create a new bill if none exists
        INSERT INTO Billing (patient_id, total_amount, payment_status, bill_date)
        VALUES (NEW.patient_id, NEW.cost, 'Pending', NEW.treatment_date);
    END IF;
END$$

-- 10.2 Prevent deletion of a completed appointment
CREATE TRIGGER trg_block_delete_completed
BEFORE DELETE ON Appointment
FOR EACH ROW
BEGIN
    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete a completed appointment.';
    END IF;
END$$

-- 10.3 Log cancelled appointments (audit table)
CREATE TABLE IF NOT EXISTS Appointment_Audit (
    audit_id        INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id  INT,
    patient_id      INT,
    cancelled_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER trg_log_cancellation
AFTER UPDATE ON Appointment
FOR EACH ROW
BEGIN
    IF NEW.status = 'Cancelled' AND OLD.status != 'Cancelled' THEN
        INSERT INTO Appointment_Audit (appointment_id, patient_id)
        VALUES (NEW.appointment_id, NEW.patient_id);
    END IF;
END$$

DELIMITER ;


-- ============================================================
-- SECTION 11: ADVANCED QUERIES (BONUS / EXTRA MARKS)
-- ============================================================

-- 11.1 Patients who have NEVER had an appointment
SELECT p.name
FROM Patient p
WHERE p.patient_id NOT IN (
    SELECT DISTINCT patient_id FROM Appointment
);

-- 11.2 Doctors with the most appointments
SELECT d.name, COUNT(a.appointment_id) AS total_appointments
FROM Doctor d
LEFT JOIN Appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.name
ORDER BY total_appointments DESC;

-- 11.3 Patients with unpaid/partial bills > 500
SELECT p.name, b.total_amount, b.payment_status
FROM Billing b
JOIN Patient p ON b.patient_id = p.patient_id
WHERE b.payment_status != 'Paid' AND b.total_amount > 500;

-- 11.4 Department-wise revenue (via treatments)
SELECT dp.dept_name, SUM(t.cost) AS dept_revenue
FROM Treatment t
JOIN Doctor     d  ON t.doctor_id = d.doctor_id
JOIN Department dp ON d.dept_id   = dp.dept_id
GROUP BY dp.dept_name;

-- 11.5 Subquery — patients treated by Cardiology doctors
SELECT DISTINCT p.name
FROM Patient p
WHERE p.patient_id IN (
    SELECT t.patient_id
    FROM Treatment t
    JOIN Doctor d ON t.doctor_id = d.doctor_id
    WHERE d.dept_id = (
        SELECT dept_id FROM Department WHERE dept_name = 'Cardiology'
    )
);

-- 11.6 Appointments this month (dynamic)
SELECT p.name, d.name AS doctor, a.appt_date
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Doctor  d ON a.doctor_id  = d.doctor_id
WHERE MONTH(a.appt_date) = MONTH(CURDATE())
  AND YEAR(a.appt_date)  = YEAR(CURDATE());


-- ============================================================
-- END OF HOSPITAL MANAGEMENT SYSTEM
-- ============================================================
