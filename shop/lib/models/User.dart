class User {
  final String email;
  final String username;
  final String password;
  final bool isAdmin;
  final String photo;
  final String pays;
  final List<String> myProducts;

  User({
    required this.email,
    required this.username,
    required this.password,
    this.isAdmin = false,
    this.photo = "",
    this.pays = "",
    this.myProducts = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      password: json['password'],
      isAdmin: json['isAdmin'] ?? false,
      photo: json['photo'] ?? "",
      pays: json['pays'] ?? "",
      myProducts: List<String>.from(json['myProducts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'isAdmin': isAdmin,
      'photo': photo,
      'pays': pays,
      'myProducts': myProducts,
    };
  }
}
