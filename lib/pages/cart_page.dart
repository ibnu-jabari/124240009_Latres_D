import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/cart_service.dart';
import '../services/session_service.dart';
import '../utils/format.dart';

/// Keranjang milik user yang sedang login.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final username = SessionService.username ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      // ValueListenableBuilder membangun ulang tampilan setiap isi box Hive berubah,
      // jadi setelah item dihapus, daftar langsung ter-update.
      body: ValueListenableBuilder<Box>(
        valueListenable: CartService.listenable,
        builder: (context, box, _) {
          // Hanya item milik user yang sedang login.
          final items = CartService.itemsOf(username);

          if (items.isEmpty) {
            return const Center(child: Text('Keranjang masih kosong'));
          }

          final total = items.fold<double>(0, (sum, item) => sum + item.subtotal);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          item.thumbnail,
                          width: 56,
                          height: 56,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 40),
                        ),
                        title: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Qty: ${item.quantity} | Harga: ${formatHarga(item.price)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Hapus dari keranjang',
                          onPressed: () => CartService.remove(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatHarga(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
