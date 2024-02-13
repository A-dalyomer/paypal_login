import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'paypal_login_method_channel.dart';

abstract class PaypalLoginPlatform extends PlatformInterface {
  /// Constructs a PaypalLoginPlatform.
  PaypalLoginPlatform() : super(token: _token);

  static final Object _token = Object();

  static PaypalLoginPlatform _instance = MethodChannelPaypalLogin();

  /// The default instance of [PaypalLoginPlatform] to use.
  ///
  /// Defaults to [MethodChannelPaypalLogin].
  static PaypalLoginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PaypalLoginPlatform] when
  /// they register themselves.
  static set instance(PaypalLoginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
