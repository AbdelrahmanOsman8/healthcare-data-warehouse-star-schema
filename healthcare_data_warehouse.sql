-- ============================================================
-- Healthcare Operations & Patient Analytics Data Warehouse
-- ============================================================


-- ============================================================
-- 1. DIMENSION TABLES
-- ============================================================


-- ============================================================
-- Dimension: dim_date
-- ============================================================

CREATE TABLE healthcare_dw.dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_week INTEGER,
    day_name VARCHAR(10),
    day_of_month INTEGER,
    day_of_year INTEGER,
    week_of_year INTEGER,
    month_number INTEGER,
    month_name VARCHAR(10),
    quarter INTEGER,
    year INTEGER,
    is_weekend CHAR(1),
    is_holiday CHAR(1)
);


-- ============================================================
-- Dimension: dim_patient
-- ============================================================

CREATE TABLE healthcare_dw.dim_patient (
    patient_key INTEGER PRIMARY KEY,
    patient_id VARCHAR(20) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    city VARCHAR(50),
    insurance_type VARCHAR(30),
    patient_segment VARCHAR(20)
);


-- ============================================================
-- Dimension: dim_provider
-- ============================================================

CREATE TABLE healthcare_dw.dim_provider (
    provider_key INTEGER PRIMARY KEY,
    provider_id VARCHAR(20) NOT NULL,
    provider_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50),
    department_name VARCHAR(100),
    provider_type VARCHAR(30)
);


-- ============================================================
-- Dimension: dim_department
-- ============================================================

CREATE TABLE healthcare_dw.dim_department (
    department_key INTEGER PRIMARY KEY,
    department_id VARCHAR(20) NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    department_type VARCHAR(50),
    floor_number INTEGER,
    hospital_unit VARCHAR(50)
);


-- ============================================================
-- Dimension: dim_diagnosis
-- ============================================================

CREATE TABLE healthcare_dw.dim_diagnosis (
    diagnosis_key INTEGER PRIMARY KEY,
    diagnosis_code VARCHAR(20) NOT NULL,
    diagnosis_name VARCHAR(100) NOT NULL,
    diagnosis_category VARCHAR(50),
    severity_level VARCHAR(20)
);


-- ============================================================
-- Dimension: dim_medication
-- ============================================================

CREATE TABLE healthcare_dw.dim_medication (
    medication_key INTEGER PRIMARY KEY,
    medication_id VARCHAR(20) NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    medication_class VARCHAR(50),
    dosage_form VARCHAR(30),
    strength VARCHAR(30),
    manufacturer VARCHAR(100)
);


-- ============================================================
-- 2. FACT TABLES
-- ============================================================


-- ============================================================
-- Fact: fact_patient_encounter
--
-- Grain:
-- One row represents one patient healthcare encounter.
-- ============================================================

CREATE TABLE healthcare_dw.fact_patient_encounter (
    encounter_key INTEGER PRIMARY KEY,
    date_key INTEGER NOT NULL,
    patient_key INTEGER NOT NULL,
    provider_key INTEGER NOT NULL,
    department_key INTEGER NOT NULL,
    diagnosis_key INTEGER NOT NULL,
    encounter_type VARCHAR(30) NOT NULL,
    length_of_stay INTEGER DEFAULT 0,
    wait_time_minutes INTEGER,
    treatment_cost DECIMAL(14,2)
);


-- ============================================================
-- Fact: fact_medication
--
-- Grain:
-- One row represents one medication event/prescription.
-- ============================================================

CREATE TABLE healthcare_dw.fact_medication (
    medication_event_key INTEGER PRIMARY KEY,
    date_key INTEGER NOT NULL,
    patient_key INTEGER NOT NULL,
    provider_key INTEGER NOT NULL,
    medication_key INTEGER NOT NULL,
    encounter_key INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    dosage VARCHAR(50),
    duration_days INTEGER,
    medication_cost DECIMAL(14,2)
);


-- ============================================================
-- 3. INDEXES
-- ============================================================
--
-- Indexes are created on foreign-key columns frequently used
-- in analytical joins and filtering.
-- ============================================================

CREATE INDEX idx_fact_encounter_date
ON healthcare_dw.fact_patient_encounter(date_key);

CREATE INDEX idx_fact_encounter_patient
ON healthcare_dw.fact_patient_encounter(patient_key);

CREATE INDEX idx_fact_encounter_provider
ON healthcare_dw.fact_patient_encounter(provider_key);

CREATE INDEX idx_fact_encounter_department
ON healthcare_dw.fact_patient_encounter(department_key);

CREATE INDEX idx_fact_encounter_diagnosis
ON healthcare_dw.fact_patient_encounter(diagnosis_key);


CREATE INDEX idx_fact_medication_date
ON healthcare_dw.fact_medication(date_key);

CREATE INDEX idx_fact_medication_patient
ON healthcare_dw.fact_medication(patient_key);

CREATE INDEX idx_fact_medication_provider
ON healthcare_dw.fact_medication(provider_key);

CREATE INDEX idx_fact_medication
ON healthcare_dw.fact_medication(medication_key);

CREATE INDEX idx_fact_medication_encounter
ON healthcare_dw.fact_medication(encounter_key);


-- ============================================================
-- 4. SAMPLE DATA
-- ============================================================


-- ============================================================
-- Sample data: dim_date
-- ============================================================

INSERT INTO healthcare_dw.dim_date
(date_key, full_date, day_of_week, day_name, day_of_month,
 day_of_year, week_of_year, month_number, month_name,
 quarter, year, is_weekend, is_holiday)
VALUES

(20240101, DATE '2024-01-01', 1, 'Monday', 1, 1, 1,
 1, 'January', 1, 2024, 'N', 'Y'),

(20240102, DATE '2024-01-02', 2, 'Tuesday', 2, 2, 1,
 1, 'January', 1, 2024, 'N', 'N'),

