/// User model representing a user in the system
class UserModel {
  /// Creates a new user instance
  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  /// User's unique identifier
  final String id;

  /// User's email address
  final String email;

  /// User's username
  final String username;

  /// User's first name
  final String firstName;

  /// User's last name
  final String lastName;

  /// User's phone number (optional)
  final String? phoneNumber;

  /// URL to user's profile image (optional)
  final String? profileImageUrl;

  /// Whether the user account is active
  final bool isActive;

  /// When the user was created
  final DateTime? createdAt;

  /// When the user was last updated
  final DateTime? updatedAt;

  /// User's full name
  String get fullName => '$firstName $lastName';

  /// User's display name (username or full name)
  String get displayName => username.isNotEmpty ? username : fullName;

  /// Creates a copy of this user with the given fields replaced
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
    username: username ?? this.username,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Creates a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    username: json['username'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    phoneNumber: json['phone_number'] as String?,
    profileImageUrl: json['profile_image_url'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : null,
  );

  /// Converts this UserModel to a JSON map
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'first_name': firstName,
    'last_name': lastName,
    'phone_number': phoneNumber,
    'profile_image_url': profileImageUrl,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.username == username;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ username.hashCode;

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, username: $username, '
      'firstName: $firstName, lastName: $lastName)';
}
