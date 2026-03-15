import 'package:flutter/material.dart';
import 'sklad.dart';
import 'detail_zakaznika_obrazovka.dart';

class HistorieObrazovka extends StatefulWidget {
  const HistorieObrazovka({super.key});

  @override
  State<HistorieObrazovka> createState() => _HistorieObrazovkaState();
}

class _HistorieObrazovkaState extends State<HistorieObrazovka> {
  
  double _spocitejCelkemVse() {
    double suma = 0;
    for (var nakup in vsechnyNakupy) {
      suma += (nakup['cena'] ?? 0);
    }
    return suma;
  }

  @override
  Widget build(BuildContext context) {
    final seznamZakazniku = vsechnyNakupy.map((n) => n['zakaznik'].toString()).toSet().toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('MOJI ZÁKAZNÍCI', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: vsechnyNakupy.isEmpty
                ? const Center(child: Text('Zatím nemáš žádné záznamy.', style: TextStyle(fontSize: 18)))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: seznamZakazniku.length,
                    itemBuilder: (context, index) {
                      final jmeno = seznamZakazniku[index];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                          title: Text(jmeno.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: const Text('Podrž pro smazání / Klikni pro detail'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                          
                          // KRÁTKÝ KLIK - Jdeme do detailu
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailZakaznikaObrazovka(jmenoZakaznika: jmeno)),
                            ).then((value) => setState(() {}));
                          },

                          // DLOUHÝ KLIK - Smazání celého zákazníka
                          onLongPress: () {
                            _potvrditSmazani(jmeno);
                          },
                        ),
                      );
                    },
                  ),
          ),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CELKEM NA CESTĚ:', style: TextStyle(color: Colors.white, fontSize: 16)),
                Text('${_spocitejCelkemVse().toStringAsFixed(0)} Kč', style: const TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Funkce, která ukáže okénko s potvrzením smazání
  void _potvrditSmazani(String jmeno) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Smazat zákazníka $jmeno?'),
        content: const Text('Tímto se vymažou všechny jeho nákupy i hodiny.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ZRUŠIT')),
          TextButton(
            onPressed: () {
              setState(() {
                // Vymažeme všechny nákupy, kde se jméno shoduje
                vsechnyNakupy.removeWhere((n) => n['zakaznik'] == jmeno);
              });
              Navigator.pop(context);
            },
            child: const Text('SMAZAT', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}