(20240103, DATE '2024-01-03', 3, 'Wednesday', 3, 3, 1,
 1, 'January', 1, 2024, 'N', 'N'),

(20240104, DATE '2024-01-04', 4, 'Thursday', 4, 4, 1,
 1, 'January', 1, 2024, 'N', 'N'),

(20240105, DATE '2024-01-05', 5, 'Friday', 5, 5, 1,
 1, 'January', 1, 2024, 'N', 'N'),

(20240106, DATE '2024-01-06', 6, 'Saturday', 6, 6, 1,
 1, 'January', 1, 2024, 'Y', 'N'),

(20240107, DATE '2024-01-07', 7, 'Sunday', 7, 7, 1,
 1, 'January', 1, 2024, 'Y', 'N'),

(20240115, DATE '2024-01-15', 1, 'Monday', 15, 15, 3,
 1, 'January', 1, 2024, 'N', 'N'),

(20240201, DATE '2024-02-01', 4, 'Thursday', 1, 32, 5,
 2, 'February', 1, 2024, 'N', 'N'),

(20240215, DATE '2024-02-15', 4, 'Thursday', 15, 46, 7,
 2, 'February', 1, 2024, 'N', 'N'),

(20240301, DATE '2024-03-01', 5, 'Friday', 1, 61, 9,
 3, 'March', 1, 2024, 'N', 'N'),

(20240315, DATE '2024-03-15', 5, 'Friday', 15, 75, 11,
 3, 'March', 1, 2024, 'N', 'N'),

(20240401, DATE '2024-04-01', 1, 'Monday', 1, 92, 14,
 4, 'April', 2, 2024, 'N', 'N'),

(20240415, DATE '2024-04-15', 1, 'Monday', 15, 106, 16,
 4, 'April', 2, 2024, 'N', 'N'),

(20240501, DATE '2024-05-01', 3, 'Wednesday', 1, 122, 18,
 5, 'May', 2, 2024, 'N', 'N'),

(20240515, DATE '2024-05-15', 3, 'Wednesday', 15, 136, 20,
 5, 'May', 2, 2024, 'N', 'N'),

(20240601, DATE '2024-06-01', 6, 'Saturday', 1, 153, 22,
 6, 'June', 2, 2024, 'Y', 'N'),

(20240615, DATE '2024-06-15', 6, 'Saturday', 15, 167, 24,
 6, 'June', 2, 2024, 'Y', 'N'),

(20240701, DATE '2024-07-01', 1, 'Monday', 1, 183, 27,
 7, 'July', 3, 2024, 'N', 'N'),

(20240715, DATE '2024-07-15', 1, 'Monday', 15, 197, 29,
 7, 'July', 3, 2024, 'N', 'N'),

(20240801, DATE '2024-08-01', 4, 'Thursday', 1, 214, 31,
 8, 'August', 3, 2024, 'N', 'N'),

(20240815, DATE '2024-08-15', 4, 'Thursday', 15, 228, 33,
 8, 'August', 3, 2024, 'N', 'N'),

(20240901, DATE '2024-09-01', 7, 'Sunday', 1, 245, 35,
 9, 'September', 3, 2024, 'Y', 'N'),

(20240915, DATE '2024-09-15', 7, 'Sunday', 15, 259, 37,
 9, 'September', 3, 2024, 'Y', 'N'),

(20241001, DATE '2024-10-01', 2, 'Tuesday', 1, 275, 40,
 10, 'October', 4, 2024, 'N', 'N'),

(20241015, DATE '2024-10-15', 2, 'Tuesday', 15, 289, 42,
 10, 'October', 4, 2024, 'N', 'N'),

(20241101, DATE '2024-11-01', 5, 'Friday', 1, 306, 44,
 11, 'November', 4, 2024, 'N', 'N'),

(20241115, DATE '2024-11-15', 5, 'Friday', 15, 320, 46,
 11, 'November', 4, 2024, 'N', 'N'),

(20241201, DATE '2024-12-01', 7, 'Sunday', 1, 336, 48,
 12, 'December', 4, 2024, 'Y', 'N'),

(20241215, DATE '2024-12-15', 7, 'Sunday', 15, 350, 50,
 12, 'December', 4, 2024, 'Y', 'N'),

(20241225, DATE '2024-12-25', 3, 'Wednesday', 25, 360, 52,
 12, 'December', 4, 2024, 'N', 'Y'),

(20250101, DATE '2025-01-01', 3, 'Wednesday', 1, 1, 1,
 1, 'January', 1, 2025, 'N', 'Y'),

(20250115, DATE '2025-01-15', 3, 'Wednesday', 15, 15, 3,
 1, 'January', 1, 2025, 'N', 'N'),

(20250201, DATE '2025-02-01', 6, 'Saturday', 1, 32, 5,
 2, 'February', 1, 2025, 'Y', 'N'),

(20250215, DATE '2025-02-15', 6, 'Saturday', 15, 46, 7,
 2, 'February', 1, 2025, 'Y', 'N'),

(20250301, DATE '2025-03-01', 6, 'Saturday', 1, 60, 9,
 3, 'March', 1, 2025, 'Y', 'N'),

(20250315, DATE '2025-03-15', 6, 'Saturday', 15, 74, 11,
 3, 'March', 1, 2025, 'Y', 'N');


-- ============================================================
-- Sample data: dim_patient
-- ============================================================

INSERT INTO healthcare_dw.dim_patient
(patient_key, patient_id, first_name, last_name, gender,
 date_of_birth, city, insurance_type, patient_segment)
VALUES

(1, 'PAT001', 'Ahmed', 'Hassan', 'Male',
 DATE '1998-04-12', 'Alexandria', 'Private', 'Regular'),

(2, 'PAT002', 'Sara', 'Ali', 'Female',
 DATE '2001-08-21', 'Alexandria', 'Government', 'Regular'),

