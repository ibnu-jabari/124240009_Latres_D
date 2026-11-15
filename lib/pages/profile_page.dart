import 'package:flutter/material.dart';

import '../services/session_service.dart';
import 'login_page.dart';

/// Tab Profile: username, deskripsi, dan tombol logout.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    // Hapus sesi. Isi keranjang di Hive TIDAK dihapus, jadi saat user yang
    // sama login lagi, keranjangnya masih ada.
    await SessionService.logout();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = SessionService.username ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 48),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 32),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Deskripsi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Deskripsi bebas, silakan ganti sesuai keinginanmu.
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Aplikasi toko online untuk latihan responsi Praktikum '
                      'Pemrograman Aplikasi Mobile. Data produk diambil dari '
                      'API dummyjson, sesi login disimpan dengan '
                      'SharedPreferences, dan keranjang belanja disimpan di '
                      'database lokal Hive.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
