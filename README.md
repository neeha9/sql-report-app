# SQL Report Generator

Ask a question in plain English, review the generated SQL, run it against Oracle, and export the results to Excel — built with Streamlit and the Anthropic API.

## Features

- Type a question in plain English and get back an Oracle SQL `SELECT` statement (via Claude), or write/edit SQL directly.
- Review and edit the generated SQL before running it.
- Results and SQL shown side by side; export results to Excel with one click.
- **No Oracle connection required to try it out** — if `.env` isn't configured, the app automatically falls back to a local in-memory SQLite database pre-loaded with sample student data (`students`, `class_registrations`, `student_fees`, `attendance`, `grades`).

## Setup

1. Clone the repo and create a virtual environment:
   ```bash
   git clone https://github.com/neeha9/sql-report-app.git
   cd sql-report-app
   python -m venv .venv
   .venv\Scripts\activate      # Windows
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Copy `.env.example` to `.env` and fill in your credentials:
   ```bash
   copy .env.example .env
   ```
   - `ORACLE_USER`, `ORACLE_PASSWORD`, `ORACLE_HOST`, `ORACLE_PORT`, `ORACLE_SERVICE_NAME` — your Oracle connection details.
   - `ANTHROPIC_API_KEY` — required for the "Generate SQL" (plain-English → SQL) feature.

   If you skip this step, the app still runs — it just uses local demo data instead of a real Oracle connection, and "Generate SQL" will show an error until a real `ANTHROPIC_API_KEY` is set.

4. Run the app:
   ```bash
   streamlit run app.py
   ```
   It opens at http://localhost:8501.

## Loading the sample data into a real Oracle database

`sql/student_demo.sql` has the same sample dataset (students, class registrations, fees, attendance, grades) ported to Oracle SQL. Once real Oracle credentials are in `.env`, load it with:
```bash
python setup_test_data.py
```

## Project structure

| File | Purpose |
|---|---|
| `app.py` | Streamlit UI |
| `db.py` | Database connection, schema introspection, query execution (Oracle or local SQLite demo fallback) |
| `demo_data.py` | Local SQLite demo dataset, used when Oracle isn't configured |
| `nl2sql.py` | Turns a plain-English question into SQL via the Anthropic API, plus read-only SQL validation |
| `setup_test_data.py` | Loads `sql/student_demo.sql` into a real Oracle database |
| `sql/student_demo.sql` | Oracle DDL/DML for the sample dataset, plus example report queries |
| `.streamlit/config.toml` | App theme (dark, black background, orange/yellow accents) |
