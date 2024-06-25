class PaymentRequest {
  /// A positive integer in the smallest currency unit
  /// e.g 100 cents to charge an amount of $1.00, 100 halalah to
  /// charge an amount of 1 SAR, or 1 to charge an amount of ¥1,
  /// a 0-decimal currency representing how much to charge the card.
  /// The minimum amount is $0.50 (or equivalent in charge currency).
  /// it will be converted at the platform level.
  final num amount;

  /// 3-letter ISO code for currency. E.g., SAR, CAD, USD. (default: SAR)
  final String currency;

  /// payment description
  final String description;

  /// api key for project in dashboard
  final String apiKey;

  /// an object that can be attached with Payment and Invoice.
  /// You can specify up to 30 keys, with key names up to 40 characters long
  /// and values up to 500 characters long.
  final Map<String, dynamic>? metaData;

  ///
  final String? baseUrl;

  /// apple merchant id,
  /// it has no effect on android
  final String? merchantId;

  PaymentRequest(
      {required this.amount,
      required this.currency,
      required this.description,
      required this.apiKey,
      this.metaData,
      this.merchantId,
      this.baseUrl});

  Map<String, dynamic> toMap() {
    return {
      "amount": amount,
      "currency": currency,
      "description": description,
      "api_key": apiKey,
      "merchant_id": merchantId,
      "meta_data": metaData,
      "base_url": baseUrl
    };
  }
}
