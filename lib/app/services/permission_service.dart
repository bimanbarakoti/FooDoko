// lib/app/services/permission_service.dart
class PermissionService {
  PermissionService._();
  static Future<bool> requestLocationPermission() async {
    // In real app use permission_handler
    return true;
  }
}
