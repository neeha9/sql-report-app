"""Load sql/student_demo.sql into the configured Oracle database.

Usage: python setup_test_data.py
Requires real ORACLE_* credentials in .env (see db.get_connection).
"""
import re
from pathlib import Path

from dotenv import load_dotenv

from db import get_connection

load_dotenv()

SQL_FILE = Path(__file__).parent / "sql" / "student_demo.sql"


def split_statements(script: str) -> list[str]:
    """DDL/DML only -- the sample SELECT queries at the end of the file are
    for reference and are skipped here."""
    statements = []
    for raw in re.split(r";\s*(?:\n|$)", script):
        stmt = raw.strip()
        if stmt and not stmt.startswith("--") and not stmt.upper().startswith("SELECT"):
            statements.append(stmt)
    return statements


def main():
    script = SQL_FILE.read_text()
    statements = split_statements(script)

    conn = get_connection()
    cur = conn.cursor()
    for stmt in statements:
        label = stmt.split(None, 2)[:2]
        try:
            cur.execute(stmt)
            print(f"OK   {' '.join(label)}")
        except Exception as e:
            if stmt.startswith("DROP TABLE"):
                print(f"SKIP {' '.join(label)} ({e})")
            else:
                raise
    conn.commit()
    print("Done. Tables STUDENTS and CLASS_REGISTRATIONS are populated.")


if __name__ == "__main__":
    main()
