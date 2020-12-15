from dataclasses import dataclass, field
from enum import Enum
from typing import List, Type, Dict, Any, Optional

from db.types import BaseColumnType, all_types


@dataclass
class TableColumnData:
    """For table columns creation."""
    name: str
    type: Type[BaseColumnType]  # Type - check parent's class (should be the same)
    min: Optional[Any] = field(default=None)
    max: Optional[Any] = field(default=None)


@dataclass
class TableRowDataReceived:
    """For data insertion."""
    column: str
    value: Any


@dataclass
class TableRow:
    id: int
    row_data: List["TableRowData"]


@dataclass
class TableRowData:
    column: Any  # not any, this should be table column type but set it here will be a bit difficult
    value: Any


class Table:
    def __init__(self, name: str, columns: List[TableColumnData]):
        self.name = name
        self.columns = Enum(
            'TableColumns',
            {
                column.name: column.type(column.min, column.max)
                for column in columns
            }
        )
        self.rows: List[TableRow] = []

    def add_row(self, row_data: List[TableRowDataReceived]):
        serialized_data = {}
        for data in row_data:
            getattr(self.columns, data.column).value.validate(data.value)  # calling column type validation
            serialized_data[data.column] = data.value

        self.rows.append(  # adding a new row with id and list of structure like column: value but in class terms
            TableRow(
                id=len(self.rows),
                row_data=[
                    TableRowData(
                        column=column,
                        value=serialized_data[column.name] if column.name in serialized_data else None
                    )
                    for column in self.columns
                ]
            )
        )

    def update_row(self, row_id: int, row_data: List[TableRowDataReceived]):
        """Update row by it's id."""
        if row_id not in [row.id for row in self.rows]:
            raise ValueError('no such row')

        serialized_data = {}
        for data in row_data:
            getattr(self.columns, data.column).value.validate(data.value)
            serialized_data[data.column] = data.value

        row_data = self.rows[row_id].row_data
        for row_column_data in row_data:
            if row_column_data.column.name in serialized_data:
                row_column_data.value = serialized_data[row_column_data.column.name]

    def delete_row(self, row_id: int):
        index = None
        for i, row in enumerate(self.rows):
            if row.id == row_id:
                index = i
        if index is not None:
            self.rows.pop(index)
