import 'package:flutter/material.dart';
import 'sklad.dart'; 
import 'zaznam_karta.dart'; 
import 'faktura_nahled.dart'; 
import 'export_dat.dart'; // Natahujeme kabel k naší velké záloze dat!

class HistorieObrazovka extends StatefulWidget {
  const HistorieObrazovka({super.key});

  @override
  State<HistorieObrazovka> createState() => _HistorieObrazovkaState();
}

class _HistorieObrazovkaState extends State<HistorieObrazovka> {

  void _obnovitObrazovku() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> slozkyZakazniku = {};
    
    for (var zaznam in vsechnyNakupy) {
      String jmeno = zaznam['zakaznik'];
      if (!slozkyZakazniku.containsKey(jmeno)) {
        slozkyZakazniku[jmeno] = [];
      }
      slozkyZakazniku[jmeno]!.add(zaznam);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('HISTORIE VÝDAJŮ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        
        // TADY PŘIDÁVÁME TLAČÍTKO DO HORNÍ LIŠTY
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload, size: 28), // Ikonka obláčku se šipkou
            tooltip: 'Zálohovat všechna data',
            onPressed: () {
              // Když ťukneš, zavolá se ta naše nová funkce vedle ze souboru
              exportovatVsechnaData();
            },
          ),
          const SizedBox(width: 10), // Jen malá mezera, ať to není nalepené na kraji
        ],
      ),
      
      body: vsechnyNakupy.isEmpty
          ? const Center(child: Text('Zatím tu nemáš žádné záznamy.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: slozkyZakazniku.keys.length,
              itemBuilder: (context, index) {
                String jmenoZakaznika = slozkyZakazniku.keys.elementAt(index);
                List<Map<String, dynamic>> veciZakaznika = slozkyZakazniku[jmenoZakaznika]!;
                
                double celkovaCena = 0;
                for (var vec in veciZakaznika) {
                  celkovaCena += (vec['cena'] as num).toDouble();
                }

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ExpansionTile(
                    iconColor: Colors.black,
                    title: Text(jmenoZakaznika.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Text('Celkem: $celkovaCena Kč', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                    
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[50], foregroundColor: Colors.blue, elevation: 0),
                            onPressed: () => ukazatNahledFaktury(context, jmenoZakaznika, veciZakaznika, celkovaCena),
                            icon: const Icon(Icons.receipt_long),
                            label: const Text('ZOBRAZIT NÁHLED / ODESLAT', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),

                      ...veciZakaznika.map((zaznam) {
                        return ZaznamKarta(
                          zaznam: zaznam,
                          poZmene: _obnovitObrazovku, 
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}