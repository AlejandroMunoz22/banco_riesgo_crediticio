import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
from tqdm import tqdm

# 1. Lee automáticamente las credenciales de tu archivo .env
load_dotenv()

USER = os.getenv("DB_USER")
PASSWORD = os.getenv("DB_PASSWORD")
SERVER = os.getenv("DB_SERVER")
PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")

connection_url = f"mssql+pymssql://{USER}:{PASSWORD}@{SERVER}:{PORT}/{DB_NAME}"
engine = create_engine(connection_url)

def cargar_csv_a_sql(ruta_csv: str, nombre_tabla: str, chunksize: int = 50000):
    print(f"\n Cargando {ruta_csv} hacia SQL Server (dbo.{nombre_tabla})...")
    
    for i, chunk in enumerate(tqdm(pd.read_csv(ruta_csv, chunksize=chunksize, low_memory=False))):
        modo = "replace" if i == 0 else "append"
        chunk.to_sql(
            name=nombre_tabla,
            con=engine,
            schema="dbo",
            if_exists=modo,
            index=False
        )
    print(f"Tabla dbo.{nombre_tabla} lista en SQL Server")

if __name__ == "__main__":
        archivos_a_cargar = {
        "data/raw/application_train.csv": "application_train",
        "data/raw/application_test.csv": "application_test",
        "data/raw/bureau.csv": "bureau",
        "data/raw/bureau_balance.csv": "bureau_balance",
        "data/raw/previous_application.csv": "previous_application",
        "data/raw/POS_CASH_balance.csv": "POS_CASH_balance",
        "data/raw/installments_payments.csv": "installments_payments",
        "data/raw/credit_card_balance.csv": "credit_card_balance"
    }

for ruta, tabla in archivos_a_cargar.items():
    try:
        cargar_csv_a_sql(ruta, tabla)
    except Exception as e:
        print(f"Error cargando {tabla}: {e}")