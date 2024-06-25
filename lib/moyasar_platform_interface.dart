import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'moyasar.dart';
import 'moyasar_method_channel.dart';

abstract class MoyasarPlatform extends PlatformInterface {
  /// Constructs a MoyasarPlatform.
  MoyasarPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoyasarPlatform _instance = MethodChannelMoyasar();

  /// The default instance of [MoyasarPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoyasar].
  static MoyasarPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MoyasarPlatform] when
  /// they register themselves.
  static set instance(MoyasarPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// checks if apple payment is setup
  /// on Android it has no effect and will throw [PlatformException]
  Future<bool> applePayStatus() {
    throw UnimplementedError('applePayStatus has not been implemented.');
  }

  /// starts the apple payment payment by passing request
  /// request [PaymentRequest]
  /// on Android it has no effect and will throw [PlatformException]
  Future<PaymentResponse?> applePay(PaymentRequest request) {
    throw UnimplementedError(
        'applePay(PaymentRequest) has not been implemented.');
  }

  /// starts the payment by passing request
  /// request [PaymentRequest]
  Future<PaymentResponse?> start(PaymentRequest request) {
    throw UnimplementedError('start(PaymentRequest) has not been implemented.');
  }

  /// starts apple pay setup proccess
  /// on Android it has no effect and will throw [PlatformException]
  Future<void> setupPayment() {
    throw UnimplementedError('setupPayment has not been implemented.');
  }
}
