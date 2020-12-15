from typing import Optional, List

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session

from db.data_base import DataBase
from db.table import Table, TableColumnData, TableRowDataReceived
from db.types import Int, Char, Money, MoneyInvl, Float, Str, all_types, types_hack

_session: Optional[Session] = None
DB_URL = "postgresql://postgres:admin@localhost/it"

types_match = {
    Float.__name__: 'float',
    Char.__name__: 'Char',
    Str.__name__: 'text',
    Int.__name__: 'int',
    Money.__name__: 'text',
    MoneyInvl.__name__: 'text',
}
string_types = ['Str', 'Char']


def get_db_session():
    global _session
    global DB_URL

    if _session is None:
        sess_maker = sessionmaker()
        engine = create_engine(DB_URL)
        sess_maker.configure(bind=engine)
        _session = sess_maker()

    return _session


# saving
def save_data_base(db: DataBase):
    _init_db_schemas()

    for table in db.tables:
        _create_table_schema(table)
        _save_table_data(table)

    session = get_db_session()
    session.commit()


def save_table(table: Table):
    session = get_db_session()

    _create_table_schema(table)
    _save_table_data(table)

    session.commit()


def add_row(table, row_id):
    session = get_db_session()
    row = [row for row in table.rows if row.id == row_id][0]

    row_data = "(" + ",".join(
        [
            _get_formatted_value(row_data.value, row_data.column.value.__class__.__name__)
            for row_data in row.row_data
        ]
    ) + ")"
    session.execute(
        f"INSERT INTO {table.name} ({','.join([column.name for column in table.columns])}) VALUES {row_data};"
    )


def _init_db_schemas():
    """Table to store columns data."""
    if 'columns_data' in [table[0] for table in _get_list_of_tables()]:
        return

    session = get_db_session()
    session.execute(
        "CREATE TABLE columns_data (table_name text, column_name text, type text, min text, max text);"
    )


def _create_table_schema(table: Table):
    session = get_db_session()

    columns_data = ",".join(
        [
            f"{column.name} {types_match[column.value.__class__.__name__]}"
            for column in table.columns
        ]
    )
    session.execute(f"CREATE TABLE {table.name} ({columns_data});")

    # saving columns data to columns_data table
    columns_data_full = [
        f"""
        ('{table.name}', '{column.name}', '{column.value.__class__.__name__}',
        '{column.value.min if column.value.min else ''}', 
        '{column.value.max if column.value.max else ''}')
        """
        for column in table.columns
    ]

    session.execute(f"""
    INSERT INTO columns_data
    (table_name, column_name, type, min, max) VALUES
    {','.join(columns_data_full)}
    """)


def _save_table_data(table: Table):
    session = get_db_session()

    rows_data = ",".join(
        [
            "(" +
            ",".join(
                [
                    _get_formatted_value(row_data.value, row_data.column.value.__class__.__name__)
                    for row_data in row.row_data
                ]
            )
            + ")"
            for row in table.rows
        ]
    )

    session.execute(
        f"INSERT INTO {table.name} ({','.join([column.name for column in table.columns])}) VALUES {rows_data};"
    )


def _get_formatted_value(value, value_type) -> str:
    if value_type in string_types:
        return f"\'{value}\'" if value else "null"
    else:
        return f"{value}" if value else "null"


# loading
def load_data_base(db_name: Optional[str] = 'it') -> DataBase:
    global DB_URL
    DB_URL = '/'.join(DB_URL.split('/')[:-1]) + f'/{db_name}'
    db = DataBase(db_name)

    for table_name in _get_list_of_tables():
        table_name = table_name[0]
        if table_name == 'columns_data':
            continue
        table = _restore_table(db, table_name)
        _load_table_data(table)

    return db


def _get_list_of_tables() -> List[str]:
    session = get_db_session()

    result = session.execute("""
    SELECT table_name FROM information_schema.tables
    WHERE table_schema='public';
    """)

    return result


def _restore_table(db: DataBase, table_name: str) -> Table:
    session = get_db_session()
    result = session.execute(
        f"SELECT column_name, type, min, max FROM columns_data WHERE table_name='{table_name}'"
    )

    return db.create_table(
        table_name,
        [
            TableColumnData(
                name=column_name,
                type=all_types[type_name],
                min=int(min_value) if min_value else None,
                max=int(max_value) if max_value else None,
            )
            for column_name, type_name, min_value, max_value in result
        ]
    )


def _load_table_data(table: Table):
    session = get_db_session()

    result = session.execute(f"""
    SELECT {','.join([column.name for column in table.columns])}
    FROM {table.name};
    """)

    for row_data in result:
        table.add_row(
            [
                TableRowDataReceived(
                    column=column.name,
                    value=types_hack[column.value.__class__.__name__](data_value) if data_value else None
                )
                for column, data_value in zip(table.columns, row_data)
            ]
        )


if __name__ == '__main__':
    load_data_base()
