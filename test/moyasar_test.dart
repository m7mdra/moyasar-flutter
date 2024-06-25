import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';
import 'package:moyasar/moyasar_platform_interface.dart';
import 'package:moyasar/moyasar_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMoyasarPlatform
    with MockPlatformInterfaceMixin
    implements MoyasarPlatform {
  @override
  Future<PaymentResponse?> start(PaymentRequest request) {
    // TODO: implement start
    throw UnimplementedError();
  }

  @override
  Future<bool> applePayStatus() async {
    // TODO: implement start
    throw UnimplementedError();
  }

  @override
  Future<PaymentResponse?> applePay(PaymentRequest request) {
    // TODO: implement applePay
    throw UnimplementedError();
  }

  @override
  Future<void> setupPayment() {
    // TODO: implement setupPayment
    throw UnimplementedError();
  }
}

void main() {
  final MoyasarPlatform initialPlatform = MoyasarPlatform.instance;

  test('$MethodChannelMoyasar is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMoyasar>());
  });
}
