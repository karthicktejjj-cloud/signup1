/// Clean domain model representing authenticated user session.
/// Keeps contract simple and ready for real backend DTO mapping.
class UserSession {
  final String id;
  final String email;
  final String? displayName;
  final DateTime? expiresAt;

  const UserSession({
    required this.id,
    required this.email,
    this.displayName,
    this.expiresAt,
  });

  UserSession copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? expiresAt,
  }) {
    return UserSession(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
