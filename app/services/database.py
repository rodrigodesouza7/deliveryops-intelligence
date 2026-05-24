import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

def get_engine():
    database_url = os.getenv("DATABASE_URL")

    if not database_url:
        raise ValueError("DATABASE_URL não encontrada no arquivo .env")

    return create_engine(database_url)


def load_table(query: str) -> pd.DataFrame:
    engine = get_engine()

    with engine.connect() as connection:
        return pd.read_sql(query, connection)