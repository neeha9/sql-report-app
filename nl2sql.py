import os
import re

from anthropic import Anthropic

MODEL = "claude-sonnet-5"

_BLOCKED_KEYWORDS = (
    "INSERT", "UPDATE", "DELETE", "MERGE", "DROP", "ALTER", "TRUNCATE",
    "CREATE", "GRANT", "REVOKE", "EXEC", "EXECUTE", "CALL",
)

SYSTEM_PROMPT = """You are an expert Oracle SQL analyst. Given a database \
schema and a plain-English question, write a single read-only Oracle SQL \
SELECT statement that answers it.

Rules:
- Output ONLY the SQL query, no explanation, no markdown code fences.
- The query must be a single SELECT (or WITH ... SELECT) statement.
- Never use INSERT, UPDATE, DELETE, MERGE, DROP, ALTER, TRUNCATE, CREATE, \
GRANT, REVOKE, EXEC, or CALL.
- Use only tables/columns that appear in the provided schema.
- Use Oracle SQL syntax (e.g. FETCH FIRST n ROWS ONLY instead of LIMIT).
"""


def generate_sql(question: str, schema_context: str) -> str:
    client = Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])
    response = client.messages.create(
        model=MODEL,
        max_tokens=1024,
        system=SYSTEM_PROMPT,
        messages=[
            {
                "role": "user",
                "content": f"Schema:\n{schema_context}\n\nQuestion: {question}",
            }
        ],
    )
    sql = response.content[0].text.strip()
    return _strip_code_fence(sql)


def _strip_code_fence(sql: str) -> str:
    match = re.match(r"^```(?:sql)?\s*(.*?)\s*```$", sql, re.DOTALL | re.IGNORECASE)
    return match.group(1).strip() if match else sql


def validate_sql(sql: str) -> str | None:
    """Returns an error message if the query looks unsafe, else None."""
    cleaned = sql.strip().rstrip(";")

    if not re.match(r"^(SELECT|WITH)\b", cleaned, re.IGNORECASE):
        return "Only SELECT (or WITH ... SELECT) statements are allowed."

    if ";" in cleaned:
        return "Multiple statements are not allowed."

    for keyword in _BLOCKED_KEYWORDS:
        if re.search(rf"\b{keyword}\b", cleaned, re.IGNORECASE):
            return f"Query contains a blocked keyword: {keyword}"

    return None
