class Branch {
  const Branch({
    required this.id,
    required this.name,
    required this.regionId,
    required this.isActive,
    this.address,
    this.phone,
  });

  final int id;
  final String name;
  final int regionId;
  final String? address;
  final String? phone;
  final bool isActive;

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      regionId: (json['regionId'] as num).toInt(),
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}
