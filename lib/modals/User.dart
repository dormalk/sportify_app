class User {
  String displayName;
  String id;
  String photoUrl;
  String email;
  DateTime createdAt;
  DateTime updatedAt;

  User(
      {this.id,
      this.displayName,
      this.email,
      this.createdAt,
      this.photoUrl,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'],
        photoUrl = json['photoUrl'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']),
        id = json['id'].toString(),
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'id': id,
        'photoUrl': photoUrl,
        'createdAt': createdAt.toString(),
        'updatedAt': updatedAt.toString(),
        'email': email
      };
}
