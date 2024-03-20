class ClinicModel {
  final String id;
  final String name;
  final String detail;
  final String phone;
  final String lat;
  final String lon;
  final String? imageUrl;

  const ClinicModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.phone,
    required this.lat,
    required this.lon,
    this.imageUrl,
  });
}
