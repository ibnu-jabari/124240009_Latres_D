import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../utils/constants.dart';

/// Mengelola keranjang di database lokal Hive.
/// Semua user disimpan di satu box; tiap item punya field username,
/// jadi saat ditampilkan kita filter berdasarkan user yang sedang login.
class CartService {
  static Box get _box => Hive.box(kCartBox);

  /// Dipakai ValueListenableBuilder supaya tampilan ikut berubah
  /// saat isi box berubah (tambah / hapus item).
  static ValueListenable<Box> get listenable => _box.listenable();

  /// Semua item milik [username].
  static List<CartItem> itemsOf(String username) {
    return _box.values
        .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e as Map)))
        .where((item) => item.username == username)
        .toList();
  }

  /// Menambah produk ke keranjang. Kalau produk sudah ada, jumlahnya
  /// ditambah (maksimal sebanyak stok). Mengembalikan jumlah akhir.
  static Future<int> add({
    required String username,
    required Product product,
    required int quantity,
  }) async {
    final key = CartItem.keyFor(username, product.id);
    var total = quantity;

    final existing = _box.get(key);
    if (existing != null) {
      final lama = CartItem.fromMap(Map<String, dynamic>.from(existing as Map));
      total += lama.quantity;
    }
    if (total > product.stock) total = product.stock;

    final item = CartItem(
      username: username,
      productId: product.id,
      title: product.title,
      price: product.price,
      thumbnail: product.thumbnail,
      quantity: total,
      stock: product.stock,
    );
    await _box.put(item.key, item.toMap());
    return total;
  }

  /// Menghapus satu item dari keranjang.
  static Future<void> remove(CartItem item) async {
    await _box.delete(item.key);
  }
}
