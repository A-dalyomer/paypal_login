import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/paypal_account_info_model.dart';
import '../model/paypal_login_model.dart';
import '../../presentation/screen/paypal_login_screen.dart';

export '../model/paypal_account_info_model.dart';

class PaypalLogin {
  PaypalLogin({
    required this.clientId,
    this.enableSandbox = true,
  });

  /// paypal Client ID
  final String clientId;

  /// Set to true to enable sandbox mode
  final bool enableSandbox;

  final Dio dio = Dio();

  /// login with paypal and retrieve user email
  Future<PayPalAccountInfoModel?> loginWithPayPal(
    BuildContext context, {
    required String redirectUri,
    required String secret,
    Widget? browserAppbar,
  }) async {
    final String? authorizationCode = await getAuthorizationCode(
      context,
      redirectUri: redirectUri,
      browserAppbar: browserAppbar,
    );

    /// Handle authorization code retrieval failure
    if (authorizationCode == null) {
      if (kDebugMode) {
        print('paypal authorization code not retrieved');
      }
      return null;
    }

    /// get Access Token from retrieved Authorization Code
    final String? accessToken = await getAccountAccessToken(
      authorizationCode: authorizationCode,
      redirectUri: redirectUri,
      secret: secret,
    );

    /// Handle access token retrieval failure
    if (accessToken == null) {
      if (kDebugMode) {
        print('paypal access token not retrieved');
      }
      return null;
    }

    /// Get User Email
    final Map<String, dynamic>? accountInfo =
        await _getAccountInfo(accessToken: accessToken);
    if (kDebugMode) {
      print('paypal account info: $accountInfo');
    }
    try {
      return PayPalAccountInfoModel.fromJson(accountInfo!);
    } catch (runtimeException) {
      if (kDebugMode) {
        print(runtimeException);
      }
      return null;
    }
  }

  /// login with paypal and acquire only the AuthorizationCode from account
  Future<String?> getAuthorizationCode(
    BuildContext context, {
    required String redirectUri,
    Widget? browserAppbar,
  }) async {
    /// Generate State Parameter
    final state = _generateStateParameter();

    /// Authorization URL
    final String authUrl = enableSandbox
        ? 'https://www.sandbox.paypal.com/webapps/auth/protocol/openidconnect/v1/authorize?'
        : 'https://www.paypal.com/webapps/auth/protocol/openidconnect/v1/authorize?';
    const responseType = 'code';
    const scope = 'openid%20email%20address';
    final authorizationUrl = '$authUrl'
        'client_id=$clientId'
        '&response_type=$responseType'
        '&scope=$scope'
        '&redirect_uri=$redirectUri'
        '&state=$state';

    /// Open Authorization URL in WebView or Browser to allow user login
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaypalLoginScreen(
          authorizationUrl,
          redirectURL: redirectUri,
          appBar: browserAppbar ?? AppBar(),
        ),
      ),
    );
    final String? authorizationCode = _parseAuthorizationCode(result);
    return authorizationCode;
  }

  /// Generate a unique state parameter using a UUID or a secure random generator
  String _generateStateParameter() {
    const uuid = Uuid();
    final state = uuid.v4();
    return state;
  }

  /// Parse Authorization Code from Redirect URL on webview
  String? _parseAuthorizationCode(String? redirectUrl) {
    if (redirectUrl != null && redirectUrl.isNotEmpty) {
      final uri = Uri.parse(redirectUrl);
      return uri.queryParameters['code'];
    }
    return null;
  }

  Future<String?> getAccountAccessToken({
    required String authorizationCode,
    required String redirectUri,
    required String secret,
  }) async {
    final String tokenUrl = enableSandbox
        ? 'https://api.sandbox.paypal.com/v1/oauth2/token'
        : 'https://api.paypal.com/v1/oauth2/token';
    try {
      final response = await dio.post(
        tokenUrl,
        data: {
          'grant_type': 'authorization_code',
          'code': authorizationCode,
          'redirect_uri': redirectUri,
        },
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$clientId:$secret'))}',
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );
      return PayPalLoginModel.fromJson(response.data!).accessToken;
    } catch (dioException) {
      if (kDebugMode) {
        print('paypal accessToken, error: $dioException');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getAccountInfo({
    required String accessToken,
  }) async {
    final String userEmailUrl = enableSandbox
        ? 'https://api.sandbox.paypal.com/v1/identity/oauth2/userinfo?schema=openid'
        : 'https://api.paypal.com/v1/identity/oauth2/userinfo?schema=openid';
    try {
      final userEmailResponse = await dio.get(
        userEmailUrl,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final accountInfo = userEmailResponse.data;
      return accountInfo;
    } catch (dioException) {
      if (kDebugMode) {
        print('paypal email, error: $dioException');
      }
      return null;
    }
  }
}
