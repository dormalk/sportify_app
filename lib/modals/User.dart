class User {
  String displayName;
  String id;
  String photoUrl;
  String email;
  DateTime createdAt;
  DateTime updateAt;

  User.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'],
        photoUrl = json['photoUrl'],
        createdAt = DateTime(json['createAt']),
        updateAt = DateTime(json['updateAt']),
        id = json['Id'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'id': id,
        'photoUrl': photoUrl,
        'createdAt': createdAt.toString(),
        'updateAt': updateAt.toString(),
        'email': email
      };
}
