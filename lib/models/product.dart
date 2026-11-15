/// Satu ulasan (review) pada produk.
class Review {
  final int rating;
  final String comment;
  final String reviewerName;

  const Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      reviewerName: json['reviewerName'] as String? ?? '-',
    );
  }
}

/// Model produk, mengikuti bentuk JSON dari https://dummyjson.com/products
class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand; // bisa kosong (mis. produk groceries)
  final String sku;
  final double weight;
  final String dimensions; // gabungan lebar x tinggi x kedalaman
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final List<Review> reviews;
  final List<String> images;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.reviews,
    required this.images,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final dim = json['dimensions'] as Map<String, dynamic>?;
    final dimensions = dim == null
        ? '-'
        : '${dim['width']} x ${dim['height']} x ${dim['depth']}';

    return Product(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      brand: json['brand'] as String?,
      sku: json['sku'] as String? ?? '-',
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      dimensions: dimensions,
      warrantyInformation: json['warrantyInformation'] as String? ?? '-',
      shippingInformation: json['shippingInformation'] as String? ?? '-',
      availabilityStatus: json['availabilityStatus'] as String? ?? '-',
      returnPolicy: json['returnPolicy'] as String? ?? '-',
      minimumOrderQuantity: (json['minimumOrderQuantity'] as num?)?.toInt() ?? 1,
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }
}
