import os
import sqlite3

import oracledb
import pandas as pd

from demo_data import build_demo_connection

_PLACEHOLDER_PREFIX = "your_"


def is_demo_mode() -> bool:
    """True when Oracle isn't configured (still has .env.example placeholders)."""
    required = ("ORACLE_USER", "ORACLE_PASSWORD", "ORACLE_HOST", "ORACLE_SERVICE_NAME")
    return any(
        not os.environ.get(var) or os.environ[var].startswith(_PLACEHOLDER_PREFIX)
        for var in required
    )


def get_connection():
    if is_demo_mode():
        return build_demo_connection()

    dsn = oracledb.makedsn(
        os.environ["ORACLE_HOST"],
        int(os.environ.get("ORACLE_PORT", 1521)),
        service_name=os.environ["ORACLE_SERVICE_NAME"],
    )
    return oracledb.connect(
        user=os.environ["ORACLE_USER"],
        password=os.environ["ORACLE_PASSWORD"],
        dsn=dsn,
    )


def get_schema_context(conn, max_tables=50, max_cols_per_table=40):
    """Build a text description of available tables/columns for the given
    schema, to give the LLM enough context to write valid SQL."""
    if isinstance(conn, sqlite3.Connection):
        return _sqlite_schema_context(conn)

    schema = os.environ.get("ORACLE_SCHEMA", os.environ["ORACLE_USER"]).upper()

    query = """
        SELECT table_name, column_name, data_type
        FROM all_tab_columns
        WHERE owner = :owner
        ORDER BY table_name, column_id
    """
    df = pd.read_sql(query, conn, params={"owner": schema})

    if df.empty:
        return f"-- No tables found for schema {schema}"

    lines = []
    for table_name, group in list(df.groupby("TABLE_NAME"))[:max_tables]:
        cols = [
            f"{row.COLUMN_NAME} {row.DATA_TYPE}"
            for row in group.head(max_cols_per_table).itertuples()
        ]
        lines.append(f"{table_name}(" + ", ".join(cols) + ")")

    return f"Schema: {schema}\nTables:\n" + "\n".join(lines)


def _sqlite_schema_context(conn):
    tables = [
        row[0]
        for row in conn.execute(
            "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
        )
    ]
    lines = []
    for table in tables:
        cols = [row[1] for row in conn.execute(f"PRAGMA table_info({table})")]
        lines.append(f"{table}(" + ", ".join(cols) + ")")
    return "Schema: DEMO (local SQLite)\nTables:\n" + "\n".join(lines)


def run_query(conn, sql, max_rows=10000):
    return pd.read_sql(sql, conn, dtype_backend="numpy_nullable").head(max_rows)