(3, 'PAT003', 'Omar', 'Mahmoud', 'Male',
 DATE '1987-01-10', 'Cairo', 'Private', 'High_Risk'),

(4, 'PAT004', 'Mona', 'Ibrahim', 'Female',
 DATE '1995-06-18', 'Giza', 'Government', 'Regular'),

(5, 'PAT005', 'Youssef', 'Adel', 'Male',
 DATE '1978-11-03', 'Alexandria', 'Private', 'High_Risk'),

(6, 'PAT006', 'Nour', 'Khaled', 'Female',
 DATE '2003-02-25', 'Alexandria', 'Student', 'Regular'),

(7, 'PAT007', 'Karim', 'Samir', 'Male',
 DATE '1990-09-14', 'Cairo', 'Private', 'Regular'),

(8, 'PAT008', 'Salma', 'Tarek', 'Female',
 DATE '1985-03-30', 'Alexandria', 'Government', 'High_Risk'),

(9, 'PAT009', 'Mostafa', 'Nabil', 'Male',
 DATE '1972-12-05', 'Giza', 'Private', 'High_Risk'),

(10, 'PAT010', 'Hana', 'Wael', 'Female',
 DATE '1999-07-19', 'Alexandria', 'Private', 'Regular'),

(11, 'PAT011', 'Adam', 'Fathy', 'Male',
 DATE '2000-05-22', 'Alexandria', 'Student', 'Regular'),

(12, 'PAT012', 'Laila', 'Sami', 'Female',
 DATE '1968-10-11', 'Cairo', 'Government', 'High_Risk');


-- ============================================================
-- Sample data: dim_provider
-- ============================================================

INSERT INTO healthcare_dw.dim_provider
(provider_key, provider_id, provider_name, specialty,
 department_name, provider_type)
VALUES

(1, 'DOC001', 'Dr. Ahmed Mostafa',
 'Cardiology', 'Cardiology', 'Physician'),

(2, 'DOC002', 'Dr. Sara Khalil',
 'Emergency Medicine', 'Emergency Department', 'Physician'),

(3, 'DOC003', 'Dr. Omar Adel',
 'Internal Medicine', 'Internal Medicine', 'Physician'),

(4, 'DOC004', 'Dr. Mona Samir',
 'Pediatrics', 'Pediatrics', 'Physician'),

(5, 'DOC005', 'Dr. Karim Hassan',
 'Neurology', 'Neurology', 'Physician'),

(6, 'DOC006', 'Dr. Nour Ali',
 'Radiology', 'Radiology', 'Radiologist'),

(7, 'DOC007', 'Dr. Youssef Ibrahim',
 'General Surgery', 'Surgery', 'Surgeon'),

(8, 'DOC008', 'Dr. Salma Nabil',
 'Emergency Medicine', 'Emergency Department', 'Physician');


-- ============================================================
-- Sample data: dim_department
-- ============================================================

INSERT INTO healthcare_dw.dim_department
(department_key, department_id, department_name,
 department_type, floor_number, hospital_unit)
VALUES

(1, 'DEP001', 'Emergency Department',
 'Emergency', 1, 'Emergency Unit'),

(2, 'DEP002', 'Cardiology',
 'Specialty', 2, 'Heart Center'),

(3, 'DEP003', 'Internal Medicine',
 'Specialty', 3, 'Medical Unit'),

(4, 'DEP004', 'Radiology',
 'Diagnostic', 1, 'Imaging Center'),

(5, 'DEP005', 'Neurology',
 'Specialty', 2, 'Neuro Unit'),

(6, 'DEP006', 'Pediatrics',
 'Specialty', 2, 'Children Unit'),

(7, 'DEP007', 'Surgery',
 'Surgical', 3, 'Surgical Unit'),

(8, 'DEP008', 'Outpatient Clinic',
 'Outpatient', 1, 'OPD');


-- ============================================================
-- Sample data: dim_diagnosis
--
-- Diagnosis codes are simulated and are NOT clinical coding
-- recommendations.
-- ============================================================

INSERT INTO healthcare_dw.dim_diagnosis
(diagnosis_key, diagnosis_code, diagnosis_name,
 diagnosis_category, severity_level)
VALUES

(1, 'SIM001', 'Hypertension',
 'Cardiovascular', 'Moderate'),

(2, 'SIM002', 'Type 2 Diabetes',
 'Endocrine', 'Moderate'),

(3, 'SIM003', 'Acute Respiratory Infection',
 'Respiratory', 'Mild'),

(4, 'SIM004', 'Chest Pain',
 'Cardiovascular', 'High'),

(5, 'SIM005', 'Migraine',
 'Neurological', 'Moderate'),

(6, 'SIM006', 'Gastrointestinal Disorder',
 'Digestive', 'Moderate'),

(7, 'SIM007', 'Minor Injury',
 'Trauma', 'Mild'),

(8, 'SIM008', 'Asthma Exacerbation',
 'Respiratory', 'High'),

(9, 'SIM009', 'Fever',
 'General', 'Mild'),

(10, 'SIM010', 'Postoperative Follow-up',
 'Surgical', 'Moderate');


-- ============================================================
-- Sample data: dim_medication
-- ============================================================

INSERT INTO healthcare_dw.dim_medication
(medication_key, medication_id, medication_name,
 medication_class, dosage_form, strength, manufacturer)
VALUES

(1, 'MED001', 'Amlodipine',
 'Antihypertensive', 'Tablet', '5 mg', 'Simulated Pharma'),

(2, 'MED002', 'Metformin',
 'Antidiabetic', 'Tablet', '500 mg', 'Simulated Pharma'),

(3, 'MED003', 'Salbutamol',
 'Bronchodilator', 'Inhaler', '100 mcg', 'Simulated Pharma'),

(4, 'MED004', 'Paracetamol',
 'Analgesic', 'Tablet', '500 mg', 'Simulated Pharma'),

