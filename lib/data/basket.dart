import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'responses.dart';

class BasketStateNotifier extends StateNotifier<BasketState> {
  final DB db;

  BasketStateNotifier(this.db) : super(BasketState([]));

  Future<void> addToBasket({
    required int id,
    required String name,
    required double price,
    required int weight,
    required String description,
    required String imageUrl,
    int quantity = 1,
  }) async {
    await db.addToBasket(
      id: id,
      name: name,
      price: price,
      weight: weight,
      description: description,
      imageUrl: imageUrl,
      quantity: quantity,
    );

    await reloadBasket();
  }

  Future<void> updateQuantity({required int id, int quantity = 1}) async {
    await db.updateQuantityInBasket(id, quantity);

    await reloadBasket();
  }

  Future<void> removeFromBasket({required int id}) async {
    await db.removeFromBasket(id);

    await reloadBasket();
  }

  Future<void> clearBasket() async {
    await db.clearBasket();

    await reloadBasket();
  }

  Future<void> reloadBasket() async {
    final items = await db.basketItems();
    state = BasketState(items);
    if (kDebugMode) {
      print(items.length);
    }
  }
}

class BasketState {
  List<Dish> basketProducts = [];

  BasketState(this.basketProducts);

  int? getQuantity(int id) {
    try {
      final item = basketProducts.firstWhere(
        (item) => item.id == id,
      );

      return item.quantity;
    } catch (_) {
      return 0;
    }
  }

  int itemCount() {
    int sum = 0;
    for (final item in basketProducts) {
      sum += item.quantity ?? 1;
    }
    return sum;
  }

  double totalCost() {
    double sum = 0.0;
    for (final item in basketProducts) {
      sum += double.parse(item.price.toString()) * item.quantity!;
    }
    return double.parse(sum.toString());
  }
}
