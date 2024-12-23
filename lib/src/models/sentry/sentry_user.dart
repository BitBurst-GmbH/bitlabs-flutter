class SentryUser {
  final String id;
  final String? email;
  final String? username;
  final String ipAddress;

  SentryUser({
    required this.id,
    this.email,
    this.username,
    this.ipAddress = '{{auto}}',
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'ip_address': ipAddress,
    };

    if (email != null) {
      json['email'] = email;
    }

    if (username != null) {
      json['username'] = username;
    }

    return json;
  }
}
