// lib/app/services/location_service.dart
class LocationService {
  LocationService._();
  static Future<Map<String,double>> getCurrentLatLng() async {
    // mock coordinates (Kathmandu)
    return {'lat': 27.7172, 'lng': 85.3240};
  }
}
