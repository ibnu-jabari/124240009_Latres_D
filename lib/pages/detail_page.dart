import 'package:flutter/material.dart';

import 'package:latres_prak_mobile/models/product.dart';
import 'package:latres_prak_mobile/services/cart_service.dart';
import 'package:latres_prak_mobile/services/session_service.dart';
import 'package:latres_prak_mobile/utils/format.dart';

/// Detail produk: semua informasi + pilih jumlah + tombol Add to Cart.
class DetailPage extends StatefulWidget {
  final Product product;

  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _qty = 1; // jumlah yang dipilih, harus 0 < qty <= stok

  Product get _p => widget.product;

  void _kurang() {
    if (_qty > 1) {
      setState(() => _qty--);
    }
  }

  void _tambah() {
    if (_qty < _p.stock) {
      setState(() => _qty++);
    }
  }

  Future<void> _tambahKeKeranjang() async {
    final username = SessionService.username ?? '';

    // Simpan: produk + user yang menekan + quantity ke Hive.
    final total = await CartService.add(
      username: username,
      product: _p,
      quantity: _qty,
    );
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${_p.title} masuk keranjang (total di keranjang: $total)',
          ),
          backgroundColor: Colors.green,
        ),
      );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gambar = _p.images.isNotEmpty ? _p.images : [_p.thumbnail];

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gambar produk (geser ke samping kalau lebih dari satu)
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final url in gambar)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.network(
                      url,
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                        width: 220,
                        child: Icon(Icons.image_not_supported, size: 48),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _p.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                formatHarga(_p.price),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Text('(diskon ${_p.discountPercentage}%)'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text('${_p.rating} | Stok: ${_p.stock}'),
            ],
          ),
          const Divider(height: 24),
          const Text(
            'Deskripsi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(_p.description),
          const Divider(height: 24),
          _info('Brand', _p.brand ?? '-'),
          _info('Kategori', _p.category),
          _info('SKU', _p.sku),
          _info('Berat', '${_p.weight}'),
          _info('Dimensi', _p.dimensions),
          _info('Ketersediaan', _p.availabilityStatus),
          _info('Garansi', _p.warrantyInformation),
          _info('Pengiriman', _p.shippingInformation),
          _info('Kebijakan retur', _p.returnPolicy),
          _info('Min. order', '${_p.minimumOrderQuantity}'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: [
              for (final tag in _p.tags)
                Chip(
                  label: Text(tag),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const Divider(height: 24),
          const Text(
            'Ulasan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          for (final review in _p.reviews)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Text('${review.rating}')),
              title: Text(review.reviewerName),
              subtitle: Text(review.comment),
            ),
        ],
      ),
      // Pemilih jumlah + tombol Add to Cart
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: _p.stock <= 0
              ? const Text(
                  'Stok habis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Row(
                  children: [
                    IconButton(
                      onPressed: _qty > 1 ? _kurang : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$_qty',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _qty < _p.stock ? _tambah : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _tambahKeKeranjang,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
