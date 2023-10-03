import 'package:json_annotation/json_annotation.dart';

part 'user_model_update.g.dart';

@JsonSerializable()
class UserModelUpdate {
  String username;
  String password;
  String name;
  int id;
  int age;
  String bring_people;
  int sleep;
  int phone;
  //String role;
  bool vape;
  String personality;
  bool likes_pets;
  String clean;
  //String week;
  bool smoke;
  String gender;
  // Image
  UserModelUpdate({
    required this.username,
    required this.password,
    required this.name,
    required this.id,
    required this.age,
    required this.bring_people,
    required this.sleep,
    required this.phone,
    //required this.role,
    required this.vape,
    required this.personality,
    required this.likes_pets,
    required this.clean,
    //required this.week,
    required this.smoke,
    required this.gender,
  });

  factory UserModelUpdate.fromJson(Map<String, dynamic> json) =>
      _$UserModelUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelUpdateToJson(this);
}