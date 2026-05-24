from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    "owner": "rodrigo",
    "start_date": datetime(2026, 5, 24),
    "retries": 1,
}

with DAG(
    dag_id="deliveryops_dbt_pipeline",
    default_args=default_args,
    schedule="@daily",
    catchup=False,
    tags=["deliveryops", "dbt"],
) as dag:

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="""
        cd /opt/airflow/deliveryops_dbt &&
        dbt run
        """
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="""
        cd /opt/airflow/deliveryops_dbt &&
        dbt test
        """
    )

    dbt_docs = BashOperator(
        task_id="dbt_docs_generate",
        bash_command="""
        cd /opt/airflow/deliveryops_dbt &&
        dbt docs generate
        """
    )

    dbt_run >> dbt_test >> dbt_docs