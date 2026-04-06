# 🏥 Hospital Management System

A database-driven Hospital Management System built with **MySQL** and a **Python GUI**, designed to automate and streamline core hospital operations — from patient registration to billing and reporting.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [SQL Features](#sql-features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Limitations](#limitations)
- [Future Work](#future-work)

---

## Overview

Manual hospital management is error-prone, slow, and hard to scale. This project implements a centralized relational database system to manage:

- Patient records
- Doctor and department details
- Appointment scheduling
- Treatment tracking
- Billing and payments
- Analytics and reports

The system integrates a **SQL backend** with a **GUI frontend**, enabling real-time data management with minimal manual effort.

---

## Features

| Module | Description |
|---|---|
| 👤 Patient Management | Register, update, search, and delete patient records |
| 🩺 Doctor Management | Manage doctors linked to departments |
| 📅 Appointment Booking | Schedule appointments with transactional safety |
| 💊 Treatment Recording | Log diagnoses, treatment details, and costs |
| 💳 Billing System | Auto-generate and track bills by payment status |
| 📊 Reports Dashboard | View revenue, pending bills, and appointment summaries |

---

## Database Schema

The system uses **6 core tables** and **1 audit table**:

```
Department ──< Doctor ──< Appointment >── Patient
                               │                │
                           Treatment ──────────┘
                               │
                           Billing ───────────┘
                    Appointment_Audit (trigger-populated)
```

### Tables

| Table | Key Columns |
|---|---|
| `Department` | `dept_id`, `dept_name` |
| `Doctor` | `doctor_id`, `name`, `specialization`, `phone`, `dept_id` |
| `Patient` | `patient_id`, `name`, `age`, `gender`, `phone`, `address` |
| `Appointment` | `appointment_id`, `patient_id`, `doctor_id`, `appt_date`, `appt_time`, `status` |
| `Treatment` | `treatment_id`, `patient_id`, `doctor_id`, `diagnosis`, `cost` |
| `Billing` | `bill_id`, `patient_id`, `total_amount`, `payment_status`, `bill_date` |
| `Appointment_Audit` | `audit_id`, `appointment_id`, `patient_id`, `cancelled_at` |

---

## SQL Features

### ⚙️ Stored Procedures
- `sp_add_patient` — Insert a new patient
- `sp_book_appointment` — Book an appointment atomically (with billing)
- `sp_patient_report` — Generate a full report for a given patient

### 🔁 Triggers
- `trg_update_bill_on_treatment` — Auto-updates the billing total when a treatment is added
- `trg_block_delete_completed` — Prevents deletion of completed appointments
- `trg_log_cancellation` — Logs cancelled appointments to the audit table

### 👁️ Views
- `vw_patient_appointments` — Full appointment history per patient with doctor and department info
- `vw_pending_bills` — All pending or partial bills with patient details

### 🔒 Transactions
- Appointment booking and billing creation are wrapped in a single atomic transaction with rollback on failure

### 🔍 Advanced Queries
- Patients with no appointments (using `NOT IN` subquery)
- Doctors ranked by appointment count
- Department-wise revenue from treatments
- Patients treated by a specific department (nested subquery)
- Patients with outstanding bills over ₹500

---

## Getting Started

### Prerequisites

- MySQL 8.0+
- Python 3.x (for GUI)
- A MySQL client (MySQL Workbench, DBeaver, or CLI)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/hospital-management-system.git
   cd hospital-management-system
   ```

2. **Run the SQL script** to create and populate the database
   ```bash
   mysql -u root -p < hospital_management_system.sql
   ```

3. **Launch the GUI** (if applicable)
   ```bash
   python main.py
   ```

### Quick Test

After importing the SQL file, verify everything is working:

```sql
USE HospitalDB;

-- Check all patients
SELECT * FROM Patient;

-- View appointment history
SELECT * FROM vw_patient_appointments;

-- Check pending bills
SELECT * FROM vw_pending_bills;

-- Run a patient report
CALL sp_patient_report(1);
```

---

## Usage

### Book an Appointment via Stored Procedure
```sql
CALL sp_book_appointment(1, 2, '2025-08-01', '10:00:00');
```
This atomically inserts the appointment and a corresponding pending bill.

### Add a New Patient
```sql
CALL sp_add_patient('Aryan Shah', 29, 'Male', '9000011111', 'Bandra, Mumbai');
```

### Check Department-wise Revenue
```sql
SELECT dp.dept_name, SUM(t.cost) AS dept_revenue
FROM Treatment t
JOIN Doctor d ON t.doctor_id = d.doctor_id
JOIN Department dp ON d.dept_id = dp.dept_id
GROUP BY dp.dept_name;
```

---

## Project Structure

```
hospital-management-system/
│
├── hospital_management_system.sql   # Full DB schema, data, procedures, triggers, views
├── main.py                          # GUI entry point
├── README.md
└── screenshots/
    └── dashboard.png
```

---

## Limitations

- Not optimized for very large hospital networks
- Basic GUI with limited UX polish
- No user authentication or role-based access control

---

## Future Work

- 🔐 Add login system with role-based access (Admin, Doctor, Receptionist)
- 🌐 Build a web-based version using Flask or Django
- 📈 Advanced analytics dashboard with charts and KPIs
- 🔗 Integration with real hospital systems and HL7/FHIR standards

---