(5, 'MED005', 'Omeprazole',
 'Gastroprotective', 'Capsule', '20 mg', 'Simulated Pharma'),

(6, 'MED006', 'Sumatriptan',
 'Antimigraine', 'Tablet', '50 mg', 'Simulated Pharma'),

(7, 'MED007', 'Amoxicillin',
 'Antibiotic', 'Capsule', '500 mg', 'Simulated Pharma'),

(8, 'MED008', 'Atorvastatin',
 'Lipid-lowering', 'Tablet', '20 mg', 'Simulated Pharma');


-- ============================================================
-- 5. SAMPLE FACT DATA
-- ============================================================


-- ============================================================
-- fact_patient_encounter
-- ============================================================

INSERT INTO healthcare_dw.fact_patient_encounter
(encounter_key, date_key, patient_key, provider_key,
 department_key, diagnosis_key, encounter_type,
 length_of_stay, wait_time_minutes, treatment_cost)
VALUES

(1, 20240101, 1, 1, 2, 1,
 'Outpatient', 0, 25, 450.00),

(2, 20240101, 3, 2, 1, 4,
 'Emergency', 1, 85, 1200.00),

(3, 20240102, 2, 3, 3, 2,
 'Outpatient', 0, 30, 500.00),

(4, 20240102, 5, 2, 1, 8,
 'Emergency', 2, 110, 1800.00),

(5, 20240103, 7, 5, 5, 5,
 'Outpatient', 0, 40, 650.00),

(6, 20240103, 4, 4, 6, 9,
 'Outpatient', 0, 20, 350.00),

(7, 20240104, 9, 2, 1, 7,
 'Emergency', 1, 95, 900.00),

(8, 20240104, 8, 1, 2, 1,
 'Outpatient', 0, 35, 480.00),

(9, 20240105, 10, 3, 3, 6,
 'Outpatient', 0, 28, 420.00),

(10, 20240105, 12, 5, 5, 5,
 'Outpatient', 0, 45, 700.00),

(11, 20240106, 3, 2, 1, 4,
 'Emergency', 1, 120, 1500.00),

(12, 20240106, 6, 3, 3, 3,
 'Outpatient', 0, 22, 380.00),

(13, 20240107, 5, 1, 2, 1,
 'Outpatient', 0, 32, 550.00),

(14, 20240115, 1, 1, 2, 1,
 'Follow-up', 0, 18, 300.00),

(15, 20240115, 9, 2, 1, 4,
 'Emergency', 2, 100, 2100.00),

(16, 20240201, 2, 3, 3, 2,
 'Follow-up', 0, 25, 320.00),

(17, 20240201, 8, 1, 2, 1,
 'Follow-up', 0, 30, 350.00),

(18, 20240215, 5, 2, 1, 8,
 'Emergency', 1, 90, 1400.00),

(19, 20240215, 7, 5, 5, 5,
 'Follow-up', 0, 35, 450.00),

(20, 20240301, 12, 5, 5, 5,
 'Outpatient', 0, 42, 620.00),

(21, 20240301, 10, 3, 3, 6,
 'Outpatient', 0, 20, 400.00),

(22, 20240315, 3, 2, 1, 4,
 'Emergency', 2, 115, 1900.00),

(23, 20240315, 6, 3, 3, 3,
 'Outpatient', 0, 25, 360.00),

(24, 20240401, 1, 1, 2, 1,
 'Follow-up', 0, 20, 320.00),

(25, 20240401, 4, 4, 6, 9,
 'Outpatient', 0, 15, 300.00),

(26, 20240415, 9, 2, 1, 7,
 'Emergency', 1, 105, 1100.00),

(27, 20240415, 11, 3, 3, 2,
 'Outpatient', 0, 30, 480.00),

(28, 20240501, 5, 1, 2, 1,
 'Follow-up', 0, 25, 360.00),

(29, 20240501, 8, 1, 2, 1,
 'Outpatient', 0, 35, 500.00),

(30, 20240515, 12, 5, 5, 5,
 'Follow-up', 0, 40, 520.00),

(31, 20240515, 3, 2, 1, 4,
 'Emergency', 2, 125, 2200.00),

(32, 20240601, 7, 5, 5, 5,
 'Outpatient', 0, 30, 450.00),

(33, 20240601, 10, 3, 3, 6,
 'Outpatient', 0, 22, 390.00),

(34, 20240615, 2, 3, 3, 2,
 'Follow-up', 0, 27, 340.00),

(35, 20240615, 9, 2, 1, 8,
 'Emergency', 1, 100, 1600.00),

(36, 20240701, 1, 1, 2, 1,
 'Outpatient', 0, 30, 450.00),

(37, 20240701, 6, 3, 3, 3,
 'Outpatient', 0, 18, 330.00),

(38, 20240715, 5, 2, 1, 8,
 'Emergency', 2, 130, 2300.00),

(39, 20240715, 12, 5, 5, 5,
 'Follow-up', 0, 38, 480.00),

(40, 20240801, 8, 1, 2, 1,
 'Outpatient', 0, 28, 410.00),

(41, 20240801, 10, 3, 3, 6,
 'Outpatient', 0, 24, 400.00),

(42, 20240815, 3, 2, 1, 4,
 'Emergency', 2, 118, 2000.00),

(43, 20240815, 7, 5, 5, 5,
 'Outpatient', 0, 33, 460.00),

(44, 20240901, 9, 2, 1, 7,
 'Emergency', 1, 92, 1000.00),

(45, 20240901, 2, 3, 3, 2,
 'Outpatient', 0, 26, 430.00),

(46, 20240915, 11, 3, 3, 2,
 'Follow-up', 0, 21, 310.00),

(47, 20240915, 4, 4, 6, 9,
 'Outpatient', 0, 17, 290.00),

(48, 20241001, 1, 1, 2, 1,
 'Follow-up', 0, 24, 330.00),

