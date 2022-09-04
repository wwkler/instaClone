class IUser {
  String? uid;
  String? nickname;
  String? thumbnail;
  String? description;

  // Constructor
  IUser({
    this.uid,
    this.nickname,
    this.thumbnail,
    this.description,
  });

  // JSON 데이터를 Model 데이터로 변환하는 Constructor
  factory IUser.fromJson(Map<String, dynamic> json) {
    return IUser(
      uid: json['uid'] == null ? '' : json['uid'] as String,
      nickname: json['nickname'] == null ? '' : json['nickname'] as String,
      thumbnail: json['thumbnail'] == null ? '' : json['thumbnail'] as String,
      description:
          json['description'] == null ? '' : json['description'] as String,
    );
  }

  // Model 데이터를 JSON 데이터로 변환하는 부분
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'thumbnail': thumbnail,
      'description': description,
    };
  }

  // Instance를 복제하는 method
  IUser copyWith({
    String? uid,
    String? nickname,
    String? thumbnail,
    String? description,
  }) {
    return IUser(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
    );
  }
}
