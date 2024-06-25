import 'package:flutter/services.dart';

import 'model/payment_request.dart';
import 'model/payment_response.dart';
import 'moyasar_platform_interface.dart';

class Moyasar {
  /// starts the payment by passing request
  /// request [PaymentRequest]
  Future<PaymentResponse?> start(PaymentRequest request) {
    return MoyasarPlatform.instance.start(request);
  }

  /// starts the apple payment payment by passing request
  /// request [PaymentRequest]
  /// on Android it has no effect and will throw [PlatformException]
  Future<PaymentResponse?> applePay(PaymentRequest request) {
    return MoyasarPlatform.instance.applePay(request);
  }

  /// checks if apple payment is setup
  /// on Android it has no effect and will throw [PlatformException]
  Future<bool> applePayStatus() {
    return MoyasarPlatform.instance.applePayStatus();
  }

  /// starts apple pay setup proccess
  /// on Android it has no effect and will throw [PlatformException]
  Future<void> setupPayment() {
    return MoyasarPlatform.instance.setupPayment();
  }
}