(49, 20241001, 12, 5, 5, 5,
 'Outpatient', 0, 35, 500.00),

(50, 20241015, 5, 2, 1, 8,
 'Emergency', 2, 140, 2500.00),

(51, 20241015, 8, 1, 2, 1,
 'Outpatient', 0, 30, 440.00),

(52, 20241101, 3, 2, 1, 4,
 'Emergency', 2, 110, 1900.00),

(53, 20241101, 7, 5, 5, 5,
 'Follow-up', 0, 32, 450.00),

(54, 20241115, 10, 3, 3, 6,
 'Outpatient', 0, 23, 390.00),

(55, 20241115, 2, 3, 3, 2,
 'Follow-up', 0, 28, 350.00),

(56, 20241201, 9, 2, 1, 7,
 'Emergency', 1, 98, 1150.00),

(57, 20241201, 6, 3, 3, 3,
 'Outpatient', 0, 20, 350.00),

(58, 20241215, 5, 1, 2, 1,
 'Follow-up', 0, 29, 380.00),

(59, 20241215, 12, 5, 5, 5,
 'Outpatient', 0, 36, 520.00),

(60, 20241225, 3, 2, 1, 4,
 'Emergency', 2, 135, 2400.00),

(61, 20250101, 8, 1, 2, 1,
 'Outpatient', 0, 27, 420.00),

(62, 20250101, 10, 3, 3, 6,
 'Outpatient', 0, 22, 380.00),

(63, 20250115, 1, 1, 2, 1,
 'Follow-up', 0, 25, 340.00),

(64, 20250115, 9, 2, 1, 7,
 'Emergency', 1, 105, 1200.00),

(65, 20250201, 2, 3, 3, 2,
 'Outpatient', 0, 30, 450.00),

(66, 20250201, 5, 1, 2, 1,
 'Follow-up', 0, 35, 390.00),

(67, 20250215, 12, 5, 5, 5,
 'Outpatient', 0, 40, 540.00),

(68, 20250215, 3, 2, 1, 4,
 'Emergency', 2, 145, 2600.00),

(69, 20250301, 7, 5, 5, 5,
 'Follow-up', 0, 32, 470.00),

(70, 20250301, 6, 3, 3, 3,
 'Outpatient', 0, 19, 340.00),

(71, 20250315, 8, 1, 2, 1,
 'Outpatient', 0, 28, 430.00),

(72, 20250315, 9, 2, 1, 7,
 'Emergency', 1, 100, 1250.00);


-- ============================================================
-- 6. SAMPLE MEDICATION EVENTS
-- ============================================================

INSERT INTO healthcare_dw.fact_medication
(medication_event_key, date_key, patient_key, provider_key,
 medication_key, encounter_key, quantity, dosage,
 duration_days, medication_cost)
VALUES

(1, 20240101, 1, 1, 1, 1, 30, '5 mg once daily', 30, 90.00),

(2, 20240101, 3, 2, 4, 2, 10, '500 mg as needed', 5, 25.00),

(3, 20240102, 2, 3, 2, 3, 60, '500 mg twice daily', 30, 70.00),

(4, 20240102, 5, 2, 3, 4, 1, 'As directed', 7, 80.00),

(5, 20240103, 7, 5, 6, 5, 6, '50 mg as needed', 6, 120.00),

(6, 20240104, 9, 2, 4, 7, 10, '500 mg as needed', 5, 25.00),

(7, 20240105, 10, 3, 5, 9, 30, '20 mg once daily', 30, 65.00),

(8, 20240105, 12, 5, 6, 10, 4, '50 mg as needed', 4, 80.00),

(9, 20240106, 3, 2, 4, 11, 10, '500 mg as needed', 5, 25.00),

(10, 20240106, 6, 3, 7, 12, 21, '500 mg three times daily', 7, 90.00),

(11, 20240115, 1, 1, 1, 14, 30, '5 mg once daily', 30, 90.00),

(12, 20240115, 9, 2, 4, 15, 10, '500 mg as needed', 5, 25.00),

(13, 20240201, 2, 3, 2, 16, 60, '500 mg twice daily', 30, 70.00),

(14, 20240201, 8, 1, 1, 17, 30, '5 mg once daily', 30, 90.00),

(15, 20240215, 5, 2, 3, 18, 1, 'As directed', 7, 80.00),

(16, 20240215, 7, 5, 6, 19, 6, '50 mg as needed', 6, 120.00),

(17, 20240301, 12, 5, 6, 20, 4, '50 mg as needed', 4, 80.00),

(18, 20240301, 10, 3, 5, 21, 30, '20 mg once daily', 30, 65.00),

(19, 20240315, 3, 2, 4, 22, 10, '500 mg as needed', 5, 25.00),

(20, 20240315, 6, 3, 7, 23, 21, '500 mg three times daily', 7, 90.00),

(21, 20240401, 1, 1, 1, 24, 30, '5 mg once daily', 30, 90.00),

(22, 20240401, 4, 4, 4, 25, 10, '500 mg as needed', 5, 25.00),

(23, 20240415, 9, 2, 4, 26, 10, '500 mg as needed', 5, 25.00),

(24, 20240415, 11, 3, 2, 27, 60, '500 mg twice daily', 30, 70.00),

(25, 20240501, 5, 1, 1, 28, 30, '5 mg once daily', 30, 90.00),

(26, 20240501, 8, 1, 1, 29, 30, '5 mg once daily', 30, 90.00),

(27, 20240515, 12, 5, 6, 30, 4, '50 mg as needed', 4, 80.00),

(28, 20240515, 3, 2, 4, 31, 10, '500 mg as needed', 5, 25.00),

(29, 20240601, 7, 5, 6, 32, 6, '50 mg as needed', 6, 120.00),

(30, 20240601, 10, 3, 5, 33, 30, '20 mg once daily', 30, 65.00),

(31, 20240615, 2, 3, 2, 34, 60, '500 mg twice daily', 30, 70.00),

