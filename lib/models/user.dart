import 'package:equatable/equatable.dart';

enum UserRole {
  farmer('agricultor'),
  buyer('comprador');

  final String displayName;
  const UserRole(this.displayName);
}

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final UserRole role;
  final String? imageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.role,
    this.imageUrl,
  });

  bool get isFarmer => role == UserRole.farmer;
  bool get isBuyer => role == UserRole.buyer;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.buyer,
      ),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role.name,
      'imageUrl': imageUrl,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    UserRole? role,
    String? imageUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, address, role, imageUrl];
}