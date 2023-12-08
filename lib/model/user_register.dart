import 'package:nodejstoflutter/model/user_details.dart';

class UserRegister{

  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final List<UserDetailsModel>?  userdetails;

  UserRegister({ this.id,this.name, this.email, this.password,this.userdetails});
  factory UserRegister.fromJson(Map<String, dynamic> json) {
    return UserRegister(
      name: json['name'],
      email: json['email'],
      userdetails: (json['userdetails'] as List<dynamic>)
          .map((detail) => UserDetailsModel.fromJson(detail))
          .toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id':this.id,
      'name': this.name,
      'email': this.email,
      'userdetails': this.userdetails?.map((detail) => detail.toMap()).toList() ?? [],

      // Diğer alanları ekleyin...
    };
  }
}