(32, 20240615, 9, 2, 3, 35, 1, 'As directed', 7, 80.00),

(33, 20240701, 1, 1, 1, 36, 30, '5 mg once daily', 30, 90.00),

(34, 20240701, 6, 3, 7, 37, 21, '500 mg three times daily', 7, 90.00),

(35, 20240715, 5, 2, 3, 38, 1, 'As directed', 7, 80.00),

(36, 20240715, 12, 5, 6, 39, 4, '50 mg as needed', 4, 80.00),

(37, 20240801, 8, 1, 1, 40, 30, '5 mg once daily', 30, 90.00),

(38, 20240801, 10, 3, 5, 41, 30, '20 mg once daily', 30, 65.00),

(39, 20240815, 3, 2, 4, 42, 10, '500 mg as needed', 5, 25.00),

(40, 20240815, 7, 5, 6, 43, 6, '50 mg as needed', 6, 120.00),

(41, 20240901, 9, 2, 4, 44, 10, '500 mg as needed', 5, 25.00),

(42, 20240901, 2, 3, 2, 45, 60, '500 mg twice daily', 30, 70.00),

(43, 20240915, 11, 3, 2, 46, 60, '500 mg twice daily', 30, 70.00),

(44, 20240915, 4, 4, 4, 47, 10, '500 mg as needed', 5, 25.00),

(45, 20241001, 1, 1, 1, 48, 30, '5 mg once daily', 30, 90.00),

(46, 20241001, 12, 5, 6, 49, 4, '50 mg as needed', 4, 80.00),

(47, 20241015, 5, 2, 3, 50, 1, 'As directed', 7, 80.00),

(48, 20241015, 8, 1, 1, 51, 30, '5 mg once daily', 30, 90.00),

(49, 20241101, 3, 2, 4, 52, 10, '500 mg as needed', 5, 25.00),

(50, 20241101, 7, 5, 6, 53, 6, '50 mg as needed', 6, 120.00),

(51, 20241115, 10, 3, 5, 54, 30, '20 mg once daily', 30, 65.00),

(52, 20241115, 2, 3, 2, 55, 60, '500 mg twice daily', 30, 70.00),

(53, 20241201, 9, 2, 4, 56, 10, '500 mg as needed', 5, 25.00),

(54, 20241201, 6, 3, 7, 57, 21, '500 mg three times daily', 7, 90.00),

(55, 20241215, 5, 1, 1, 58, 30, '5 mg once daily', 30, 90.00),

(56, 20241215, 12, 5, 6, 59, 4, '50 mg as needed', 4, 80.00),

(57, 20241225, 3, 2, 4, 60, 10, '500 mg as needed', 5, 25.00),

(58, 20250101, 8, 1, 1, 61, 30, '5 mg once daily', 30, 90.00),

(59, 20250101, 10, 3, 5, 62, 30, '20 mg once daily', 30, 65.00),

(60, 20250115, 1, 1, 1, 63, 30, '5 mg once daily', 30, 90.00),

(61, 20250115, 9, 2, 4, 64, 10, '500 mg as needed', 5, 25.00),

(62, 20250201, 2, 3, 2, 65, 60, '500 mg twice daily', 30, 70.00),

(63, 20250201, 5, 1, 1, 66, 30, '5 mg once daily', 30, 90.00),

(64, 20250215, 12, 5, 6, 67, 4, '50 mg as needed', 4, 80.00),

(65, 20250215, 3, 2, 4, 68, 10, '500 mg as needed', 5, 25.00),

(66, 20250301, 7, 5, 6, 69, 6, '50 mg as needed', 6, 120.00),

(67, 20250301, 6, 3, 7, 70, 21, '500 mg three times daily', 7, 90.00),

(68, 20250315, 8, 1, 1, 71, 30, '5 mg once daily', 30, 90.00),

(69, 20250315, 9, 2, 4, 72, 10, '500 mg as needed', 5, 25.00);


-- ============================================================
-- 7. SUMMARY TABLE
-- ============================================================
--
-- Pre-aggregated healthcare activity.
--
-- Similar to an analytical cube:
-- Date + Department + Encounter Metrics
-- ============================================================

CREATE TABLE healthcare_dw.summary_daily_patient_activity AS
SELECT
    f.date_key,
    d.full_date,
    d.year,
    d.month_number,
    d.month_name,

    f.department_key,
    dep.department_name,
    dep.department_type,

    COUNT(*) AS total_encounters,

    COUNT(DISTINCT f.patient_key) AS unique_patients,

    SUM(
        CASE
            WHEN f.encounter_type = 'Emergency'
            THEN 1
            ELSE 0
        END
    ) AS emergency_encounters,

    ROUND(AVG(f.wait_time_minutes), 2)
        AS average_wait_time,

    ROUND(AVG(f.length_of_stay), 2)
        AS average_length_of_stay,

    SUM(f.treatment_cost)
        AS total_treatment_cost

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_date d
    ON f.date_key = d.date_key

JOIN healthcare_dw.dim_department dep
    ON f.department_key = dep.department_key

GROUP BY
    f.date_key,
    d.full_date,
    d.year,
    d.month_number,
    d.month_name,
    f.department_key,
    dep.department_name,
    dep.department_type;


-- ============================================================
-- 8. ANALYTICAL QUERIES
-- ============================================================


-- ============================================================
-- Query 1:
-- Total patient encounters per department
-- ============================================================

SELECT
    dep.department_key,
    dep.department_name,
    dep.department_type,

    COUNT(*) AS total_encounters,

    COUNT(DISTINCT f.patient_key)
        AS unique_patients,

    ROUND(AVG(f.wait_time_minutes), 2)
        AS average_wait_time

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_department dep
    ON f.department_key = dep.department_key

GROUP BY
    dep.department_key,
    dep.department_name,
    dep.department_type

ORDER BY total_encounters DESC;


