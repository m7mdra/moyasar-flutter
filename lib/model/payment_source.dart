class PaymentSource {
  PaymentSource(
      {this.type,
      this.name,
      this.number,
      this.company,
      this.gateway,
      this.referenceNumber,
      this.token,
      this.message,
      this.transactionUrl});

  /// defines the type of payment
  /// could be either creditcard, applepay, stcpay or token
  final String? type;

  /// credit card’s holder name
  final String? name;

  /// credit card’s masked number
  final String? number;

  /// credit card’s company mada or visa or master or amex
  final String? company;

  /// Payment’s internal gateway identifier
  final String? gateway;

  /// Payment’s bank reference number
  final String? referenceNumber;

  /// card’s token
  final String? token;

  /// payment gateway message
  final String? message;

  /// URL to complete 3-D secure transaction authorization at bank gateway
  final String? transactionUrl;

  factory PaymentSource.fromMap(Map<String, dynamic> map) {
    return PaymentSource(
        type: map["type"],
        name: map['name'],
        number: map['number'],
        company: map['company'],
        gateway: map['gateway_id'],
        referenceNumber: map['reference_number'],
        token: map['token'],
        message: map['message'],
        transactionUrl: map['transaction_url']);
  }

  Map<String, dynamic> _toMap() {
    return {
      "type": type,
      "name": name,
      "number": number,
      "gateway": gateway,
      "referenceNumber": referenceNumber,
      "token": token,
      "message": message,
      "transactionUrl": transactionUrl
    };
  }

  @override
  String toString() {
    return _toMap().toString();
  }
}
