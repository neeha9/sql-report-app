"""Local SQLite stand-in for Oracle, used when ORACLE_* env vars aren't
configured yet. Mirrors sql/student_demo.sql so the app is usable without a
live Oracle connection."""
import sqlite3

_STUDENTS = [
    (1, "STU10001", "Ava",      "Johnson",  "555-201-1001", "ava.johnson@example.com",      "Karen Johnson",   "555-301-1001", "karen.johnson@example.com"),
    (2, "STU10002", "Liam",     "Smith",    "555-201-1002", "liam.smith@example.com",       "David Smith",     "555-301-1002", "david.smith@example.com"),
    (3, "STU10003", "Sophia",   "Williams", "555-201-1003", "sophia.williams@example.com",  "Maria Williams",  "555-301-1003", "maria.williams@example.com"),
    (4, "STU10004", "Noah",     "Brown",    "555-201-1004", "noah.brown@example.com",       "James Brown",     "555-301-1004", "james.brown@example.com"),
    (5, "STU10005", "Isabella", "Davis",    "555-201-1005", "isabella.davis@example.com",   "Linda Davis",     "555-301-1005", "linda.davis@example.com"),
    (6, "STU10006", "Mason",    "Miller",   "555-201-1006", "mason.miller@example.com",     "Robert Miller",   "555-301-1006", "robert.miller@example.com"),
    (7, "STU10007", "Mia",      "Wilson",   "555-201-1007", "mia.wilson@example.com",       "Patricia Wilson", "555-301-1007", "patricia.wilson@example.com"),
    (8, "STU10008", "Ethan",    "Moore",    "555-201-1008", "ethan.moore@example.com",      "Michael Moore",   "555-301-1008", "michael.moore@example.com"),
]

_REGISTRATIONS = [
    (1, 1, "MATH101", "Algebra I",           "Fall 2026", "2026-08-01"),
    (2, 1, "ENG101",  "English Literature",  "Fall 2026", "2026-08-01"),
    (3, 2, "MATH101", "Algebra I",           "Fall 2026", "2026-08-01"),
    (4, 2, "SCI101",  "Biology",             "Fall 2026", "2026-08-02"),
    (5, 3, "ENG101",  "English Literature",  "Fall 2026", "2026-08-02"),
    (6, 3, "HIST101", "World History",       "Fall 2026", "2026-08-02"),
    (7, 4, "SCI101",  "Biology",             "Fall 2026", "2026-08-03"),
    (8, 5, "MATH101", "Algebra I",           "Fall 2026", "2026-08-03"),
    (9, 5, "ART101",  "Studio Art",          "Fall 2026", "2026-08-03"),
    (10, 6, "HIST101", "World History",      "Fall 2026", "2026-08-04"),
    (11, 6, "ENG101",  "English Literature", "Fall 2026", "2026-08-04"),
    (12, 7, "SCI101",  "Biology",            "Fall 2026", "2026-08-04"),
    (13, 7, "MATH101", "Algebra I",          "Fall 2026", "2026-08-05"),
    (14, 8, "ART101",  "Studio Art",         "Fall 2026", "2026-08-05"),
    (15, 8, "HIST101", "World History",      "Fall 2026", "2026-08-05"),
]

_FEES = [
    (1,  1, "Tuition",      1200.00, "2026-09-01", "Paid"),
    (2,  1, "Activity Fee",   75.00, "2026-09-01", "Paid"),
    (3,  2, "Tuition",      1200.00, "2026-09-01", "Pending"),
    (4,  2, "Activity Fee",   75.00, "2026-09-01", "Paid"),
    (5,  3, "Tuition",      1200.00, "2026-09-01", "Paid"),
    (6,  3, "Activity Fee",   75.00, "2026-09-01", "Overdue"),
    (7,  4, "Tuition",      1200.00, "2026-09-01", "Overdue"),
    (8,  4, "Activity Fee",   75.00, "2026-09-01", "Pending"),
    (9,  5, "Tuition",      1200.00, "2026-09-01", "Paid"),
    (10, 5, "Activity Fee",   75.00, "2026-09-01", "Paid"),
    (11, 6, "Tuition",      1200.00, "2026-09-01", "Pending"),
    (12, 6, "Activity Fee",   75.00, "2026-09-01", "Paid"),
    (13, 7, "Tuition",      1200.00, "2026-09-01", "Paid"),
    (14, 7, "Activity Fee",   75.00, "2026-09-01", "Paid"),
    (15, 8, "Tuition",      1200.00, "2026-09-01", "Overdue"),
    (16, 8, "Activity Fee",   75.00, "2026-09-01", "Pending"),
]

