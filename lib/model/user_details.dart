
class UserDetailsModel{
  String? color;
  double? width;

  UserDetailsModel({this.color,this.width});
  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      color: json['color'],
      width: json['width'] != null ? json['width'].toDouble() : 0.0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'color': this.color,
      'width': this.width != null ? this.width!.toDouble() : 0.0,
    };
  }
}
