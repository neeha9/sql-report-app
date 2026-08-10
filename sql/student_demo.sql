-- Oracle port of the student demo data (originally prototyped in SQLite).
-- Run with SQL*Plus / SQLcl, or via setup_test_data.py using this project's
-- Oracle connection (db.get_connection).

-- Drop existing objects if re-running (ignore ORA-00942 "table does not exist" on first run)
DROP TABLE grades PURGE;
DROP TABLE attendance PURGE;
DROP TABLE student_fees PURGE;
DROP TABLE class_registrations PURGE;
DROP TABLE students PURGE;

CREATE TABLE students (
    student_id      NUMBER PRIMARY KEY,
    student_number  VARCHAR2(20)  UNIQUE NOT NULL,
    first_name      VARCHAR2(50)  NOT NULL,
    last_name       VARCHAR2(50)  NOT NULL,
    cell_phone      VARCHAR2(20),
    email           VARCHAR2(100),
    parent_name     VARCHAR2(100),
    parent_phone    VARCHAR2(20),
    parent_email    VARCHAR2(100)
);

CREATE TABLE class_registrations (
    registration_id   NUMBER PRIMARY KEY,
    student_id        NUMBER NOT NULL REFERENCES students(student_id),
    class_code        VARCHAR2(20)  NOT NULL,
    class_name        VARCHAR2(100) NOT NULL,
    term              VARCHAR2(20)  NOT NULL,
    registration_date DATE NOT NULL
);

CREATE TABLE student_fees (
    fee_id      NUMBER PRIMARY KEY,
    student_id  NUMBER NOT NULL REFERENCES students(student_id),
    fee_type    VARCHAR2(30)  NOT NULL,
    amount      NUMBER(10,2)  NOT NULL,
    due_date    DATE NOT NULL,
    status      VARCHAR2(20)  NOT NULL
);

CREATE TABLE attendance (
    attendance_id   NUMBER PRIMARY KEY,
    student_id      NUMBER NOT NULL REFERENCES students(student_id),
    class_code      VARCHAR2(20) NOT NULL,
    attendance_date DATE NOT NULL,
    status          VARCHAR2(20) NOT NULL
);

CREATE TABLE grades (
    grade_id        NUMBER PRIMARY KEY,
    student_id      NUMBER NOT NULL REFERENCES students(student_id),
    class_code      VARCHAR2(20) NOT NULL,
    assessment_name VARCHAR2(30) NOT NULL,
    score           NUMBER(5,2)  NOT NULL,
    graded_date     DATE NOT NULL
);

INSERT INTO students VALUES (1, 'STU10001', 'Ava',      'Johnson',  '555-201-1001', 'ava.johnson@example.com',      'Karen Johnson',   '555-301-1001', 'karen.johnson@example.com');
INSERT INTO students VALUES (2, 'STU10002', 'Liam',     'Smith',    '555-201-1002', 'liam.smith@example.com',       'David Smith',     '555-301-1002', 'david.smith@example.com');
INSERT INTO students VALUES (3, 'STU10003', 'Sophia',   'Williams', '555-201-1003', 'sophia.williams@example.com',  'Maria Williams',  '555-301-1003', 'maria.williams@example.com');
INSERT INTO students VALUES (4, 'STU10004', 'Noah',     'Brown',    '555-201-1004', 'noah.brown@example.com',       'James Brown',     '555-301-1004', 'james.brown@example.com');
INSERT INTO students VALUES (5, 'STU10005', 'Isabella', 'Davis',    '555-201-1005', 'isabella.davis@example.com',   'Linda Davis',     '555-301-1005', 'linda.davis@example.com');
INSERT INTO students VALUES (6, 'STU10006', 'Mason',    'Miller',   '555-201-1006', 'mason.miller@example.com',     'Robert Miller',   '555-301-1006', 'robert.miller@example.com');
INSERT INTO students VALUES (7, 'STU10007', 'Mia',      'Wilson',   '555-201-1007', 'mia.wilson@example.com',       'Patricia Wilson', '555-301-1007', 'patricia.wilson@example.com');
INSERT INTO students VALUES (8, 'STU10008', 'Ethan',    'Moore',    '555-201-1008', 'ethan.moore@example.com',      'Michael Moore',   '555-301-1008', 'michael.moore@example.com');

