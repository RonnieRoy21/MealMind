class ProfileModel{
  String email;
  String? imgPath;
  String? username;
  List conditions;

  ProfileModel({
    required this.email,
    required this.imgPath,
    required this.username,
    required this.conditions,
});

 factory ProfileModel.fromJson(Map<String, dynamic> json){
    return ProfileModel(
      email: json['email'].toString(),
      imgPath: json['profile_image']as String ?,
      username: json['user_name']as String ? ,
      conditions: json['health_conditions']!as List ,
    );
  }

}