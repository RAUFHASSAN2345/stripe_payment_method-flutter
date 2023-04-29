import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Home_View extends StatefulWidget {
  const Home_View({super.key});

  @override
  State<Home_View> createState() => _Home_ViewState();
}

class _Home_ViewState extends State<Home_View> {
  late Map paymentIntentData;
  paymentmethod() async {
    try {
      paymentIntentData = await paymentintent('20', 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret:
              'sk_test_51N1RXfSH5SvkgPqemeSQQdNwo8xR7MX670Cyr3cyEvYa27CZgtpFEyvyj2NyE89RDNgVlz7ukNf8RvgD9si5HBLq00fo539R9V',
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          customFlow: true,
          style: ThemeMode.dark,
        ),
      );
      displaypaymentsheet();
    } catch (e) {
      print('error: $e');
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('$e'),
          );
        },
      );
    }
  }

  displaypaymentsheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("paid successfully")));
    } catch (e) {
      print('error: $e');
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('$e'),
          );
        },
      );
    }
  }

  paymentintent(String amount, String currency) async {
    try {
      Map body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51N1RXfSH5SvkgPqemeSQQdNwo8xR7MX670Cyr3cyEvYa27CZgtpFEyvyj2NyE89RDNgVlz7ukNf8RvgD9si5HBLq00fo539R9V',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (e) {
      print('error: $e');
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('$e'),
          );
        },
      );
    }
  }

  calculateAmount(String Amount) {
    final price = int.parse(Amount) * 100;
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Stripe_payment_method-practice'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await paymentmethod();
                },
                child: const Text('Pay'))
          ],
        ),
      ),
    );
  }
}
