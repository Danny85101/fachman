import 'package:flutter/material.dart';
import 'hlavni_obrazovka.dart'; // Tady natahujeme kabel do nového šuplíku!

void main() => runApp(const DigitalniFachman());

class DigitalniFachman extends StatelessWidget {
  const DigitalniFachman({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const HlavniObrazovka(),
    );
  }
}