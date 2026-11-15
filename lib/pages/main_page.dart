import 'package:flutter/material.dart';

import '../services/session_service.dart';
import 'cart_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

/// Halaman utama: BottomNavigationBar dengan 2 tab (Home dan Profile).
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  AppBar _buildAppBar() {
    if (_index == 0) {
      // Tab Home: info username + tombol cart.
      return AppBar(
        title: Text('Hi, ${SessionService.username ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Keranjang',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      );
    }
    return AppBar(title: const Text('Profile'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // IndexedStack menjaga state tiap tab (daftar produk tidak dimuat ulang).
      body: IndexedStack(
        index: _index,
        children: const [HomePage(), ProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
