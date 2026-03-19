import 'package:flutter/material.dart';
import 'sklad.dart';
import 'data_formulare.dart';

// Přidali jsme parametr "cestaKFotce", abychom fotku správně umístili na "tácek"
void ukazDialogZakaznici(BuildContext context, String cestaKFotce) {
  Set<String> jmenaZakazniku = {};
  for (var zaznam in vsechnyNakupy) {
    if (zaznam['zakaznik'] != 'Neznámý') {
      jmenaZakazniku.add(zaznam['zakaznik']);
    }
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ke komu účtenku přidat?', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ...jmenaZakazniku.map((jmeno) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[100], foregroundColor: Colors.black),
                  onPressed: () {
                    zakaznikController.text = jmeno;
                    prilozenaFotka = cestaKFotce; // Tady dáváme fotku na tácek
                    Navigator.pop(context); // Zavře dialog
                    Navigator.pop(context); // Zavře foťák a vrátí se do formuláře
                  },
                  child: Text(jmeno, style: const TextStyle(fontSize: 18)),
                ),
              )),
              const Divider(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text('K novému (vypíšu sám)', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  prilozenaFotka = cestaKFotce; // I novému musíme dát fotku na tácek
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}