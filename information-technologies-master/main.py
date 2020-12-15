from db.data_base import DataBase, load_db as load_data_base
from db.types import Int, Str, Float, Money, MoneyInvl
from db.table import TableColumnData, TableRowDataReceived


def create_and_save_db():
    db = DataBase('a')
    table = db.create_table(
        'test',
        [
            TableColumnData('c1', Int),
            TableColumnData('c2', Str),
            TableColumnData('c3', Money),
            TableColumnData('c4', MoneyInvl, 3, 5),
        ]
    )
    table.add_row(
        [TableRowDataReceived('c1', 5), TableRowDataReceived('c2', 'test_file'), TableRowDataReceived('c3', '$3.00'),
         TableRowDataReceived('c4', '$4')])
    table.add_row([TableRowDataReceived('c2', 'ef')])

    print(table.rows)

    table.update_row(0, [TableRowDataReceived('c1', 6)])

    table2 = db.create_table('test_2', [TableColumnData('name', Str), TableColumnData('height', Float)])
    table2.add_row([TableRowDataReceived('name', 'Alex'), TableRowDataReceived('height', 24.3)])

    db.save()

    print(table.rows)

    table = db.create_table(
        'test_3',
        [
            TableColumnData('c1', Int),
            TableColumnData('c5', Str),
            TableColumnData('c6', MoneyInvl, 1, 5),
        ]
    )
    table.add_row([TableRowDataReceived('c1', 6), TableRowDataReceived('c5', 'ADADADAD')])
    table.add_row([TableRowDataReceived('c1', 2), TableRowDataReceived('c5', 'ef')])

    print('___________________________')
    print(db.join('test', 'test_3', 'c1'))


def load_db():
    db = load_data_base('a.json')
    print(db.tables)
    print([x for x in db.tables[-1].columns])
    print(db.tables[1].rows)
    print(db.tables[0].rows)


if __name__ == '__main__':
    create_and_save_db()
    # load_db()
