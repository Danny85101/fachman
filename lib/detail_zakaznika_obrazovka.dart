import 'package:flutter/material.dart';
import 'sklad.dart';

class DetailZakaznikaObrazovka extends StatefulWidget {
  final String jmenoZakaznika;

  const DetailZakaznikaObrazovka({super.key, required this.jmenoZakaznika});

  @override
  State<DetailZakaznikaObrazovka> createState() => _DetailZakaznikaObrazovkaState();
}

class _DetailZakaznikaObrazovkaState extends State<DetailZakaznikaObrazovka> {
  @override
  Widget build(BuildContext context) {
    // Filtrace nákupů pro konkrétního zákazníka
    final nakupyZakaznika = vsechnyNakupy.where((n) => n['zakaznik'] == widget.jmenoZakaznika).toList();

    double celkem = 0;
    for (var n in nakupyZakaznika) {
      celkem += n['cena'];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(widget.jmenoZakaznika.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: nakupyZakaznika.isEmpty
                ? const Center(child: Text('Žádné záznamy pro tohoto zákazníka.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: nakupyZakaznika.length,
                    itemBuilder: (context, index) {
                      final nakup = nakupyZakaznika[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(nakup['polozka'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${nakup['cena'].toStringAsFixed(0)} Kč'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                vsechnyNakupy.remove(nakup);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // TLAČÍTKO HOTOVO / ULOŽIT
          if (nakupyZakaznika.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Tady se později v mobilu spustí vyfocení obrazovky do Galerie
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('UKLÁDÁM PŘEHLED DO ZAŘÍZENÍ...')),
                    );
                  },
                  icon: const Icon(Icons.save_alt, color: Colors.white),
                  label: const Text('HOTOVO / ULOŽIT', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                ),
              ),
            ),

          // Spodní lišta se součtem
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CELKEM:', style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('${celkem.toStringAsFixed(0)} Kč', style: const TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}