INSERT INTO class_registrations VALUES (1,  1, 'MATH101', 'Algebra I',           'Fall 2026', DATE '2026-08-01');
INSERT INTO class_registrations VALUES (2,  1, 'ENG101',  'English Literature',  'Fall 2026', DATE '2026-08-01');
INSERT INTO class_registrations VALUES (3,  2, 'MATH101', 'Algebra I',           'Fall 2026', DATE '2026-08-01');
INSERT INTO class_registrations VALUES (4,  2, 'SCI101',  'Biology',             'Fall 2026', DATE '2026-08-02');
INSERT INTO class_registrations VALUES (5,  3, 'ENG101',  'English Literature',  'Fall 2026', DATE '2026-08-02');
INSERT INTO class_registrations VALUES (6,  3, 'HIST101', 'World History',       'Fall 2026', DATE '2026-08-02');
INSERT INTO class_registrations VALUES (7,  4, 'SCI101',  'Biology',             'Fall 2026', DATE '2026-08-03');
INSERT INTO class_registrations VALUES (8,  5, 'MATH101', 'Algebra I',           'Fall 2026', DATE '2026-08-03');
INSERT INTO class_registrations VALUES (9,  5, 'ART101',  'Studio Art',          'Fall 2026', DATE '2026-08-03');
INSERT INTO class_registrations VALUES (10, 6, 'HIST101', 'World History',       'Fall 2026', DATE '2026-08-04');
INSERT INTO class_registrations VALUES (11, 6, 'ENG101',  'English Literature',  'Fall 2026', DATE '2026-08-04');
INSERT INTO class_registrations VALUES (12, 7, 'SCI101',  'Biology',             'Fall 2026', DATE '2026-08-04');
INSERT INTO class_registrations VALUES (13, 7, 'MATH101', 'Algebra I',           'Fall 2026', DATE '2026-08-05');
INSERT INTO class_registrations VALUES (14, 8, 'ART101',  'Studio Art',          'Fall 2026', DATE '2026-08-05');
INSERT INTO class_registrations VALUES (15, 8, 'HIST101', 'World History',       'Fall 2026', DATE '2026-08-05');

INSERT INTO student_fees VALUES (1,  1, 'Tuition',      1200.00, DATE '2026-09-01', 'Paid');
INSERT INTO student_fees VALUES (2,  1, 'Activity Fee',   75.00, DATE '2026-09-01', 'Paid');
INSERT INTO student_fees VALUES (3,  2, 'Tuition',      1200.00, DATE '2026-09-01', 'Pending');
INSERT INTO student_fees VALUES (4,  2, 'Activity Fee',   75.00, DATE '2026-09-01', 'Paid');
INSERT INTO student_fees VALUES (5,  3, 'Tuition',      1200.00, DATE '2026-09-01', 'Paid');
INSERT INTO student_fees VALUES (6,  3, 'Activity Fee',   75.00, DATE '2026-09-01', 'Overdue');
INSERT INTO student_fees VALUES (7,  4, 'Tuition',      1200.00, DATE '2026-09-01', 'Overdue');
INSERT INTO student_fees VALUES (8,  4, 'Activity Fee',   75.00, DATE '2026-09-01', 'Pending');
INSERT INTO student_fees VALUES (9,  5, 'Tuition',      1200.00, DATE '2026-09-01', 'Paid');
INSERT INTO student_fees VALUES (10, 5, 'Activity Fee',   75.00, DATE '2026-09-01', 'Paid');
INSERT INTO student_fees VALUES (11, 6, 'Tuition',      1200.00, DATE '2026-09-01', 'Pending');
INSERT INTO student_fees VALUES (12, 6, 'Activity Fee',   75.00, DATE '2026-09-01', 'Paid');
INSERT INTO student_fees VALUES (13, 7, 'Tuition',      1200.00, DATE '2026-09-01', 'Paid');
INSERT INTO student_fees VALUES (14, 7, 'Activity Fee',   75.00, DATE '2026-09-01', 'Paid');
INSERT INTO student_fees VALUES (15, 8, 'Tuition',      1200.00, DATE '2026-09-01', 'Overdue');
INSERT INTO student_fees VALUES (16, 8, 'Activity Fee',   75.00, DATE '2026-09-01', 'Pending');

