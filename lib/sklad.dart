import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Náš centrální sešit (zatím prázdný při prvním zapnutí)
List<Map<String, dynamic>> vsechnyNakupy = [];

// FUNKCE 1: VEZME SEŠIT A ZAPÍŠE HO NA PEVNÝ DISK TELEFONU
Future<void> ulozDoPameti() async {
  final prefs = await SharedPreferences.getInstance();
  // Převedeme náš seznam na obyčejný text (tzv. JSON), protože disk umí ukládat jen text
  String dataTextem = jsonEncode(vsechnyNakupy);
  await prefs.setString('mojeZaznamy', dataTextem);
}

// FUNKCE 2: PŘI STARTU APLIKACE VEZME DATA Z DISKU A DÁ JE ZPĚT DO SEŠITU
Future<void> nactiZPameti() async {
  final prefs = await SharedPreferences.getInstance();
  String? ulozenaData = prefs.getString('mojeZaznamy');
  
  if (ulozenaData != null) {
    // Pokud na disku něco je, přeložíme ten text zpátky do našeho seznamu nákupů
    List<dynamic> prekodovano = jsonDecode(ulozenaData);
    vsechnyNakupy = prekodovano.map((polozka) => polozka as Map<String, dynamic>).toList();
  }
}