-- ============================================================
-- Query 2:
-- Total encounters per patient
-- ============================================================

SELECT
    p.patient_key,
    p.first_name || ' ' || p.last_name
        AS patient_name,

    p.gender,
    p.insurance_type,
    p.patient_segment,

    COUNT(*) AS total_encounters,

    SUM(f.treatment_cost)
        AS total_treatment_cost

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_patient p
    ON f.patient_key = p.patient_key

GROUP BY
    p.patient_key,
    p.first_name,
    p.last_name,
    p.gender,
    p.insurance_type,
    p.patient_segment

ORDER BY total_encounters DESC;


-- ============================================================
-- Query 3:
-- Average emergency department waiting time
-- ============================================================

SELECT
    dep.department_name,

    ROUND(
        AVG(f.wait_time_minutes),
        2
    ) AS average_emergency_wait_time,

    MAX(f.wait_time_minutes)
        AS maximum_wait_time,

    COUNT(*) AS emergency_visits

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_department dep
    ON f.department_key = dep.department_key

WHERE f.encounter_type = 'Emergency'

GROUP BY dep.department_name

ORDER BY average_emergency_wait_time DESC;


-- ============================================================
-- Query 4:
-- Patient volume per date
-- ============================================================

SELECT
    d.date_key,
    d.full_date,
    d.month_name,
    d.year,

    COUNT(*) AS total_encounters,

    COUNT(DISTINCT f.patient_key)
        AS unique_patients,

    SUM(
        CASE
            WHEN f.encounter_type = 'Emergency'
            THEN 1
            ELSE 0
        END
    ) AS emergency_visits

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_date d
    ON f.date_key = d.date_key

GROUP BY
    d.date_key,
    d.full_date,
    d.month_name,
    d.year

ORDER BY d.full_date;


-- ============================================================
-- Query 5:
-- Top diagnoses by number of encounters
-- ============================================================

SELECT
    dg.diagnosis_key,
    dg.diagnosis_code,
    dg.diagnosis_name,
    dg.diagnosis_category,
    dg.severity_level,

    COUNT(*) AS encounter_count

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_diagnosis dg
    ON f.diagnosis_key = dg.diagnosis_key

GROUP BY
    dg.diagnosis_key,
    dg.diagnosis_code,
    dg.diagnosis_name,
    dg.diagnosis_category,
    dg.severity_level

ORDER BY encounter_count DESC;


-- ============================================================
-- Query 6:
-- Running total of patient encounters over time
--
-- Window Function:
-- SUM() OVER()
-- ============================================================

