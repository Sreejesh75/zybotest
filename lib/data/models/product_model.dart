class Product {
  final int id;
  final String name;
  final String? description;
  final String? caption;
  final String? featuredImage;
  final List<String> images;
  final int salePrice;
  final int mrp;
  final int stock;
  final bool isActive;
  final String discount;
  final String productType;
  final String? variationName;
  final int? category;
  final int? taxRate;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.caption,
    this.featuredImage,
    required this.images,
    required this.salePrice,
    required this.mrp,
    required this.stock,
    required this.isActive,
    required this.discount,
    required this.productType,
    this.variationName,
    this.category,
    this.taxRate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      caption: json['caption'],
      featuredImage: json['featured_image'],
      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      salePrice: json['sale_price'] is int
          ? json['sale_price']
          : int.tryParse(json['sale_price'].toString()) ?? 0,
      mrp: json['mrp'] is int
          ? json['mrp']
          : int.tryParse(json['mrp'].toString()) ?? 0,
      stock: json['stock'] is int
          ? json['stock']
          : int.tryParse(json['stock'].toString()) ?? 0,
      isActive: json['is_active'] ?? false,
      discount: json['discount']?.toString() ?? '0',
      productType: json['product_type']?.toString() ?? '',
      variationName: json['variation_name']?.toString(),
      category: json['category'] is int
          ? json['category']
          : int.tryParse(json['category']?.toString() ?? ''),
      taxRate: json['tax_rate'] is int
          ? json['tax_rate']
          : int.tryParse(json['tax_rate']?.toString() ?? ''),
    );
  }
}
