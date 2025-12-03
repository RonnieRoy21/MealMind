class ProfileModel{
  String email;
  String? imgPath;
  String? username;

  ProfileModel({
    required this.email,
    required this.imgPath,
    required this.username,
});

 factory ProfileModel.fromJson(Map<String, dynamic> json){
    return ProfileModel(
      email: json['email'].toString(),
      imgPath: json['profile_image']as String ?,
      username: json['user_name']as String ? ,
    );
  }

}