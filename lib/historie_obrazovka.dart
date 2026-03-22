import 'package:flutter/material.dart';
import 'sklad.dart'; 
import 'zaznam_karta.dart'; 
import 'faktura_nahled.dart'; 
import 'export_dat.dart'; 

class HistorieObrazovka extends StatefulWidget {
  final String? hledanyZakaznik;
  
  const HistorieObrazovka({super.key, this.hledanyZakaznik});

  @override
  State<HistorieObrazovka> createState() => _HistorieObrazovkaState();
}

class _HistorieObrazovkaState extends State<HistorieObrazovka> {

  void _obnovitObrazovku() {
    setState(() {});
  }

  // PŘIDÁNO: Funkce, která vyhodí bezpečnostní okno a po potvrzení zákazníka vymaže
  void _potvrditSmazaniZakaznika(String jmenoZakaznika) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skutečně vymazat?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Opravdu chceš smazat zákazníka "$jmenoZakaznika" a všechny jeho záznamy?\n\nTuhle akci už nepůjde vzít zpět!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('NE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                // Najde a smaže úplně všechny záznamy, které mají jméno tohoto zákazníka
                vsechnyNakupy.removeWhere((zaznam) => zaznam['zakaznik'] == jmenoZakaznika);
              });
              ulozDoPameti(); // Uložíme na disk, ať je to smazané napořád
              Navigator.pop(context); // Zavřeme dialogové okno
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Zákazník $jmenoZakaznika byl kompletně smazán!')));
            },
            child: const Text('ANO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> slozkyZakazniku = {};
    
    for (var zaznam in vsechnyNakupy) {
      String jmeno = zaznam['zakaznik'];
      
      if (widget.hledanyZakaznik != null && widget.hledanyZakaznik != jmeno) {
        continue; 
      }

      if (!slozkyZakazniku.containsKey(jmeno)) {
        slozkyZakazniku[jmeno] = [];
      }
      slozkyZakazniku[jmeno]!.add(zaznam);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(widget.hledanyZakaznik == null ? 'HISTORIE VÝDAJŮ' : 'VÝDAJE: ${widget.hledanyZakaznik!.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload, size: 28),
            tooltip: 'Zálohovat všechna data',
            onPressed: () {
              exportovatVsechnaData();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      
      body: vsechnyNakupy.isEmpty
          ? const Center(child: Text('Zatím tu nemáš žádné záznamy.', style: TextStyle(fontSize: 18)))
          : slozkyZakazniku.isEmpty 
              ? Center(child: Text('U zákazníka "${widget.hledanyZakaznik}" zatím nemáš žádné výdaje.', style: const TextStyle(fontSize: 18), textAlign: TextAlign.center))
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
                        initiallyExpanded: widget.hledanyZakaznik != null,
                        iconColor: Colors.black,
                        
                        // ZMĚNA: Dali jsme jméno a popelnici do jednoho řádku
                        title: Row(
                          children: [
                            Expanded(child: Text(jmenoZakaznika.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _potvrditSmazaniZakaznika(jmenoZakaznika),
                            ),
                          ],
                        ),
                        
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