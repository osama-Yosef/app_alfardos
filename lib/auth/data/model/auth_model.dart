class LoginModel {
  final String email;
  final String type;

  LoginModel({
    required this.email,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "type": type,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      email: map["email"] ?? "",
      type: map["type"] ?? "",
    );
  }
}

class RegisterModel {
  final String id;
  final String uid;
  final String name;
  final String email;
  final DateTime? createdAt;

  RegisterModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.email,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "uid": uid,
      "name": name,
      "email": email,
      "createdAt": createdAt?.toIso8601String(),
    };
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      id: map["id"] ?? "",
      uid: map["uid"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      createdAt: map["createdAt"] == null
          ? null
          : DateTime.tryParse(map["createdAt"]),
    );
  }
}

