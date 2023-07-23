class User {
  final String userId;

  User(this.userId);
}

class UserData {
  final String userId;
  final String lineId;
  final String appId;
  final String name;
  final String nativeLang;
  final String email;
  final String password;

  UserData(
    this.userId,
    this.lineId,
    this.appId,
    this.name,
    this.nativeLang,
    this.email,
    this.password,
  );
}
