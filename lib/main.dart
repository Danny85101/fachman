import 'package:flutter/material.dart';
// PŘIDÁNO: Načteme ten nový český slovník, co jsme si přidali do pubspec.yaml
import 'package:flutter_localizations/flutter_localizations.dart';

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
      
      // --- OPRAVENO: TADY ZAPÍNÁME ČEŠTINU BEZ SLOVÍČEK CONST ---
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('cs', 'CZ'), // Říkáme aplikaci: Tvůj rodný jazyk je teď čeština!
      ],
      // --- KONEC ČEŠTINY ---

      theme: ThemeData(primarySwatch: Colors.orange),
      home: const HlavniObrazovka(),
    );
  }
}