INSERT INTO attendance VALUES (1, 1, 'MATH101', DATE '2026-08-15', 'Present');
INSERT INTO attendance VALUES (2, 1, 'MATH101', DATE '2026-08-22', 'Absent');
INSERT INTO attendance VALUES (3, 1, 'MATH101', DATE '2026-08-29', 'Late');
INSERT INTO attendance VALUES (4, 1, 'ENG101', DATE '2026-08-15', 'Absent');
INSERT INTO attendance VALUES (5, 1, 'ENG101', DATE '2026-08-22', 'Late');
INSERT INTO attendance VALUES (6, 1, 'ENG101', DATE '2026-08-29', 'Present');
INSERT INTO attendance VALUES (7, 2, 'MATH101', DATE '2026-08-15', 'Late');
INSERT INTO attendance VALUES (8, 2, 'MATH101', DATE '2026-08-22', 'Present');
INSERT INTO attendance VALUES (9, 2, 'MATH101', DATE '2026-08-29', 'Excused');
INSERT INTO attendance VALUES (10, 2, 'SCI101', DATE '2026-08-15', 'Present');
INSERT INTO attendance VALUES (11, 2, 'SCI101', DATE '2026-08-22', 'Excused');
INSERT INTO attendance VALUES (12, 2, 'SCI101', DATE '2026-08-29', 'Present');
INSERT INTO attendance VALUES (13, 3, 'ENG101', DATE '2026-08-15', 'Excused');
INSERT INTO attendance VALUES (14, 3, 'ENG101', DATE '2026-08-22', 'Present');
INSERT INTO attendance VALUES (15, 3, 'ENG101', DATE '2026-08-29', 'Present');
INSERT INTO attendance VALUES (16, 3, 'HIST101', DATE '2026-08-15', 'Present');
INSERT INTO attendance VALUES (17, 3, 'HIST101', DATE '2026-08-22', 'Present');
INSERT INTO attendance VALUES (18, 3, 'HIST101', DATE '2026-08-29', 'Absent');
INSERT INTO attendance VALUES (19, 4, 'SCI101', DATE '2026-08-15', 'Present');
INSERT INTO attendance VALUES (20, 4, 'SCI101', DATE '2026-08-22', 'Absent');
INSERT INTO attendance VALUES (21, 4, 'SCI101', DATE '2026-08-29', 'Late');
INSERT INTO attendance VALUES (22, 5, 'MATH101', DATE '2026-08-15', 'Absent');
INSERT INTO attendance VALUES (23, 5, 'MATH101', DATE '2026-08-22', 'Late');
INSERT INTO attendance VALUES (24, 5, 'MATH101', DATE '2026-08-29', 'Present');
INSERT INTO attendance VALUES (25, 5, 'ART101', DATE '2026-08-15', 'Late');
INSERT INTO attendance VALUES (26, 5, 'ART101', DATE '2026-08-22', 'Present');
INSERT INTO attendance VALUES (27, 5, 'ART101', DATE '2026-08-29', 'Excused');
INSERT INTO attendance VALUES (28, 6, 'HIST101', DATE '2026-08-15', 'Present');
INSERT INTO attendance VALUES (29, 6, 'HIST101', DATE '2026-08-22', 'Excused');
INSERT INTO attendance VALUES (30, 6, 'HIST101', DATE '2026-08-29', 'Present');
INSERT INTO attendance VALUES (31, 6, 'ENG101', DATE '2026-08-15', 'Excused');
INSERT INTO attendance VALUES (32, 6, 'ENG101', DATE '2026-08-22', 'Present');
INSERT INTO attendance VALUES (33, 6, 'ENG101', DATE '2026-08-29', 'Present');
INSERT INTO attendance VALUES (34, 7, 'SCI101', DATE '2026-08-15', 'Present');
INSERT INTO attendance VALUES (35, 7, 'SCI101', DATE '2026-08-22', 'Present');
INSERT INTO attendance VALUES (36, 7, 'SCI101', DATE '2026-08-29', 'Absent');
INSERT INTO attendance VALUES (37, 7, 'MATH101', DATE '2026-08-15', 'Present');
INSERT INTO attendance VALUES (38, 7, 'MATH101', DATE '2026-08-22', 'Absent');
INSERT INTO attendance VALUES (39, 7, 'MATH101', DATE '2026-08-29', 'Late');
INSERT INTO attendance VALUES (40, 8, 'ART101', DATE '2026-08-15', 'Absent');
INSERT INTO attendance VALUES (41, 8, 'ART101', DATE '2026-08-22', 'Late');
INSERT INTO attendance VALUES (42, 8, 'ART101', DATE '2026-08-29', 'Present');
INSERT INTO attendance VALUES (43, 8, 'HIST101', DATE '2026-08-15', 'Late');
INSERT INTO attendance VALUES (44, 8, 'HIST101', DATE '2026-08-22', 'Present');
INSERT INTO attendance VALUES (45, 8, 'HIST101', DATE '2026-08-29', 'Excused');

