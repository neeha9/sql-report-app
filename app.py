import io

import pandas as pd
import streamlit as st
from dotenv import load_dotenv

from db import get_connection, get_schema_context, is_demo_mode, run_query
from nl2sql import generate_sql, validate_sql

load_dotenv()

st.set_page_config(page_title="SQL Report Generator", layout="wide")

st.markdown(
    """
    <style>
    h1 {
        background: linear-gradient(90deg, #ff8c00, #ffd60a);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        font-weight: 800;
    }
    h2, h3 {
        color: #ffb703 !important;
    }
    .stButton > button, .stDownloadButton > button {
        background: linear-gradient(90deg, #ff8c00, #ffd60a);
        color: #111111;
        font-weight: 700;
        border: none;
        border-radius: 8px;
        padding: 0.5em 1.3em;
        transition: transform 0.15s ease, box-shadow 0.15s ease;
    }
    .stButton > button:hover, .stDownloadButton > button:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 16px rgba(255, 140, 0, 0.55);
        color: #000000;
    }
    .stButton > button:disabled {
        background: #333333;
        color: #777777;
    }
    </style>
    """,
    unsafe_allow_html=True,
)

st.title("SQL Report Generator")
st.caption("Ask a question in plain English, review the generated SQL, run it, and export the results to Excel.")

if "sql" not in st.session_state:
    st.session_state.sql = ""
if "results" not in st.session_state:
    st.session_state.results = None


@st.cache_resource(show_spinner=False)
def _connection():
    return get_connection()


@st.cache_data(show_spinner=False, ttl=3600)
def _schema_context():
    return get_schema_context(_connection())


with st.sidebar:
    st.subheader("Connection")
    try:
        _connection()
        if is_demo_mode():
            st.warning("Oracle isn't configured in .env — using local demo data (students / class_registrations).")
        else:
            st.success("Connected to Oracle")
    except Exception as e:
        st.error(f"Connection failed: {e}")
        st.stop()

question = st.text_input("Ask a question about your data", placeholder="e.g. Show total sales by region for the last quarter")

col1, col2 = st.columns([1, 1])
generate_clicked = col1.button("Generate SQL", type="primary", disabled=not question)
clear_clicked = col2.button("Clear")

if clear_clicked:
    st.session_state.sql = ""
    st.session_state.results = None
    st.rerun()

if generate_clicked:
    with st.spinner("Generating SQL..."):
        try:
            schema_context = _schema_context()
            st.session_state.sql = generate_sql(question, schema_context)
            st.session_state.results = None
        except Exception as e:
            st.error(f"Failed to generate SQL: {e}")

sql_col, results_col = st.columns([1, 1])

with sql_col:
    st.subheader("SQL")
    st.session_state.sql = st.text_area(
        "Review and edit the query before running it, or type your own SQL directly",
        value=st.session_state.sql,
        height=300,
        placeholder="e.g. SELECT * FROM students",
        label_visibility="collapsed",
    )

    run_clicked = st.button("Run query", disabled=not st.session_state.sql.strip())

    if run_clicked:
        error = validate_sql(st.session_state.sql)
        if error:
            st.error(error)
        else:
            with st.spinner("Running query..."):
                try:
                    st.session_state.results = run_query(_connection(), st.session_state.sql)
                except Exception as e:
                    st.error(f"Query failed: {e}")
                    st.session_state.results = None

with results_col:
    st.subheader("Results")
    if st.session_state.results is not None:
        df = st.session_state.results
        st.caption(f"{len(df)} rows")
        st.dataframe(df, use_container_width=True)

        buffer = io.BytesIO()
        with pd.ExcelWriter(buffer, engine="openpyxl") as writer:
            df.to_excel(writer, index=False, sheet_name="Report")
        buffer.seek(0)

        st.download_button(
            "Download as Excel",
            data=buffer,
            file_name="report.xlsx",
            mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        )
    else:
        st.info("Run a query to see results here.")
