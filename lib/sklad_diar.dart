import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Tady je naše nová, prázdná krabice čistě jen na plánované zakázky
List<Map<String, dynamic>> vsechnyZakazky = [];

// Funkce pro uložení diáře na pevný disk telefonu
Future<void> ulozDiarDoPameti() async {
  final prefs = await SharedPreferences.getInstance();
  String dataJakoText = jsonEncode(vsechnyZakazky);
  await prefs.setString('mojeZakazky', dataJakoText);
}

// Funkce pro načtení diáře při startu aplikace
Future<void> nactiDiarZPameti() async {
  final prefs = await SharedPreferences.getInstance();
  String? nahranaData = prefs.getString('mojeZakazky');

  if (nahranaData != null) {
    List<dynamic> rozkodovano = jsonDecode(nahranaData);
    vsechnyZakazky = rozkodovano.map((polozka) => polozka as Map<String, dynamic>).toList();
  }
}