INSERT INTO grades VALUES (1, 1, 'MATH101', 'Midterm', 67.0, DATE '2026-08-28');
INSERT INTO grades VALUES (2, 1, 'MATH101', 'Final', 80.0, DATE '2026-09-22');
INSERT INTO grades VALUES (3, 1, 'ENG101', 'Midterm', 74.0, DATE '2026-08-28');
INSERT INTO grades VALUES (4, 1, 'ENG101', 'Final', 87.0, DATE '2026-09-22');
INSERT INTO grades VALUES (5, 2, 'MATH101', 'Midterm', 81.0, DATE '2026-08-28');
INSERT INTO grades VALUES (6, 2, 'MATH101', 'Final', 94.0, DATE '2026-09-22');
INSERT INTO grades VALUES (7, 2, 'SCI101', 'Midterm', 88.0, DATE '2026-08-28');
INSERT INTO grades VALUES (8, 2, 'SCI101', 'Final', 61.0, DATE '2026-09-22');
INSERT INTO grades VALUES (9, 3, 'ENG101', 'Midterm', 95.0, DATE '2026-08-28');
INSERT INTO grades VALUES (10, 3, 'ENG101', 'Final', 68.0, DATE '2026-09-22');
INSERT INTO grades VALUES (11, 3, 'HIST101', 'Midterm', 62.0, DATE '2026-08-28');
INSERT INTO grades VALUES (12, 3, 'HIST101', 'Final', 75.0, DATE '2026-09-22');
INSERT INTO grades VALUES (13, 4, 'SCI101', 'Midterm', 69.0, DATE '2026-08-28');
INSERT INTO grades VALUES (14, 4, 'SCI101', 'Final', 82.0, DATE '2026-09-22');
INSERT INTO grades VALUES (15, 5, 'MATH101', 'Midterm', 76.0, DATE '2026-08-28');
INSERT INTO grades VALUES (16, 5, 'MATH101', 'Final', 89.0, DATE '2026-09-22');
INSERT INTO grades VALUES (17, 5, 'ART101', 'Midterm', 83.0, DATE '2026-08-28');
INSERT INTO grades VALUES (18, 5, 'ART101', 'Final', 96.0, DATE '2026-09-22');
INSERT INTO grades VALUES (19, 6, 'HIST101', 'Midterm', 90.0, DATE '2026-08-28');
INSERT INTO grades VALUES (20, 6, 'HIST101', 'Final', 63.0, DATE '2026-09-22');
INSERT INTO grades VALUES (21, 6, 'ENG101', 'Midterm', 97.0, DATE '2026-08-28');
INSERT INTO grades VALUES (22, 6, 'ENG101', 'Final', 70.0, DATE '2026-09-22');
INSERT INTO grades VALUES (23, 7, 'SCI101', 'Midterm', 64.0, DATE '2026-08-28');
INSERT INTO grades VALUES (24, 7, 'SCI101', 'Final', 77.0, DATE '2026-09-22');
INSERT INTO grades VALUES (25, 7, 'MATH101', 'Midterm', 71.0, DATE '2026-08-28');
INSERT INTO grades VALUES (26, 7, 'MATH101', 'Final', 84.0, DATE '2026-09-22');
INSERT INTO grades VALUES (27, 8, 'ART101', 'Midterm', 78.0, DATE '2026-08-28');
INSERT INTO grades VALUES (28, 8, 'ART101', 'Final', 91.0, DATE '2026-09-22');
INSERT INTO grades VALUES (29, 8, 'HIST101', 'Midterm', 85.0, DATE '2026-08-28');
INSERT INTO grades VALUES (30, 8, 'HIST101', 'Final', 98.0, DATE '2026-09-22');

