import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payement_method/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51N1RXfSH5SvkgPqeoRPkA6iv06T56n0KBPTaOG6jmkp4WZJW7H4DV6cuBvwVWHtd9yqmW7xK3vl06DhKx0n6TroR00BSXmQArx';

  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home_View(),
    );
  }
}
