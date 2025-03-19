class Package {
  final int id;
  final String name;
  final double price;
  final String description;
  final List<String> servicesIncluded;
  final String expirationDate;
  final String subscriptionPlan;
  final String createdAt;
  final String updatedAt;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.servicesIncluded,
    required this.expirationDate,
    required this.subscriptionPlan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
  return Package(
    id: json['id'],
    name: json['name'],
    price: (json['price'] is String) 
        ? double.parse(json['price']) 
        : json['price'].toDouble(),  // Fix for mixed types
    description: json['description'],
    servicesIncluded: List<String>.from(json['services_included']),
    expirationDate: json['expiration_date'],
    subscriptionPlan: json['subscription_plan'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price.toString(),
      'description': description,
      'services_included': servicesIncluded,
      'expiration_date': expirationDate,
      'subscription_plan': subscriptionPlan,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PackagesResponse {
  final List<Package> packages;

  PackagesResponse({required this.packages});

  factory PackagesResponse.fromJson(Map<String, dynamic> json) {
    return PackagesResponse(
      packages: (json as List).map((package) => Package.fromJson(package)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packages': packages.map((package) => package.toJson()).toList(),
    };
  }
}
