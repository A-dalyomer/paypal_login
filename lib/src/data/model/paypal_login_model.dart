class PayPalLoginModel {
  PayPalLoginModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
    required this.scope,
  });
  final String? accessToken;
  final String? tokenType;
  final int? expiresIn;
  final String? refreshToken;
  final String? scope;

  factory PayPalLoginModel.fromJson(Map<String, dynamic> json) {
    return PayPalLoginModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      refreshToken: json['refresh_token'],
      scope: json['scope'],
    );
  }
}
