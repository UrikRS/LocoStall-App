class User {
  final int? userId;

  User(this.userId);
}

class UserData {
  final int userId;
  final String? lineId;
  final String? name;
  final String nLang;
  final String email;
  final String password;
  final String? type;
  final int? shopId;

  UserData(
    this.userId,
    this.lineId,
    this.name,
    this.nLang,
    this.email,
    this.password,
    this.type,
    this.shopId,
  );
}
