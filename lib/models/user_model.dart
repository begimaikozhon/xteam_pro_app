class UserModel {
  final String uid;
  final String email;

  UserModel({required this.uid, required this.email});

  // Метод для преобразования объекта в Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  // Фабричный метод для создания объекта из Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}
