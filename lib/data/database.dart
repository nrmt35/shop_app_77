import 'package:sqflite/sqflite.dart';

import 'responses.dart';

class DB {
  final Future<Database> _db;

  static const basketTable = 'meals';

  DB() : _db = _open();

  static Future<Database> _open() {
    return openDatabase(
      basketTable,
      version: 1,
      onCreate: (
        db,
        version,
      ) async {
        // basket
        await db.execute('CREATE TABLE IF NOT EXISTS $basketTable ( '
            'id INTEGER, '
            'name TEXT, '
            'price REAL, '
            'weight INTEGER, '
            'description TEXT, '
            'image_url TEXT, '
            'quantity INTEGER)');
      },
    );
  }

  Future<void> addToBasket({
    required int id,
    required String name,
    required double price,
    required int weight,
    required String description,
    required String imageUrl,
    int quantity = 1,
  }) async {
    final db = await _db;

    final item = await find(id);

    if (item != null) {
      await db.rawUpdate(
        'UPDATE $basketTable SET '
        'quantity = quantity + ? '
        'WHERE id = ?',
        [
          quantity,
          item.id,
        ],
      );
    } else {
      await db.insert(basketTable, {
        'id': id,
        'name': name,
        'price': price,
        'weight': weight,
        'description': description,
        'image_url': imageUrl,
        'quantity': 1,
      });
    }
  }

  Future<void> removeFromBasket(int id) async {
    final db = await _db;

    await db.rawQuery('DELETE FROM $basketTable WHERE id = ?', [id]);
  }

  Future<void> clearBasket() async {
    final db = await _db;

    await db.rawQuery('DELETE FROM $basketTable');
  }

  Future<List<Dish>> basketItems() async {
    final db = await _db;

    final items = await db.rawQuery('SELECT * FROM $basketTable');

    // print(items);

    return items.map(Dish.fromJson).toList();
  }

  Future<Dish?> find(int id) async {
    final items = await basketItems();

    for (final item in items) {
      bool matches = true;

      if (item.id != id) matches = false;

      if (matches) return item;
    }

    return null;
  }

  Future<void> updateQuantityInBasket(int id, int quantity) async {
    final db = await _db;

    await db.rawUpdate(
      'UPDATE $basketTable SET quantity = quantity + ? WHERE id = ?',
      [quantity, id],
    );
  }
}
