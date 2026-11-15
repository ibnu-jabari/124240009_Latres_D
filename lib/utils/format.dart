/// Contoh: 9.99 -> "$9.99"
String formatHarga(double nilai) {
  return '\$${nilai.toStringAsFixed(2)}';
}