_ATTENDANCE = [
    (1, 1, "MATH101", "2026-08-15", "Present"),
    (2, 1, "MATH101", "2026-08-22", "Absent"),
    (3, 1, "MATH101", "2026-08-29", "Late"),
    (4, 1, "ENG101", "2026-08-15", "Absent"),
    (5, 1, "ENG101", "2026-08-22", "Late"),
    (6, 1, "ENG101", "2026-08-29", "Present"),
    (7, 2, "MATH101", "2026-08-15", "Late"),
    (8, 2, "MATH101", "2026-08-22", "Present"),
    (9, 2, "MATH101", "2026-08-29", "Excused"),
    (10, 2, "SCI101", "2026-08-15", "Present"),
    (11, 2, "SCI101", "2026-08-22", "Excused"),
    (12, 2, "SCI101", "2026-08-29", "Present"),
    (13, 3, "ENG101", "2026-08-15", "Excused"),
    (14, 3, "ENG101", "2026-08-22", "Present"),
    (15, 3, "ENG101", "2026-08-29", "Present"),
    (16, 3, "HIST101", "2026-08-15", "Present"),
    (17, 3, "HIST101", "2026-08-22", "Present"),
    (18, 3, "HIST101", "2026-08-29", "Absent"),
    (19, 4, "SCI101", "2026-08-15", "Present"),
    (20, 4, "SCI101", "2026-08-22", "Absent"),
    (21, 4, "SCI101", "2026-08-29", "Late"),
    (22, 5, "MATH101", "2026-08-15", "Absent"),
    (23, 5, "MATH101", "2026-08-22", "Late"),
    (24, 5, "MATH101", "2026-08-29", "Present"),
    (25, 5, "ART101", "2026-08-15", "Late"),
    (26, 5, "ART101", "2026-08-22", "Present"),
    (27, 5, "ART101", "2026-08-29", "Excused"),
    (28, 6, "HIST101", "2026-08-15", "Present"),
    (29, 6, "HIST101", "2026-08-22", "Excused"),
    (30, 6, "HIST101", "2026-08-29", "Present"),
    (31, 6, "ENG101", "2026-08-15", "Excused"),
    (32, 6, "ENG101", "2026-08-22", "Present"),
    (33, 6, "ENG101", "2026-08-29", "Present"),
    (34, 7, "SCI101", "2026-08-15", "Present"),
    (35, 7, "SCI101", "2026-08-22", "Present"),
    (36, 7, "SCI101", "2026-08-29", "Absent"),
    (37, 7, "MATH101", "2026-08-15", "Present"),
    (38, 7, "MATH101", "2026-08-22", "Absent"),
    (39, 7, "MATH101", "2026-08-29", "Late"),
    (40, 8, "ART101", "2026-08-15", "Absent"),
    (41, 8, "ART101", "2026-08-22", "Late"),
    (42, 8, "ART101", "2026-08-29", "Present"),
    (43, 8, "HIST101", "2026-08-15", "Late"),
    (44, 8, "HIST101", "2026-08-22", "Present"),
    (45, 8, "HIST101", "2026-08-29", "Excused"),
]