SELECT
    d.full_date,

    COUNT(*) AS daily_encounters,

    SUM(COUNT(*)) OVER (
        ORDER BY d.full_date
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_encounters

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_date d
    ON f.date_key = d.date_key

GROUP BY d.full_date

ORDER BY d.full_date;


-- ============================================================
-- Query 7:
-- Monthly department ranking
--
-- Window Function:
-- DENSE_RANK()
-- ============================================================

SELECT
    d.year,
    d.month_number,
    d.month_name,

    dep.department_name,

    COUNT(*) AS monthly_encounters,

    DENSE_RANK() OVER (
        PARTITION BY
            d.year,
            d.month_number

        ORDER BY COUNT(*) DESC
    ) AS department_rank

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_date d
    ON f.date_key = d.date_key

JOIN healthcare_dw.dim_department dep
    ON f.department_key = dep.department_key

GROUP BY
    d.year,
    d.month_number,
    d.month_name,
    dep.department_name

ORDER BY
    d.year,
    d.month_number,
    department_rank;


-- ============================================================
-- Query 8:
-- Top 10 diagnoses
-- ============================================================

SELECT
    dg.diagnosis_name,
    dg.diagnosis_category,

    COUNT(*) AS encounter_count,

    COUNT(
        DISTINCT f.patient_key
    ) AS unique_patients

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_diagnosis dg
    ON f.diagnosis_key = dg.diagnosis_key

GROUP BY
    dg.diagnosis_name,
    dg.diagnosis_category

ORDER BY encounter_count DESC

FETCH FIRST 10 ROWS ONLY;


-- ============================================================
-- Query 9:
-- Monthly patient volume
-- ============================================================

SELECT
    d.year,
    d.month_number,
    d.month_name,

    COUNT(*) AS monthly_encounters,

    COUNT(
        DISTINCT f.patient_key
    ) AS unique_patients,

    ROUND(
        AVG(f.wait_time_minutes),
        2
    ) AS average_wait_time,

    ROUND(
        AVG(f.length_of_stay),
        2
    ) AS average_length_of_stay

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_date d
    ON f.date_key = d.date_key

GROUP BY
    d.year,
    d.month_number,
    d.month_name

ORDER BY
    d.year,
    d.month_number;


-- ============================================================
-- Query 10:
-- Provider workload analysis
-- ============================================================

SELECT
    pr.provider_key,
    pr.provider_name,
    pr.specialty,
    pr.provider_type,

    COUNT(*) AS total_encounters,

    COUNT(
        DISTINCT f.patient_key
    ) AS unique_patients,

    ROUND(
        AVG(f.wait_time_minutes),
        2
    ) AS average_wait_time,

    SUM(f.treatment_cost)
        AS total_treatment_cost

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_provider pr
    ON f.provider_key = pr.provider_key

GROUP BY
    pr.provider_key,
    pr.provider_name,
    pr.specialty,
    pr.provider_type

ORDER BY total_encounters DESC;


-- ============================================================
-- Query 11:
-- Medication utilization
-- ============================================================

SELECT
    m.medication_key,
    m.medication_name,
    m.medication_class,

    SUM(f.quantity)
        AS total_quantity,

    COUNT(*) AS prescription_events,

    COUNT(
        DISTINCT f.patient_key
    ) AS unique_patients,

    SUM(f.medication_cost)
        AS total_medication_cost

FROM healthcare_dw.fact_medication f

JOIN healthcare_dw.dim_medication m
    ON f.medication_key = m.medication_key

GROUP BY
    m.medication_key,
    m.medication_name,
    m.medication_class

ORDER BY total_quantity DESC;


-- ============================================================
-- Query 12:
-- Medication cost by month
-- ============================================================

SELECT
    d.year,
    d.month_number,
    d.month_name,

    SUM(f.medication_cost)
        AS monthly_medication_cost,

    COUNT(*) AS medication_events,

    SUM(f.quantity)
        AS total_medication_quantity

FROM healthcare_dw.fact_medication f

JOIN healthcare_dw.dim_date d
    ON f.date_key = d.date_key

GROUP BY
    d.year,
    d.month_number,
    d.month_name

ORDER BY
    d.year,
    d.month_number;


-- ============================================================
-- Query 13:
-- Emergency vs non-emergency encounters
-- ============================================================

SELECT
    encounter_type,

    COUNT(*) AS encounter_count,

    COUNT(
        DISTINCT patient_key
    ) AS unique_patients,

    ROUND(
        AVG(wait_time_minutes),
        2
    ) AS average_wait_time,

    ROUND(
        AVG(length_of_stay),
        2
    ) AS average_length_of_stay,

    SUM(treatment_cost)
        AS total_treatment_cost

FROM healthcare_dw.fact_patient_encounter

GROUP BY encounter_type

ORDER BY encounter_count DESC;


-- ============================================================
-- Query 14:
-- Department treatment cost
-- ============================================================

SELECT
    dep.department_name,

    COUNT(*) AS total_encounters,

    SUM(f.treatment_cost)
        AS total_treatment_cost,

    ROUND(
        AVG(f.treatment_cost),
        2
    ) AS average_treatment_cost

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_department dep
    ON f.department_key = dep.department_key

GROUP BY
    dep.department_name

ORDER BY total_treatment_cost DESC;


-- ============================================================
-- Query 15:
-- High waiting-time encounters
-- ============================================================

SELECT
    f.encounter_key,

    d.full_date,

    p.first_name || ' ' || p.last_name
        AS patient_name,

    dep.department_name,

    f.encounter_type,

    f.wait_time_minutes,

    f.length_of_stay

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_date d
    ON f.date_key = d.date_key

JOIN healthcare_dw.dim_patient p
    ON f.patient_key = p.patient_key

JOIN healthcare_dw.dim_department dep
    ON f.department_key = dep.department_key

WHERE f.wait_time_minutes >= 100

ORDER BY
    f.wait_time_minutes DESC;


-- ============================================================
-- Query 16:
-- Patient segmentation based on encounter frequency
-- ============================================================

SELECT
    p.patient_key,

    p.first_name || ' ' || p.last_name
        AS patient_name,

    COUNT(*) AS encounter_count,

    SUM(f.treatment_cost)
        AS total_treatment_cost,

    CASE
        WHEN COUNT(*) >= 8
            THEN 'Frequent'

        WHEN COUNT(*) >= 4
            THEN 'Regular'

        ELSE 'Occasional'
    END AS encounter_segment

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_patient p
    ON f.patient_key = p.patient_key

GROUP BY
    p.patient_key,
    p.first_name,
    p.last_name

ORDER BY encounter_count DESC;


-- ============================================================
-- Query 17:
-- Healthcare KPI summary
-- ============================================================

SELECT

    COUNT(*) AS total_encounters,

    COUNT(
        DISTINCT patient_key
    ) AS total_unique_patients,

    SUM(
        CASE
            WHEN encounter_type = 'Emergency'
            THEN 1
            ELSE 0
        END
    ) AS emergency_visits,

    ROUND(
        AVG(wait_time_minutes),
        2
    ) AS average_waiting_time,

    ROUND(
        AVG(length_of_stay),
        2
    ) AS average_length_of_stay,

    SUM(treatment_cost)
        AS total_treatment_cost

FROM healthcare_dw.fact_patient_encounter;


-- ============================================================
-- Query 18:
-- Healthcare activity from the summary table
-- ============================================================

SELECT
    department_name,

    SUM(total_encounters)
        AS total_encounters,

    SUM(unique_patients)
        AS total_patient_visits,

    SUM(emergency_encounters)
        AS total_emergency_encounters,

    ROUND(
        AVG(average_wait_time),
        2
    ) AS avg_wait_time,

    SUM(total_treatment_cost)
        AS total_treatment_cost

FROM healthcare_dw.summary_daily_patient_activity

GROUP BY department_name

ORDER BY total_encounters DESC;


-- ============================================================
-- Query 19:
-- Monthly treatment cost trend
-- ============================================================

SELECT
    d.year,
    d.month_number,
    d.month_name,

    SUM(f.treatment_cost)
        AS monthly_treatment_cost,

    COUNT(*) AS encounter_count

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_date d
    ON f.date_key = d.date_key

GROUP BY
    d.year,
    d.month_number,
    d.month_name

ORDER BY
    d.year,
    d.month_number;


-- ============================================================
-- Query 20:
-- Most active providers by month
-- ============================================================

SELECT
    d.year,
    d.month_number,
    d.month_name,

    pr.provider_name,
    pr.specialty,

    COUNT(*) AS monthly_encounters,

    DENSE_RANK() OVER (
        PARTITION BY
            d.year,
            d.month_number

        ORDER BY COUNT(*) DESC
    ) AS provider_rank

FROM healthcare_dw.fact_patient_encounter f

JOIN healthcare_dw.dim_date d
    ON f.date_key = d.date_key

JOIN healthcare_dw.dim_provider pr
    ON f.provider_key = pr.provider_key

GROUP BY
    d.year,
    d.month_number,
    d.month_name,
    pr.provider_name,
    pr.specialty

ORDER BY
    d.year,
    d.month_number,
    provider_rank;

