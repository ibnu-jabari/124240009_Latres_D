import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:latres_prak_mobile/models/product.dart';
import 'package:latres_prak_mobile/utils/constants.dart';

/// Mengambil data produk dari API eksternal.
class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse(kProductsUrl))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat produk (kode ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['products'] as List<dynamic>;

    return list
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
