import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/session_service.dart';
import 'utils/constants.dart';

Future<void> main() async {
  // Wajib kalau main() memakai async sebelum runApp().
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // siapkan Hive
  await Hive.openBox(kCartBox); // buka box keranjang
  await SessionService.init(); // siapkan SharedPreferences

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      // Sudah login? langsung ke halaman utama. Belum? ke halaman login.
      home: SessionService.isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}