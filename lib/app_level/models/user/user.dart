import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3)
@JsonSerializable(nullable: false)
class UserModel {
  UserModel({
    this.userName,
    this.userPhone,
    this.userEmail,
    this.userAddress,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @HiveField(0)
  @JsonKey(name: 'user_name')
  String userName;

  @HiveField(1)
  @JsonKey(name: 'user_phone')
  String userPhone;

  @HiveField(2)
  @JsonKey(name: 'user_email')
  String userEmail;

  @HiveField(3)
  @JsonKey(name: 'user_address')
  String userAddress;
}
