Paypal login is widely used way to authenticate people accounts in an app,
Enable login with paypal in you app with easy steps through this package.

## Features
- Login with paypal to get user account info.
- Get only account authorization code to only to authenticate a user on your server
- Get only account access token to manage an account.
## Getting started
1. **Account preparation**
    - First you need to activate developer mode in your paypal account to start.
    - Create an app on your paypal developer portal.
2. **Retrieve API Keys**
    - Enable Access scopes to your app.
    - Retrieve client id and client secret IDs to implement your account in the package.


## Usage
import the package in your repository
```dart
import 'package:paypal_login/paypal_login.dart';
```

use the log in API with a Callback
```dart
void paypalLogin(BuildContext context) async {
  PaypalLogin payPalRepository = PaypalLogin(
    clientId: clientId,
    enableSandbox: true,
  );
  PayPalAccountInfoModel? accountInfo = await payPalRepository.loginWithPayPal(
    context,
    redirectUri: redirectUri,
    secret: secret,
  );
  if (kDebugMode) {
    print(accountInfo?.toJson());
  }
}
```

## Additional information
1. For Contributions please file an issue on github or make a pull request too.
2. For more information about paypal login please visit their documentation section at: https://developer.paypal.com/docs/log-in-with-paypal/
