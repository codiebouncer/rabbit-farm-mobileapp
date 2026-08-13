import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String userId;
  final String email;
  final String role;
  final int farmId;
  final String farmName;

  const AuthUser({
    required this.userId,
    required this.email,
    required this.role,
    required this.farmId,
    required this.farmName,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final userId = json['userId'];
    final email = json['email'];
    final role = json['role'];
    final farmId = json['farmId'];
    final farmName = json['farmName'];
    if (userId is! String ||
        email is! String ||
        role is! String ||
        farmId is! num ||
        farmName is! String) {
      throw const FormatException('Invalid authenticated user');
    }
    return AuthUser(
      userId: userId,
      email: email,
      role: role,
      farmId: farmId.toInt(),
      farmName: farmName,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'role': role,
    'farmId': farmId,
    'farmName': farmName,
  };

  @override
  List<Object?> get props => [userId, email, role, farmId, farmName];
}
