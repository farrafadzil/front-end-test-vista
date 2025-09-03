class Service {
  final int id;
  final int companyId;
  final String name;
  final String description;
  final double price;
  final String? companyName;

  Service({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    required this.price,
    this.companyName,

  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      companyId: json['companyId'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      companyName: json['company']?['name'],
    );
  }
}
