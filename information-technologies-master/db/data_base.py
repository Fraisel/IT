from typing import List, Dict, Any, Optional
import json

from db.table import Table, TableRow, TableRowData, TableColumnData, TableRowDataReceived
from db.types import all_types
from library.exceptions import TableCreationError, DataBaseCreationError, TableJoinError


def singleton_generator():
    instances = {}

    def singleton_decorator(class_):
        def get_instance(*args, **kwargs):
            if args[0] not in instances:
                instances[args[0]] = class_(*args, **kwargs)
                return instances[args[0]]
            else:
                raise DataBaseCreationError(args[0], 'db already exists')

        return get_instance

    singleton_decorator.all = instances
    return singleton_decorator


singleton = singleton_generator()


@singleton
class DataBase:
    def __init__(self, name: str):
        self.name = name
        self.tables: List[Table] = []

    def create_table(self, name: str, columns: List[TableColumnData] = None) -> Table:
        if name in [t.name for t in self.tables]:
            raise TableCreationError(name, "table already exists")

        self.tables.append(Table(name, columns))

        return self.tables[-1]

    def get_table(self, table_name: str) -> Optional[Table]:
        for table in self.tables:
            if table.name == table_name:
                return table
        return None

    def delete_table(self, name: str) -> bool:
        table = [t for t in self.tables if t.name == name]

        if len(table) == 1:
            self.tables.remove(table[0])
            return True

        return False

    def save(self):
        with open(self.name + '.json', 'w') as file:
            tables_data = {table.name: self._prepare_table_data(table) for table in self.tables}
            data = {
                'database_name': self.name,
                'tables': tables_data,
            }
            json.dump(data, file, indent=4)

    def _prepare_table_data(self, table: Table) -> Dict[str, Any]:
        data = {
            "columns": {
                column.name: {
                    "type": column.value.__class__.__name__,
                    "min": column.value.min,
                    "max": column.value.max,
                }
                for column in table.columns
            },
            "rows": [
                {
                    row_data.column.name: row_data.value
                    for row_data in row.row_data
                }
                for row in table.rows
            ]
        }

        return data

    def join(self, table1_name: str, table2_name: str, column_name: str) -> List:
        table1 = self.get_table(table1_name)
        table2 = self.get_table(table2_name)

        joined_data = []

        if not (column_name in table1.columns.__members__ and column_name in table2.columns.__members__):
            raise TableJoinError(table1.name, table2.name, column_name)

        for rows1 in table1.rows:
            for rows2 in table2.rows:
                if next((r.value for r in rows1.row_data if r.column.name == column_name)) == next(
                        (r.value for r in rows2.row_data if r.column.name == column_name)):
                    joined_data.append(
                        TableRow(
                            id=len(joined_data),
                            row_data=[data for data in rows1.row_data + rows2.row_data]
                        )
                    )

        return joined_data


def load_db(file_name: str) -> DataBase:
    with open(file_name, 'r') as file:
        data = json.load(file)
        db = DataBase(data["database_name"])

        for table_name in data["tables"]:
            table_data = data["tables"][table_name]
            db.create_table(
                table_name,
                [
                    TableColumnData(
                        column_name,
                        all_types[column_data["type"]],
                        column_data["min"],
                        column_data["max"]
                    )
                    for column_name, column_data in table_data["columns"].items()
                ]
            )
            for row in table_data["rows"]:
                db.tables[-1].add_row([TableRowDataReceived(data, row[data]) for data in row])
    return db