COMMIT;

-- Sample report queries --------------------------------------------------

-- All students
SELECT student_number, first_name, last_name, cell_phone, email, parent_name, parent_phone
FROM students
ORDER BY student_number;

-- All class registrations
SELECT registration_id, student_id, class_code, class_name, term, registration_date
FROM class_registrations
ORDER BY registration_id;

-- Students joined to their registered classes
SELECT s.student_number,
       s.first_name || ' ' || s.last_name AS student_name,
       cr.class_code,
       cr.class_name,
       cr.term
FROM students s
JOIN class_registrations cr ON cr.student_id = s.student_id
ORDER BY s.student_number, cr.class_code;

-- Class roster with parent contact info (MATH101)
SELECT cr.class_code,
       cr.class_name,
       s.first_name || ' ' || s.last_name AS student_name,
       s.parent_name,
       s.parent_phone
FROM class_registrations cr
JOIN students s ON s.student_id = cr.student_id
WHERE cr.class_code = 'MATH101'
ORDER BY s.last_name;

-- Enrollment count per class
SELECT cr.class_code, cr.class_name, COUNT(*) AS num_students
FROM class_registrations cr
GROUP BY cr.class_code, cr.class_name
ORDER BY num_students DESC;

-- Complex: students + their classes + fee balance, joining all three tables.
-- Pre-aggregates each side in a CTE first so the class-registration fan-out
-- doesn't inflate the fee SUM (a plain 3-way JOIN would double-count fees
-- once per class a student is registered for).
WITH class_summary AS (
    SELECT student_id,
           LISTAGG(class_code, ', ') WITHIN GROUP (ORDER BY class_code) AS classes_registered,
           COUNT(*) AS num_classes
    FROM class_registrations
    GROUP BY student_id
),
fee_summary AS (
    SELECT student_id,
           SUM(amount) AS total_fees,
           SUM(CASE WHEN status IN ('Pending', 'Overdue') THEN amount ELSE 0 END) AS amount_due,
           SUM(CASE WHEN status = 'Overdue' THEN 1 ELSE 0 END) AS overdue_fee_count
    FROM student_fees
    GROUP BY student_id
)
SELECT s.student_number,
       s.first_name || ' ' || s.last_name AS student_name,
       s.parent_name,
       s.parent_phone,
       cs.classes_registered,
       cs.num_classes,
       fs.total_fees,
       fs.amount_due,
       fs.overdue_fee_count
FROM students s
JOIN class_summary cs ON cs.student_id = s.student_id
JOIN fee_summary fs ON fs.student_id = s.student_id
WHERE fs.amount_due > 0
ORDER BY fs.amount_due DESC;

-- More complex: per-class roster with window functions. For every class,
-- ranks enrolled students by outstanding balance, compares each student to
-- their class's average balance, and flags students who are overdue AND
-- enrolled in more than one class as "High Risk". Window functions can't be
-- filtered in the same SELECT's WHERE clause, so the windowed columns are
-- computed in the "roster" CTE and filtered in the outer query.
WITH fee_summary AS (
    SELECT student_id,
           SUM(amount) AS total_fees,
           SUM(CASE WHEN status IN ('Pending', 'Overdue') THEN amount ELSE 0 END) AS amount_due,
           MAX(CASE WHEN status = 'Overdue' THEN 1 ELSE 0 END) AS has_overdue
    FROM student_fees
    GROUP BY student_id
),
class_counts AS (
    SELECT student_id, COUNT(*) AS num_classes
    FROM class_registrations
    GROUP BY student_id
),
roster AS (
    SELECT cr.class_code,
           cr.class_name,
           s.student_number,
           s.first_name || ' ' || s.last_name AS student_name,
           fs.amount_due,
           fs.has_overdue,
           cc.num_classes,
           RANK() OVER (PARTITION BY cr.class_code ORDER BY fs.amount_due DESC) AS balance_rank_in_class,
           ROUND(AVG(fs.amount_due) OVER (PARTITION BY cr.class_code), 2) AS class_avg_amount_due,
           CASE
               WHEN fs.has_overdue = 1 AND cc.num_classes > 1 THEN 'High Risk'
               WHEN fs.has_overdue = 1 THEN 'Overdue'
               WHEN fs.amount_due > 0 THEN 'Pending'
               ELSE 'Current'
           END AS risk_flag
    FROM class_registrations cr
    JOIN students s ON s.student_id = cr.student_id
    JOIN fee_summary fs ON fs.student_id = cr.student_id
    JOIN class_counts cc ON cc.student_id = cr.student_id
)
SELECT class_code, class_name, student_number, student_name,
       amount_due, class_avg_amount_due, balance_rank_in_class,
       num_classes, risk_flag
