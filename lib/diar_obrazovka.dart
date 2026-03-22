import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'sklad_diar.dart'; 
import 'chytry_kalendar.dart'; 
// PŘIDÁNO: Načítáme naše dvě nové čisté kostičky!
import 'diar_karta.dart';
import 'diar_uprava_dialog.dart';

class DiarObrazovka extends StatefulWidget {
  const DiarObrazovka({super.key});

  @override
  State<DiarObrazovka> createState() => _DiarObrazovkaState();
}

class _DiarObrazovkaState extends State<DiarObrazovka> {
  final TextEditingController kdyController = TextEditingController();
  final TextEditingController kdoController = TextEditingController();
  final TextEditingController coController = TextEditingController();

  List<dynamic> _ziskatSerazeneZakazky() {
    var serazeno = List.from(vsechnyZakazky);
    serazeno.sort((a, b) {
      try {
        DateTime datumA = DateFormat("d. M. yyyy").parseStrict(a['kdy']);
        DateTime datumB = DateFormat("d. M. yyyy").parseStrict(b['kdy']);
        return datumA.compareTo(datumB);
      } catch (e) {
        return 0; 
      }
    });
    return serazeno;
  }

  // ZJEDNODUŠENO: Tohle teď slouží UŽ JENOM pro přidání ÚPLNĚ NOVÉ zakázky
  void _otevritFormularNovaZakazka() {
    kdyController.clear();
    kdoController.clear();
    coController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nová zakázka', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: kdyController,
              readOnly: true, 
              decoration: const InputDecoration(labelText: 'Datum zakázky', hintText: 'Ťukni sem pro kalendář'),
              onTap: () {
                ChytryKalendar.vybratDatum(context, kdyController);
              },
            ),
            TextField(controller: kdoController, decoration: const InputDecoration(labelText: 'Kdo (Zákazník)')),
            TextField(controller: coController, decoration: const InputDecoration(labelText: 'Co se bude dělat')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ZRUŠIT', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              if (kdoController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chybí jméno zákazníka!')));
                return;
              }

              if (kdyController.text.isNotEmpty) {
                setState(() {
                  vsechnyZakazky.add({
                    'kdy': kdyController.text, 
                    'kdo': kdoController.text,
                    'co': coController.text,
                  });
                  ulozDiarDoPameti(); 
                });
                Navigator.pop(context); 
              }
            },
            child: const Text('ULOŽIT', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // PŘIDÁNO: Naše chytrá pojistka proti nechtěnému smazání!
  void _potvrditSmazaniZakazky(Map<String, dynamic> zakazka) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skutečně vymazat?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Opravdu chceš smazat tuto zakázku pro zákazníka "${zakazka['kdo']}"?\n\nTuhle akci už nepůjde vzít zpět!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('NE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                vsechnyZakazky.remove(zakazka);
                ulozDiarDoPameti();
              });
              Navigator.pop(context); // Zavře dialog
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zakázka smazána.')));
            },
            child: const Text('ANO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var sepsaneZakazky = _ziskatSerazeneZakazky();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('MŮJ DIÁŘ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      
      body: sepsaneZakazky.isEmpty
          ? const Center(child: Text('Zatím nemáš naplánovanou žádnou práci.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: sepsaneZakazky.length,
              itemBuilder: (context, index) {
                var zakazka = sepsaneZakazky[index];
                String hezkeDatum = zakazka['kdy'];

                // ZJEDNODUŠENO: Tady jen skládáme naše nové kostičky! Žádný nekonečný kód.
                return DiarKarta(
                  zakazka: zakazka,
                  hezkeDatum: hezkeDatum,
                  naSmazani: () => _potvrditSmazaniZakazky(zakazka), // Zavolá naši pojistku smazání
                  naUpravu: () {
                    // Zavolá naše chytré okénko na úpravu
                    DiarUpravaDialog.ukazat(
                      context,
                      zakazka: zakazka,
                      hezkeDatum: hezkeDatum,
                      poZmene: () => setState(() {}), // Jakmile okénko něco změní, překreslíme seznam
                    );
                  },
                );
              },
            ),
            
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _otevritFormularNovaZakazka, 
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('PŘIDAT PRÁCI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}