_GRADES = [
    (1, 1, "MATH101", "Midterm", 67.0, "2026-08-28"),
    (2, 1, "MATH101", "Final", 80.0, "2026-09-22"),
    (3, 1, "ENG101", "Midterm", 74.0, "2026-08-28"),
    (4, 1, "ENG101", "Final", 87.0, "2026-09-22"),
    (5, 2, "MATH101", "Midterm", 81.0, "2026-08-28"),
    (6, 2, "MATH101", "Final", 94.0, "2026-09-22"),
    (7, 2, "SCI101", "Midterm", 88.0, "2026-08-28"),
    (8, 2, "SCI101", "Final", 61.0, "2026-09-22"),
    (9, 3, "ENG101", "Midterm", 95.0, "2026-08-28"),
    (10, 3, "ENG101", "Final", 68.0, "2026-09-22"),
    (11, 3, "HIST101", "Midterm", 62.0, "2026-08-28"),
    (12, 3, "HIST101", "Final", 75.0, "2026-09-22"),
    (13, 4, "SCI101", "Midterm", 69.0, "2026-08-28"),
    (14, 4, "SCI101", "Final", 82.0, "2026-09-22"),
    (15, 5, "MATH101", "Midterm", 76.0, "2026-08-28"),
    (16, 5, "MATH101", "Final", 89.0, "2026-09-22"),
    (17, 5, "ART101", "Midterm", 83.0, "2026-08-28"),
    (18, 5, "ART101", "Final", 96.0, "2026-09-22"),
    (19, 6, "HIST101", "Midterm", 90.0, "2026-08-28"),
    (20, 6, "HIST101", "Final", 63.0, "2026-09-22"),
    (21, 6, "ENG101", "Midterm", 97.0, "2026-08-28"),
    (22, 6, "ENG101", "Final", 70.0, "2026-09-22"),
    (23, 7, "SCI101", "Midterm", 64.0, "2026-08-28"),
    (24, 7, "SCI101", "Final", 77.0, "2026-09-22"),
    (25, 7, "MATH101", "Midterm", 71.0, "2026-08-28"),
    (26, 7, "MATH101", "Final", 84.0, "2026-09-22"),
    (27, 8, "ART101", "Midterm", 78.0, "2026-08-28"),
    (28, 8, "ART101", "Final", 91.0, "2026-09-22"),
    (29, 8, "HIST101", "Midterm", 85.0, "2026-08-28"),
    (30, 8, "HIST101", "Final", 98.0, "2026-09-22"),
]


def build_demo_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(":memory:", check_same_thread=False)
    conn.executescript("""
        CREATE TABLE students (
            student_id      INTEGER PRIMARY KEY,
            student_number  TEXT UNIQUE NOT NULL,
            first_name      TEXT NOT NULL,
            last_name       TEXT NOT NULL,
            cell_phone      TEXT,
            email           TEXT,
            parent_name     TEXT,
            parent_phone    TEXT,
            parent_email    TEXT
        );

        CREATE TABLE class_registrations (
            registration_id   INTEGER PRIMARY KEY,
            student_id        INTEGER NOT NULL REFERENCES students(student_id),
            class_code        TEXT NOT NULL,
            class_name        TEXT NOT NULL,
            term              TEXT NOT NULL,
            registration_date TEXT NOT NULL
        );

        CREATE TABLE student_fees (
            fee_id      INTEGER PRIMARY KEY,
            student_id  INTEGER NOT NULL REFERENCES students(student_id),
            fee_type    TEXT NOT NULL,
            amount      REAL NOT NULL,
            due_date    TEXT NOT NULL,
            status      TEXT NOT NULL
        );

        CREATE TABLE attendance (
            attendance_id   INTEGER PRIMARY KEY,
            student_id      INTEGER NOT NULL REFERENCES students(student_id),
            class_code      TEXT NOT NULL,
            attendance_date TEXT NOT NULL,
            status          TEXT NOT NULL
        );

        CREATE TABLE grades (
            grade_id        INTEGER PRIMARY KEY,
            student_id      INTEGER NOT NULL REFERENCES students(student_id),
            class_code      TEXT NOT NULL,
            assessment_name TEXT NOT NULL,
            score           REAL NOT NULL,
            graded_date     TEXT NOT NULL
        );
    """)
    conn.executemany("INSERT INTO students VALUES (?,?,?,?,?,?,?,?,?)", _STUDENTS)
    conn.executemany("INSERT INTO class_registrations VALUES (?,?,?,?,?,?)", _REGISTRATIONS)
    conn.executemany("INSERT INTO student_fees VALUES (?,?,?,?,?,?)", _FEES)
    conn.executemany("INSERT INTO attendance VALUES (?,?,?,?,?)", _ATTENDANCE)
    conn.executemany("INSERT INTO grades VALUES (?,?,?,?,?,?)", _GRADES)
    conn.commit()
    return conn
