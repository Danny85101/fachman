import 'package:flutter/material.dart';
import 'hlavni_obrazovka.dart'; 
import 'sklad.dart'; // Starý kabel k výdajům
import 'sklad_diar.dart'; // NOVÝ kabel k paměti Diáře!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Nahrajeme staré výdaje
  await nactiZPameti();
  
  // Nahrajeme i naplánované zakázky z Diáře
  await nactiDiarZPameti();

  runApp(const DigitalniFachman());
}

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