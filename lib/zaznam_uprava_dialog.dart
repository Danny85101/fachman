import 'package:flutter/material.dart';
import 'sklad.dart';

class ZaznamUpravaDialog {
  // Funkce, která vyvolá tohle chytré okno
  static void ukazat(
    BuildContext context, {
    required Map<String, dynamic> zaznam,
    required VoidCallback poZmene, // Zvonek pro hlavní obrazovku
  }) {
    String puvodniNazev = zaznam['polozka'];
    double puvodniCena = (zaznam['cena'] as num).toDouble();
    
    // Naše propisky
    TextEditingController upravaNazev = TextEditingController();
    TextEditingController upravaCena = TextEditingController(text: puvodniCena.toStringAsFixed(0));
    TextEditingController upravaHodiny = TextEditingController();
    TextEditingController upravaSazba = TextEditingController();

    // CHYTRÁ ČTEČKA ZÁVOREK: Najde " (X hod)", vyřízne to a spočítá zbytek
    final match = RegExp(r' \(([\d.]+) hod\)$').firstMatch(puvodniNazev);
    if (match != null) {
      String nalezenoHodin = match.group(1)!;
      double pocetHodin = double.tryParse(nalezenoHodin) ?? 0;
      
      upravaNazev.text = puvodniNazev.replaceAll(match.group(0)!, '');
      upravaHodiny.text = nalezenoHodin;
      
      if (pocetHodin > 0 && puvodniCena > 0) {
         upravaSazba.text = (puvodniCena / pocetHodin).toStringAsFixed(0);
      }
    } else {
      upravaNazev.text = puvodniNazev;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            
            // Živá kalkulačka
            void zkontrolujVypocet(String val) {
              double hodiny = double.tryParse(upravaHodiny.text.replaceAll(',', '.')) ?? 0;
              double sazba = double.tryParse(upravaSazba.text.replaceAll(',', '.')) ?? 0;
              
              if (hodiny > 0 && sazba > 0) {
                double vysledek = hodiny * sazba;
                setStateDialog(() {
                  upravaCena.text = vysledek.toStringAsFixed(0);
                });
              }
            }

            return AlertDialog(
              title: const Text('Opravit záznam', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: upravaNazev, 
                      decoration: const InputDecoration(labelText: 'Název / Popis práce'),
                      maxLines: null, 
                    ),
                    const SizedBox(height: 15),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: upravaHodiny, 
                            decoration: const InputDecoration(labelText: 'Hodiny', hintText: 'Např. 10'), 
                            keyboardType: TextInputType.number,
                            onChanged: zkontrolujVypocet, 
                          ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('x', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                          child: TextField(
                            controller: upravaSazba, 
                            decoration: const InputDecoration(labelText: 'Kč/Hod', hintText: 'Např. 400'), 
                            keyboardType: TextInputType.number,
                            onChanged: zkontrolujVypocet, 
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text('NEBO PEVNÁ CENA:', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                    
                    TextField(
                      controller: upravaCena, 
                      decoration: const InputDecoration(labelText: 'Cena celkem (Kč)', hintText: 'Např. 4000'), 
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), 
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('ZRUŠIT', style: TextStyle(color: Colors.grey))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    String finalniNazev = upravaNazev.text.trim(); 
                    double hodinyUlozit = double.tryParse(upravaHodiny.text.replaceAll(',', '.')) ?? 0;
                    
                    if (hodinyUlozit > 0) {
                       String hezkeHodiny = hodinyUlozit == hodinyUlozit.toInt() 
                            ? hodinyUlozit.toInt().toString() 
                            : hodinyUlozit.toString();
                       finalniNazev = "$finalniNazev ($hezkeHodiny hod)";
                    }

                    // Přepíšeme stará data těmi novými
                    zaznam['polozka'] = finalniNazev;
                    zaznam['cena'] = double.tryParse(upravaCena.text.replaceAll(',', '.')) ?? 0;
                    
                    ulozDoPameti(); 
                    poZmene(); 
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Záznam opraven!')));
                  },
                  child: const Text('ULOŽIT OPRAVU', style: TextStyle(color: Colors.white)),
                )
              ],
            );
          }
        );
      },
    );
  }
}