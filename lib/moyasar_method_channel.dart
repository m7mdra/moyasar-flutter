import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'moyasar.dart';
import 'moyasar_platform_interface.dart';

/// An implementation of [MoyasarPlatform] that uses method channels.
class MethodChannelMoyasar extends MoyasarPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('moyasar');

  @override
  Future<PaymentResponse?> start(PaymentRequest request) async {
    try {
      final result =
          await methodChannel.invokeMethod<dynamic>('start', request.toMap());
      if (result != null) {
        return PaymentResponse.fromMap(jsonDecode(jsonEncode(result)));
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<PaymentResponse?> applePay(PaymentRequest request) async {
    try {
      final result = await methodChannel.invokeMethod<dynamic>(
          'applePay', request.toMap());
      if (result != null) {
        return PaymentResponse.fromMap(jsonDecode(jsonEncode(result)));
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<bool> applePayStatus() async {
    try {
      final result =
          await methodChannel.invokeMethod<bool>('applePayAuthorization');
      return result != null && result;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<void> setupPayment() async {
    try {
      await methodChannel.invokeMethod<void>('setupPayment');
    } catch (error) {
      rethrow;
    }
  }
}
