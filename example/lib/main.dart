import 'dart:io';

import 'package:flutter/material.dart';
import 'key.dart';
import 'package:moyasar/moyasar.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _moyasarPlugin = Moyasar();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Description'),
                ),
                const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Amount'),
                ),
                const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Currencey'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      var canMakeApplePayment =
                      await _moyasarPlugin.applePayStatus();
                      print("canMakeApplePayment $canMakeApplePayment");
                    },
                    child: const Text('Check apple payment status')),
                ElevatedButton(
                    onPressed: () async {
                      await _moyasarPlugin
                          .setupPayment()
                          .then((value) => print("setup setup setup"));
                    },
                    child: const Text('setup payment')),
                ElevatedButton(
                  onPressed: () async {
                    var canMakeApplePayment =
                    await _moyasarPlugin.applePayStatus();
                    if (canMakeApplePayment) {
                      try {
                        PaymentResponse? result = await _moyasarPlugin.applePay(
                            PaymentRequest(
                                amount: (97.12 * 100),
                                currency: 'SAR',
                                description: 'description',
                                metaData: {
                                  "os": Platform.operatingSystem,
                                  "consignmentNo": "TEST321312312312"
                                },
                                merchantId: "merchant.com.example.app",
                                apiKey: kApiKey));
                        print(result);
                      } catch (err) {
                        print(err);
                      }
                    } else {
                      print("Apple not setup");
                      await _moyasarPlugin.setupPayment();
                    }
                  },
                  child: const Text('Apple Pay'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      PaymentResponse? result = await _moyasarPlugin.start(
                          PaymentRequest(
                              amount: (1197.21) * 100,
                              currency: 'SAR',
                              description: 'description',
                              apiKey: kApiKey));
                      print(result?.source.toString());
                      print(result);
                    } catch (err) {
                      print(err);
                    }
                  },
                  child: const Text('Pay'),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TestNavigation()));
                    },
                    child: const Text('Test Navigation'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TestNavigation extends StatelessWidget {
  const TestNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: const Text('POP!'),
        ),
      ),
    );
  }
}
