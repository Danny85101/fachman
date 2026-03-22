import 'package:flutter/material.dart';

class ChytryKalendar {
  // Funkce, která ukáže kalendář a vrátí vybrané datum
  static Future<void> vybratDatum(BuildContext context, TextEditingController kamZapsat) async {
    // Ukážeme kalendář
    DateTime? vybranyDen = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Začne na dnešku
      firstDate: DateTime(2020), // Jak moc do minulosti můžeš
      lastDate: DateTime(2030), // Jak moc do budoucnosti můžeš
      helpText: 'VYBER DATUM ZAKÁZKY',
      cancelText: 'ZRUŠIT',
      confirmText: 'POTVRDIT',
      // OPRAVA: Tímhle přísným zákazem jsme nadobro schovali tužku!
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    // Pokud uživatel vybral den a nedal zrušit
    if (vybranyDen != null) {
      // Převedeme to na hezký text a už k tomu nelepíme žádné tajné kódy!
      String hezkeDatum = "${vybranyDen.day}. ${vybranyDen.month}. ${vybranyDen.year}";
      
      // Zapíšeme do kolonky jen krásné a čisté datum
      kamZapsat.text = hezkeDatum; 
    }
  }
}