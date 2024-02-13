import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'paypal_login_platform_interface.dart';

/// An implementation of [PaypalLoginPlatform] that uses method channels.
class MethodChannelPaypalLogin extends PaypalLoginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('paypal_login');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
