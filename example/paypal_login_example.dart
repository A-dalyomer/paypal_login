import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paypal_login/paypal_login.dart';

/// TODO: set your developer account credentials
const String clientId = 'clientId';
const String redirectUri = 'redirectUri';
const String secret = 'secret';

Future<bool> getPaypalAccountInfo(BuildContext context) async {
  PaypalLogin payPalRepository = PaypalLogin(
    clientId: clientId,
    enableSandbox: true,
  );
  PayPalAccountInfoModel? response = await payPalRepository.loginWithPayPal(
    context,
    redirectUri: redirectUri,
    secret: secret,
  );
  if (kDebugMode) {
    print('paypal account info: $response');
  }
  return response != null;
}

Future<bool> getAuthorizationCode(BuildContext context) async {
  PaypalLogin payPalRepository = PaypalLogin(
    clientId: clientId,
    enableSandbox: true,
  );
  String? authorizationCode = await payPalRepository.getAuthorizationCode(
    context,
    redirectUri: redirectUri,
    browserAppbar: AppBar(),
  );
  if (kDebugMode) {
    print('paypal Authorization code $authorizationCode');
  }
  return authorizationCode != null;
}

void main() {
  runApp(const PaypalLoginApp());
}

class PaypalLoginApp extends StatefulWidget {
  const PaypalLoginApp({super.key});

  @override
  State<PaypalLoginApp> createState() => _PaypalLoginAppState();
}

class _PaypalLoginAppState extends State<PaypalLoginApp> {
  bool gotAccountInfo = false;
  bool gotAuthorizationCode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paypal login')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              bool result = await getPaypalAccountInfo(context);
              setState(() => gotAccountInfo = result);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                gotAccountInfo ? Colors.green : Colors.blue,
              ),
            ),
            child: const Text('login with paypal'),
          ),
          ElevatedButton(
            onPressed: () async {
              bool result = await getAuthorizationCode(context);
              setState(() => gotAuthorizationCode = result);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                gotAuthorizationCode ? Colors.green : Colors.blue,
              ),
            ),
            child: const Text('get authorization code'),
          ),
        ],
      ),
    );
  }
}