FROM roster
WHERE amount_due > class_avg_amount_due
   OR risk_flag = 'High Risk'
ORDER BY class_code, balance_rank_in_class;

-- Most complex: full student report joining all five tables (students,
-- class_registrations, grades, attendance, student_fees). Per student/class,
-- combines average grade, attendance rate, and outstanding balance into a
-- single risk status, plus ranks students within each class by grade.
WITH grade_summary AS (
    SELECT student_id, class_code, AVG(score) AS avg_score
    FROM grades
    GROUP BY student_id, class_code
),
attendance_summary AS (
    SELECT student_id, class_code,
           ROUND(100.0 * SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attendance_rate
    FROM attendance
    GROUP BY student_id, class_code
),
fee_summary AS (
    SELECT student_id,
           SUM(CASE WHEN status IN ('Pending', 'Overdue') THEN amount ELSE 0 END) AS amount_due,
           MAX(CASE WHEN status = 'Overdue' THEN 1 ELSE 0 END) AS has_overdue
    FROM student_fees
    GROUP BY student_id
)
SELECT s.student_number,
       s.first_name || ' ' || s.last_name AS student_name,
       cr.class_code,
       gs.avg_score,
       ats.attendance_rate,
       fs.amount_due,
       CASE
           WHEN gs.avg_score < 70 AND ats.attendance_rate < 50 THEN 'Academic + Attendance Risk'
           WHEN gs.avg_score < 70 THEN 'Academic Risk'
           WHEN ats.attendance_rate < 50 THEN 'Attendance Risk'
           WHEN fs.has_overdue = 1 THEN 'Financial Risk'
           ELSE 'On Track'
       END AS status,
       RANK() OVER (PARTITION BY cr.class_code ORDER BY gs.avg_score DESC) AS class_grade_rank
FROM class_registrations cr
JOIN students s ON s.student_id = cr.student_id
JOIN grade_summary gs ON gs.student_id = cr.student_id AND gs.class_code = cr.class_code
JOIN attendance_summary ats ON ats.student_id = cr.student_id AND ats.class_code = cr.class_code
JOIN fee_summary fs ON fs.student_id = cr.student_id
ORDER BY cr.class_code, class_grade_rank;

-- Self-join variant: compares each student's Midterm vs. Final score per
-- class (grades joined to itself once per assessment), alongside attendance
-- rate and fee status. No WITH -- attendance/fee aggregates are inline
-- derived-table subqueries instead.
SELECT s.student_number,
       s.first_name || ' ' || s.last_name AS student_name,
       cr.class_code,
       gm.score AS midterm_score,
       gf.score AS final_score,
       gf.score - gm.score AS improvement,
       ats.attendance_rate,
       CASE WHEN fs.has_overdue = 1 THEN 'Overdue' ELSE 'Current' END AS fee_status
FROM class_registrations cr
JOIN students s ON s.student_id = cr.student_id
JOIN grades gm ON gm.student_id = cr.student_id AND gm.class_code = cr.class_code AND gm.assessment_name = 'Midterm'
JOIN grades gf ON gf.student_id = cr.student_id AND gf.class_code = cr.class_code AND gf.assessment_name = 'Final'
JOIN (
    SELECT student_id, class_code,
           ROUND(100.0 * SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attendance_rate
    FROM attendance
    GROUP BY student_id, class_code
) ats ON ats.student_id = cr.student_id AND ats.class_code = cr.class_code
JOIN (
    SELECT student_id, MAX(CASE WHEN status = 'Overdue' THEN 1 ELSE 0 END) AS has_overdue
    FROM student_fees
    GROUP BY student_id
) fs ON fs.student_id = cr.student_id
ORDER BY improvement DESC;
