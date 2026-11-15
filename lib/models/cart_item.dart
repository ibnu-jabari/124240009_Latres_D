/// Satu baris di keranjang: milik siapa (username), produk apa, dan jumlahnya.
/// Objek ini diubah menjadi Map supaya bisa disimpan di Hive.
class CartItem {
  final String username;
  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  final int quantity;
  final int stock;

  const CartItem({
    required this.username,
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
    required this.stock,
  });

  /// Kunci unik di Hive: gabungan username dan id produk.
  /// Dengan begitu produk yang sama milik user berbeda disimpan terpisah.
  static String keyFor(String username, int productId) => '$username|$productId';

  String get key => keyFor(username, productId);

  double get subtotal => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'productId': productId,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
      'quantity': quantity,
      'stock': stock,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      username: map['username'] as String,
      productId: map['productId'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      thumbnail: map['thumbnail'] as String,
      quantity: map['quantity'] as int,
      stock: map['stock'] as int,
    );
  }
}
