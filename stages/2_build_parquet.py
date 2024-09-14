import sqlite3
from pathlib import Path
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, when, lit
from pyspark.sql.types import DecimalType
import logging

logging.basicConfig(filename='log.txt', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


def handle_high_precision_decimals(df):
    for column in df.columns:
        if isinstance(df.schema[column].dataType, DecimalType):
            decimal_type = df.schema[column].dataType
            if decimal_type.precision > 38:
                print(f"Column {column} has precision {decimal_type.precision}, casting to string")
                df = df.withColumn(column, 
                    when(col(column).isNotNull(), 
                         col(column).cast("string")).otherwise(lit(None)))
    return df

brkdir = Path("brick")
sqlite_path = next(brkdir.glob("chembl_*.db"), None)

# Download SQLite JDBC driver if not present
jdbc_driver_path = Path("sqlite-jdbc.jar")
if not jdbc_driver_path.exists():
    import urllib.request
    print("Downloading SQLite JDBC driver...")
    urllib.request.urlretrieve(
        "https://github.com/xerial/sqlite-jdbc/releases/download/3.42.0.0/sqlite-jdbc-3.42.0.0.jar",
        jdbc_driver_path
    )

# Initialize Spark session with increased memory and SQLite JDBC driver
spark = (SparkSession.builder
         .appName("ChEMBL_to_Parquet")
         .config("spark.driver.memory", "8g")
         .config("spark.executor.memory", "8g")
         .config("spark.memory.offHeap.enabled", "true")
         .config("spark.memory.offHeap.size", "8g")
         .config("spark.driver.extraClassPath", str(jdbc_driver_path))
         .config("spark.executor.extraClassPath", str(jdbc_driver_path))
         .getOrCreate())

# Build parquet tables
conn = sqlite3.connect(brkdir / sqlite_path.name)
cursor = conn.cursor()
tables = cursor.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()


for (table_name,) in tables:
    try:
        logging.info(f"Writing {table_name} ...")
        tblp = brkdir / f"{table_name}.parquet"
        
        # Read SQLite table into Spark DataFrame
        df = spark.read.format("jdbc").options(
            url=f"jdbc:sqlite:{brkdir / sqlite_path.name}",
            dbtable=table_name,
            driver="org.sqlite.JDBC",
            fetchsize="10000"  # Adjust this value as needed
        ).load()
        
        # Handle high precision decimals
        df = handle_high_precision_decimals(df)
        
        # Write DataFrame to Parquet
        df.write.mode("overwrite").parquet(str(tblp))
        
        logging.info(f"Wrote {table_name} to {tblp}")
    except Exception as e:
        error_message = f"Error processing table {table_name}: {str(e)}"
        logging.error(error_message)
        continue

conn.close()
spark.stop()