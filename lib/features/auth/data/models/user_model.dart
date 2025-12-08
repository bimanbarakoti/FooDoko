// lib/features/auth/data/models/user_model.dart
class UserModel {
  final String id;
  final String phone;
  final String? name;
  final String? avatarUrl;

  UserModel({required this.id, required this.phone, this.name, this.avatarUrl});

  factory UserModel.empty() => UserModel(id: '', phone: '', name: null, avatarUrl: null);
}
