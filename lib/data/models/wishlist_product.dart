class WishlistProduct {
  final int id;
  final List<dynamic> variations;
  final bool inWishlist;
  final double avgRating;
  final List<String> images;
  final bool variationExists;
  final int salePrice;
  final String name;
  final String description;
  final String caption;
  final String featuredImage;
  final int mrp;
  final int stock;
  final bool isActive;
  final String discount;
  final String createdDate;
  final String productType;
  final dynamic showingOrder;
  final String variationName;
  final int category;
  final int taxRate;

  WishlistProduct({
    required this.id,
    required this.variations,
    required this.inWishlist,
    required this.avgRating,
    required this.images,
    required this.variationExists,
    required this.salePrice,
    required this.name,
    required this.description,
    required this.caption,
    required this.featuredImage,
    required this.mrp,
    required this.stock,
    required this.isActive,
    required this.discount,
    required this.createdDate,
    required this.productType,
    required this.showingOrder,
    required this.variationName,
    required this.category,
    required this.taxRate,
  });

  factory WishlistProduct.fromJson(Map<String, dynamic> json) {
    return WishlistProduct(
      id: json['id'],
      variations: json['variations'] ?? [],
      inWishlist: json['in_wishlist'] ?? false,
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      variationExists: json['variation_exists'] ?? false,
      salePrice: json['sale_price'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      caption: json['caption'] ?? '',
      featuredImage: json['featured_image'] ?? '',
      mrp: json['mrp'] ?? 0,
      stock: json['stock'] ?? 0,
      isActive: json['is_active'] ?? false,
      discount: json['discount'] ?? '0.00',
      createdDate: json['created_date'] ?? '',
      productType: json['product_type'] ?? '',
      showingOrder: json['showing_order'],
      variationName: json['variation_name'] ?? '',
      category: json['category'] ?? 0,
      taxRate: json['tax_rate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variations': variations,
      'in_wishlist': inWishlist,
      'avg_rating': avgRating,
      'images': images,
      'variation_exists': variationExists,
      'sale_price': salePrice,
      'name': name,
      'description': description,
      'caption': caption,
      'featured_image': featuredImage,
      'mrp': mrp,
      'stock': stock,
      'is_active': isActive,
      'discount': discount,
      'created_date': createdDate,
      'product_type': productType,
      'showing_order': showingOrder,
      'variation_name': variationName,
      'category': category,
      'tax_rate': taxRate,
    };
  }
}
