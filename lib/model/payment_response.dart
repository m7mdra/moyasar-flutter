import 'package:moyasar/moyasar.dart';

/// a data class represent a completed payment.
class PaymentResponse {
  PaymentResponse(
      {required this.id,
      required this.status,
      required this.amount,
      this.amountFormat,
      required this.fee,
      this.feeFormat,
      required this.source,
      required this.currency,
      required this.refunded,
      this.refundedAt,
      this.refundedFormat,
      required this.captured,
      this.capturedAt,
      this.capturedFormat,
      this.voidedAt,
      this.description,
      this.invoiceId,
      this.ip,
      this.callbackUrl,
      this.createdAt,
      this.updatedAt,
      this.metaData});

  /// payment’s unique ID.
  final String id;

  /// payment status. (default: initiated) can be of the following:
  /// 1- initiated 	First status of an invoice. It indicates that the invoice has been created but is not paid yet.
  /// 2- paid 	Invoice reaches this status when card holder pays successfully.
  /// 3- refunded 	Invoice reaches this status when merchant refunds its paid or captured payment successfully.
  /// 4- canceled 	Invoice reaches this status when merchant cancels an initiated invoice.
  /// 5- on hold 	Invoice reaches this status when it has a current payment attempt that has not been completed yet.
  /// 6- expired 	Invoice reaches this status when it is set for expiry and has reached the expiration date.
  final String status;

  /// A positive integer in the smallest currency unit
  /// (e.g 100 cents to charge an amount of $1.00, 100 halalah to charge an amount of 1 SAR
  /// or 1 to charge an amount of ¥1, a 0-decimal currency)
  /// representing how much to charge the card. The minimum amount is $0.50 (or equivalent in charge currency).
  final int amount;

  ///  	formatted invoice amount.
  final String? amountFormat;

  /// transaction fee in local currency (halals).
  final int fee;

  /// formatted fee amount.
  final String? feeFormat;

  /// 3-letter ISO code for currency. E.g., SAR, CAD, USD.
  final String currency;

  /// refunded amount in halals. (default: 0)
  final int refunded;

  /// defines the type of payment
  /// could be either creditcard, applepay, stcpay or token
  /// for more information see [PaymentSource]
  final PaymentSource source;

  /// datetime of refunded. (default: null)
  final String? refundedAt;

  /// formatted refunded amount.
  final String? refundedFormat;

  /// captured amount in halals.
  final int captured;

  /// datetime of authroized payment captured
  final String? capturedAt;

  /// formatted captured amount.
  final String? capturedFormat;

  /// datetime of voided
  final String? voidedAt;

  /// payment description
  final String? description;

  /// ID of the invoice this payment is for if one exists.
  final String? invoiceId;

  /// User IP
  final String? ip;

  /// page url in customer’s site for final redirection.
  final String? callbackUrl;

  /// creation timestamp in ISO 8601 format
  final String? createdAt;

  /// modification timestamp in ISO 8601 format.
  final String? updatedAt;

  /// metadata object
  final Map<String, dynamic>? metaData;

  factory PaymentResponse.fromMap(Map<String, dynamic> map) {
    return PaymentResponse(
        id: map["id"],
        status: map["status"],
        amount: map["amount"],
        amountFormat: map["amountFormat"],
        fee: map["fee"],
        feeFormat: map["feeFormat"],
        currency: map["currency"],
        refunded: map["refunded"],
        source: PaymentSource.fromMap(map["source"]),
        refundedAt: map["refundedAt"],
        refundedFormat: map["refundedFormat"],
        captured: map["captured"],
        capturedAt: map["capturedAt"],
        capturedFormat: map["capturedFormat"],
        voidedAt: map["voidedAt"],
        description: map["description"],
        invoiceId: map["invoiceId"],
        ip: map["ip"],
        callbackUrl: map["callbackUrl"],
        createdAt: map["createdAt"],
        updatedAt: map["updatedAt"],
        metaData: map["metaData"]);
  }

  @override
  String toString() {
    return 'PaymentResponse{id: $id'
        '\tstatus: $status'
        '\tamount: $amount'
        '\tamountFormat: $amountFormat'
        '\tfee: $fee'
        '\tfeeFormat: $feeFormat'
        '\tcurrency: $currency'
        '\trefunded: $refunded'
        '\tsource: $source'
        '\trefundedAt: $refundedAt'
        '\trefundedFormat: $refundedFormat'
        '\tcaptured: $captured'
        '\tcapturedAt: $capturedAt'
        '\tcapturedFormat: $capturedFormat'
        '\tvoidedAt: $voidedAt'
        '\tdescription: $description'
        '\tinvoiceId: $invoiceId'
        '\tip: $ip'
        '\tcallbackUrl: $callbackUrl'
        '\tcreatedAt: $createdAt'
        '\tupdatedAt: $updatedAt'
        '\tmetaData: $metaData'
        '}';
  }
}
