class Country {
  const Country({
    required this.id,
    required this.name,
    required this.isoCode,
    required this.currencyCode,
    this.phoneCode,
  });

  final int id;
  final String name;
  final String isoCode;
  final String currencyCode;
  final String? phoneCode;

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int,
      name: json['name'] as String,
      isoCode: json['iso_code'] as String,
      currencyCode: json['currency_code'] as String,
      phoneCode: json['phone_code'] as String?,
    );
  }
}
