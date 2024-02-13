class PayPalAccountInfoModel {
  PayPalAccountInfoModel({
    required this.userId,
    required this.name,
    required this.givenName,
    required this.familyName,
    required this.email,
    required this.picture,
  });
  final String? userId;
  final String? name;
  final String? givenName;
  final String? familyName;
  final String? email;
  final String? picture;

  factory PayPalAccountInfoModel.fromJson(Map<String, dynamic> json) {
    return PayPalAccountInfoModel(
      userId: json['user_id'],
      name: json['name'],
      givenName: json['given_name'],
      familyName: json['family_name'],
      email: json['email'],
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = userId;
    data['givenName'] = userId;
    data['familyName'] = userId;
    data['email'] = userId;
    data['picture'] = userId;
    return data;
  }
}
