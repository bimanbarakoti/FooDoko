// Address model
class AddressModel {
  final String id;
  final String label; // Home, Work, Custom
  final String address;
  final double lat;
  final double lng;

  AddressModel({
    required this.id,
    required this.label,
    required this.address,
    required this.lat,
    required this.lng,
  });

  AddressModel copyWith({
    String? id,
    String? label,
    String? address,
    double? lat,
    double? lng,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}
